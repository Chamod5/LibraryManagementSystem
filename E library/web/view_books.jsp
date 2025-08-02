<%@ page import="java.sql.*" %>
<%@ page import="db.DataBaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Available Books</title>
    <style>
        table { border-collapse: collapse; width: 80%; margin: auto; }
        th, td { padding: 10px; border: 1px solid #000; text-align: center; }
        h2 { text-align: center; }
    </style>
</head>
<body>
    <h2>Available Books</h2>
    <table>
        <tr>
            <th>Book ID</th>
            <th>Title</th>
            <th>Author</th>
            <th>Genre</th>
            <th>Copies Available</th>
        </tr>
        <%
            try {
                Connection conn = DataBaseConnection.initializeDatabase();
                String query = "SELECT * FROM Books WHERE copiesAvailable > 0";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query);

                while(rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getString("bookID") %></td>
                        <td><%= rs.getString("title") %></td>
                        <td><%= rs.getString("author") %></td>
                        <td><%= rs.getString("genre") %></td>
                        <td><%= rs.getInt("copiesAvailable") %></td>
                    </tr>
        <%
                }
                conn.close();
            } catch(Exception e) {
                out.println("<tr><td colspan='5' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>
