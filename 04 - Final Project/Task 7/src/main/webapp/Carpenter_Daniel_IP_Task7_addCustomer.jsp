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
    String name     = request.getParameter("name");
    String address  = request.getParameter("address");
    String category = request.getParameter("category");

    /*
     * If the user hasn't filled out all the fields. This is very simple checking.
     */
    if (name.equals("") || address.equals("") || category.equals("")) {
        response.sendRedirect("Carpenter_Daniel_IP_Task7_addCustomerForm.jsp");
    } else {
        int categoryAsInt = Integer.parseInt(category);
        
        // Now perform the query with the data from the form.
        boolean success = handler.addCustomer(name, address, categoryAsInt);
        if (!success) { // Something went wrong
            %>
                <h2>There was a problem inserting the course</h2>
            <%
        } else { // Confirm success to the user
            %>
            <h2>The Customer:</h2>

            <ul>
                <li>Customer Name: <%=name%></li>
                <li>Address: <%=address%></li>
                <li>Category: <%=categoryAsInt%></li>
            </ul>

            <h2>Was successfully inserted.</h2>
            
            <a href="Carpenter_Daniel_IP_Task7_getCustomersInRangeForm.jsp">Retrieve list of customers.</a>
            <%
        }
    }
    %>
    </body>
</html>
