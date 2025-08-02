<%-- 
    Document   : add_book
    Created on : Jul 22, 2025, 11:14:10 PM
    Author     : Dell
--%>

<%@ page import="java.sql.*, db.DataBaseConnection" %>
<%@ page session="true" %>
<%
    String userID = (String) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("librarian_login.jsp");
        return;
    }

    if (request.getMethod().equals("POST")) {
        String bookID = request.getParameter("bookID");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String genre = request.getParameter("genre");
        int copies = Integer.parseInt(request.getParameter("copies"));

        try {
            Connection con = DataBaseConnection.initializeDatabase();
            PreparedStatement pst = con.prepareStatement("INSERT INTO Books VALUES (?, ?, ?, ?, ?)");
            pst.setString(1, bookID);
            pst.setString(2, title);
            pst.setString(3, author);
            pst.setString(4, genre);
            pst.setInt(5, copies);
            pst.executeUpdate();
            out.println("<p>Book added successfully!</p>");
            con.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>
<!DOCTYPE html>
<html>
<head><title>Add Book</title></head>
<body>
<h2>Add New Book</h2>
<form method="post">
    Book ID: <input type="text" name="bookID" required><br>
    Title: <input type="text" name="title" required><br>
    Author: <input type="text" name="author" required><br>
    Genre: <input type="text" name="genre" required><br>
    Copies Available: <input type="number" name="copies" required><br>
    <input type="submit" value="Add Book">
</form>
<a href="librarian_dashboard.jsp">Back to Dashboard</a>
</body>
</html>
