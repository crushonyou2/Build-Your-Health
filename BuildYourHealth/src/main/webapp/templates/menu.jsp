<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<header class="pb-3 mb-4 border-bottom">
  <div class="container ">  
   <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">  
      <a href="<c:url value='/user/welcome.jsp'/>" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
      <svg  width="32" height="32" fill="currentColor" class="bi bi-house-fill" viewBox="0 0 16 16">
  			<path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L8 2.207l6.646 6.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.707 1.5Z"/>
  			<path d="m8 3.293 6 6V13.5a1.5 1.5 0 0 1-1.5 1.5h-9A1.5 1.5 0 0 1 2 13.5V9.293l6-6Z"/>
		</svg>   
        <span class="fs-4">Home</span>
      </a> 
      
       <ul class="nav nav-pills">
         <c:choose>
            <c:when test="${empty sessionScope.sessionId}">
                <!-- 로그인하지 않은 상태 -->
                <li class="nav-item"><a class="nav-link" href="<c:url value="/member/loginMember.jsp"/>">로그인</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/member/addMember.jsp"/>">회원 가입</a></li>
            </c:when>
            <c:otherwise>
                <!-- 로그인한 상태 -->
				<li class="nav-item" style="padding-top: 7px">[${sessionScope.sessionName}님]</li>
                <!-- admin이 아닐 경우 -->
                <c:if test="${sessionScope.sessionId != 'admin'}">
				  <li class="nav-item"><a class="nav-link" href="<c:url value='/member/updateMember.jsp'/>">회원 수정</a></li>
				</c:if>
                <li class="nav-item"><a class="nav-link" href="<c:url value='/member/logoutMember.jsp'/>">로그아웃</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/content/contents.jsp"/>">추천 컨텐츠</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/product/products.jsp"/>">상품 목록</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/order/orderHistory.jsp"/>">주문 내역</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value='/BoardListAction.do?pageNum=1'/>">게시판</a></li>
                
                <!-- admin 계정 전용 메뉴 -->
                <c:if test="${sessionScope.sessionId == 'admin'}">
                	<li class="nav-item"><a class="nav-link" href="<c:url value="/content/manageContents.jsp"/>">컨텐츠 관리</a></li>
                    <li class="nav-item"><a class="nav-link" href="<c:url value="/product/addProduct.jsp"/>">상품 등록</a></li>
                    <li class="nav-item"><a class="nav-link" href="<c:url value="/product/editProduct.jsp?edit=update"/>">상품 편집</a></li>
                </c:if>
            </c:otherwise>
         </c:choose>
       </ul>
    </div>
  </div>   
</header>
