<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="mvc.database.DBConnection"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement"%>

<%
    // 사용자 로그인 여부 확인
    String userId = (String) session.getAttribute("sessionId");
    if (userId == null) {
        response.sendRedirect("../templates/login.jsp");
        return;
    }

    // 요청된 orderId 확인
    String orderId = request.getParameter("orderId");
    if (orderId == null || orderId.trim().isEmpty()) {
        response.sendRedirect("orderHistory.jsp?error=invalidRequest");
        return;
    }

    try (Connection conn = DBConnection.getConnection()) {
        if ("all".equals(orderId)) {
            // 모든 주문 삭제
            String deleteAllOrderItemsSql = "DELETE FROM order_items WHERE order_id IN (SELECT order_id FROM orders WHERE user_id = ?)";
            String deleteAllOrdersSql = "DELETE FROM orders WHERE user_id = ?";

            // 모든 주문 항목 삭제
            try (PreparedStatement pstmtItems = conn.prepareStatement(deleteAllOrderItemsSql)) {
                pstmtItems.setString(1, userId);
                pstmtItems.executeUpdate();
            }

            // 모든 주문 삭제
            try (PreparedStatement pstmtOrders = conn.prepareStatement(deleteAllOrdersSql)) {
                pstmtOrders.setString(1, userId);
                pstmtOrders.executeUpdate();
            }

            response.sendRedirect("orderHistory.jsp?success=allOrdersDeleted");
        } else {
            // 개별 주문 삭제
            String deleteOrderItemsSql = "DELETE FROM order_items WHERE order_id = ?";
            String deleteOrderSql = "DELETE FROM orders WHERE order_id = ? AND user_id = ?";

            // 주문 항목 삭제
            try (PreparedStatement pstmtItems = conn.prepareStatement(deleteOrderItemsSql)) {
                pstmtItems.setInt(1, Integer.parseInt(orderId));
                pstmtItems.executeUpdate();
            }

            // 주문 삭제
            try (PreparedStatement pstmtOrder = conn.prepareStatement(deleteOrderSql)) {
                pstmtOrder.setInt(1, Integer.parseInt(orderId));
                pstmtOrder.setString(2, userId);
                int affectedRows = pstmtOrder.executeUpdate();

                if (affectedRows > 0) {
                    response.sendRedirect("orderHistory.jsp?success=orderDeleted");
                } else {
                    response.sendRedirect("orderHistory.jsp?error=orderNotFound");
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("orderHistory.jsp?error=serverError");
    }
%>
