<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 수정 결과</title>
    <link rel="stylesheet" href="../resources/css/sweetalert2.min.css">
    <script src="../resources/js/sweetalert2.all.min.js"></script>
</head>
<body>
<%
    // Required Fields
    String id = request.getParameter("id");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String ageGroup = request.getParameter("ageGroup");

    // Optional Fields
    String gender = request.getParameter("gender");
    gender = (gender == null || gender.isEmpty()) ? null : gender;

    String birthyy = request.getParameter("birthyy");
    String birthmm = request.getParameter("birthmm");
    String birthdd = request.getParameter("birthdd");
    String birth = null;

    if (birthyy != null && !birthyy.isEmpty() &&
        birthmm != null && !birthmm.isEmpty() &&
        birthdd != null && !birthdd.isEmpty()) {
        // Ensure proper date format with leading zeros
        birth = birthyy + "-" + String.format("%02d", Integer.parseInt(birthmm)) + "-" + String.format("%02d", Integer.parseInt(birthdd));
    }

    String email1 = request.getParameter("mail1");
    String email2 = request.getParameter("mail2");
    String email = (email1 != null && !email1.isEmpty() && email2 != null && !email2.isEmpty())
        ? email1 + "@" + email2
        : null;

    String phone = request.getParameter("phone");
    phone = (phone == null || phone.isEmpty()) ? null : phone;

    String address = request.getParameter("address");
    address = (address == null || address.isEmpty()) ? null : address;

    // 사용자가 입력한 수면시간과 물 섭취량을 받아옴
    String sleepHoursStr = request.getParameter("sleepHours");
    String waterIntakeStr = request.getParameter("waterIntake");

    double sleepHours = 0.0;
    double waterIntake = 0.0;

    try {
        sleepHours = Double.parseDouble(sleepHoursStr);
    } catch (NumberFormatException e) {
        sleepHours = 0.0; // 기본값 설정 또는 오류 처리
    }

    try {
        waterIntake = Double.parseDouble(waterIntakeStr);
    } catch (NumberFormatException e) {
        waterIntake = 0.0; // 기본값 설정 또는 오류 처리
    }

    // 남은 섭취량과 수면 시간은 사용자가 입력하지 않으므로 권장 값으로 초기화
    double remainingWater = waterIntake;
    double remainingSleep = sleepHours;

    Connection connection = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/HealthDB", "root", "1234");

        String query = "UPDATE MEMBER SET password = ?, name = ?, age_group = ?, sleep_hours = ?, water_intake = ?, remaining_sleep = ?, remaining_water = ?, " +
                       "gender = IFNULL(?, gender), birth = IFNULL(?, birth), email = IFNULL(?, email), phone = IFNULL(?, phone), address = IFNULL(?, address) " +
                       "WHERE id = ?";
        pstmt = connection.prepareStatement(query);
        pstmt.setString(1, password);
        pstmt.setString(2, name);
        pstmt.setString(3, ageGroup);
        pstmt.setDouble(4, sleepHours);
        pstmt.setDouble(5, waterIntake);
        pstmt.setDouble(6, remainingSleep);
        pstmt.setDouble(7, remainingWater);
        pstmt.setString(8, gender);
        pstmt.setString(9, birth);
        pstmt.setString(10, email);
        pstmt.setString(11, phone);
        pstmt.setString(12, address);
        pstmt.setString(13, id);

        int rowsUpdated = pstmt.executeUpdate();

        if (rowsUpdated > 0) {
            // 세션에 이름 업데이트 (필요한 경우)
            session.setAttribute("sessionName", name);
%>
<script type="text/javascript">
    Swal.fire({
        icon: 'success',
        title: '수정 완료',
        text: '회원 정보가 성공적으로 수정되었습니다!',
    }).then(() => {
        window.location.href = "../user/welcome.jsp"; // 성공 시 welcome 페이지로 이동
    });
</script>
<%
        } else {
%>
<script type="text/javascript">
    Swal.fire({
        icon: 'error',
        title: '수정 실패',
        text: '회원 정보를 수정하는 데 실패했습니다. 다시 시도해주세요.',
    }).then(() => {
        window.history.back(); // 실패 시 이전 페이지로 이동
    });
</script>
<%
        }
    } catch (Exception e) {
%>
<script type="text/javascript">
    Swal.fire({
        icon: 'error',
        title: '오류 발생',
        text: '<%= e.getMessage().replaceAll("'", "\\'").replaceAll("\n", " ") %>',
    }).then(() => {
        window.history.back(); // 오류 시 이전 페이지로 이동
    });
</script>
<%
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (connection != null) try { connection.close(); } catch (Exception e) {}
    }
%>
</body>
</html>
