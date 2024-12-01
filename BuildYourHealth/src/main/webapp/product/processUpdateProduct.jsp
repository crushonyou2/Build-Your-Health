<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ include file="../templates/dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String realFolder = "C:\\Users\\crush\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\BuildYourHealth\\resources\\images"; // 실제 이미지 저장 경로
    int maxSize = 5 * 1024 * 1024;
    String encType = "utf-8";

    MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

    String productId = multi.getParameter("productId");
    String productName = multi.getParameter("productName");
    int regularPrice = Integer.parseInt(multi.getParameter("regularPrice"));
    int discountPrice = Integer.parseInt(multi.getParameter("discountPrice"));
    String manufacturer = multi.getParameter("manufacturer");
    String shippingInfo = multi.getParameter("shippingInfo");
    String productOptions = multi.getParameter("productOptions");
    String imageFile = multi.getFilesystemName("imageFile");
    String expectedDeliveryDate = multi.getParameter("expectedDeliveryDate");

    String sql;
    if (imageFile != null) {
        sql = "UPDATE product SET product_name = ?, regular_price = ?, discount_price = ?, manufacturer = ?, shipping_info = ?, product_options = ?, image_file = ?, arrival_date = ? WHERE product_id = ?";
    } else {
        sql = "UPDATE product SET product_name = ?, regular_price = ?, discount_price = ?, manufacturer = ?, shipping_info = ?, product_options = ?, arrival_date = ? WHERE product_id = ?";
    }

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setString(1, productName);
        pstmt.setInt(2, regularPrice);
        pstmt.setInt(3, discountPrice);
        pstmt.setString(4, manufacturer);
        pstmt.setString(5, shippingInfo);
        pstmt.setString(6, productOptions);

        if (imageFile != null) {
            pstmt.setString(7, imageFile);
            pstmt.setString(8, expectedDeliveryDate);
            pstmt.setString(9, productId);
        } else {
            pstmt.setString(7, expectedDeliveryDate);
            pstmt.setString(8, productId);
        }

        pstmt.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }

    response.sendRedirect("editProduct.jsp?edit=update");
%>
