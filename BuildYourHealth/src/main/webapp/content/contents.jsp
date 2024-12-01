<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <link href="../resources/css/bootstrap.min.css" rel="stylesheet">
    <title>추천 컨텐츠</title>
    <style>
        .video-card {
            margin-bottom: 20px;
        }
        .video-thumbnail {
            width: 100%;
            height: auto;
            border-radius: 5px;
        }
        .video-title {
            font-size: 1rem;
            font-weight: bold;
            margin-top: 10px;
            text-align: center;
        }
        .recommendation-section {
            background-image: url('../resources/images/happy.jpg');
            background-size: cover;
            background-position: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .recommendation-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* 검은색 반투명 오버레이 */
            z-index: 1;
        }

        .recommendation-section .container-fluid {
            position: relative;
            z-index: 2;
        }

        .recommendation-section h1,
        .recommendation-section p {
            color: white;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <%@ include file="../templates/menu.jsp"%>
        <div class="p-5 mb-4 rounded-3 recommendation-section">
            <div class="container-fluid py-5">
                <h1 class="display-5 fw-bold">오늘의 추천 컨텐츠</h1>
                <p class="col-md-8 fs-4">건강한 삶을 위한 유익한 영상을 확인해보세요.</p>      
            </div>
        </div>

        <!-- 추천 컨텐츠 리스트 -->
        <div class="row">
            <%! 
                /**
                 * 유튜브 URL에서 동영상 ID를 추출하는 메서드
                 * 지원하는 URL 형식:
                 * 1. https://www.youtube.com/watch?v=VIDEO_ID
                 * 2. https://youtu.be/VIDEO_ID
                 * @param url 유튜브 동영상 URL
                 * @return 동영상 ID 또는 null
                 */
                public String extractYouTubeId(String url) {
                    // 패턴 1: https://www.youtube.com/watch?v=VIDEO_ID
                    Pattern pattern1 = Pattern.compile("v=([a-zA-Z0-9_-]{11})");
                    Matcher matcher1 = pattern1.matcher(url);
                    if (matcher1.find()) {
                        return matcher1.group(1);
                    }

                    // 패턴 2: https://youtu.be/VIDEO_ID
                    Pattern pattern2 = Pattern.compile("youtu\\.be/([a-zA-Z0-9_-]{11})");
                    Matcher matcher2 = pattern2.matcher(url);
                    if (matcher2.find()) {
                        return matcher2.group(1);
                    }

                    return null; // ID를 찾지 못한 경우
                }
            %>
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

                    int columnCount = 3; // 한 행에 표시할 컨텐츠 수
                    int currentColumn = 0;

                    while (rs.next()) {
                        if (currentColumn % columnCount == 0) { %>
                            <div class="row">
                        <% }

                        String videoUrl = rs.getString("video_url");
                        String title = rs.getString("title");
                        String videoId = extractYouTubeId(videoUrl);
                        String thumbnailUrl = (videoId != null) ? "https://img.youtube.com/vi/" + videoId + "/0.jpg" : "";

                        if (videoId != null) { %>
                            <div class="col-md-4 video-card">
                                <a href="<%= videoUrl %>" target="_blank">
                                    <img src="<%= thumbnailUrl %>" alt="Video Thumbnail" class="video-thumbnail">
                                    <p class="video-title"><%= title %></p>
                                </a>
                            </div>
                        <% }

                        currentColumn++;

                        if (currentColumn % columnCount == 0) { %>
                            </div>
                        <% }
                    }

                    // 마지막 행이 닫히지 않은 경우 닫기
                    if (currentColumn % columnCount != 0) { %>
                        </div>
                    <% }

                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (stmt != null) try { stmt.close(); } catch (Exception e) {}
                    if (connection != null) try { connection.close(); } catch (Exception e) {}
                }
            %>
        </div>

        <%@ include file="../templates/footer.jsp"%>   
    </div>
</body>
</html>
