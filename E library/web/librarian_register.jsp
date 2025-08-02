<%-- 
    Document   : librarian_register
    Created on : Jul 22, 2025, 9:34:55 PM
    Author     : Dell
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>


<%@ page import="db.DataBaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Librarian Register</title>
</head>
<body>
    <h2>Librarian Register</h2>
<% if (request.getMethod().equals("POST")) {
    String userID = request.getParameter("userID");
    String name = request.getParameter("name");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");
    String employeeID = request.getParameter("employeeID");
    try {
        Connection con = DataBaseConnection.initializeDatabase();
        PreparedStatement pst = con.prepareStatement("INSERT INTO Librarian VALUES (?, ?, ?, ?, ?)");
        pst.setString(1, userID);
        pst.setString(2, name);
        pst.setString(3, employeeID);
        pst.setString(4, phone);
        pst.setString(5, password);
        pst.executeUpdate();
        out.println("<p>Registration successful!</p>");
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
} %>
<form method="post">
    User ID: <input type="text" name="userID" required><br>
    Name: <input type="text" name="name" required><br>
    Password: <input type="password" name="password" required><br>
    Phone: <input type="text" name="phone" required><br>
    Employee ID: <input type="text" name="employeeID" required><br>
    <input type="submit" value="Register">
</form>
</body>
</html>
