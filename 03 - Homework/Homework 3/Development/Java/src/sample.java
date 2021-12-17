import java.sql.Connection;
import java.sql.Statement;
import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class sample {

    // Database credentials
    final static String HOSTNAME = "carp9743.database.windows.net";
    final static String DBNAME   = "cs-dsa-4513-sql-db";
    final static String USERNAME = "carp9743";
    final static String PASSWORD = "tacoBout$97315!";

    // Database connection string
    final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
    		HOSTNAME, DBNAME, USERNAME, PASSWORD);

    // Query templates
    final static String QUERY_TEMPLATE_1 = "INSERT INTO Student " + 
                                           "VALUES (?, ?, ?, ?, ?, ?);";

    final static String QUERY_TEMPLATE_2 = "SELECT * FROM Student;";

    // User input prompt//
    final static String PROMPT = 
            "\nPlease select one of the options below: \n" +
            "1) Insert new student; \n" + 
            "2) Display all students; \n" + 
            "3) Exit!";

    public static void main(String[] args) throws SQLException {

        System.out.println("Welcome to the sample application!");

        final Scanner sc = new Scanner(System.in); // Scanner is used to collect the user input
        String option = ""; // Initialize user option selection as nothing
        while (!option.equals("3")) { // As user for options until option 3 is selected
            System.out.println(PROMPT); // Print the available options
            option = sc.next(); // Read in the user option selection

            switch (option) { // Switch between different options
                case "1": // Insert a new student option
                    // Collect the new student data from the user
                    System.out.println("Please enter integer student ID:");
                    final int id = sc.nextInt(); // Read in the user input of student ID

                    System.out.println("Please enter student first name:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String fname = sc.nextLine(); // Read in user input of student First Name (white-spaces allowed).

                    System.out.println("Please enter student last name:");
                    // No need to call nextLine extra time here, because the preceding nextLine consumed the newline character.
                    final String lname = sc.nextLine(); // Read in user input of student Last Name (white-spaces allowed).

                    System.out.println("Please enter float student GPA:");
                    final float gpa = sc.nextFloat(); // Read in user input of student GPA

                    System.out.println("Please enter student major:");
                    sc.nextLine(); // Consuming the trailing new line character left after nextFloat
                    final String major = sc.nextLine(); // Read in user input of student Major

                    System.out.println("Please enter student classification (Freshman, Sophomore, Junior, or Senior):");
                    final String classification = sc.nextLine(); // Read in user input of student Classification

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_1)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, id);
                            statement.setString(2, fname);
                            statement.setString(3, lname);
                            statement.setFloat(4, gpa);
                            statement.setString(5, major);
                            statement.setString(6, classification);

                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }

                    break;
                case "2":
                    System.out.println("Connecting to the database...");
                    // Get the database connection, create statement and execute it right away, as no user input need be collected
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        System.out.println("Dispatching the query...");
                        try (
                            final Statement statement = connection.createStatement();
                            final ResultSet resultSet = statement.executeQuery(QUERY_TEMPLATE_2)) {

                                System.out.println("Contents of the Student table:");
                                System.out.println("ID | first name | last name | GPA | major | classification ");

                                // Unpack the tuples returned by the database and print them out to the user
                                while (resultSet.next()) {
                                    System.out.println(String.format("%s | %s | %s | %s | %s | %s ",
                                        resultSet.getString(1),
                                        resultSet.getString(2),
                                        resultSet.getString(3),
                                        resultSet.getString(4),
                                        resultSet.getString(5),
                                        resultSet.getString(6)));
                                }
                        }
                    }

                    break;
                case "3": // Do nothing, the while loop will terminate upon the next iteration
                    System.out.println("Exiting! Good-buy!");
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
