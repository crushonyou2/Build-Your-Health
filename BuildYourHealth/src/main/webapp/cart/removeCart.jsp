<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dto.Product"%>
<%
    // 요청으로부터 상품 ID 가져오기
    String id = request.getParameter("id");
    if (id == null || id.trim().equals("")) {
        response.sendRedirect("cart.jsp");
        return;
    }

    // 세션에서 장바구니 가져오기
    ArrayList<Product> cartList = (ArrayList<Product>) session.getAttribute("cartlist");
    if (cartList == null || cartList.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }

    // 장바구니에서 해당 상품 제거
    Product productToRemove = null;
    for (Product product : cartList) {
        if (product.getProductId().equals(id)) {
            productToRemove = product;
            break;
        }
    }

    if (productToRemove != null) {
        cartList.remove(productToRemove);
    }

    // 세션 업데이트 후 장바구니 페이지로 리디렉션
    session.setAttribute("cartlist", cartList);
    response.sendRedirect("cart.jsp");
%>
