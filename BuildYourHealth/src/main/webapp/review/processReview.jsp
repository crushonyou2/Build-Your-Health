<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet"%>
<%@ page import="mvc.database.DBConnection"%>
<%@ page import="java.util.*"%>

<%
    String productId = request.getParameter("productId");
    String review = request.getParameter("review");

    // 검증
    if (productId == null || productId.trim().isEmpty()) {
        response.sendRedirect("../order/orderHistory.jsp?error=invalidProductId");
        return;
    }
    if (review == null || review.trim().isEmpty()) {
        response.sendRedirect("writeReview.jsp?error=emptyReview&productId=" + productId);
        return;
    }

    String userId = (String) session.getAttribute("sessionId");
    if (userId == null) {
        response.sendRedirect("../templates/login.jsp");
        return;
    }

    try (Connection conn = DBConnection.getConnection()) {
        // 리뷰 저장
        String insertReviewSql = "INSERT INTO reviews (product_id, user_id, review, created_at) VALUES (?, ?, ?, NOW())";
        try (PreparedStatement pstmt = conn.prepareStatement(insertReviewSql)) {
            pstmt.setString(1, productId);
            pstmt.setString(2, userId);
            pstmt.setString(3, review);
            pstmt.executeUpdate();
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("writeReview.jsp?error=serverError&productId=" + productId);
        return;
    }

    response.sendRedirect("../product/product.jsp?id=" + productId);
%>
