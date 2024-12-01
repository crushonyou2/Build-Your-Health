<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String sessionId = (String) session.getAttribute("sessionId");
    String sessionName = (String) session.getAttribute("sessionName");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Build Your Health!</title>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css">
    <link rel="stylesheet" href="../resources/css/sweetalert2.min.css">
    <script src="../resources/js/sweetalert2.all.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <header class="mb-4">
        <h1 class="text-center text-primary">Build Your Health</h1>
        <p class="text-center text-secondary">
            <% if ("admin".equals(sessionId)) { %>
                홈페이지 관리 기능
            <% } else { %>
                매일 건강한 물 섭취량과 수면 시간을 기록하세요!
            <% } %>
        </p>
    </header>

    <% if (sessionId != null) { %>
        <% if ("admin".equals(sessionId)) { %>
            <!-- 관리자용 콘텐츠 -->
            <div class="card mb-4">
                <div class="card-body text-center">
                    <h4 class="card-title">환영합니다, 관리자님!</h4>
                    <p class="card-text">아래에서 홈페이지를 관리할 수 있습니다.</p>
                    <div class="list-group">
                        <a href="../content/manageContents.jsp" class="list-group-item list-group-item-action">컨텐츠 관리</a>
                        <a href="../product/addProduct.jsp" class="list-group-item list-group-item-action">상품 등록</a>
                        <a href="../product/editProduct.jsp?edit=update" class="list-group-item list-group-item-action">상품 편집</a>
                    </div>
                </div>
            </div>
        <% } else { %>
            <!-- 일반 사용자용 콘텐츠 -->
            <%!
                // 남은 섭취량 비율을 계산하여 퍼센티지 반환
                public int calculatePercentage(double remaining, double recommended) {
                    if (recommended <= 0) {
                        return 0; // 권장 섭취량이 0 이하인 경우
                    }
                    double consumed = recommended - remaining;
                    double percentage = (consumed / recommended) * 100;
                    if (percentage < 0) percentage = 0;
                    if (percentage > 100) percentage = 100;
                    return (int) percentage;
                }
            %>
            <%
                // 데이터베이스 연결 및 권장 섭취량, 남은 섭취량 가져오기
                Connection connection = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connection = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/HealthDB", "root", "1234");

                    String query = "SELECT water_intake, sleep_hours, remaining_water, remaining_sleep " +
                                   "FROM MEMBER WHERE id = ?";
                    stmt = connection.prepareStatement(query);
                    stmt.setString(1, sessionId);
                    rs = stmt.executeQuery();

                    double waterIntake = 0.0;
                    double sleepHours = 0.0;
                    double remainingWater = 0.0;
                    double remainingSleep = 0.0;

                    if (rs.next()) {
                        waterIntake = rs.getDouble("water_intake");
                        sleepHours = rs.getDouble("sleep_hours");
                        remainingWater = rs.getDouble("remaining_water");
                        remainingSleep = rs.getDouble("remaining_sleep");
                    }

                    int waterPercentage = calculatePercentage(remainingWater, waterIntake);
                    int sleepPercentage = calculatePercentage(remainingSleep, sleepHours);
            %>

            <!-- 사용자 정보 -->
            <div class="card mb-4">
                <div class="card-body">
                    <h4 class="card-title">환영합니다, <%= sessionName %> 님!</h4>
                    <p class="card-text">아래에서 오늘의 기록을 추가하거나 수정할 수 있습니다.</p>
                </div>
            </div>

            <!-- 권장 섭취량 및 남은 섭취량 -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="card border-success">
                        <div class="card-header bg-success text-white">오늘의 권장 물 섭취량</div>
                        <div class="card-body">
                            <p class="card-text">권장 섭취량: <strong><%= String.format("%.1f", waterIntake) %> L</strong></p>
                            <p class="card-text">남은 섭취량: <strong><%= String.format("%.1f", remainingWater) %> L</strong></p>
                            <!-- 진행률 바 -->
                            <div class="progress">
                                <div class="progress-bar <%= waterPercentage >= 100 ? "bg-success" : (waterPercentage >= 50 ? "bg-info" : "bg-warning") %>" 
                                     role="progressbar" 
                                     style="width: <%= waterPercentage %>%;" 
                                     aria-valuenow="<%= waterPercentage %>" 
                                     aria-valuemin="0" 
                                     aria-valuemax="100">
                                    <%= waterPercentage %>%
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card border-primary"> 
                        <div class="card-header bg-primary text-white">오늘의 권장 수면 시간</div>
                        <div class="card-body">
                            <p class="card-text">권장 수면 시간: <strong><%= String.format("%.1f", sleepHours) %> 시간</strong></p>
                            <p class="card-text">남은 수면 시간: <strong><%= String.format("%.1f", remainingSleep) %> 시간</strong></p>
                            <!-- 진행률 바 -->
                            <div class="progress">
                                <div class="progress-bar <%= sleepPercentage >= 100 ? "bg-success" : (sleepPercentage >= 50 ? "bg-info" : "bg-warning") %>" 
                                     role="progressbar" 
                                     style="width: <%= sleepPercentage %>%;" 
                                     aria-valuenow="<%= sleepPercentage %>" 
                                     aria-valuemin="0" 
                                     aria-valuemax="100">
                                    <%= sleepPercentage %>%
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 기록 추가 -->
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">기록 추가</h5>
                    <p class="card-text">추가할 물 섭취량과 수면 시간을 입력하세요.</p>
                    <form action="updateUserMetrics.jsp" method="post" class="row g-3">
                        <div class="col-md-6">
                            <label for="consumedWater" class="form-label">오늘 섭취한 물의 양 (L)</label>
                            <input type="number" step="0.1" name="consumedWater" class="form-control" id="consumedWater" required>
                        </div>
                        <div class="col-md-6">
                            <label for="sleptHours" class="form-label">오늘 잔 수면 시간 (시간)</label>
                            <input type="number" step="0.1" name="sleptHours" class="form-control" id="sleptHours" required>
                        </div>
                        <div class="col-12 text-center">
                            <button type="submit" class="btn btn-success">기록하기</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 기록 수정 -->
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">기록 수정</h5>
                    <p class="card-text">감소할 물 섭취량과 수면 시간을 입력하세요.</p>
                    <form action="adjustUserMetrics.jsp" method="post" class="row g-3">
                        <div class="col-md-6">
                            <label for="adjustWater" class="form-label">감소할 물 섭취량 (L)</label>
                            <input type="number" step="0.1" name="adjustWater" class="form-control" id="adjustWater" required>
                        </div>
                        <div class="col-md-6">
                            <label for="adjustSleep" class="form-label">감소할 수면 시간 (시간)</label>
                            <input type="number" step="0.1" name="adjustSleep" class="form-control" id="adjustSleep" required>
                        </div>
                        <div class="col-12 text-center">
                            <button type="submit" class="btn btn-warning">수정하기</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 기록 초기화 -->
            <div class="text-center">
                <form action="resetUserMetrics.jsp" method="post">
                    <button type="submit" class="btn btn-danger">기록 초기화</button>
                </form>
            </div>
            <%
                } catch (Exception e) {
                    out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (stmt != null) try { stmt.close(); } catch (Exception e) {}
                    if (connection != null) try { connection.close(); } catch (Exception e) {}
                }
            %>
        <% } %>
    <% } else { %>
        <!-- 비로그인 상태 -->
        <div class="alert alert-warning text-center">
            <p>로그인 상태가 아닙니다. 로그인 후 기록을 확인하세요.</p>
        </div>
    <% } %>
</div>
<footer>
    <div class="container">
        <ul class="nav justify-content-center border-top pt-3">
            <!-- 모든 상태에서 Home 메뉴 표시 -->
            <li class="nav-item"><a class="nav-link" href="/BuildYourHealth/user/welcome.jsp">Home</a></li>
            <c:choose>
                <c:when test="${empty sessionId}">
                    <!-- 로그인하지 않은 상태 -->
                    <li class="nav-item"><a class="nav-link" href="<c:url value="/member/loginMember.jsp"/>">로그인</a></li>
                    <li class="nav-item"><a class="nav-link" href="<c:url value="/member/addMember.jsp"/>">회원 가입</a></li>
                </c:when>
                <c:otherwise>
                    <!-- 로그인한 상태 -->
                    <!-- admin이 아닐 경우 -->
	                <c:if test="${sessionId != 'admin'}">
					  <li class="nav-item"><a class="nav-link" href="<c:url value='/member/updateMember.jsp'/>">회원 수정</a></li>
					</c:if>
                    <li class="nav-item"><a class="nav-link" href="<c:url value="/member/logoutMember.jsp"/>">로그아웃</a></li>
                    <li class="nav-item"><a class="nav-link" href="<c:url value="/content/contents.jsp"/>">추천 컨텐츠</a></li>
                    <li class="nav-item"><a class="nav-link" href="<c:url value="/product/products.jsp"/>">상품 목록</a></li>
                    <li class="nav-item"><a class="nav-link" href="<c:url value="../BoardListAction.do?pageNum=1"/>">게시판</a></li>
                    

                    <!-- admin 계정만 표시 -->
                    <c:if test="${sessionId == 'admin'}">
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/content/manageContents.jsp"/>">컨텐츠 관리</a></li>
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/product/addProduct.jsp"/>">상품 등록</a></li>
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/product/editProduct.jsp?edit=update"/>">상품 편집</a></li>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
