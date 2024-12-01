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

    // 메시지 확인
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>컨텐츠 관리</title>
    <link href="../resources/css/bootstrap.min.css" rel="stylesheet">
    <script src="../resources/js/sweetalert2.all.min.js"></script>
    <style>
        .table-container {
            margin-top: 20px;
        }
        .form-container {
            margin-top: 40px;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <%@ include file="../templates/menu.jsp"%>	

        <h2 class="mb-4">추천 컨텐츠 관리</h2>

        <!-- 메시지 표시 -->
        <% if (msg != null) { %>
            <script>
                <% if ("addSuccess".equals(msg)) { %>
                    Swal.fire({
                        title: '성공',
                        text: '컨텐츠가 성공적으로 추가되었습니다.',
                        icon: 'success',
                        confirmButtonText: '확인'
                    });
                <% } else if ("editSuccess".equals(msg)) { %>
                    Swal.fire({
                        title: '성공',
                        text: '컨텐츠가 성공적으로 수정되었습니다.',
                        icon: 'success',
                        confirmButtonText: '확인'
                    });
                <% } else if ("deleteSuccess".equals(msg)) { %>
                    Swal.fire({
                        title: '성공',
                        text: '컨텐츠가 성공적으로 삭제되었습니다.',
                        icon: 'success',
                        confirmButtonText: '확인'
                    });
                <% } else if ("addError".equals(msg) || "editError".equals(msg) || "deleteError".equals(msg)) { %>
                    Swal.fire({
                        title: '오류',
                        text: '작업 중 오류가 발생했습니다.',
                        icon: 'error',
                        confirmButtonText: '확인'
                    });
                <% } %>
            </script>
        <% } %>

        <!-- 컨텐츠 목록 테이블 -->
        <div class="table-container">
            <table class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>유튜브 URL</th>
                        <th>제목</th>
                        <th>썸네일</th>
                        <th>수정</th>
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection connection = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            connection = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/HealthDB", "root", "1234");

                            String query = "SELECT * FROM CONTENTS";
                            stmt = connection.prepareStatement(query);
                            rs = stmt.executeQuery();

                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String videoUrl = rs.getString("video_url");
                                String title = rs.getString("title");
                                String videoId = YoutubeUtil.extractYouTubeId(videoUrl);
                                String thumbnailUrl = (videoId != null) ? "https://img.youtube.com/vi/" + videoId + "/0.jpg" : "";

                                out.println("<tr>");
                                out.println("<td>" + id + "</td>");
                                out.println("<td><a href='" + videoUrl + "' target='_blank'>" + videoUrl + "</a></td>");
                                out.println("<td>" + title + "</td>");
                                if (!thumbnailUrl.isEmpty()) {
                                    out.println("<td><img src='" + thumbnailUrl + "' alt='Thumbnail' width='120'></td>");
                                } else {
                                    out.println("<td>N/A</td>");
                                }
                                out.println("<td><a href='editContent.jsp?id=" + id + "' class='btn btn-primary btn-sm'>수정</a></td>");
                                out.println("<td><a href='deleteContent.jsp?id=" + id + "' class='btn btn-danger btn-sm delete-button' data-id='" + id + "'>삭제</a></td>");
                                out.println("</tr>");
                            }

                        } catch (Exception e) {
                            e.printStackTrace();
                            out.println("<tr><td colspan='6'>오류가 발생했습니다: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (Exception e) {}
                            if (stmt != null) try { stmt.close(); } catch (Exception e) {}
                            if (connection != null) try { connection.close(); } catch (Exception e) {}
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- 새로운 컨텐츠 추가 폼 -->
        <div class="form-container">
            <h3>새로운 컨텐츠 추가</h3>
            <form action="addContent.jsp" method="post">
                <div class="mb-3">
                    <label for="videoUrl" class="form-label">유튜브 URL</label>
                    <input type="url" class="form-control" id="videoUrl" name="videoUrl" required>
                </div>
                <div class="mb-3">
                    <label for="title" class="form-label">제목</label>
                    <input type="text" class="form-control" id="title" name="title" required>
                </div>
                <button type="submit" class="btn btn-success">추가하기</button>
            </form>
        </div>

        <%@ include file="../templates/footer.jsp"%>   
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const deleteButtons = document.querySelectorAll('.delete-button');

            deleteButtons.forEach(function(button) {
                button.addEventListener('click', function(event) {
                    event.preventDefault(); // 기본 링크 동작 방지

                    const deleteUrl = this.getAttribute('href');

                    Swal.fire({
                        title: '정말 삭제하시겠습니까?',
                        text: "삭제된 데이터는 복구할 수 없습니다.",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: '삭제',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = deleteUrl;
                        }
                    });
                });
            });
        });
    </script>
</body>
</html>
