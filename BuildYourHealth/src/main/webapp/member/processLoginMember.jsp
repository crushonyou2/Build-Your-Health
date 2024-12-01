<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%
    request.setCharacterEncoding("UTF-8");
%>

<sql:setDataSource var="dataSource"
    url="jdbc:mysql://localhost:3306/HealthDB"
    driver="com.mysql.cj.jdbc.Driver" user="root" password="1234" />

<sql:query dataSource="${dataSource}" var="resultSet">
    SELECT * FROM MEMBER WHERE ID = ? AND password = ?
    <sql:param value="${param.id}" />
    <sql:param value="${param.password}" />
</sql:query>

<c:choose>
    <c:when test="${not empty resultSet.rows}">
        <c:set var="row" value="${resultSet.rows[0]}" />
        <c:set var="sessionId" value="${param.id }" scope="session" />
        <c:set var="sessionName" value="${row.name}" scope="session" />
        <c:redirect url="../user/welcome.jsp?msg=2" />
    </c:when>
    <c:otherwise>
        <c:redirect url="loginMember.jsp?error=1" />
    </c:otherwise>
</c:choose>
