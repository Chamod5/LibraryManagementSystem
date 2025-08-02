<%@ page import="java.sql.*, db.DataBaseConnection" %>
<%
    String bookID = request.getParameter("bookID");
    String nic = (String) session.getAttribute("NIC");

    if (nic == null) {
        response.sendRedirect("member_login.jsp");
        return;
    }

    // Show book details
    String title = "", author = "", genre = "";
    int copiesAvailable = 0;

    try {
        Connection conn = DataBaseConnection.initializeDatabase();
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM Books WHERE bookID = ?");
        ps.setString(1, bookID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            title = rs.getString("title");
            author = rs.getString("author");
            genre = rs.getString("genre");
            copiesAvailable = rs.getInt("copiesAvailable");
        } else {
            out.println("<p style='color:red;'>Invalid Book ID.</p>");
            return;
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error loading book: " + e.getMessage());
        return;
    }

    // Handle borrow confirmation
    if (request.getMethod().equalsIgnoreCase("post")) {
        String password = request.getParameter("password");

        try {
            Connection conn = DataBaseConnection.initializeDatabase();

            // 1. Check how many books this member has borrowed
            PreparedStatement psCount = conn.prepareStatement("SELECT COUNT(*) FROM BorrowedBooks WHERE NIC = ?");
            psCount.setString(1, nic);
            ResultSet rsCount = psCount.executeQuery();
            rsCount.next();
            int borrowCount = rsCount.getInt(1);

            if (borrowCount >= 3) {
                out.println("<p style='color:red;'>You have already borrowed 3 books. Please return a book before borrowing another.</p>");
                out.println("<a href='member_dashboard.jsp'>Back to Dashboard</a>");
                conn.close();
                return;
            }

            // 2. Verify member password
            PreparedStatement psCheck = conn.prepareStatement("SELECT * FROM Member WHERE NIC = ? AND password = ?");
            psCheck.setString(1, nic);
            psCheck.setString(2, password);
            ResultSet rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {
                // 3. Check if copies are available
                PreparedStatement psAvailable = conn.prepareStatement("SELECT copiesAvailable FROM Books WHERE bookID = ?");
                psAvailable.setString(1, bookID);
                ResultSet rsAvailable = psAvailable.executeQuery();

                if (rsAvailable.next() && rsAvailable.getInt("copiesAvailable") > 0) {
                    // 4. Insert into BorrowedBooks
                    PreparedStatement insert = conn.prepareStatement(
                        "INSERT INTO BorrowedBooks (NIC, bookID, borrowDate) VALUES (?, ?, CURRENT_TIMESTAMP)"
                    );
                    insert.setString(1, nic);
                    insert.setString(2, bookID);
                    insert.executeUpdate();

                    // 5. Update Books table
                    PreparedStatement update = conn.prepareStatement(
                        "UPDATE Books SET copiesAvailable = copiesAvailable - 1 WHERE bookID = ?"
                    );
                    update.setString(1, bookID);
                    update.executeUpdate();

                    out.println("<p style='color:green;'>Book borrowed successfully!</p>");
                    out.println("<a href='member_dashboard.jsp'>Back to Dashboard</a>");
                } else {
                    out.println("<p style='color:red;'>No copies available at the moment.</p>");
                    out.println("<a href='member_dashboard.jsp'>Back to Dashboard</a>");
                }
            } else {
                out.println("<p style='color:red;'>Incorrect password. Borrow failed.</p>");
                out.println("<a href='member_dashboard.jsp'>Back to Dashboard</a>");
            }

            conn.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Borrow Book Confirmation</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .book-info { border: 1px solid #ccc; padding: 15px; width: 50%; margin-bottom: 20px; }
        .book-info h3 { margin-top: 0; }
        form { margin-top: 20px; }
    </style>
</head>
<body>
    <div class="book-info">
        <h3>Confirm Borrowing:</h3>
        <p><strong>Book ID:</strong> <%= bookID %></p>
        <p><strong>Title:</strong> <%= title %></p>
        <p><strong>Author:</strong> <%= author %></p>
        <p><strong>Genre:</strong> <%= genre %></p>
        <p><strong>Copies Available:</strong> <%= copiesAvailable %></p>
    </div>

    <form method="post">
        <label>Enter your password to confirm borrowing:</label><br>
        <input type="password" name="password" required />
        <br><br>
        <input type="submit" value="Confirm Borrow" />
        <button type="button" onclick="window.location.href='member_dashboard.jsp'">Cancel</button>
    </form>
</body>
</html>
