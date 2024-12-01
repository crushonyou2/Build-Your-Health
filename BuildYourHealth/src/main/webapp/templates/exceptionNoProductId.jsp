<%@ page contentType="text/html; charset=utf-8"%>
<html >
<head>    
    <link rel ="stylesheet" href ="../resources/css/bootstrap.min.css" />
	<title>도서아이디 오류</title>
</head>
<body>
<div class="container py-4">
   <%@ include file="menu.jsp"%>  	
    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
      <div class="container-fluid py-5">
      <h1 class="alert alert-danger">해당 상품이 존재하지 않습니다.</h1>  
      </div>
    </div>

    <div class="row align-items-md-stretch ">
      <div class="col-md-12">
        <div class="h-100 p-5">
        <p><%=request.getRequestURL()%>?<%=request.getQueryString()%>
			<p><a href="../product/products.jsp" class="btn btn-secondary"> 상품 목록 &raquo;</a>	
        </div>
      </div>   
 	</div> 	
	<%@ include file="footer.jsp"%>   
  </div>
</body>
</html>
  