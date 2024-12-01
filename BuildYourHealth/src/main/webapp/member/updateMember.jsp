<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
    <link rel="stylesheet" href="../resources/css/sweetalert2.min.css">
    <script src="../resources/js/sweetalert2.all.min.js"></script>
    <%
        String sessionId = (String) session.getAttribute("sessionId");
    %>
    <sql:setDataSource var="dataSource"
        url="jdbc:mysql://localhost:3306/HealthDB"
        driver="com.mysql.cj.jdbc.Driver" user="root" password="1234" />

    <sql:query dataSource="${dataSource}" var="resultSet">
        SELECT * FROM MEMBER WHERE ID=?
        <sql:param value="<%=sessionId%>" />
    </sql:query>

    <title>회원 수정</title>
</head>
<script type="text/javascript">
function checkForm() {
    const password = document.updateMemberForm.password.value;
    const passwordConfirm = document.updateMemberForm.password_confirm.value;

    if (password !== passwordConfirm) {
        Swal.fire({
            icon: 'error',
            title: '비밀번호 불일치',
            text: '비밀번호가 일치하지 않습니다. 다시 입력해주세요.',
            confirmButtonText: '확인'
        });
        return false;
    }
    return true;
}

function confirmDelete() {
    Swal.fire({
        title: '정말 회원 탈퇴를 하시겠습니까?',
        text: '탈퇴 후 복구할 수 없습니다.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: '탈퇴',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = "deleteMember.jsp";
        }
    });
}

function updateRecommendations() {
    const ageGroup = document.updateMemberForm.ageGroup.value;
    let sleepHours = '';
    let waterIntake = '';

    switch (ageGroup) {
        case '20s':
            sleepHours = '8.0';
            waterIntake = '2.5';
            break;
        case '30s':
            sleepHours = '8.0';
            waterIntake = '2.3';
            break;
        case '40s':
            sleepHours = '8.0';
            waterIntake = '2.2';
            break;
        case '50s':
            sleepHours = '7.5';
            waterIntake = '2.0';
            break;
        case '60s':
            sleepHours = '7.5';
            waterIntake = '1.8';
            break;
        default:
            sleepHours = '7.0';
            waterIntake = '2.0';
    }

    // 사용자가 직접 수정할 수 있으므로 값을 자동으로 채워주되, 필드를 읽기 전용으로 하지 않습니다.
    document.updateMemberForm.sleepHours.value = sleepHours;
    document.updateMemberForm.waterIntake.value = waterIntake;
}
</script>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
<div class="container py-4">
    <jsp:include page="../templates/menu.jsp" />

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">회원 수정</h1>
            <p class="col-md-8 fs-4">Membership Updating</p>
        </div>
    </div>

    <c:forEach var="row" items="${resultSet.rows}">
        <c:set var="email" value="${row.email}" />
        <c:set var="email1" value="${email != null ? email.split('@')[0] : ''}" />
        <c:set var="email2" value="${email != null ? email.split('@')[1] : ''}" />

        <c:set var="birth" value="${row.birth}" />
        <fmt:formatDate value="${birth}" pattern="yyyy-MM-dd" var="formattedBirth" />
        <c:set var="year" value="${formattedBirth != null ? formattedBirth.substring(0, 4) : ''}" />
        <c:set var="month" value="${formattedBirth != null ? formattedBirth.substring(5, 7) : ''}" />
        <c:set var="day" value="${formattedBirth != null ? formattedBirth.substring(8, 10) : ''}" />

        <form name="updateMemberForm" action="processUpdateMember.jsp" method="post" onsubmit="return checkForm()">
            <div class="text-end"> 
                <a href="?language=ko" >Korean</a> | <a href="?language=en" >English</a>
            </div>
            <!-- 아이디 -->
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="id" /></label>
                <div class="col-sm-3">
                    <input name="id" type="text" class="form-control" value="<c:out value='${row.id}'/>" readonly>
                </div>
            </div>
            <!-- 비밀번호 -->
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="password" /></label>
                <div class="col-sm-3">
                    <input name="password" type="password" class="form-control" value="<c:out value='${row.password}'/>" required>
                </div>
            </div>
            <!-- 비밀번호 확인 -->
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="passwordConfirm" /></label>
                <div class="col-sm-3">
                    <input name="password_confirm" type="password" class="form-control" required>
                </div>
            </div>
            <!-- 성명 -->
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="name" /></label>
                <div class="col-sm-3">
                    <input name="name" type="text" class="form-control" value="<c:out value='${row.name}'/>" required>
                </div>
            </div>
            <!-- 연령대 -->
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="ageGroup" /></label>
                <div class="col-sm-3">
                    <select name="ageGroup" class="form-select" required onchange="updateRecommendations()">
                        <option value="" disabled><fmt:message key="choose" /></option>
                        <option value="20s" <c:if test="${row.age_group == '20s'}">selected</c:if>>20s</option>
                        <option value="30s" <c:if test="${row.age_group == '30s'}">selected</c:if>>30s</option>
                        <option value="40s" <c:if test="${row.age_group == '40s'}">selected</c:if>>40s</option>
                        <option value="50s" <c:if test="${row.age_group == '50s'}">selected</c:if>>50s</option>
                        <option value="60s" <c:if test="${row.age_group == '60s'}">selected</c:if>>60s</option>
                    </select>
                </div>
            </div>
            <!-- 권장 수면시간 -->
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="recommendSleep" /></label>
                <div class="col-sm-3">
                    <input name="sleepHours" type="text" class="form-control" value="<c:out value='${row.sleep_hours}'/>">
                </div>
            </div>
            <!-- 권장 물 섭취량 (L) -->
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="recommendWater" /></label>
                <div class="col-sm-3">
                    <input name="waterIntake" type="text" class="form-control" value="<c:out value='${row.water_intake}'/>">
                </div>
            </div>
            <!-- 생일 -->
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="birth" /></label>
                <div class="col-sm-10">
                    <div class="row">
                        <div class="col-sm-2">
                            <input type="text" name="birthyy" maxlength="4" class="form-control" value="${year}">
                        </div>
                        <div class="col-sm-2">
                            <select name="birthmm" class="form-select">
                                <option value="" disabled><fmt:message key="month" /></option>
                                <!-- 월 옵션들 -->
                                <c:forEach var="i" begin="1" end="12">
                                    <option value="<fmt:formatNumber value='${i}' pattern='00' />"
                                        <c:if test="${month == (i < 10 ? '0' : '') + i}">selected</c:if>>
                                        ${i}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-sm-2">
                            <input type="text" name="birthdd" maxlength="2" class="form-control" value="${day}">
                        </div>
                    </div>
                </div>
            </div>
            <!-- 이메일 -->
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="email" /></label>
                <div class="col-sm-10">
                    <div class="row">
                        <div class="col-sm-4">
                            <input type="text" name="mail1" value="${email1}" class="form-control">
                        </div> @
                        <div class="col-sm-3">
                            <select name="mail2" class="form-select">
                                <option value="naver.com" <c:if test="${email2 == 'naver.com'}">selected</c:if>>naver.com</option>
                                <option value="daum.net" <c:if test="${email2 == 'daum.net'}">selected</c:if>>daum.net</option>
                                <option value="gmail.com" <c:if test="${email2 == 'gmail.com'}">selected</c:if>>gmail.com</option>
                                <option value="nate.com" <c:if test="${email2 == 'nate.com'}">selected</c:if>>nate.com</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 수정/탈퇴 버튼 -->
            <div class="mb-3 row">
                <div class="col-sm-offset-2 col-sm-10">
                    <input type="submit" class="btn btn-primary" value="<fmt:message key="update" />">
                    <button type="button" class="btn btn-danger" onclick="confirmDelete()"><fmt:message key="delete" /></button>
                </div>
            </div>
        </form>
    </c:forEach>

    <jsp:include page="../templates/footer.jsp" />
</div>
</fmt:bundle>
</body>
</html>
