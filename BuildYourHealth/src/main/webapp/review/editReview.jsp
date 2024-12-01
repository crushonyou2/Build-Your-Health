<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet"%>
<%@ page import="mvc.database.DBConnection"%>

<%
    String reviewId = request.getParameter("reviewId");
    String productId = request.getParameter("productId");

    if (reviewId == null || productId == null || reviewId.trim().isEmpty() || productId.trim().isEmpty()) {
        response.sendRedirect("../product/product.jsp?error=invalidReviewId&productId=" + productId);
        return;
    }

    String currentReview = "";
    try (Connection conn = DBConnection.getConnection()) {
        String fetchReviewSql = "SELECT review FROM reviews WHERE review_id = ? AND product_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(fetchReviewSql)) {
            pstmt.setInt(1, Integer.parseInt(reviewId));
            pstmt.setString(2, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    currentReview = rs.getString("review");
                } else {
                    response.sendRedirect("..product/product.jsp?error=reviewNotFound&productId=" + productId);
                    return;
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../product/product.jsp?error=serverError&productId=" + productId);
        return;
    }
%>

<html>
<head>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
    <title>리뷰 수정</title>
    <style>
        .edit-review-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            background-color: #ffffff;
        }
        .edit-review-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .edit-review-header h1 {
            font-size: 24px;
            color: #333;
        }
        .form-control {
            font-size: 16px;
        }
    </style>
</head>
<body>
<div class="container py-4">
    <%@ include file="../templates/menu.jsp" %>

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold text-center">리뷰 수정</h1>
            <p class="col-md-8 fs-4 text-center mx-auto">리뷰 내용을 수정하고 저장하세요.</p>
        </div>
    </div>

    <div class="edit-review-container">
        <form action="updateReview.jsp" method="post">
            <input type="hidden" name="reviewId" value="<%= reviewId %>">
            <input type="hidden" name="productId" value="<%= productId %>">
            <div class="mb-3">
                <label for="review" class="form-label">리뷰 내용</label>
                <textarea class="form-control" id="review" name="review" rows="6" required><%= currentReview %></textarea>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-primary">수정 저장</button>
                <a href="../product/product.jsp?id=<%= productId %>" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
