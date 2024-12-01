<%@ page contentType="text/html; charset=utf-8"%>
<%
    String sessionId = (String) session.getAttribute("sessionId");
    if (sessionId != null) {
        java.sql.Connection connection = null;
        java.sql.PreparedStatement deleteRecordsStmt = null;
        java.sql.PreparedStatement resetMemberStmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = java.sql.DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/HealthDB", "root", "1234");

            // 1. USER_RECORDS 테이블에서 기록 삭제
            String deleteRecordsQuery = "DELETE FROM USER_RECORDS WHERE user_id = ?";
            deleteRecordsStmt = connection.prepareStatement(deleteRecordsQuery);
            deleteRecordsStmt.setString(1, sessionId);
            deleteRecordsStmt.executeUpdate();

            // 2. MEMBER 테이블에서 남은 섭취량 초기화
            String resetMemberQuery = "UPDATE MEMBER SET remaining_water = water_intake, remaining_sleep = sleep_hours WHERE id = ?";
            resetMemberStmt = connection.prepareStatement(resetMemberQuery);
            resetMemberStmt.setString(1, sessionId);
            resetMemberStmt.executeUpdate();

            response.sendRedirect("welcome.jsp?msg=resetSuccess");

        } catch (Exception e) {
            out.println("<p>오류: " + e.getMessage() + "</p>");
        } finally {
            if (deleteRecordsStmt != null) try { deleteRecordsStmt.close(); } catch (Exception e) {}
            if (resetMemberStmt != null) try { resetMemberStmt.close(); } catch (Exception e) {}
            if (connection != null) try { connection.close(); } catch (Exception e) {}
        }
    } else {
        out.println("<p>로그인 상태가 아닙니다.</p>");
    }
%>
