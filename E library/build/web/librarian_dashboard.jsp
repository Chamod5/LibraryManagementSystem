<%-- 
    Document   : librarian_dashboard
    Created on : Jul 22, 2025, 10:52:01 AM
    Author     : Dell
--%>
<%@ page session="true" %>
<%@ page import="java.sql.*, db.DataBaseConnection" %>
<%
    String userID = (String) session.getAttribute("userID");
    String name = "Librarian";

    if (userID != null) {
        try {
            Connection con = DataBaseConnection.initializeDatabase();
            PreparedStatement ps = con.prepareStatement(
                "SELECT name FROM Librarian WHERE userID = ?"
            );
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error retrieving name: " + e.getMessage() + "</p>");
        }
    } else {
        response.sendRedirect("librarian_login.jsp"); // Not logged in
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Librarian Dashboard</title>
    <style>
        table { border-collapse: collapse; width: 90%; margin: 20px auto; }
        th, td { border: 1px solid black; padding: 8px; text-align: center; }
        h2, h3 { text-align: center; }
        ul { list-style-type: none; }
    </style>
</head>
<body>
<h2>Welcome, <%= name %> </h2>
<ul>
    <li><a href="add_book.jsp">Add Book</a></li>
    <li><a href="update_book.jsp">Update Book</a></li>
    <li><a href="delete_book.jsp">Delete Book</a></li>
</ul>
<button onclick="window.location.href='edit_librarian_profile.jsp'">Edit profile</button>
<button onclick="window.location.href='librarian_login.jsp'">Log Out</button>

<hr>
<h3>All Available Books</h3>
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
            Connection con = DataBaseConnection.initializeDatabase();
            String query = "SELECT * FROM Books WHERE copiesAvailable > 0";
            Statement stmt = con.createStatement();
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
            con.close();
        } catch(Exception e) {
            out.println("<tr><td colspan='5' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
        }
    %>
</table>
</body>
</html>
