<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="mvc.model.BoardDTO"%>

<%
    BoardDTO notice = (BoardDTO) request.getAttribute("board");
    int num = ((Integer) request.getAttribute("num")).intValue();
    int nowpage = ((Integer) request.getAttribute("page")).intValue();
%>

<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>게시판</title>
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
        <form name="newUpdate" action="BoardUpdateAction.do?num=<%=notice.getNum()%>&pageNum=<%=nowpage%>" method="post" enctype="multipart/form-data">
            <div class="mb-3 row">
                <label class="col-sm-2 control-label">성명</label>
                <div class="col-sm-3">
                    <input name="name" class="form-control" value="<%=notice.getName()%>">
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2 control-label">제목</label>
                <div class="col-sm-5">
                    <input name="subject" class="form-control" value="<%=notice.getSubject()%>">
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2 control-label">내용</label>
                <div class="col-sm-8" style="word-break: break-all;">
                    <textarea name="content" class="form-control" cols="50" rows="5"><%=notice.getContent()%></textarea>
                </div>
            </div>
            
            <%
                String imageFileName = notice.getImageFileName();
                if (imageFileName != null && !imageFileName.isEmpty()) {
            %>
            <div class="mb-3 row">
                <label class="col-sm-2 control-label">첨부 이미지</label>
                <div class="col-sm-8">
                    <img src="<%=request.getContextPath()%>/uploads/<%=imageFileName%>" alt="첨부 이미지" class="img-fluid" />
                </div>
            </div>
            <% } %>

            <div class="mb-3 row">
                <label class="col-sm-2 control-label">이미지 변경</label>
                <div class="col-sm-5">
                    <input type="file" name="uploadFile" class="form-control" accept="image/*">
                </div>
            </div>

            <div class="mb-3 row">
                <div class="col-sm-offset-2 col-sm-10">
                    <c:set var="userId" value="<%=notice.getId()%>" />
                     <!-- admin 또는 작성자인 경우 삭제/수정 버튼 표시 -->
                    <c:if test="${sessionScope.sessionId == 'admin' || sessionScope.sessionId == userId}">
                        <p>
                            <a href="./BoardDeleteAction.do?num=<%=notice.getNum()%>&pageNum=<%=nowpage%>" class="btn btn-danger">삭제</a> 
                            <input type="submit" class="btn btn-success" value="수정">
                            <a href="./BoardListAction.do?pageNum=<%=nowpage%>" class="btn btn-primary">목록</a>
                        </p>
                    </c:if>
                    
                </div>
            </div>
        </form>
    </div>

    <jsp:include page="../templates/footer.jsp" />
</div>
</body>
</html>
