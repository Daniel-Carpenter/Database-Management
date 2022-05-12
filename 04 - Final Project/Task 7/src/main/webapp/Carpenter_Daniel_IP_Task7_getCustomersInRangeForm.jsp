<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Get customers whose category is in a given range </title>
    </head>
    <body>
        <h2>Get Customers</h2>
        <!--
            Form for collecting user input for the new Customer record.
            Upon form submission, addCustomer.jsp file will be invoked.
        -->
        <form action="Carpenter_Daniel_IP_Task7_getCustomersInRange.jsp">
            <!-- The form organized in an HTML table for better clarity. -->
            <table border=1>
                <tr>
                    <th colspan="2">Retrieve the customers (in name order) whose category is in range 1 through 10 (integer):</th>
                </tr>
                <tr>
                    <td>Min Value:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=min>
                    </div></td>
                </tr>
                <tr>
                    <td>Max Value:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=max>
                    </div></td>
                </tr>
                <tr>
                    <td><div style="text-align: center;">
                    <input type=reset value=Clear>
                    </div></td>
                    <td><div style="text-align: center;">
                    <input type=submit value=Submit>
                    </div></td>
                </tr>
            </table>
        </form>
    </body>
</html>
