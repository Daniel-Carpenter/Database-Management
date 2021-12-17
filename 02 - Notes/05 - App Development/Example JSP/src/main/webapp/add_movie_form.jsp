<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add Movie Night</title>
    </head>
    <body>
        <h2>Add Movie Night</h2>
        <!--
            Form for collecting user input for the new movie_night record.
            Upon form submission, add_movie.jsp file will be invoked.
        -->
        <form action="add_movie.jsp">
            <!-- The form organized in an HTML table for better clarity. -->
            <table border=1>
                <tr>
                    <th colspan="2">Enter the Movie Night Data:</th>
                </tr>
                <tr>
                    <td>Movie night time:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=start_time>
                    </div></td>
                </tr>
                <tr>
                    <td>Movie Name:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=movie_name>
                    </div></td>
                </tr>
                <tr>
                    <td>Duration:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=duration_min>
                    </div></td>
                </tr>
                <tr>
                    <td>Guest 1 Name:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=guest_1>
                    </div></td>
                </tr>
                <tr>
                    <td>Guest 2 Name</td>
                    <td><div style="text-align: center;">
                    <input type=text name=guest_2>
                    </div></td>
                </tr>
                <tr>
                    <td>Guest 3 Name</td>
                    <td><div style="text-align: center;">
                    <input type=text name=guest_3>
                    </div></td>
                </tr>
                <tr>
                    <td>Guest 4 Name</td>
                    <td><div style="text-align: center;">
                    <input type=text name=guest_4>
                    </div></td>
                </tr>
                <tr>
                    <td>Guest 5 Name</td>
                    <td><div style="text-align: center;">
                    <input type=text name=guest_5>
                    </div></td>
                </tr>
                <tr>
                    <td><div style="text-align: center;">
                    <input type=reset value=Clear>
                    </div></td>
                    <td><div style="text-align: center;">
                    <input type=submit value=Insert>
                    </div></td>
                </tr>
            </table>
        </form>
    </body>
</html>
