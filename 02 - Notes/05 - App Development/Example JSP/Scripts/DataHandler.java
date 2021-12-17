package jsp_azure_test;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class DataHandler {

    private Connection conn;

    // Azure SQL connection credentials
    private String server = "<Replace Me>-sql-server.database.windows.net";
    private String database = "cs-dsa-4513-sql-db";
    private String username = "<Replace Me>";
    private String password = "<Replace Me>";

    // Resulting connection string
    final private String url =
            String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
                    server, database, username, password);

    // Initialize and save the database connection
    private void getDBConnection() throws SQLException {
        if (conn != null) {
            return;
        }

        this.conn = DriverManager.getConnection(url);
    }

    // Return the result of selecting everything from the movie_night table 
    public ResultSet getAllMovies() throws SQLException {
        getDBConnection();
        
        final String sqlQuery = "SELECT * FROM movie_night;";
        final PreparedStatement stmt = conn.prepareStatement(sqlQuery);
        return stmt.executeQuery();
    }

    // Inserts a record into the movie_night table with the given attribute values
    public boolean addMovie(
            String startTime, String movieName, int duration, String g1, String g2, String g3, String g4, String g5) throws SQLException {

        getDBConnection(); // Prepare the database connection

        // Prepare the SQL statement
        final String sqlQuery =
                "INSERT INTO movie_night " + 
                    "(start_time, movie_name, duration_min, guest_1, guest_2, guest_3, guest_4, guest_5) " + 
                "VALUES " + 
                "(?, ?, ?, ?, ?, ?, ?, ?)";
        final PreparedStatement stmt = conn.prepareStatement(sqlQuery);

        // Replace the '?' in the above statement with the given attribute values
        stmt.setString(1, startTime);
        stmt.setString(2, movieName);
        stmt.setInt(3, duration);
        stmt.setString(4, g1);
        stmt.setString(5, g2);
        stmt.setString(6, g3);
        stmt.setString(7, g4);
        stmt.setString(8, g5);

        // Execute the query, if only one record is updated, then we indicate success by returning true
        return stmt.executeUpdate() == 1;
    }
}
