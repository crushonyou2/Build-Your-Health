<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>
<%
    String sessionId = (String) session.getAttribute("sessionId");

    if (sessionId == null || !"admin".equals(sessionId)) {
        response.sendRedirect("../menu/welcome.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("manageContents.jsp?msg=deleteError");
        return;
    }

    int id = 0;
    try {
        id = Integer.parseInt(idStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("manageContents.jsp?msg=deleteError");
        return;
    }

    Connection connection = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/HealthDB", "root", "1234");

        String deleteQuery = "DELETE FROM CONTENTS WHERE id = ?";
        stmt = connection.prepareStatement(deleteQuery);
        stmt.setInt(1, id);
        int rowsAffected = stmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("manageContents.jsp?msg=deleteSuccess");
        } else {
            response.sendRedirect("manageContents.jsp?msg=deleteError");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageContents.jsp?msg=deleteError");
    } finally {
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (connection != null) try { connection.close(); } catch (Exception e) {}
    }
%>
