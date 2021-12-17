<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8">
        <title>Movie Nights</title>
    </head>
    <body>
        <%@page import="jsp_azure_test.DataHandler"%>
        <%@page import="java.sql.ResultSet"%>
        <%
            // We instantiate the data handler here, and get all the movies from the database
            final DataHandler handler = new DataHandler();
            final ResultSet movies = handler.getAllMovies();
        %>
        <!-- The table for displaying all the movie records -->
        <table cellspacing="2" cellpadding="2" border="1">
            <tr> <!-- The table headers row -->
              <td align="center">
                <h4>Time</h4>
              </td>
              <td align="center">
                <h4>Movie Name</h4>
              </td>
              <td align="center">
                <h4>Duration</h4>
              </td>
              <td align="center">
                <h4>Guest 1</h4>
              </td>
              <td align="center">
                <h4>Guest 2</h4>
              </td>
              <td align="center">
                <h4>Guest 3</h4>
              </td>
              <td align="center">
                <h4>Guest 4</h4>
              </td>
              <td align="center">
                <h4>Guest 5</h4>
              </td>
            </tr>
            <%
               while(movies.next()) { // For each movie_night record returned...
                   // Extract the attribute values for every row returned
                   final String time = movies.getString("start_time");
                   final String name = movies.getString("movie_name");
                   final String duration = movies.getString("duration_min");
                   final String guest1 = movies.getString("guest_1");
                   final String guest2 = movies.getString("guest_2");
                   final String guest3 = movies.getString("guest_3");
                   final String guest4 = movies.getString("guest_4");
                   final String guest5 = movies.getString("guest_5");
                   
                   out.println("<tr>"); // Start printing out the new table row
                   out.println( // Print each attribute value
                        "<td align=\"center\">" + time +
                        "</td><td align=\"center\"> " + name +
                        "</td><td align=\"center\"> " + duration +
                        "</td><td align=\"center\"> " + guest1 +
                        "</td><td align=\"center\"> " + guest2 +
                        "</td><td align=\"center\"> " + guest3 +
                        "</td><td align=\"center\"> " + guest4 +
                        "</td><td align=\"center\"> " + guest5 + "</td>");
                   out.println("</tr>");
               }
               %>
          </table>
    </body>
</html>
