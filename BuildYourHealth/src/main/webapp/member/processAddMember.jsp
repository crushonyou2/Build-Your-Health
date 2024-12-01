<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 가입 처리</title>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
    <link rel="stylesheet" href="../resources/css/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <%
        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String year = request.getParameter("birthyy");
        String month = request.getParameter("birthmm");
        String day = request.getParameter("birthdd");
        String birth = null; // 초기값 null
        if (year != null && !year.isEmpty() && month != null && !month.isEmpty() && day != null && !day.isEmpty()) {
            birth = year + "-" + month + "-" + day; // 유효한 생일 조합이 있을 경우에만 설정
        }
        String mail1 = request.getParameter("mail1");
        String mail2 = request.getParameter("mail2");
        String mail = mail1 + "@" + mail2;
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String ageGroup = request.getParameter("ageGroup"); // 추가된 연령대 필드

        // Default 추천 값
        double waterIntake = 0;
        double sleepHours = 0;
        switch (ageGroup) {
            case "20s":
                waterIntake = 2.5;
                sleepHours = 8.0;
                break;
            case "30s":
                waterIntake = 2.3;
                sleepHours = 8.0;
                break;
            case "40s":
                waterIntake = 2.2;
                sleepHours = 8.0;
                break;
            case "50s":
                waterIntake = 2.0;
                sleepHours = 7.5;
                break;
            case "60s":
                waterIntake = 1.8;
                sleepHours = 7.5;
                break;
            default:
                waterIntake = 2.0;
                sleepHours = 7.0;
        }

        Date currentDatetime = new Date(System.currentTimeMillis());
        java.sql.Timestamp timestamp = new java.sql.Timestamp(currentDatetime.getTime());
    %>

    <sql:setDataSource var="dataSource"
        url="jdbc:mysql://localhost:3306/HealthDB"
        driver="com.mysql.cj.jdbc.Driver"
        user="root"
        password="1234" />
        
    <!-- ID 중복 확인 쿼리 -->
    <sql:query dataSource="${dataSource}" var="existingMember">
        SELECT id FROM member WHERE id = ?
        <sql:param value="<%=id%>" />
    </sql:query>
        
    <c:set var="idExists" value="${not empty existingMember.rows}" />

    <c:choose>
        <c:when test="${idExists}">
            <!-- ID가 이미 존재하는 경우 -->
            <script>
                Swal.fire({
                    title: '중복된 아이디',
                    text: "이미 존재하는 아이디입니다. 다른 아이디를 사용해주세요.",
                    icon: 'error',
                    confirmButtonText: '확인'
                }).then(() => {
                    window.history.back();
                });
            </script>
        </c:when>
        <c:otherwise>
            <!-- ID가 존재하지 않는 경우, 회원 추가 시도 -->
            <sql:update dataSource="${dataSource}" var="resultSet">
                INSERT INTO member (id, password, name, gender, birth, email, phone, address, age_group, water_intake, sleep_hours, reg_date) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                <sql:param value="<%=id%>" />
                <sql:param value="<%=password%>" />
                <sql:param value="<%=name%>" />
                <sql:param value="<%=gender%>" />
                <sql:param value="<%=birth%>" />
                <sql:param value="<%=mail%>" />
                <sql:param value="<%=phone%>" />
                <sql:param value="<%=address%>" />
                <sql:param value="<%=ageGroup%>" />
                <sql:param value="<%=waterIntake%>" />
                <sql:param value="<%=sleepHours%>" />
                <sql:param value="<%=timestamp%>" />
            </sql:update>

            <c:choose>
                <c:when test="${resultSet >= 1}">
                    <!-- 회원 가입 성공 -->
                    <script>
                        Swal.fire({
                            title: '성공',
                            text: "회원이 성공적으로 추가되었습니다.",
                            icon: 'success',
                            confirmButtonText: '확인'
                        }).then(() => {
                            window.location.href = "../user/welcome.jsp";
                        });
                    </script>
                </c:when>
                <c:otherwise>
                    <!-- 회원 가입 실패 -->
                    <script>
                        Swal.fire({
                            title: '오류',
                            text: "회원 가입 중 문제가 발생했습니다. 다시 시도해 주세요.",
                            icon: 'error',
                            confirmButtonText: '확인'
                        }).then(() => {
                            window.history.back();
                        });
                    </script>
                </c:otherwise>
            </c:choose>
        </c:otherwise>
    </c:choose>
</body>
</html>
