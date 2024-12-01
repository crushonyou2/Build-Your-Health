<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%@ page import="mvc.model.BoardDTO"%>
<%
    String sessionId = (String) session.getAttribute("sessionId");
    List boardList = (List) request.getAttribute("boardlist");
    if (boardList == null) {
        boardList = new ArrayList();
    }

    Integer totalRecordObj = (Integer) request.getAttribute("total_record");
    int total_record = (totalRecordObj != null) ? totalRecordObj : 0;

    Integer pageNumObj = (Integer) request.getAttribute("pageNum");
    int pageNum = (pageNumObj != null) ? pageNumObj : 1;

    Integer totalPageObj = (Integer) request.getAttribute("total_page");
    int total_page = (totalPageObj != null) ? totalPageObj : 1;
%>

<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>게시판</title>
<script type="text/javascript">
    function checkForm() {
        var sessionId = "<%= sessionId %>";
        if (sessionId == null || sessionId == "") {
            alert("로그인 해주세요.");
            return false;
        }

        location.href = "./BoardWriteForm.do?id=" + sessionId;
    }
</script>

<style>
    .recommendation-section {
        background-image: url('./resources/images/share.jpg');
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
    <jsp:include page="../templates/menu.jsp" />

     <div class="p-5 mb-4 recommendation-section rounded-3">
      <div class="container-fluid py-5">
        <h1 class="display-5 fw-bold">게시판</h1>
        <p class="col-md-8 fs-4">당신의 건강한 하루를 뽐내보세요.</p>
      </div>
    </div>

    <div class="row align-items-md-stretch text-center">
        <form action="<c:url value="./BoardListAction.do"/>" method="post">

            <div class="text-end">
                <span class="badge text-bg-success">전체 <%= total_record %>건</span>
            </div>

            <div style="padding-top: 20px">
                <table class="table table-hover text-center">
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>작성일</th>
                        <th>조회</th>
                        <th>글쓴이</th>
                    </tr>
                    <%
                        if (!boardList.isEmpty()) {
                            for (int j = 0; j < boardList.size(); j++) {
                                BoardDTO notice = (BoardDTO) boardList.get(j);
                    %>
                    <tr>
                        <td><%= notice.getNum() %></td>
                        <td><a href="./BoardViewAction.do?num=<%= notice.getNum() %>&pageNum=<%= pageNum %>"><%= notice.getSubject() %></a></td>
                        <td><%= notice.getRegist_day() %></td>
                        <td><%= notice.getHit() %></td>
                        <td><%= notice.getName() %></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5">등록된 글이 없습니다.</td>
                    </tr>
                    <%
                        } // Closing the if-else block
                    %>
                </table>
            </div>
            <div align="center">
                <c:set var="pageNum" value="<%= pageNum %>" />
                <c:forEach var="i" begin="1" end="<%= total_page %>">
                    <a href="<c:url value="./BoardListAction.do?pageNum=${i}" />">
                        <c:choose>
                            <c:when test="${pageNum == i}">
                                <font color='4C5317'><b> [${i}]</b></font>
                            </c:when>
                            <c:otherwise>
                                <font color='4C5317'> [${i}]</font>
                            </c:otherwise>
                        </c:choose>
                    </a>
                </c:forEach>
            </div>

            <div class="py-3" align="right">
                <a href="#" onclick="checkForm(); return false;" class="btn btn-primary">&laquo;글쓰기</a>
            </div>
            <div align="left">
                <select name="items" class="txt">
                    <option value="subject">제목</option>
                    <option value="content">본문</option>
                    <option value="name">글쓴이</option>
                </select>
                <input name="text" type="text" />
                <input type="submit" id="btnAdd" class="btn btn-primary" value="검색" />
            </div>

        </form>
    </div>
    <jsp:include page="../templates/footer.jsp" />
</div>
</body>
</html>
