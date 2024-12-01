<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<%
    String sessionId = (String) session.getAttribute("sessionId");

    if (sessionId != null) {
        Connection connection = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/HealthDB", "root", "1234");

            String query = "DELETE FROM MEMBER WHERE id = ?";
            pstmt = connection.prepareStatement(query);
            pstmt.setString(1, sessionId);

            int rowsDeleted = pstmt.executeUpdate();

            if (rowsDeleted > 0) {
%>
<script type="text/javascript">
    alert("회원 탈퇴가 완료되었습니다. 감사합니다.");
    window.location.href = "logoutMember.jsp"; // 로그아웃 처리 후 메인으로 이동
</script>
<%
            } else {
%>
<script type="text/javascript">
    alert("회원 탈퇴에 실패했습니다. 다시 시도해주세요.");
    window.history.back(); // 이전 페이지로 돌아가기
</script>
<%
            }
        } catch (Exception e) {
%>
<script type="text/javascript">
    alert("오류가 발생했습니다: <%= e.getMessage() %>");
    window.history.back();
</script>
<%
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (connection != null) try { connection.close(); } catch (Exception e) {}
        }
    } else {
%>
<script type="text/javascript">
    alert("로그인 상태가 아닙니다.");
    window.location.href = "loginMember.jsp"; // 로그인 페이지로 리디렉션
</script>
<%
    }
%>
