import java.sql.Connection;
import java.sql.Statement;
import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class HW3_Problem2_Carpenter_Daniel {

    // Database credentials
    final static String HOSTNAME = "carp9743.database.windows.net";
    final static String DBNAME   = "cs-dsa-4513-sql-db";
    final static String USERNAME = "carp9743";
    final static String PASSWORD = "tacoBout$97315!";

    // Database connection string
    final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
    		HOSTNAME, DBNAME, USERNAME, PASSWORD);

    // Query for 3rd option
    final static String QUERY_TEMPLATE_SELECT_ALL = "SELECT * FROM Performer;";
    
    // Activate option1 stored procedure (gets average experience when filtering on +/- 10 years of age
    final static String QUERY_TEMPLATE_CALC_AVG_1 = "EXEC spUploadAvg1 @pid = ?, @pname = ?, @age = ?";
    
    // Query for 2nd option (joins from performer to movie to get did, then filters on did)
    final static String QUERY_TEMPLATE_CALC_AVG_2 = "EXEC spUploadAvg2 @pid = ?, @pname = ?, @age = ?, @did = ?";
    
    // User input prompt//
    final static String PROMPT = 
            "\nPlease select one of the options below: \n" +
            "1) Insert new performer (experience = +/-10 yr. est. of experience); \n" + 
            "2) Insert new performer (experience = average of all performers who have acted under select director); \n" + 
            "3) Display the complete information of all performers; \n" + 
            "4) Quit (exit the program)";

    public static void main(String[] args) throws SQLException {

        System.out.println("It's time to update your database!");

        final Scanner sc = new Scanner(System.in); // Scanner is used to collect thes user input
        String option = ""; // Initialize user option selection as nothing
        while (!option.equals("4")) { // As user for options until option 3 is selected
            System.out.println(PROMPT); // Print the available options
            option = sc.next(); // Read in the user option selection

            switch (option) { // Switch between different options
                case "1": // Insert a new student option
                	
                    // Get Performer ID
                    System.out.println("Please enter integer performer ID (pid):");
                    int pid = sc.nextInt(); // Read in the user input of student ID
                    
                    // Get Performer Name
                    System.out.println("Please enter performer name (pname):");
                    sc.nextLine();
                    String pname = sc.nextLine(); // Read in user input of student First Name (white-spaces allowed).
                    
                    // Get Performer Age
                    System.out.println("Please enter integer age of the performer (age):");
                    int age = sc.nextInt(); // Read in user input of student GPA

                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                    	
                        // Activate option1 stored procedure (gets average experience when filtering on +/- 10 years of age
                    	// Insert new performer record into database
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_CALC_AVG_1)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, 	pid);
                            statement.setString(2, 	pname);
                            statement.setInt(3, 	age);

                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }
                    break;
                  
                case "2": // insert performer with average based on director id input
                    // Get Performer ID
                    System.out.println("Please enter integer performer ID (pid):");
                    pid = sc.nextInt(); // Read in the user input of student ID
                    
                    // Get Performer Name
                    System.out.println("Please enter performer name (pname):");
                    sc.nextLine();
                    pname = sc.nextLine(); // Read in user input of student First Name (white-spaces allowed).
                    
                    // Get Performer Age
                    System.out.println("Please enter integer age of the performer (age):");
                    age = sc.nextInt(); // Read in user input of student GPA
                    
                    System.out.println("Please enter integer director id (did) that you want to average years of experience from:");
                    int did = sc.nextInt(); // Read in user input of student GPA

                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                    	
                    	// Insert new performer record into database
                    	// Get the average age of performers with acted in movie from selected did ----------------------
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_CALC_AVG_2)) {
                            
                        	// Populate the query template with the data collected from the user
                            statement.setInt(1, pid);
                            statement.setString(2, pname);
                            statement.setInt(3, age);
                            statement.setInt(4, did);

                            System.out.println("Dispatching the query...");
                            
                            // execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }
                	break;
                	
                case "3": // Show all contents of database
                    System.out.println("\nEstablishing connection to database...");
                    // Get the database connection, create statement and execute it right away, as no user input need be collected
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        System.out.println("Sending query...");
                        try (
                            final Statement statement = connection.createStatement();
                            final ResultSet resultSet = statement.executeQuery(QUERY_TEMPLATE_SELECT_ALL)) {

                                System.out.println("\nAll contents of the Performer table:");
                                System.out.println("pid	  | pname	  | years_of_experience	  | age ");

                                // Unpack the tuples returned by the database and print them out to the user
                                while (resultSet.next()) {
                                    System.out.println(String.format("%s	  | %s	  | %s	  | %s ",
                                        resultSet.getString(1),
                                        resultSet.getString(2),
                                        resultSet.getString(3),
                                        resultSet.getString(4)));
                                }
                        }
                    }

                    break;
                case "4": // Do nothing, the while loop will terminate upon the next iteration
                    System.out.println("Quitting application. Thanks and have a great day!");
                    break;
                default: // Unrecognized option, re-prompt the user for the correct one
                    System.out.println(String.format(
                        "Unrecognized option: %s\n" + 
                        "Please try again!", 
                        option));
                    break;
            }
        }

        sc.close(); // Close the scanner before exiting the application
    }
}
