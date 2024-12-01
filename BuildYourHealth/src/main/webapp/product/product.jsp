<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="dto.Product"%>
<%@ page import="dao.ProductRepository"%>
<%@ page import="mvc.database.UserUtils"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>

<html>
<head>
    <link href="../resources/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <title>상품 정보</title>
    <style>
	    .recommendation-section {
	        background-image: url('../resources/images/market.jpg');
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
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            // 장바구니 추가 팝업
            document.getElementById('addToCartBtn').addEventListener('click', function () {
                Swal.fire({
                    title: '상품을 장바구니에 추가하시겠습니까?',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: '예',
                    cancelButtonText: '아니요'
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.addForm.submit();
                    } else {
                        document.addForm.reset();
                    }
                });
            });

            // 리뷰 삭제 팝업
            document.addEventListener('click', function (event) {
                const target = event.target.closest('.delete-review-btn'); // Closest 버튼 찾기
                if (target) {
                	const reviewId = target.getAttribute('data-review-id'); // 데이터 속성 읽기
                    const productId = target.getAttribute('data-product-id'); // 데이터 속성 읽기

                    console.log("Debug: Review ID =", reviewId, "Product ID =", productId);

                    if (!reviewId || !productId) {
                        console.error("Review ID 또는 Product ID가 누락되었습니다.");
                        return;
                    }

                    Swal.fire({
                        title: '정말로 이 리뷰를 삭제하시겠습니까?',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: '삭제',
                        cancelButtonText: '취소',
                        reverseButtons: true
                    }).then((result) => {
                        if (result.isConfirmed) {
                        	const deleteUrl = '../review/deleteReview.jsp?reviewId=' + encodeURIComponent(reviewId) + 
                            '&productId=' + encodeURIComponent(productId);
	                        console.log("Redirecting to:", deleteUrl);
	                        window.location.href = deleteUrl;
                        }
                    });
                }
            });

        });
    </script>
</head>
<body>
<div class="container py-4">
    <%@ include file="../templates/menu.jsp" %>    

    <div class="p-5 mb-4 recommendation-section rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">상품 정보</h1>
            <p class="col-md-8 fs-4">Product Info</p>      
        </div>
    </div>
    
    <%
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            out.println("<div class='alert alert-danger'>상품 ID가 유효하지 않습니다.</div>");
            return;
        }

        ProductRepository dao = ProductRepository.getInstance();
        Product product = dao.getProductById(id);

        if (product == null) {
            out.println("<div class='alert alert-danger'>해당 상품을 찾을 수 없습니다.</div>");
            return;
        }

        // 리뷰 가져오기
        List<Map<String, String>> reviews = dao.getReviewsByProductId(id);
        String loggedInUserId = (String) session.getAttribute("sessionId"); // 로그인한 사용자 ID
    %>

    <div class="row align-items-md-stretch">        
        <div class="col-md-5">
            <img src="../resources/images/<%=product.getImageFile()%>" style="width: 100%; border-radius: 8px;" alt="<%=product.getProductName()%>">
        </div>
        <div class="col-md-6">
            <h3><b><%=product.getProductName()%></b></h3>
            <p><b>제조사</b>: <%=product.getManufacturer()%></p>
            <p><b>배송 정보</b>: <%=product.getShippingInfo()%></p>
            <p><b>도착 예정</b>: <%=product.getExpectedDeliveryDate()%></p>
            <!-- 가격 정보 -->
            <div>
                <p><b>정가</b>: <del><%=product.getRegularPrice()%>원</del></p>
                <p><b>할인가</b>: <span style="color: red; font-size: 1.5rem;"><%=product.getDiscountPrice()%>원</span></p>
            </div>
            <!-- 옵션 정보 -->
            <div>
                <b>상세정보</b>: 
                <ul>
                    <% 
                        String options = product.getProductOptions(); 
                        if (options != null && !options.isEmpty()) { 
                            // JSON 파싱 후 옵션 목록 표시
                            String[] optionList = options.split(","); // 간단히 ","로 분리
                            for (String option : optionList) { 
                    %>
                        <li><%=option.trim()%></li>
                    <% 
                            } 
                        } else { 
                    %>
                        <li>옵션 없음</li>
                    <% } %>
                </ul>
            </div>
            <form name="addForm" action="../cart/addCart.jsp?id=<%=product.getProductId()%>" method="post">
                <button type="button" id="addToCartBtn" class="btn btn-info">상품 주문 &raquo;</button>
                <a href="../cart/cart.jsp" class="btn btn-warning">장바구니 &raquo;</a>                
                <a href="../product/products.jsp" class="btn btn-secondary">상품 목록 &raquo;</a>
            </form>
        </div>
    </div>
    <hr />
    <h4>리뷰</h4>
    <div class="reviews">
        <% 
            if (!reviews.isEmpty()) {
                for (Map<String, String> review : reviews) {
                    String userId = review.get("userId");
                    String maskedUserId = UserUtils.maskUserId(userId); 
                    String reviewId = review.get("reviewId"); // reviewId 가져오기
        %>
        <div class="alert alert-light">
            <strong><%= maskedUserId %></strong>: <%= review.get("review") %>
            <p class="text-muted"><small><%= review.get("createdAt") %></small></p>
            <% if (userId.equals(loggedInUserId)) { %>
            <div class="action-buttons">
                <a href="../review/editReview.jsp?reviewId=<%= reviewId %>&productId=<%= id %>" class="btn btn-outline-primary btn-sm">수정</a>
				<button type="button" 
			        class="btn btn-outline-danger btn-sm delete-review-btn" 
			        data-review-id="<%= reviewId %>" 
			        data-product-id="<%= id %>">삭제</button>
            </div>
            <% } %>
        </div>
        <% 
                }
            } else { 
        %>
        <div class="alert alert-warning">
            아직 등록된 리뷰가 없습니다.
        </div>
        <% } %>
    </div>
    <jsp:include page="../templates/footer.jsp" />
</div>
</body>
</html>
