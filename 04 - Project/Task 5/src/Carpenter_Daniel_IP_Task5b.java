import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.io.*;
import java.io.FileWriter;

// ==========================================================================
// @class:  DSA 4513
// @asnmt:  Class Project
// @task:   5 (b)
// @author: Daniel Carpenter, ID: 113009743
// @description: 
//     Program to implement job-shop accounting system queries
// ==========================================================================

public class Carpenter_Daniel_IP_Task5b {

    // Database credentials
    final static String HOSTNAME = "carp9743.database.windows.net";
    final static String DBNAME   = "cs-dsa-4513-sql-db";
    final static String USERNAME = "carp9743";
    final static String PASSWORD = "tacoBout$97315!";

    // Database connection string
    final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
    		HOSTNAME, DBNAME, USERNAME, PASSWORD);
    
    // Selected integer that quits application
    final static int QUIT_APPLICATION = 18;

    // Create Template Queries to Execute stored procedures 
    final static String QUERY_1  = "EXEC [Project].addCustomer @name = ?,  @address = ?, @category = ?";
    final static String QUERY_2  = "EXEC [Project].addDepartment @deptNo = ?";
    final static String QUERY_3  = "EXEC [Project].addProcess @id = ?, @deptNo = ?";
    final static String QUERY_4  = "EXEC [Project].addAssembly @assID = ?, @dateOrdered = ?, @details = ?, @customerName = ?, @processID = ?";
    final static String QUERY_5  = "EXEC [Project].addAccount @acctNo = ?, @dateEstablished = ?, @assembliesID = ?, @processID = ?, @deptNo = ?";
    final static String QUERY_6  = "EXEC [Project].addJob @jobNo = ?, @startDate = ?, @assembliesID = ?, @processID = ?, @deptNo = ?";
    final static String QUERY_7  = "EXEC [Project].setJobAsCompleted @jobNo = ?, @endDate = ?, @otherInfo = ?";
	final static String QUERY_8  = "EXEC [Project].addTransaction @transactionNo = ?, @cost = ?, @deptNo = ?, @assembliesID = ?, @processID = ?, @jobNo = ?";
	final static String QUERY_9  = "{CALL [Project].getTotalCosts(?)}";
	final static String QUERY_10 = "{CALL [Project].getTotalLaborTime(?, ?)}";
	final static String QUERY_11 = "{CALL [Project].getProcessUpdate(?)}";
	final static String QUERY_12 = "{CALL [Project].getJobs(?, ?)}";
	final static String QUERY_13 = "{CALL [Project].getCustomers(?, ?)}";
	final static String QUERY_14 = "EXEC [Project].deleteJobs @min = ?, @max = ?";
	final static String QUERY_15 = "EXEC [Project].setPaintJob @newColor = ?, @jobNo = ?";
	final static String QUERY_17 = "{CALL [Project].getCustomersInRange(?, ?)}";
    
    // User input prompt
    final static String PROMPT = 
            "\nPlease select one of the options below: \n" +
            		"(1) Enter a new customer \n" + 
            		"(2) Enter a new department \n" + 
            		"(3) Enter a new process-id and its department together with its type and information \n" + 
            		"\trelevant to the type\n" + 
            		"(4) Enter a new assembly with its customer-name, assembly-details, assembly-id, \n" + 
            		"\tand dateordered and associate it with one or more processes\n" + 
            		"(5) Create a new account and associate it with the process, assembly, or department \n" + 
            		"\tto which it is applicable\n" + 
            		"(6) Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced\n" + 
            		"(7) At the completion of a job, enter the date it completed and the information \n" + 
            		"\trelevant to the type of job \n" + 
            		"(8) Enter a transaction-no and its sup-cost and update all the costs (details) of the \n" + 
            		"\taffected accounts by adding sup-cost to their current values of details \n" + 
            		"(9) Retrieve the total cost incurred on an assembly-id \n" + 
            		"(10) Retrieve the total labor time within a department for jobs completed in the \n" + 
            		"\tdepartment during a given date\n" + 
            		"(11) Retrieve the processes through which a given assembly-id has passed so far \n" + 
            		"\t(in datecommenced order) and the department responsible for each process\n" + 
            		"(12) Retrieve the jobs (together with their type information and assembly-id) \n" + 
            		"\tcompleted during a given date in a given department\n" + 
            		"(13) Retrieve the customers (in name order) whose category is in a given range\n" + 
            		"(14) Delete all cut-jobs whose job-no is in a given range\n" + 
            		"(15) Change the color of a given paint job\n" + 
            		"(16) Import: enter new customers from a data file until the file is empty \n" + 
            		"(\tthe user must be asked to enter the input file name). \n" + 
            		"(17) Export: Retrieve the customers (in name order) whose category is in a given range \n" + 
            		"\tand output them to a data file instead of screen (the user must be asked to enter the output file name).\n" + 
            		"(18) Quit\n";

    
    // Function to read in a csv file and return a concatenated into an insert statement
    public static String readCSV(String filename) throws IOException, SQLException  {  

    	// Number of columns in the customer table (3)
    	final int NUM_CUST_COLS = 3;
    	
    	// string that will hold the insert statement
    	 String insertStatement = "INSERT INTO [Project].Customer VALUES (";
    	
    	// Create input reader
    	BufferedReader input = new BufferedReader(new FileReader(filename));
        String line = "";
        int iterCount = 0; // keep track of iterations
        final int FIRST_ITER = 0;
            
            // Iterate through each 'row' of the csv
            while ((line = input.readLine()) != null) {
            	
            	// IF the first iteration, then do nothing. else concatenate parenthesis
            	if (iterCount != FIRST_ITER) {
            		insertStatement += ", (";
            	} else {
            		++iterCount;
            	}
            		
            	
            	// Iterate through each 'column' of the csv file
            	for (int col = 0; col < NUM_CUST_COLS; ++col) {
            		
            		// Add a ' in front of the string vars
            		if (col != NUM_CUST_COLS - 1) {
            			insertStatement += "'";
            		}
            		
            		// return the value of the row for each column index (1 through 3)
            		insertStatement += line.split(",")[col];
            		
            		// If not at last column, add comma to the string
            		// Add a ' at end of the string vars
            		if (col != NUM_CUST_COLS - 1) {
            			insertStatement += "', ";
            		}
            		
            		// End the values insert
            		else {
            			insertStatement += ")";
            		}
            	}
            }
            
            // close the input method
            input.close();
            
            // return the insert statement
            return (insertStatement);
    }  

    public static void main(String[] args) throws SQLException, IOException {

        System.out.println("Update Job-Shop Accounting Database:");

        // CREATE INPUT SCANNER ---------------------------------------------------------------------------------
        final Scanner sc = new Scanner(System.in); // Scanner is used to collect thes user input
        String option = ""; // Initialize user option selection as nothing
        while (!option.equals(Integer.toString(QUIT_APPLICATION))) { // As user for options until quit option  is selected
            System.out.println(PROMPT); // Print the available options
            
            option = sc.next(); // Read in the user option selection

            
            // BEGIN SWITCH STATEMENTS ==========================================================================
            switch (option) { // Switch between different options
            
            	// (1) Enter a new customer 
                case "1":
                	
                	// Set the query 
                	String query = QUERY_1;
                	
                    System.out.println("Please enter customer name:");
                    sc.nextLine();
                    String cName = sc.nextLine();
                    
                    System.out.println("Please enter customer address in single line:");
                    String address = sc.nextLine(); 
                    
                    System.out.println("Please enter integer  customer category between 1 and 10:");
                    int category = sc.nextInt(); 

                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                    	
                        // Activate stored procedure to enter above data in database
                    	// Insert new performer record into database
                        try (
                            final PreparedStatement statement = connection.prepareStatement(query)) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, 	cName);
                            statement.setString(2, 	address);
                            statement.setInt(3, 	category);

                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }
                    break;
                  
                // (2) Enter a new department 
                case "2":
                	
                	// Set the query 
                	query = QUERY_2;
                	
                	System.out.println("Please enter a new department number:");
                	int deptNo = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Activate stored procedure to enter above data in database
                		// Insert new performer record into database
                		try (
                				final PreparedStatement statement = connection.prepareStatement(query)) {
                			// Populate the query template with the data collected from the user
                			statement.setInt(1, 	deptNo);
                			
                			System.out.println("Dispatching the query...");
                			// Actually execute the populated query
                			final int rows_inserted = statement.executeUpdate();
                			System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                		}
                	}
                	break;
                	
            	// (3) Enter a new process-id and its department together with its type and information 
            	// relevant to the type
                case "3":
                	
                	// Set the query 
                	query = QUERY_3;
                	
                	System.out.println("Please enter a new process id (integer):");
                	int processID = sc.nextInt();
                	
                	System.out.println("Please enter its existing department number:");
                	deptNo = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Activate stored procedure to enter above data in database
                		// Insert new performer record into database
                		try (
                				final PreparedStatement statement = connection.prepareStatement(query)) {
                			// Populate the query template with the data collected from the user
                			statement.setInt(1, 	processID);
                			statement.setInt(2, 	deptNo);
                			
                			System.out.println("Dispatching the query...");
                			// Actually execute the populated query
                			final int rows_inserted = statement.executeUpdate();
                			System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                		}
                	}
                	break;
                	
            	// (4) Enter a new assembly with its customer-name, assembly-details, assembly-id, 
            	// and dateordered and associate it with one or more processes
                case "4":
                	
                	// Set the query 
                	query = QUERY_4;
                	
                	System.out.println("Please enter a new assembly id (integer):");
                	int assID = sc.nextInt();
                	
                	System.out.println("Please enter the date commenced in 'YYYY-MM-DD' format, e.g. 2020-11-30:");
                    sc.nextLine();
                	String dateOrdered = sc.nextLine();
                	
                	System.out.println("Please enter the details of the order in text");
                	String details = sc.nextLine();
                	
                	System.out.println("Please enter the existing customer name associated with the assembly");
                	cName = sc.nextLine();
                	
                	System.out.println("Please enter the existing process ID (integer) associated with the assembly");
                	processID = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Activate stored procedure to enter above data in database
                		// Insert new performer record into database
                		try (
                				final PreparedStatement statement = connection.prepareStatement(query)) {
                			// Populate the query template with the data collected from the user
                			statement.setInt(1, 	assID);
                			statement.setString(2, 	dateOrdered);
                			statement.setString(3, 	details);
                			statement.setString(4, 	cName);
                			statement.setInt(5, 	processID);
                			
                			System.out.println("Dispatching the query...");
                			// Actually execute the populated query
                			final int rows_inserted = statement.executeUpdate();
                			System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                		}
                	}
                	break;
            	
                // (5) Create a new account and associate it with the process, assembly, or department 
            	// to which it is applicable
                case "5":
                	
                	// Set the query 
                	query = QUERY_5;
                	
                	System.out.println("Please enter a new account id (integer):");
                	int acctNo = sc.nextInt();
                	
                	System.out.println("Please enter the date established in 'YYYY-MM-DD' format, e.g. 2020-11-30:");
                	sc.nextLine();
                	String dateEst = sc.nextLine();
                	
                	System.out.println("Please enter the associated assembly id (integer)");
                	assID = sc.nextInt();
                	
                	System.out.println("Please enter the associated process id (integer)");
                	processID = sc.nextInt();
                	
                	System.out.println("Please enter the associated department number");
                	deptNo = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Activate stored procedure to enter above data in database
                		// Insert new performer record into database
                		try (
                				final PreparedStatement statement = connection.prepareStatement(query)) {
                			// Populate the query template with the data collected from the user
                			statement.setInt(1, 	acctNo);
                			statement.setString(2, 	dateEst);
                			statement.setInt(3, 	assID);
                			statement.setInt(4, 	processID);
                			statement.setInt(5, 	deptNo);
                			
                			System.out.println("Dispatching the query...");
                			// Actually execute the populated query
                			final int rows_inserted = statement.executeUpdate();
                			System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                		}
                	}
                	break;
        		
            	// (6) Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced
                case "6":
                	
                	// Set the query 
                	query = QUERY_6;
                	
                	System.out.println("Please enter a new job number:");
                	int jobNo = sc.nextInt();
                	
                	System.out.println("Please enter the start date of the job in 'YYYY-MM-DD' format, e.g. 2020-11-30:");
                	sc.nextLine();
                	String startDate = sc.nextLine();
                	
                	System.out.println("Please enter the associated assembly id (integer)");
                	assID = sc.nextInt();
                	
                	System.out.println("Please enter the associated process id (integer)");
                	processID = sc.nextInt();
                	
                	System.out.println("Please enter the associated department number");
                	deptNo = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Activate stored procedure to enter above data in database
                		// Insert new performer record into database
                		try (
                				final PreparedStatement statement = connection.prepareStatement(query)) {
                			// Populate the query template with the data collected from the user
                			statement.setInt(1, 	jobNo);
                			statement.setString(2, 	startDate);
                			statement.setInt(3, 	assID);
                			statement.setInt(4, 	processID);
                			statement.setInt(5, 	deptNo);
                			
                			System.out.println("Dispatching the query...");
                			// Actually execute the populated query
                			final int rows_inserted = statement.executeUpdate();
                			System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                		}
                	}
                	break;
            	
            	// (7) At the completion of a job, enter the date it completed and the information 
            	// relevant to the type of job 
                case "7":
                	
                	// Set the query 
                	query = QUERY_7;
                	
                	System.out.println("Please enter the existing job number:");
                	jobNo = sc.nextInt();
                	
                	System.out.println("Please enter the end date of the job in 'YYYY-MM-DD' format, e.g. 2020-11-30:");
                	sc.nextLine();
                	String endDate = sc.nextLine();
                	
                	System.out.println("Please enter any other info about the job (as text):");
                	String otherInfo = sc.nextLine();

                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Activate stored procedure to enter above data in database
                		// Insert new performer record into database
                		try (
                				final PreparedStatement statement = connection.prepareStatement(query)) {
                			// Populate the query template with the data collected from the user
                			statement.setInt(1, 	jobNo);
                			statement.setString(2, 	endDate);
                			statement.setString(3, 	otherInfo);
                			
                			System.out.println("Dispatching the query...");
                			// Actually execute the populated query
                			final int rows_inserted = statement.executeUpdate();
                			System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                		}
                	}
                	break;
            
            	// (8) Enter a transaction-no and its sup-cost and update all the costs (details) of the 
            	// affected accounts by adding sup-cost to their current values of details 
                case "8":
                	
                	// Set the query 
                	query = QUERY_8;
                	
                	System.out.println("Please enter the new transaction number:");
                	int transactionNo = sc.nextInt();
                	
                	System.out.println("Please enter the cost of the transaction (as decimal number):");
                	double cost = sc.nextDouble();
                	
                	System.out.println("Please enter the associated assembly id (integer)");
                	assID = sc.nextInt();
                	
                	System.out.println("Please enter the associated process id (integer)");
                	processID = sc.nextInt();
                	
                	System.out.println("Please enter the associated department number");
                	deptNo = sc.nextInt();
                	
                	System.out.println("Please enter the associated job number");
                	jobNo = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Activate stored procedure to enter above data in database
                		// Insert new performer record into database
                		try (
                				final PreparedStatement statement = connection.prepareStatement(query)) {
                			// Populate the query template with the data collected from the user
                			statement.setInt(1, 	transactionNo);
                			statement.setDouble(2, 	cost);
                			statement.setInt(3, 	deptNo);
                			statement.setInt(4, 	assID);
                			statement.setInt(5, 	processID);
                			statement.setInt(6, 	jobNo);
                			
                			System.out.println("Dispatching the query...");
                			// Actually execute the populated query
                			final int rows_inserted = statement.executeUpdate();
                			System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                		}
                	}
                	break;
            	
            	// (9) Retrieve the total cost incurred on an assembly-id 
                case "9":
                	
                	// Set the query 
                	query = QUERY_9;
                	
                	System.out.println("Please enter the assembly id (integer):");
                	assID = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
            			// Prepare a call to the stored procedure
        				CallableStatement cs = connection.prepareCall(query);
        				
        				// Set the assigned value(s) to the procedures input
        				cs.setInt("id", assID);
        				
        				// Run the stored procedure and store values in resultSet
        				System.out.println("Dispatching the query...");
        				ResultSet resultSet = cs.executeQuery();
        			
        				System.out.println("Done.");
                        System.out.println("\nTotal cost incurred on assembly-id: " + assID);

                        // Unpack the tuples returned by the database and print them out to the user
                        while (resultSet.next()) {
                            System.out.println(String.format("%s", resultSet.getString(1)));
                        }
                    }
            	
                	break;
            	
            	// (10) Retrieve the total labor time within a department for jobs completed in the 
            	// department during a given date
                case "10":
                	
                	// Set the query 
                	query = QUERY_10;
                	
                	System.out.println("Please enter the department number:");
                	deptNo = sc.nextInt();
                	
                	System.out.println("Please enter the end date of the job in 'YYYY-MM-DD' format, e.g. 2020-11-30:");
                	sc.nextLine();
                	endDate = sc.nextLine();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Prepare a call to the stored procedure
                		CallableStatement cs = connection.prepareCall(query);
                		
                		// Set the assigned value(s) to the procedures input
                		cs.setInt("deptNo",	 deptNo);
                		cs.setString("endDate", endDate);
                		
                		// Run the stored procedure and store values in resultSet
        				System.out.println("Dispatching the query...");
        				ResultSet resultSet = cs.executeQuery();
        			
        				System.out.println("Done.");
                		System.out.println("\nTotal labor time for department: " + deptNo +
                							" for date ending on: " + endDate);
                		System.out.println("deptNo	  | timeOfLabor");
                		
                		// Unpack the tuples returned by the database and print them out to the user
                		while (resultSet.next()) {
                			System.out.println(String.format("%s	  | %s",
                                    resultSet.getString(1),
                                    resultSet.getString(2)));
                		}
                	}
                	
                	break;
                	
            	
            	// (11) Retrieve the processes through which a given assembly-id has passed so far 
            	// (in datecommenced order) and the department responsible for each process
                case "11":
                	
                	// Set the query 
                	query = QUERY_11;
                	
                	System.out.println("Please enter the assembly id (integer):");
                	assID = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Prepare a call to the stored procedure
                		CallableStatement cs = connection.prepareCall(query);
                		
                		// Set the assigned value(s) to the procedures input
                		cs.setInt("assID",	 assID);
                		
                		// Run the stored procedure and store values in resultSet
        				System.out.println("Dispatching the query...");
        				ResultSet resultSet = cs.executeQuery();
        			
        				System.out.println("Done.");
                		System.out.println("\nProcess for assembly-id: " + assID + 
                				", and its departement number; Sorted by date commenced.");
                		System.out.println("dateOrdered	  | processID	| deptNo");
                		
                		// Unpack the tuples returned by the database and print them out to the user
                		while (resultSet.next()) {
                			System.out.println(String.format("%s	| %s	| %s",
                					resultSet.getString(1),
                					resultSet.getString(2),
                					resultSet.getString(3)));
                		}
                	}
                	
                	break;
            	
            	// (12) Retrieve the jobs (together with their type information and assembly-id) 
            	// completed during a given date in a given department
                case "12":
                	
                	// Set the query 
                	query = QUERY_12;
                	
                	System.out.println("Please enter the department number:");
                	deptNo = sc.nextInt();
                	
                	System.out.println("Please enter the end date of the job in 'YYYY-MM-DD' format, e.g. 2020-11-30:");
                	sc.nextLine();
                	endDate = sc.nextLine();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Prepare a call to the stored procedure
                		CallableStatement cs = connection.prepareCall(query);
                		
                		// Set the assigned value(s) to the procedures input
                		cs.setInt("deptNo",	 deptNo);
                		cs.setString("endDate", endDate);
                		
                		// Run the stored procedure and store values in resultSet
        				System.out.println("Dispatching the query...");
        				ResultSet resultSet = cs.executeQuery();
        			
        				System.out.println("Done.");
                		System.out.println("\nJobs from department " + deptNo +
                				" completed on: " + endDate);
                		System.out.println("jobNo	  | otherInfo	| assembliesID ");
                		
                		// Unpack the tuples returned by the database and print them out to the user
                		while (resultSet.next()) {
                			System.out.println(String.format("%s	  | %s	| %s",
                					resultSet.getString(1),
                					resultSet.getString(2),
                					resultSet.getString(3)));
                		}
                	}
                	
                	break;
            	
            	// (13) Retrieve the customers (in name order) whose category is in a given range
                case "13":
                	
                	// Set the query 
                	query = QUERY_13;
                	
                	System.out.println("Please enter MIN category number (integer from 1 - 10, inclusive):");
                	int min = sc.nextInt();
                	
                	System.out.println("Please enter MAX category number (integer from 1 - 10, inclusive):");
                	int max = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Prepare a call to the stored procedure
                		CallableStatement cs = connection.prepareCall(query);
                		
                		// Set the assigned value(s) to the procedures input
                		cs.setInt("min", min);
                		cs.setInt("max", max);
                		
                		// Run the stored procedure and store values in resultSet
        				System.out.println("Dispatching the query...");
        				ResultSet resultSet = cs.executeQuery();
        			
        				System.out.println("Done.");
                		System.out.println("\nCustomers with category from " + min + " to " + max);
                		System.out.println("name"); //	  | otherInfo	| assembliesID ");
                		
                		// Unpack the tuples returned by the database and print them out to the user
                		while (resultSet.next()) {
                			System.out.println(String.format("%s", //	  | %s	| %s",
                					resultSet.getString(1)));
                		}
                	}
                	
                	break;
            	
            	// (14) Delete all cut-jobs whose job-no is in a given range
                case "14":
                	
                	// Set the query 
                	query = QUERY_14;
                	
                	System.out.println("Please enter MIN category number (integer from 1 - 10, inclusive):");
                	min = sc.nextInt();
                	
                	System.out.println("Please enter MAX category number (integer from 1 - 10, inclusive):");
                	max = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Prepare a call to the stored procedure
                		PreparedStatement ps = connection.prepareCall(query);
                		
                		// Set the assigned value(s) to the procedures input
                		ps.setInt(1, min);
                		ps.setInt(2, max);
                		
                		
                		
                		System.out.println("Dispatching the query...");
            			// Actually execute the populated query
            			final int rows_deleted = ps.executeUpdate();
            			System.out.println(String.format("Done. %d rows deleted.", rows_deleted) +
            								" from " + min + " to " + max);
                	}
                	
                	break;
            	
            	// (15) Change the color of a given paint job
                case "15":
                	
                	// Set the query 
                	query = QUERY_15;
                	
                	System.out.println("Please enter the new color:");
                	sc.nextLine();
                	String newColor = sc.nextLine();
                	
                	System.out.println("Please enter the job number associated:");
                	jobNo = sc.nextInt();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Prepare a call to the stored procedure
                		PreparedStatement ps = connection.prepareCall(query);
                		
                		// Set the assigned value(s) to the procedures input
                		ps.setString(1, newColor);
                		ps.setInt(2, jobNo);
                		
                		
                		
                		System.out.println("Dispatching the query...");
                		// Actually execute the populated query
                		final int rows_changed = ps.executeUpdate();
                		System.out.println(String.format("Done. %d rows changed.", rows_changed) +
                				" for job number: " + jobNo);
                	}
                	
                	break;
            	
            	// (16) Import: enter new customers from a data file until the file is empty 
            	// (the user must be asked to enter the input file name). 
                	
                case "16":
                	
                	System.out.println("Please enter the location and name of a CSV file with customer data:" +
                						"\n>> PLEASE DO NOT INCLUDE COMMAS EXCEPT FOR THE DELIMITER <<");
                	sc.nextLine();
                	String filename = sc.nextLine();
                	
                	// create insert statement with values from csv file
                	query = readCSV(filename);
                	
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Prepare a call to the stored procedure
                		PreparedStatement ps = connection.prepareCall(query);
                		
                		System.out.println("Dispatching the query...");
                		// Actually execute the populated query
                		final int rows_inserted = ps.executeUpdate();
                		System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                	}
                	break;
                	
            	
            	// (17) Export: Retrieve the customers (in name order) whose category is in a given range 
	            	// and output them to a data file instead of screen (the user must be asked to enter the output file name).
            	
                case "17":
                	
                	// Set the query 
                	query = QUERY_17;
                	
                	System.out.println("Please enter MIN category number (integer from 1 - 10, inclusive):");
                	min = sc.nextInt();
                	
                	System.out.println("Please enter MAX category number (integer from 1 - 10, inclusive):");
                	max = sc.nextInt();
                	
                	System.out.println("Please enter the file output name:");
                	sc.nextLine();
                	filename = sc.nextLine();
                	
                	// Get a database connection and prepare a query statement
                	try (final Connection connection = DriverManager.getConnection(URL)) {
                		
                		// Prepare a call to the stored procedure
                		CallableStatement cs = connection.prepareCall(query);
                		
                		// Set the assigned value(s) to the procedures input
                		cs.setInt("min", min);
                		cs.setInt("max", max);
                		
                		// Run the stored procedure and store values in resultSet
        				System.out.println("Dispatching the query...");
                		ResultSet resultSet = cs.executeQuery();
                		
                		try {
                		      FileWriter myWriter = new FileWriter(filename + ".csv");
                		      myWriter.write("name,address,category\n");
                		      
                		      // Unpack the tuples returned by the database and print them out to the user
                		      while (resultSet.next()) {
                		    	  myWriter.write(String.format("%s,%s,%s\n",
                		    			  resultSet.getString(1),
                		    			  resultSet.getString(2),
                		    			  resultSet.getString(3)));
                		      }
                		      
                		      // close the writer
                		      myWriter.close();
                		      
                		    } catch (IOException e) {
                		      System.out.println("Error with file name.");
                		      e.printStackTrace();
                		    }
                	}
    			
    				System.out.println("Done. File Location here:");
    				System.out.println(filename + ".csv");

                	
                	break;
                	
            	// (18) Quit
                case "18":
                	System.out.println("Finished! Your work here is done.");
            }
        }

        sc.close(); // Close the scanner before exiting the application
    }
}
