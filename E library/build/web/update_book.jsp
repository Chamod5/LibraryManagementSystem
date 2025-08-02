<%-- 
    Document   : update_book
    Created on : Jul 22, 2025, 11:10:53 PM
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

    String bookID = request.getParameter("bookID") != null ? request.getParameter("bookID") : "";
    String title = "";
    String author = "";
    String genre = "";
    int copies = 0;

    // Handle GET request: Load existing book data
    if ("GET".equalsIgnoreCase(request.getMethod()) && request.getParameter("load") != null && !bookID.isEmpty()) {
        try {
            Connection con = DataBaseConnection.initializeDatabase();
            PreparedStatement pst = con.prepareStatement("SELECT * FROM Books WHERE bookID=?");
            pst.setString(1, bookID);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                title = rs.getString("title");
                author = rs.getString("author");
                genre = rs.getString("genre");
                copies = rs.getInt("copiesAvailable");
            } else {
                out.println("<p>No book found with ID: " + bookID + "</p>");
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error loading book: " + e.getMessage() + "</p>");
        }
    }

    // Handle POST request: Update book data
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("bookID") != null) {
        bookID = request.getParameter("bookID").trim();
        title = request.getParameter("title");
        author = request.getParameter("author");
        genre = request.getParameter("genre");
        copies = Integer.parseInt(request.getParameter("copies"));

        try {
            Connection con = DataBaseConnection.initializeDatabase();
            PreparedStatement pst = con.prepareStatement(
                "UPDATE Books SET title=?, author=?, genre=?, copiesAvailable=? WHERE bookID=?"
            );
            pst.setString(1, title);
            pst.setString(2, author);
            pst.setString(3, genre);
            pst.setInt(4, copies);
            pst.setString(5, bookID);
            int updated = pst.executeUpdate();
            if (updated > 0) {
                out.println("<p>Book updated successfully!</p>");
            } else {
                out.println("<p>No book updated. Check Book ID.</p>");
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error updating book: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head><title>Update Book</title></head>
<body>
<h2>Update Book</h2>

<!-- Form to load book data -->
<form method="get">
    Book ID: <input type="text" name="bookID" value="<%= bookID %>" required>
    <input type="submit" name="load" value="Load Book">
</form>

<!-- Only show the update form if book data was loaded -->
<% if (!title.isEmpty()) { %>
<form method="post">
    <input type="hidden" name="bookID" value="<%= bookID %>">
    Title: <input type="text" name="title" value="<%= title %>" required><br>
    Author: <input type="text" name="author" value="<%= author %>" required><br>
    Genre: <input type="text" name="genre" value="<%= genre %>" required><br>
    Copies Available: <input type="number" name="copies" value="<%= copies %>" required><br>
    <input type="submit" value="Update Book">
</form>
<% } %>

<a href="librarian_dashboard.jsp">Back to Dashboard</a>
</body>
</html>
