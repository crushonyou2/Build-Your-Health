<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
    <script type="text/javascript" src="../resources/js/validation.js"></script>
    <title>상품 등록</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message">
<div class="container py-4">
    <%@ include file="../templates/menu.jsp" %>	

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">상품 등록</h1>
            <p class="col-md-8 fs-4">Add New Product</p>      
        </div>
    </div>
  
    <div class="row align-items-md-stretch">
        <form name="newProduct" action="./processAddProduct.jsp" method="post" enctype="multipart/form-data">		
            <!-- 상품 ID -->
            <div class="mb-3 row">
                <label class="col-sm-2">상품 ID</label>
                <div class="col-sm-3">
                    <input type="text" name="productId" id="productId" class="form-control" required>
                </div>
            </div>
            <!-- 상품 이름 -->
            <div class="mb-3 row">
                <label class="col-sm-2">상품 이름</label>
                <div class="col-sm-3">
                    <input type="text" name="productName" id="productName" class="form-control" required>
                </div>
            </div>
            <!-- 정가 -->
            <div class="mb-3 row">
                <label class="col-sm-2">정가</label>
                <div class="col-sm-3">
                    <input type="number" name="regularPrice" id="regularPrice" class="form-control" required>
                </div>
            </div>
            <!-- 할인가 -->
            <div class="mb-3 row">
                <label class="col-sm-2">할인가</label>
                <div class="col-sm-3">
                    <input type="number" name="discountPrice" id="discountPrice" class="form-control">
                </div>
            </div>
            <!-- 제조사 -->
            <div class="mb-3 row">
                <label class="col-sm-2">제조사</label>
                <div class="col-sm-3">
                    <input type="text" name="manufacturer" id="manufacturer" class="form-control" required>
                </div>
            </div>
            <!-- 배송 정보 -->
            <div class="mb-3 row">
                <label class="col-sm-2">배송 정보</label>
                <div class="col-sm-3">
                    <input type="text" name="shippingInfo" id="shippingInfo" class="form-control" placeholder="예: 무료배송">
                </div>
            </div>
            <!-- 예상 도착일 -->
            <div class="mb-3 row">
                <label class="col-sm-2">예상 도착일</label>
                <div class="col-sm-3">
                    <input type="date" name="arrivalDate" id="arrivalDate" class="form-control">
                </div>
            </div>
            <!-- 옵션 정보 -->
            <div class="mb-3 row">
                <label class="col-sm-2">옵션 정보</label>
                <div class="col-sm-5">
                    <textarea name="productOptions" id="productOptions" cols="50" rows="2" class="form-control" ></textarea>
                </div>
            </div>
            <!-- 상품 이미지 -->
            <div class="mb-3 row">
                <label class="col-sm-2">상품 이미지</label>
                <div class="col-sm-5">
                    <input type="file" name="productImage" id="productImage" class="form-control">
                </div>
            </div>
            <!-- 제출 버튼 -->
            <div class="mb-3 row">
                <div class="col-sm-offset-2 col-sm-10">
                    <input type="submit" class="btn btn-primary" value="등록하기">
                </div>
            </div>
        </form>
    </div>
    <jsp:include page="../templates/footer.jsp" />
</div>	
</fmt:bundle>
</body>
</html>
