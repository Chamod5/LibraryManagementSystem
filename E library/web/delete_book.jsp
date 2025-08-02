<%-- 
    Document   : delete_book
    Created on : Jul 22, 2025, 11:12:15 PM
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
        try {
            Connection con = DataBaseConnection.initializeDatabase();
            PreparedStatement pst = con.prepareStatement("DELETE FROM Books WHERE bookID=?");
            pst.setString(1, bookID);
            int deleted = pst.executeUpdate();
            if (deleted > 0) {
                out.println("<p>Book deleted successfully!</p>");
            } else {
                out.println("<p>No book found with ID: " + bookID + "</p>");
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>
<!DOCTYPE html>
<html>
<head><title>Delete Book</title></head>
<body>
<h2>Delete Book</h2>
<form method="post">
    Book ID: <input type="text" name="bookID" required><br>
    <input type="submit" value="Delete Book">
</form>
<a href="librarian_dashboard.jsp">Back to Dashboard</a>
</body>
</html>
