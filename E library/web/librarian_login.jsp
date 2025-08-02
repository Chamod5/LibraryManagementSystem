<%-- 
    Document   : librarian_login
    Created on : Jul 22, 2025, 10:39:11 AM
    Author     : Dell
--%>

<%@ page import="java.sql.*" %>
<%@ page import="db.DataBaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Librarian Login</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;  /* Center horizontally */
            align-items: center;      /* Center vertically */
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
        }

        .container {
            text-align: center;
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }

        input[type="text"],
        input[type="password"] {
            width: 80%;
            padding: 8px;
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
    <h2>Librarian Login</h2>

    <%
        if (request.getMethod().equals("POST")) {
            String userID = request.getParameter("userID");
            String password = request.getParameter("password");
            try {
                Connection con = DataBaseConnection.initializeDatabase();
                PreparedStatement pst = con.prepareStatement("SELECT * FROM Librarian WHERE userID=? AND password=?");
                pst.setString(1, userID);
                pst.setString(2, password);
                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    session.setAttribute("userID", userID);
                    response.sendRedirect("librarian_dashboard.jsp");
                } else {
                    out.println("<p>Invalid credentials</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
    %>

    <form method="post">
        <input type="text" name="userID" placeholder="User ID" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <input type="submit" value="Login">
    </form>
    <a href="index.html">Back</a>
</div>

</body>
</html>
