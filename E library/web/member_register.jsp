<%-- 
    Document   : member_register
    Created on : Jul 22, 2025, 10:36:02 AM
    Author     : Dell
--%>

<%@ page import="java.sql.*" %>
<%@ page import="db.DataBaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Member Register</title>
</head>
<body>
    <h2>Member Register</h2>
<% if (request.getMethod().equals("POST")) {
    String NIC = request.getParameter("NIC");
    String name = request.getParameter("name");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");
    try {
        Connection con = DataBaseConnection.initializeDatabase();
        PreparedStatement pst = con.prepareStatement("INSERT INTO Member VALUES (?, ?, ?, ?)");
        pst.setString(1, NIC);
        pst.setString(2, name);
        pst.setString(3, phone);
        pst.setString(4, password);
        pst.executeUpdate();
        out.println("<p>Registration successful!</p>");
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
} %>
<form method="post">
    NIC: <input type="text" name="NIC" required><br>
    Name: <input type="text" name="name" required><br>
    Phone: <input type="text" name="phone" required><br>
    Password: <input type="password" name="password" required><br>

    <input type="submit" value="Register">
</form>
</body>
</html>
