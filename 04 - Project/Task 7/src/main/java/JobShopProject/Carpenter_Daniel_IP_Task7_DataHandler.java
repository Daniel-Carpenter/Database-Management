package JobShopProject;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

//==========================================================================
//@class:  DSA 4513
//@asnmt:  Class Project
//@task:   7
//@author: Daniel Carpenter, ID: 113009743
//@description: 
//  Program to implement job-shop accounting system query 1 and 13
//==========================================================================

public class Carpenter_Daniel_IP_Task7_DataHandler {

    private Connection conn;

    // Azure SQL connection credentials
    private String server 	= "carp9743.database.windows.net";
    private String database = "cs-dsa-4513-sql-db";
    private String username = "carp9743";
    private String password = "tacoBout$97315!";

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

    // Adds a customer to the Customer table and returns true if executed correctly
    public boolean addCustomer(String name, String address, int category) throws SQLException {
        getDBConnection();
        
        // Prepare the query
        final String sqlQuery = "EXEC [Project].addCustomer @name = ?,  @address = ?, @category = ?;";
        
        // Replace the '?' in the above statement with the given attribute values
        final PreparedStatement statement = conn.prepareStatement(sqlQuery);
        	statement.setString(1, 	name);
            statement.setString(2, 	address);
            statement.setInt(3, 	category);
            
        // Return true if successful
        return statement.executeUpdate() == 1;
    }

    // Inserts a record into the movie_night table with the given attribute values
    public ResultSet getCustomersInRange(int min, int max) throws SQLException {

        getDBConnection(); // Prepare the database connection

        // Query
        String sqlQuery = "{CALL [Project].getCustomers(?, ?)}";
        
        // Prepare query call
        CallableStatement statement = conn.prepareCall(sqlQuery);
		
		// Set the assigned value(s) to the procedures input '?'
        statement.setInt("min", min);
        statement.setInt("max", max);

        // Execute the query
        return statement.executeQuery();
    }
}
