<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement"%>
<%@ page import="mvc.database.DBConnection"%>

<%
    String reviewId = request.getParameter("reviewId");
    String reviewContent = request.getParameter("review");
    String productId = request.getParameter("productId");

    if (reviewId == null || reviewContent == null || productId == null ||
        reviewId.trim().isEmpty() || reviewContent.trim().isEmpty() || productId.trim().isEmpty()) {
    	out.println("Debug: Missing reviewId, reviewContent, or productId");
        response.sendRedirect("../product/product.jsp?error=invalidReviewData&productId=" + productId);
        return;
    }

    try (Connection conn = DBConnection.getConnection()) {
        String updateReviewSql = "UPDATE reviews SET review = ? WHERE review_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(updateReviewSql)) {
            pstmt.setString(1, reviewContent);
            pstmt.setInt(2, Integer.parseInt(reviewId));
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                response.sendRedirect("../product/product.jsp?success=reviewUpdated&id=" + productId);
            } else {
                response.sendRedirect("../product/product.jsp?error=reviewNotFound&id=" + productId);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../product/product.jsp?error=serverError&id=" + productId);
    }
%>
