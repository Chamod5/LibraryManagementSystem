<%-- 
    Document   : edit_librarian_profile
    Created on : Jul 22, 2025, 1:34:21 PM
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

    String name = "";
    String phone = "";
    String password = "";
    String employeeID = "";

    if (request.getMethod().equals("POST")) {
        name = request.getParameter("name");
        phone = request.getParameter("phone");
        password = request.getParameter("password");
        employeeID = request.getParameter("employeeID");

        try {
            Connection con = DataBaseConnection.initializeDatabase();
            PreparedStatement pst = con.prepareStatement(
                "UPDATE Librarian SET name=?, phone=?, password=?, employeeID=? WHERE userID=?"
            );
            pst.setString(1, name);
            pst.setString(2, phone);
            pst.setString(3, password);
            pst.setString(4, employeeID);
            pst.setString(5, userID);
            
            int updated = pst.executeUpdate();
            if (updated > 0) {
                out.println("<p>Profile updated successfully!</p>");
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    } else {
        try {
            Connection con = DataBaseConnection.initializeDatabase();
            PreparedStatement pst = con.prepareStatement(
                "SELECT name, phone, password, employeeID FROM Librarian WHERE userID=?"
            );
            pst.setString(1, userID);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                phone = rs.getString("phone");
                password = rs.getString("password");
                employeeID = rs.getString("employeeID");
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Librarian Profile</title>
</head>
<body>
    <h2>Edit Your Profile</h2>
    <form method="post">
        Name: <input type="text" name="name" value="<%= name %>" required><br>
        Phone: <input type="text" name="phone" value="<%= phone %>" required><br>
        Password: <input type="password" name="password" value="<%= password %>" required><br>
        Employee ID: <input type="text" name="employeeID" value="<%= employeeID %>" required><br>
        <input type="submit" value="Update Profile">
    </form>
    <a href="librarian_dashboard.jsp">Back to Dashboard</a>
</body>
</html>
