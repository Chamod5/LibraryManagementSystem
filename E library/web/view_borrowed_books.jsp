<%@ page import="java.sql.*, db.DataBaseConnection" %>
<%@ page session="true" %>
<%
    String nic = (String) session.getAttribute("NIC");
    if (nic == null) {
        response.sendRedirect("member_login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Borrowed Books</title>
    <style>
        body { font-family: Arial; background-color: #f0f0f0; padding: 20px; }
        h2 { text-align: center; }
        table {
            width: 90%;
            margin: auto;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 0 10px #ccc;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #eee;
        }
        .center {
            text-align: center;
            margin-top: 20px;
        }
        a, button {
            text-decoration: none;
            background-color: #007bff;
            color: white;
            padding: 8px 15px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }
        a:hover, button:hover {
            background-color: #0056b3;
        }
        form { display: inline; }
    </style>
</head>
<body>

<h2>My Borrowed Books</h2>

<%
    try {
        con = DataBaseConnection.initializeDatabase();
        String query = "SELECT b.id, b.bookID, bk.title, bk.author, bk.genre, b.borrowDate " +
                       "FROM BorrowedBooks b JOIN Books bk ON b.bookID = bk.bookID " +
                       "WHERE b.NIC = ? ORDER BY b.borrowDate DESC";

        ps = con.prepareStatement(query);
        ps.setString(1, nic);
        rs = ps.executeQuery();

        boolean hasRecords = false;
%>
<table>
    <tr>
        <th>Book ID</th>
        <th>Title</th>
        <th>Author</th>
        <th>Genre</th>
        <th>Borrow Date</th>
        <th>Action</th>
    </tr>
<%
        while (rs.next()) {
            hasRecords = true;
%>
    <tr>
        <td><%= rs.getString("bookID") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("author") %></td>
        <td><%= rs.getString("genre") %></td>
        <td><%= rs.getTimestamp("borrowDate") %></td>
        <td>
            <form method="post" action="return_book.jsp">
                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <input type="hidden" name="bookID" value="<%= rs.getString("bookID") %>">
                <button type="submit">Return</button>
            </form>
        </td>
    </tr>
<%
        }
%>
</table>
<%
        if (!hasRecords) {
%>
    <p class="center">You haven't borrowed any books yet.</p>
<%
        }
    } catch (Exception e) {
%>
    <p style="color:red; text-align:center;">Error: <%= e.getMessage() %></p>
<%
    } finally {
        try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception e) {}
    }
%>

<div class="center">
    <a href="member_dashboard.jsp">Back to Dashboard</a>
</div>

</body>
</html>
