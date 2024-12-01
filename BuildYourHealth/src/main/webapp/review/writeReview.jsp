<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="dto.Product"%>
<%
    String productId = request.getParameter("productId");

    if (productId == null || productId.trim().isEmpty()) {
        response.sendRedirect("../order/orderHistory.jsp");
        return;
    }

    String userId = (String) session.getAttribute("sessionId");
    if (userId == null) {
        response.sendRedirect("../templates/login.jsp");
        return;
    }
%>
<script>
    function confirmCancel() {
        if (confirm("리뷰 작성을 취소하시겠습니까?")) {
            history.back();
        }
    }
</script>
<html>
<head>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
    <title>리뷰 작성</title>
</head>
<body>
<div class="container py-4">
    <%@ include file="../templates/menu.jsp"%>

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">리뷰 작성</h1>
            <p class="col-md-8 fs-4">Write a Review</p>
        </div>
    </div>

    <form action="processReview.jsp" method="post">
        <input type="hidden" name="productId" value="<%= productId %>">
        <div class="mb-3">
            <label for="review" class="form-label">리뷰 내용</label>
            <textarea class="form-control" id="review" name="review" rows="4" placeholder="리뷰를 작성해주세요" minlength="10" maxlength="300" required></textarea>
            <small class="form-text text-muted">리뷰는 최소 10자에서 최대 300자까지 입력할 수 있습니다.</small>
        </div>
        <button type="submit" class="btn btn-primary">리뷰 저장</button>
        <a href="javascript:confirmCancel()" class="btn btn-secondary">취소</a>
    </form>
</div>
</body>
</html>
