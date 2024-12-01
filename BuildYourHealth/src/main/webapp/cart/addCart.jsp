<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dto.Product"%>
<%@ page import="dao.ProductRepository"%>
<%
    // 상품 ID 가져오기
    String id = request.getParameter("id");
    if (id == null || id.trim().equals("")) {
        response.sendRedirect("../product/products.jsp");
        return;
    }

    // DAO를 통해 상품 정보 가져오기
    ProductRepository dao = ProductRepository.getInstance();
    Product product = dao.getProductById(id);

    if (product == null) {
        response.sendRedirect("../templates/exceptionNoProductId.jsp");
        return;
    }

    // 세션에서 장바구니 가져오기
    ArrayList<Product> cartList = (ArrayList<Product>) session.getAttribute("cartlist");
    if (cartList == null) {
        cartList = new ArrayList<>();
        session.setAttribute("cartlist", cartList);
    }

    // 상품이 이미 장바구니에 있는지 확인
    boolean found = false;
    for (Product item : cartList) {
        if (item.getProductId().equals(id)) {
            // 수량 증가
            item.setQuantity(item.getQuantity() + 1);
            found = true;
            break;
        }
    }

    // 장바구니에 없는 경우 새로 추가
    if (!found) {
        product.setQuantity(1); // 초기 수량 설정
        cartList.add(product);
    }

    // 상품 상세 페이지로 리디렉션
    response.sendRedirect("../product/product.jsp?id=" + id);
%>
