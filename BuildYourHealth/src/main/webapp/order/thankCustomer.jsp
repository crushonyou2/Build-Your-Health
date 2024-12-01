<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="mvc.database.DBConnection"%>
<%@ page import="dto.Product"%>
<%@ page import="java.sql.*"%>

<head>
<link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
<title>주문 완료</title>
</head>
<%
    String shipping_cartId = "";
    String shipping_name = "";
    String shipping_shippingDate = "";
    String shipping_addressName = "";
    String shipping_zipCode = "";

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie thisCookie : cookies) {
            String name = thisCookie.getName();
            switch (name) {
                case "Shipping_cartId":
                    shipping_cartId = URLDecoder.decode(thisCookie.getValue(), "utf-8");
                    break;
                case "Shipping_name":
                    shipping_name = URLDecoder.decode(thisCookie.getValue(), "utf-8");
                    break;
                case "Shipping_shippingDate":
                    shipping_shippingDate = URLDecoder.decode(thisCookie.getValue(), "utf-8");
                    break;
                case "Shipping_addressName":
                    shipping_addressName = URLDecoder.decode(thisCookie.getValue(), "utf-8");
                    break;
                case "Shipping_zipCode":
                    shipping_zipCode = URLDecoder.decode(thisCookie.getValue(), "utf-8");
                    break;
            }
        }
    }

    List<Product> cartList = (List<Product>) session.getAttribute("cartlist");
    if (cartList == null) {
        cartList = new ArrayList<>();
    }

    String userId = (String) session.getAttribute("sessionId");
    if (userId == null) {
        response.sendRedirect("../templates/login.jsp");
        return;
    }

    int totalPrice = 0;
    for (Product product : cartList) {
        totalPrice += product.getDiscountPrice() * product.getQuantity();
    }

    int orderId = -1;
    try (Connection conn = DBConnection.getConnection()) {
        String insertOrderSql = "INSERT INTO orders (user_id, delivery_date, total_price, shipping_address, shipping_zipcode) " +
                                "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, userId);
            pstmt.setDate(2, java.sql.Date.valueOf(shipping_shippingDate));
            pstmt.setInt(3, totalPrice);
            pstmt.setString(4, shipping_addressName);
            pstmt.setString(5, shipping_zipCode);
            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }
        }

        if (orderId != -1) {
            String insertItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            try (PreparedStatement itemStmt = conn.prepareStatement(insertItemSql)) {
                for (Product product : cartList) {
                    itemStmt.setInt(1, orderId);
                    itemStmt.setString(2, product.getProductId());
                    itemStmt.setInt(3, product.getQuantity());
                    itemStmt.setInt(4, product.getDiscountPrice());
                    itemStmt.addBatch();
                }
                itemStmt.executeBatch();
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    session.removeAttribute("cartlist");
%>

<div class="container py-4">
    <%@ include file="../templates/menu.jsp"%>	

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">주문 완료</h1>
            <p class="col-md-8 fs-4">Order Completed</p>      
        </div>
    </div>
  	
    <div class="row align-items-md-stretch">
        <h2 class="alert alert-success">주문해주셔서 감사합니다. <%= userId %></h2>
        <p>주문은 <%= shipping_shippingDate %>에 배송될 예정입니다!</p>
    </div>
</div>
