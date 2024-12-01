<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String sessionId = (String) session.getAttribute("sessionId");
    String sessionName = (String) session.getAttribute("sessionName");
%>
<html>
<head>
<title>게시판</title>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
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
<script type="text/javascript">
    function checkForm() {
        if (!document.newWrite.subject.value) {
            alert("제목을 입력하세요.");
            return false;
        }
        if (!document.newWrite.content.value) {
            alert("내용을 입력하세요.");
            return false;
        }       
    }
</script>
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

        <form name="newWrite" action="./BoardWriteAction.do" method="post" enctype="multipart/form-data" onsubmit="return checkForm()">
            <!-- 숨겨진 필드로 id와 name을 전달 -->
            <input type="hidden" name="id" value="<%= sessionId %>">
            <input type="hidden" name="name" value="<%= sessionName %>">
            
            <!-- 성명은 읽기 전용으로 표시 -->
            <div class="mb-3 row">
                <label class="col-sm-2 control-label">성명</label>
                <div class="col-sm-3">
                    <input type="text" class="form-control" value="<%= sessionName %>" readonly>
                </div>
            </div>

            <div class="mb-3 row">
                <label class="col-sm-2 control-label">제목</label>
                <div class="col-sm-5">
                    <input name="subject" type="text" class="form-control" placeholder="subject">
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2 control-label">이미지 업로드</label>
                <div class="col-sm-5">
                    <input type="file" name="uploadFile" class="form-control" accept="image/*">
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2 control-label">내용</label>
                <div class="col-sm-8">
                    <textarea name="content" cols="50" rows="5" class="form-control" placeholder="content"></textarea>
                </div>
            </div>
            <div class="mb-3 row">
                <div class="col-sm-offset-2 col-sm-10">
                    <input type="submit" class="btn btn-primary" value="등록">
                    <input type="reset" class="btn btn-primary" value="취소">
                </div>
            </div>
        </form>
        
    </div>
    <jsp:include page="../templates/footer.jsp" />
</div>
</body>
</html>
