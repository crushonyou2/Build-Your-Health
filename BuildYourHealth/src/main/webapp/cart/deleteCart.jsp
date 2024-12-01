<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dto.Product"%>
<%
    // cartId 파라미터 확인
    String id = request.getParameter("id");
    if (id == null || id.trim().equals("")) {
        response.sendRedirect("cart.jsp");
        return;
    }

    // 세션에서 장바구니 가져오기
    ArrayList<Product> cartList = (ArrayList<Product>) session.getAttribute("cartlist");
    if (cartList == null) {
        response.sendRedirect("cart.jsp");
        return;
    }

    // 장바구니에서 상품 제거
    cartList.removeIf(item -> item.getProductId().equals(id));

    // 업데이트된 장바구니 세션에 저장
    session.setAttribute("cartlist", cartList);

    // 장바구니 페이지로 리디렉션
    response.sendRedirect("cart.jsp");
%>
