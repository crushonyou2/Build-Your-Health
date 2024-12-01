<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>

<html>
<head>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
    <script src="../resources/js/sweetalert2.all.min.js"></script> <!-- SweetAlert Script -->
    <title>상품 편집</title>
    <script type="text/javascript">
        function deleteConfirm(id) {
            Swal.fire({
                title: '정말 삭제하시겠습니까?',
                text: "이 작업은 되돌릴 수 없습니다!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: '삭제',
                cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {
                    location.href = "./deleteProduct.jsp?id=" + id;
                }
            });
        }
    </script>
</head>
<body>
<div class="container py-4">
    <%@ include file="../templates/menu.jsp" %>

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">상품 편집</h1>
            <p class="col-md-8 fs-4">Product Editing</p>
        </div>
    </div>
    <%@ include file="../templates/dbconn.jsp" %>
    <div class="row align-items-md-stretch text-center">
        <%
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            String sql = "SELECT * FROM product";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
        %>
        <div class="col-md-3">
            <div class="h-100 p-2 rounded-3">
                <img src="../resources/images/<%= rs.getString("image_file") %>" style="width: 250px; height: 350px" />
                <h5><b><%= rs.getString("product_name") %></b></h5>
                <p>제조사: <%= rs.getString("manufacturer") %></p>
                <p>배송: <%= rs.getString("shipping_info") %></p>
                <p>정가: <%= rs.getInt("regular_price") %>원</p>
                <p>할인가: <%= rs.getInt("discount_price") %>원</p>
                <p>
                    <a href="./updateProduct.jsp?id=<%= rs.getString("product_id") %>" class="btn btn-success">수정</a>
                    <a href="#" onclick="deleteConfirm('<%= rs.getString("product_id") %>')" class="btn btn-danger">삭제</a>
                </p>
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
