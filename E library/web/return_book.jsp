<%-- 
    Document   : return_book
    Created on : Jul 24, 2025, 11:43:27 PM
    Author     : Dell
--%>

<%@ page import="java.sql.*, db.DataBaseConnection" %>
<%
    String nic = (String) session.getAttribute("NIC");
    if (nic == null) {
        response.sendRedirect("member_login.jsp");
        return;
    }

    String bookID = request.getParameter("bookID");
    String id = request.getParameter("id");

    Connection con = null;

    try {
        con = DataBaseConnection.initializeDatabase();

        // 1. Delete from BorrowedBooks table
        PreparedStatement ps = con.prepareStatement("DELETE FROM BorrowedBooks WHERE id = ? AND NIC = ?");
        ps.setInt(1, Integer.parseInt(id));
        ps.setString(2, nic);
        int rows = ps.executeUpdate();

        if (rows > 0) {
            // 2. Increase available copies in Books
            PreparedStatement ps2 = con.prepareStatement("UPDATE Books SET copiesAvailable = copiesAvailable + 1 WHERE bookID = ?");
            ps2.setString(1, bookID);
            ps2.executeUpdate();
        }

        con.close();
        response.sendRedirect("view_borrowed_books.jsp");
    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
    }
%>
