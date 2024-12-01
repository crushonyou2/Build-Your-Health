<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%@ page import="java.util.*"%>
<%@ include file="../templates/dbconn.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String realFolder = "C:\\Users\\crush\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\BuildYourHealth\\resources\\images";
    int maxSize = 5 * 1024 * 1024; // 최대 업로드될 파일의 크기 5MB
    String encType = "utf-8"; // 인코딩 타입

    MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

    // 폼 데이터 가져오기
    String productId = multi.getParameter("productId");
    String productName = multi.getParameter("productName");
    String regularPrice = multi.getParameter("regularPrice");
    String discountPrice = multi.getParameter("discountPrice");
    String manufacturer = multi.getParameter("manufacturer");
    String shippingInfo = multi.getParameter("shippingInfo");
    String arrivalDate = multi.getParameter("arrivalDate");
    String productOptions = multi.getParameter("productOptions");

    Enumeration files = multi.getFileNames();
    String fname = (String) files.nextElement();
    String imageFile = multi.getFilesystemName(fname);
    
    System.out.println("productId: " + productId);
    System.out.println("productName: " + productName);
    System.out.println("regularPrice: " + regularPrice);
    System.out.println("discountPrice: " + discountPrice);
    System.out.println("manufacturer: " + manufacturer);
    System.out.println("shippingInfo: " + shippingInfo);
    System.out.println("arrivalDate: " + arrivalDate);
    System.out.println("productOptions: " + productOptions);
    System.out.println("imageFile: " + imageFile);

    // 가격과 기타 숫자형 값 검증 및 파싱
    int regularPriceValue = regularPrice.isEmpty() ? 0 : Integer.parseInt(regularPrice);
    int discountPriceValue = discountPrice.isEmpty() ? 0 : Integer.parseInt(discountPrice);

    // 데이터베이스에 상품 정보 저장
    PreparedStatement pstmt = null;

    String sql = "INSERT INTO product (product_id, product_name, regular_price, discount_price, manufacturer, shipping_info, image_file, product_options, arrival_date) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, productId);
        pstmt.setString(2, productName);
        pstmt.setInt(3, regularPriceValue);
        pstmt.setInt(4, discountPriceValue);
        pstmt.setString(5, manufacturer);
        pstmt.setString(6, shippingInfo);
        pstmt.setString(7, imageFile);
        pstmt.setString(8, productOptions);
        
        if (arrivalDate != null && !arrivalDate.isEmpty()) {
            pstmt.setDate(9, java.sql.Date.valueOf(arrivalDate));
        } else {
            pstmt.setNull(9, java.sql.Types.DATE);
        }

        pstmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("exceptionNoProductId.jsp");
        return;
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    // 등록 완료 후 목록 페이지로 리디렉션
    response.sendRedirect("./products.jsp");
%>
