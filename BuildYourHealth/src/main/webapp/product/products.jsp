<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <link href="../resources/css/bootstrap.min.css" rel="stylesheet">
    <title>상품 목록</title>
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
</head>
<body>
<div class="container py-4">
    <%@ include file="../templates/menu.jsp" %>

    <div class="p-5 mb-4 recommendation-section rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">상품 목록</h1>
            <p class="col-md-8 fs-4">Product List</p>
        </div>
    </div>
<div class="text-end"> 
	            <a href="../cart/cart.jsp" class="btn btn-sm btn-success">장바구니로</a>
	    </div>
    <%@ include file="../templates/dbconn.jsp" %>

    <div class="row">
        <%
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            String sql = "SELECT * FROM product";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
        %>
        
        <div class="col-md-3">
            <div class="card">
                <!-- 상품 이미지 -->
                <img src="../resources/images/<%= rs.getString("image_file") %>" class="card-img-top" alt="<%= rs.getString("product_name") %>">
                
                <div class="card-body">
                    <!-- 상품 이름 -->
                    <h5 class="card-title"><%= rs.getString("product_name") %></h5>
                    <!-- 정가와 할인 가격 -->
                    <p class="card-text">
                        <del><%= rs.getInt("regular_price") %>원</del>
                        <strong style="color: red; font-size: 1.2rem;"><%= rs.getInt("discount_price") %>원</strong>
                    </p>
                    <!-- 제조사 -->
                    <p class="text-muted">제조사: <%= rs.getString("manufacturer") %></p>
                    <!-- 상세보기 버튼 -->
                    <a href="./product.jsp?id=<%= rs.getString("product_id") %>" class="btn btn-primary">상세보기</a>
                </div>
            </div>
        </div>
        <% } %>

        <% 
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        %>
    </div>
    <%@ include file="../templates/footer.jsp" %>
</div>
</body>
</html>
