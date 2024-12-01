<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>

<html>
<head>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
    <title>상품 수정</title>
</head>
<body>
<div class="container py-4">
    <%@ include file="../templates/menu.jsp" %>

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">상품 수정</h1>
            <p class="col-md-8 fs-4">Product Updating</p>
        </div>
    </div>
    <%@ include file="../templates/dbconn.jsp" %>
    <%
        String productId = request.getParameter("id");
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM product WHERE product_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, productId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
    %>
    <form name="updateProduct" action="./processUpdateProduct.jsp" method="post" enctype="multipart/form-data">
        <input type="hidden" name="productId" value="<%= rs.getString("product_id") %>">

        <div class="mb-3 row">
            <label class="col-sm-2">상품 이름</label>
            <div class="col-sm-5">
                <input type="text" name="productName" class="form-control" value="<%= rs.getString("product_name") %>">
            </div>
        </div>

        <div class="mb-3 row">
            <label class="col-sm-2">정가</label>
            <div class="col-sm-5">
                <input type="text" name="regularPrice" class="form-control" value="<%= rs.getInt("regular_price") %>">
            </div>
        </div>

        <div class="mb-3 row">
            <label class="col-sm-2">할인가</label>
            <div class="col-sm-5">
                <input type="text" name="discountPrice" class="form-control" value="<%= rs.getInt("discount_price") %>">
            </div>
        </div>

        <div class="mb-3 row">
            <label class="col-sm-2">제조사</label>
            <div class="col-sm-5">
                <input type="text" name="manufacturer" class="form-control" value="<%= rs.getString("manufacturer") %>">
            </div>
        </div>

        <div class="mb-3 row">
            <label class="col-sm-2">배송 정보</label>
            <div class="col-sm-5">
                <input type="text" name="shippingInfo" class="form-control" value="<%= rs.getString("shipping_info") %>">
            </div>
        </div>

        <div class="mb-3 row">
            <label class="col-sm-2">옵션 정보</label>
            <div class="col-sm-5">
                <textarea name="productOptions" class="form-control"><%= rs.getString("product_options") %></textarea>
            </div>
        </div>

        <div class="mb-3 row">
            <label class="col-sm-2">이미지</label>
            <div class="col-sm-5">
                <input type="file" name="imageFile" class="form-control">
                <img src="../resources/images/<%= rs.getString("image_file") %>" alt="상품 이미지" width="100">
            </div>
        </div>

        <div class="mb-3 row">
            <label class="col-sm-2">도착 예정일</label>
            <div class="col-sm-5">
                <input type="text" name="expectedDeliveryDate" class="form-control" value="<%= rs.getString("arrival_date") %>">
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" class="btn btn-primary">수정 완료</button>
            </div>
        </div>
    </form>
    <% } %>
    <%
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    %>
    <%@ include file="../templates/footer.jsp" %>
</div>
</body>
</html>
