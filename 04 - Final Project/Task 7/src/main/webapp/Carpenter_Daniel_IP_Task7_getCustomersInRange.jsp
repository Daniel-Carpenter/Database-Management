<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Query Result</title>
</head>
    <body>
    <%@page import="JobShopProject.Carpenter_Daniel_IP_Task7_DataHandler"%>
    <%@page import="java.sql.ResultSet"%>
    <%@page import="java.sql.Array"%>
    <%
    // The handler is the one in charge of establishing the connection.
    Carpenter_Daniel_IP_Task7_DataHandler handler = new Carpenter_Daniel_IP_Task7_DataHandler();

    // Get the attribute values passed from the input form.
    String min  = request.getParameter("min");
    String max  = request.getParameter("max");

     // Assume all categories if query fails
     int minAsInt = 1;
     int maxAsInt = 10;
     ResultSet customers;
    
    // detect input
    if (min.equals("") || max.equals("")) {
        response.sendRedirect("Carpenter_Daniel_IP_Task7_getCustomersInRange.jsp");
    } else {
	    // Get the actual input 
	    minAsInt = Integer.parseInt(min);
	    maxAsInt = Integer.parseInt(max);
	    
    }
    // Now perform the query with the data from the form.
    customers = handler.getCustomersInRange(minAsInt, maxAsInt);
   
    
    %>
    <!-- The table for displaying all the customer records -->
    <table cellspacing="2" cellpadding="2" border="1">
        <tr> <!-- The table headers row -->
          <td align="center">
            <h4>name</h4>
          </td>
        </tr>
        <%
           while(customers.next()) { // For each Customer record returned...
               // Extract the attribute values for every row returned
               final String name     = customers.getString("name");
               
               out.println("<tr>"); // Start printing out the new table row
               out.println( // Print each attribute value
                    "<td align=\"center\">" + name + "</td>");
               out.println("</tr>");
           }
           %>
      </table>
      <a href="Carpenter_Daniel_IP_Task7_addCustomerForm.jsp">Add more customers.</a>

    </body>
</html>
