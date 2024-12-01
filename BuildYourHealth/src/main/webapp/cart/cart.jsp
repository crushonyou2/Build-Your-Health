<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dto.Product"%>
<html>
<head>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
<%
    String cartId = session.getId();
%>
    <title>장바구니</title>
    <style>
	    .recommendation-section {
	        background-image: url('../resources/images/shopping_bag.jpeg');
	        background-size: cover;
	        background-position: center;
	        color: white;
	        position: relative;
	        overflow: hidden;
	    }
	
	    .recommendation-section::before {
	        content: '';
	        position: absolute;
	        top: 0;
	        left: 0;
	        width: 100%;
	        height: 100%;
	        background-color: rgba(0, 0, 0, 0.5); /* 검은색 반투명 오버레이 */
	        z-index: 1;
	    }
	
	    .recommendation-section .container-fluid {
	        position: relative;
	        z-index: 2;
	    }
	
	    .recommendation-section h1,
	    .recommendation-section p {
	        color: white;
	    }
	</style>
</head>
<body>

<div class="container py-4">
   <%@ include file="../templates/menu.jsp"%>    

   <div class="p-5 mb-4 recommendation-section rounded-3">
      <div class="container-fluid py-5">
        <h1 class="display-5 fw-bold">장바구니</h1>
        <p class="col-md-8 fs-4">Cart</p>      
      </div>
    </div>
      
    <div class="row align-items-md-stretch">
        <div class="row">
            <table width="100%">
                <tr>
                    <td align="left">
                        <a href="./deleteCart.jsp?cartId=<%=cartId%>" class="btn btn-danger">전체 삭제</a>
                    </td>
                    <td align="right">
                        <a href="../order/shippingInfo.jsp?cartId=<%=cartId%>" class="btn btn-success">주문하기</a>
                    </td>
                </tr>
            </table>
        </div>
        <div style="padding-top: 50px">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>상품</th>
                        <th>가격</th>
                        <th>수량</th>
                        <th>소계</th>
                        <th>비고</th>
                    </tr>
                </thead>
                <tbody>
                <%                
                    int sum = 0;
                    ArrayList<Product> cartList = (ArrayList<Product>) session.getAttribute("cartlist");
                    if (cartList == null) {
                        cartList = new ArrayList<Product>();
                    }

                    for (Product product : cartList) { // 상품 리스트 하나씩 출력하기
                        int total = product.getDiscountPrice() * product.getQuantity();
                        sum += total;
                %>
                <tr>
                    <td><%=product.getProductName()%></td>
                    <td><%=product.getDiscountPrice()%></td>
                    <td>
                        <form action="./updateCart.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="id" value="<%=product.getProductId()%>">
                            <input type="number" name="quantity" value="<%=product.getQuantity()%>" min="1" style="width: 60px;">
                            <button type="submit" class="btn btn-primary btn-sm">수정</button>
                        </form>
                    </td>
                    <td><%=total%></td>
                    <td>
                        <a href="./removeCart.jsp?id=<%=product.getProductId()%>" class="badge text-bg-danger">삭제</a>
                    </td>
                </tr>
                <% } %>
                </tbody>
                <tfoot>
                <tr>
                    <td colspan="2"></td>
                    <th>총액</th>
                    <th><%=sum%></th>
                    <td></td>
                </tr>
                </tfoot>
            </table>
            <a href="../product/products.jsp" class="btn btn-secondary"> &laquo; 쇼핑 계속하기</a>
        </div>
    </div>

    <jsp:include page="../templates/footer.jsp" />
</div>
</body>
</html>
