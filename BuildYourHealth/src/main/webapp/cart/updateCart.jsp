<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dto.Product"%>
<%
    String id = request.getParameter("id");
    String quantityParam = request.getParameter("quantity");

    if (id == null || id.trim().equals("") || quantityParam == null || quantityParam.trim().equals("")) {
        response.sendRedirect("cart.jsp");
        return;
    }

    int quantity = Integer.parseInt(quantityParam);

    ArrayList<Product> cartList = (ArrayList<Product>) session.getAttribute("cartlist");
    if (cartList != null) {
        for (Product product : cartList) {
            if (product.getProductId().equals(id)) {
                product.setQuantity(quantity);
                break;
            }
        }
    }

    session.setAttribute("cartlist", cartList);
    response.sendRedirect("cart.jsp");
%>
