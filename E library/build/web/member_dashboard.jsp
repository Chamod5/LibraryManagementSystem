<%-- 
    Document   : member_dashboard
    Created on : Jul 22, 2025, 10:52:51 AM
    Author     : Dell
--%>

<%@ page session="true" %>
<%@ page import="java.sql.*, db.DataBaseConnection" %>

<%
    String NIC = (String) session.getAttribute("NIC");
    String name = "Member";

    if (NIC != null) {
        try {
            Connection con = DataBaseConnection.initializeDatabase();
            PreparedStatement ps = con.prepareStatement("SELECT name FROM Member WHERE NIC = ?");
            ps.setString(1, NIC);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error retrieving name: " + e.getMessage() + "</p>");
        }
    } else {
        response.sendRedirect("member_login.jsp"); // Not logged in
    }

    // Borrow Book Check Logic (runs if form is submitted)
    if (request.getParameter("borrowBookID") != null) {
        String bookID = request.getParameter("borrowBookID");
        try {
            Connection conn = DataBaseConnection.initializeDatabase();
            PreparedStatement checkPs = conn.prepareStatement("SELECT copiesAvailable FROM Books WHERE bookID = ?");
            checkPs.setString(1, bookID);
            ResultSet rsCheck = checkPs.executeQuery();
            if (rsCheck.next()) {
                int available = rsCheck.getInt("copiesAvailable");
                if (available > 0) {
                    // Redirect to borrow confirmation page
                    response.sendRedirect("borrow_book.jsp?bookID=" + bookID);
                } else {
%>
                    <p style="color:red; text-align:center;">Not enough copies available for Book ID: <%= bookID %></p>
<%
                }
            }
            conn.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Member Dashboard</title>
    <style>
        table { border-collapse: collapse; width: 90%; margin: 20px auto; }
        th, td { border: 1px solid black; padding: 8px; text-align: center; }
        h2, h3 { text-align: center; }
        ul { list-style-type: none; }
    </style>
</head>
<body>
<h2>Welcome, <%= name %></h2>
<ul>
    <li><a href="view_borrowed_books.jsp">My Borrowed Books</a></li>
</ul>
<button onclick="window.location.href='edit_member_profile.jsp'">Edit profile</button>
<button onclick="window.location.href='member_login.jsp'">Log Out</button>

<hr>
<h3>Available Books</h3>
<table>
    <tr>
        <th>Book ID</th>
        <th>Title</th>
        <th>Author</th>
        <th>Genre</th>
        <th>Copies Available</th>
        <th>Action</th>
    </tr>
<%
    try {
        Connection conn = DataBaseConnection.initializeDatabase();
        String query = "SELECT * FROM Books WHERE copiesAvailable > 0";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        while(rs.next()) {
            String bookID = rs.getString("bookID");
%>
    <tr>
        <td><%= bookID %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("author") %></td>
        <td><%= rs.getString("genre") %></td>
        <td><%= rs.getInt("copiesAvailable") %></td>
        <td>
            <form method="post" style="margin:0;">
                <input type="hidden" name="borrowBookID" value="<%= bookID %>" />
                <input type="submit" value="Borrow Book" />
            </form>
        </td>
    </tr>
<%
        }
        conn.close();
    } catch(Exception e) {
        out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
    }
%>
</table>
</body>
</html>
