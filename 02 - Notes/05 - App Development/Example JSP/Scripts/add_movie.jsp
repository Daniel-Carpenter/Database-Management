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
    <%@page import="jsp_azure_test.DataHandler"%>
    <%@page import="java.sql.ResultSet"%>
    <%@page import="java.sql.Array"%>
    <%
    // The handler is the one in charge of establishing the connection.
    DataHandler handler = new DataHandler();

    // Get the attribute values passed from the input form.
    String startTime = request.getParameter("start_time");
    String movieName = request.getParameter("movie_name");
    String durationString = request.getParameter("duration_min");
    String g1 = request.getParameter("guest_1");
    String g2 = request.getParameter("guest_2");
    String g3 = request.getParameter("guest_3");
    String g4 = request.getParameter("guest_4");
    String g5 = request.getParameter("guest_5");

    /*
     * If the user hasn't filled out all the time, movie name and duration. This is very simple checking.
     */
    if (startTime.equals("") || movieName.equals("") || durationString.equals("")) {
        response.sendRedirect("add_movie_form.jsp");
    } else {
        int duration = Integer.parseInt(durationString);
        
        // Now perform the query with the data from the form.
        boolean success = handler.addMovie(startTime, movieName, duration, g1, g2, g3, g4, g5);
        if (!success) { // Something went wrong
            %>
                <h2>There was a problem inserting the course</h2>
            <%
        } else { // Confirm success to the user
            %>
            <h2>The Movie Night:</h2>

            <ul>
                <li>Start Time: <%=startTime%></li>
                <li>Movie Name: <%=movieName%></li>
                <li>Duration: <%=durationString%></li>
                <li>Guest 1: <%=g1%></li>
                <li>Guest 2: <%=g2%></li>
                <li>Guest 3: <%=g3%></li>
                <li>Guest 4: <%=g4%></li>
                <li>Guest 5: <%=g5%></li>
            </ul>

            <h2>Was successfully inserted.</h2>
            
            <a href="get_all_movies.jsp">See all movie nights.</a>
            <%
        }
    }
    %>
    </body>
</html>
