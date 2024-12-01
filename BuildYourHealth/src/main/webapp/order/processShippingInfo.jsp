<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.time.format.DateTimeParseException"%>
<%
    request.setCharacterEncoding("UTF-8");

    // 배송 날짜를 검증하고 변환
    String shippingDateStr = request.getParameter("shippingDate");
    String userId = (String) session.getAttribute("sessionId");

    if (userId == null) {
        response.sendRedirect("../templates/login.jsp");
        return;
    }

    java.sql.Date deliveryDate = null;
    try {
        LocalDate localDate = LocalDate.parse(shippingDateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        deliveryDate = java.sql.Date.valueOf(localDate);
    } catch (DateTimeParseException e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp?msg=invalidDate");
        return;
    }

    // 쿠키 생성 및 저장
    Cookie cartId = new Cookie("Shipping_cartId", URLEncoder.encode(request.getParameter("cartId"), "utf-8"));
    Cookie name = new Cookie("Shipping_name", URLEncoder.encode(request.getParameter("name"), "utf-8"));
    Cookie shippingDate = new Cookie("Shipping_shippingDate", URLEncoder.encode(deliveryDate.toString(), "utf-8"));
    Cookie country = new Cookie("Shipping_country", URLEncoder.encode(request.getParameter("country"), "utf-8"));
    Cookie zipCode = new Cookie("Shipping_zipCode", URLEncoder.encode(request.getParameter("zipCode"), "utf-8"));
    Cookie addressName = new Cookie("Shipping_addressName", URLEncoder.encode(request.getParameter("addressName"), "utf-8"));

    int cookieMaxAge = 24 * 60 * 60;
    cartId.setMaxAge(cookieMaxAge);
    name.setMaxAge(cookieMaxAge);
    shippingDate.setMaxAge(cookieMaxAge);
    country.setMaxAge(cookieMaxAge);
    zipCode.setMaxAge(cookieMaxAge);
    addressName.setMaxAge(cookieMaxAge);

    // 쿠키의 경로를 설정
    cartId.setPath("/");
    name.setPath("/");
    shippingDate.setPath("/");
    country.setPath("/");
    zipCode.setPath("/");
    addressName.setPath("/");

    response.addCookie(cartId);
    response.addCookie(name);
    response.addCookie(shippingDate);
    response.addCookie(country);
    response.addCookie(zipCode);
    response.addCookie(addressName);

    response.sendRedirect("orderConfirmation.jsp");
%>
