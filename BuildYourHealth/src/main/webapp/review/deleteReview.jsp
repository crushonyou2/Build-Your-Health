<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement"%>
<%@ page import="mvc.database.DBConnection"%>

<%
    String reviewId = request.getParameter("reviewId");
    String productId = request.getParameter("productId");

    if (reviewId == null || reviewId.trim().isEmpty() || productId == null || productId.trim().isEmpty()) {
        out.println("Debug: reviewId or productId is missing or invalid.");
        response.sendRedirect("../product/product.jsp?error=invalidReviewId");
        return;
    }

    try (Connection conn = DBConnection.getConnection()) {
        String deleteReviewSql = "DELETE FROM reviews WHERE review_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(deleteReviewSql)) {
            pstmt.setInt(1, Integer.parseInt(reviewId));
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                response.sendRedirect("../product/product.jsp?success=reviewDeleted&id=" + productId);
            } else {
                response.sendRedirect("../product/product.jsp?error=reviewNotFound&id=" + productId);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../product/product.jsp?error=serverError&id=" + productId);
    }
%>
