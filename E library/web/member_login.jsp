<%-- 
    Document   : member_login
    Created on : Jul 22, 2025, 10:40:13 AM
    Author     : Dell
--%>

<%@ page import="java.sql.*" %>
<%@ page import="db.DataBaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Member Login</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
        }

        .container {
            text-align: center;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }

        input[type="text"],
        input[type="password"] {
            width: 80%;
            padding: 10px;
            margin: 10px 0;
            font-size: 16px;
        }

        input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            margin-top: 10px;
        }

        a {
            display: block;
            margin-top: 15px;
            color: #007bff;
            text-decoration: none;
        }

        p {
            color: red;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Member Login</h2>

    <%
        if (request.getMethod().equals("POST")) {
            String NIC = request.getParameter("NIC");
            String password = request.getParameter("password");
            try {
                Connection con = DataBaseConnection.initializeDatabase();
                PreparedStatement pst = con.prepareStatement("SELECT * FROM Member WHERE NIC=? AND password=?");
                pst.setString(1, NIC);
                pst.setString(2, password);
                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    session.setAttribute("NIC", NIC);
                    response.sendRedirect("member_dashboard.jsp");
                } else {
                    out.println("<p>Invalid credentials</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
    %>

    <form method="post">
        <input type="text" name="NIC" placeholder="NIC" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <input type="submit" value="Login">
    </form>
    <a href="index.html">Back</a>
</div>

</body>
</html>
