import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class stored_procedure_call_example {

    // Database credentials
    final static String HOSTNAME = "<your4x4>-sql-server.database.windows.net";
    final static String DBNAME = "cs-dsa-4513-sql-db";
    final static String USERNAME = "<your4x4>";
    final static String PASSWORD = "<Your Password>";

    // Database connection string
    final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
            HOSTNAME, DBNAME, USERNAME, PASSWORD);

    public static void main(String[] args) throws SQLException {
        // Connecting to the database
        try (final Connection connection = DriverManager.getConnection(URL)) {
            try (final PreparedStatement statement = connection.prepareStatement("EXEC sp_test3 @age = ?, @city = ?;")) {

                    // Setting the storage procedure input parameter values
                    statement.setInt(1, 20);
                    statement.setString(2, "Norman");

                    // Call the stored procedure
                    ResultSet resultSet = statement.executeQuery();

                    System.out.println("Results of the sp_test3:");
                    System.out.println("PersonID | Name | Age | City ");

                    while (resultSet.next()) {
                        System.out.println(String.format("%s | %s | %s | %s ",
                            resultSet.getString(1),
                            resultSet.getString(2),
                            resultSet.getString(3),
                            resultSet.getString(4)));
                    }
            }
        }

    }
}
