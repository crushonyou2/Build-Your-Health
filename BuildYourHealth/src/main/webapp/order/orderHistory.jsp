<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="dto.Product"%>
<%@ page import="mvc.database.DBConnection"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet"%>
<html>
<head>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
    <title>주문 내역</title>
    <style>
        .order-card {
            border: 1px solid #ddd;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            background-color: #ffffff;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
        .order-header {
            font-weight: bold;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 1.1rem;
            color: #333;
        }
        .product-details {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            margin-right: 15px;
            border-radius: 8px;
            border: 1px solid #ddd;
        }
        .product-info {
            flex: 1;
        }
        .product-info strong {
            font-size: 1.1rem;
            color: #555;
        }
        .product-info p {
            margin: 5px 0;
            color: #777;
        }
        .action-buttons {
            display: flex;
            justify-content: flex-end;
        }
        .action-buttons a {
            margin-left: 10px;
        }
        .delete-all-btn {
            margin-bottom: 20px;
            font-size: 1rem;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container py-4">
    <%@ include file="../templates/menu.jsp"%>

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">주문 내역</h1>
            <p class="col-md-8 fs-4">Order History</p>
        </div>
    </div>

    <!-- 오류 및 성공 메시지 처리 -->
    <%
        String error = request.getParameter("error");
        String success = request.getParameter("success");

        if (error != null) {
            if (error.equals("invalidIndex")) {
    %>
    <div class="alert alert-danger">잘못된 요청입니다. 주문을 삭제할 수 없습니다.</div>
    <%
            } else if (error.equals("orderNotFound")) {
    %>
    <div class="alert alert-danger">선택한 주문을 찾을 수 없습니다.</div>
    <%
            }
        }

        if (success != null && success.equals("orderDeleted")) {
    %>
    <div class="alert alert-success">주문이 성공적으로 삭제되었습니다.</div>
    <%
        }
    %>

    <div class="order-list">
        <%
            String userId = (String) session.getAttribute("sessionId");
            if (userId == null) {
                response.sendRedirect("../templates/login.jsp");
                return;
            }

            List<Map<String, Object>> orders = new ArrayList<>();
            try (Connection conn = DBConnection.getConnection()) {
                String getOrderSql = "SELECT order_id, order_date, delivery_date, total_price, shipping_address FROM orders WHERE user_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(getOrderSql)) {
                    pstmt.setString(1, userId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> order = new HashMap<>();
                            order.put("orderId", rs.getInt("order_id"));
                            order.put("orderDate", rs.getTimestamp("order_date"));
                            order.put("deliveryDate", rs.getDate("delivery_date"));
                            order.put("totalPrice", rs.getInt("total_price"));
                            order.put("shippingAddress", rs.getString("shipping_address"));
                            orders.add(order);
                        }
                    }
                }

			String getOrderItemsSql = "SELECT p.product_id, p.product_name, oi.quantity, oi.price, p.image_file " +
			                          "FROM order_items oi " +
			                          "JOIN product p ON oi.product_id = p.product_id " +
			                          "WHERE oi.order_id = ?";
			for (Map<String, Object> order : orders) {
			    List<Product> products = new ArrayList<>();
			    int orderId = (int) order.get("orderId");
			    try (PreparedStatement pstmt = conn.prepareStatement(getOrderItemsSql)) {
			        pstmt.setInt(1, orderId);
			        try (ResultSet rs = pstmt.executeQuery()) {
			            while (rs.next()) {
			                Product product = new Product();
			                product.setProductId(rs.getString("product_id"));
			                product.setProductName(rs.getString("product_name"));
			                product.setQuantity(rs.getInt("quantity"));
			                product.setDiscountPrice(rs.getInt("price"));
			                product.setImageFile(rs.getString("image_file"));
			                products.add(product);
			            }
			        }
			    }
			    order.put("products", products);
			}
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (orders.isEmpty()) {
        %>
        <div class="alert alert-warning text-center">
            주문 내역이 없습니다.
        </div>
        <a href="../product/products.jsp" class="btn btn-secondary">상품 목록 &raquo;</a>
        <%
            } else {
        %>
        <div class="text-end">
            <!-- 모든 주문 삭제 버튼 -->
            <a href="./deleteOrder.jsp?orderId=all" class="btn btn-danger delete-all-btn">모든 주문 삭제</a>
        </div>
        <%
                for (Map<String, Object> order : orders) {
                    List<Product> products = (List<Product>) order.get("products");
        %>
        <div class="order-card">
            <div class="order-header">
                주문번호: <%= order.get("orderId") %> • 주문일: <%= order.get("orderDate") %> • 총액: <%= order.get("totalPrice") %>원
                <a href="./deleteOrder.jsp?orderId=<%= order.get("orderId") %>" class="btn btn-outline-danger btn-sm">주문 삭제</a>
            </div>
            <div class="order-content">
                <% for (Product product : products) { %>
                <div class="product-details">
                    <img src="../resources/images/<%= product.getImageFile() %>" class="product-image" alt="<%= product.getProductName() %>">
                    <div class="product-info">
                        <p><strong><%= product.getProductName() %></strong></p>
                        <p>수량: <%= product.getQuantity() %> • 가격: <%= product.getDiscountPrice() %>원</p>
                        <div class="action-buttons">
                            <a href="../review/writeReview.jsp?productId=<%= product.getProductId() %>" class="btn btn-outline-success btn-sm">리뷰 작성</a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>
</div>
</body>
</html>
