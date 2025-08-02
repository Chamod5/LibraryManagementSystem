<%-- 
    Document   : edit_member_profile
    Created on : Jul 22, 2025, 1:26:54 PM
    Author     : Dell
--%>

<%@ page import="java.sql.*, db.DataBaseConnection" %>
<%@ page session="true" %>
<%
    String nic = (String) session.getAttribute("NIC");
    if (nic == null) {
        response.sendRedirect("member_login.jsp");
        return;
    }

    String name = "";
    String phone = "";
    String password = "";

    if (request.getMethod().equals("POST")) {
        name = request.getParameter("name");
        phone = request.getParameter("phone");
        password = request.getParameter("password");

        try {
            Connection con = DataBaseConnection.initializeDatabase();
            PreparedStatement pst = con.prepareStatement(
                "UPDATE Member SET name=?, phone=?, password=? WHERE NIC=?"
            );
            pst.setString(1, name);
            pst.setString(2, phone);
            pst.setString(3, password);
            pst.setString(4, nic);
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
                "SELECT name, phone, password FROM Member WHERE NIC=?"
            );
            pst.setString(1, nic);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                phone = rs.getString("phone");
                password = rs.getString("password");
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
    <title>Edit Member Profile</title>
</head>
<body>
    <h2>Edit Your Profile</h2>
    <form method="post">
        Name: <input type="text" name="name" value="<%= name %>" required><br>
        Phone: <input type="text" name="phone" value="<%= phone %>" required><br>
        Password: <input type="password" name="password" value="<%= password %>" required><br>
        <input type="submit" value="Update Profile">
    </form>
    <a href="member_dashboard.jsp">Back to Dashboard</a>
</body>
</html>
