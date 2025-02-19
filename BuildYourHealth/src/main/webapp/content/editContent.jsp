<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="mvc.database.YoutubeUtil"%>
<%@ page import="java.sql.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    // 관리자 인증 확인
    String sessionId = (String) session.getAttribute("sessionId");
    if (sessionId == null || !"admin".equals(sessionId)) {
        response.sendRedirect("../menu/welcome.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("manageContents.jsp?msg=editError");
        return;
    }

    int id = 0;
    try {
        id = Integer.parseInt(idStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("manageContents.jsp?msg=editError");
        return;
    }

    String warningMessage = null;
    String videoUrl = "";
    String title = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // 수정 폼 제출 처리
        videoUrl = request.getParameter("videoUrl");
        title = request.getParameter("title");

        if (videoUrl == null || videoUrl.isEmpty() || title == null || title.isEmpty()) {
            warningMessage = "유튜브 URL과 제목을 모두 입력해주세요.";
        } else {
            // 유튜브 동영상 ID 추출
            String videoId = YoutubeUtil.extractYouTubeId(videoUrl);
            if (videoId == null) {
                warningMessage = "유효한 유튜브 URL을 입력해주세요.";
            } else {
                Connection connection = null;
                PreparedStatement stmt = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connection = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/HealthDB", "root", "1234");

                    String updateQuery = "UPDATE CONTENTS SET video_url = ?, title = ? WHERE id = ?";
                    stmt = connection.prepareStatement(updateQuery);
                    stmt.setString(1, videoUrl);
                    stmt.setString(2, title);
                    stmt.setInt(3, id);
                    int rowsAffected = stmt.executeUpdate();

                    if (rowsAffected > 0) {
                        response.sendRedirect("manageContents.jsp?msg=editSuccess");
                        return;
                    } else {
                        warningMessage = "수정에 실패했습니다.";
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    warningMessage = "오류가 발생했습니다: " + e.getMessage();
                } finally {
                    if (stmt != null) try { stmt.close(); } catch (Exception e) {}
                    if (connection != null) try { connection.close(); } catch (Exception e) {}
                }
            }
        }
    } else {
        // 초기 수정 폼 로드
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/HealthDB", "root", "1234");

            String selectQuery = "SELECT * FROM CONTENTS WHERE id = ?";
            stmt = connection.prepareStatement(selectQuery);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                videoUrl = rs.getString("video_url");
                title = rs.getString("title");
            } else {
                response.sendRedirect("manageContents.jsp?msg=editError");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            warningMessage = "오류가 발생했습니다: " + e.getMessage();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (stmt != null) try { stmt.close(); } catch (Exception e) {}
            if (connection != null) try { connection.close(); } catch (Exception e) {}
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>컨텐츠 수정</title>
    <link href="../resources/css/bootstrap.min.css" rel="stylesheet">
    <script src="../resources/js/sweetalert2.all.min.js"></script>
</head>
<body>
    <div class="container py-4">
        <%@ include file="../templates/menu.jsp"%>	

        <h2 class="mb-4">컨텐츠 수정</h2>
        <% if (warningMessage != null) { %>
            <script>
                Swal.fire({
                    title: '알림',
                    text: "<%= warningMessage %>",
                    icon: 'warning',
                    confirmButtonText: '확인'
                }).then(() => {
                    window.history.back();
                });
            </script>
        <% } %>

        <form action="editContent.jsp?id=<%= id %>" method="post">
            <div class="mb-3">
                <label for="videoUrl" class="form-label">유튜브 URL</label>
                <input type="url" class="form-control" id="videoUrl" name="videoUrl" value="<%= videoUrl %>" required>
            </div>
            <div class="mb-3">
                <label for="title" class="form-label">제목</label>
                <input type="text" class="form-control" id="title" name="title" value="<%= title %>" required>
            </div>
            <button type="submit" class="btn btn-primary">수정하기</button>
            <a href="manageContents.jsp" class="btn btn-secondary">취소</a>
        </form>
    </div>

    <%@ include file="../templates/footer.jsp"%>   

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
