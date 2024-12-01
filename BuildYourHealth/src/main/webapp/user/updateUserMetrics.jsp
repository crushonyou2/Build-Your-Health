<%@ page contentType="text/html; charset=utf-8"%>
<%
    String sessionId = (String) session.getAttribute("sessionId");
    String warningMessage = null; // 경고 메시지 초기화

    if (sessionId != null) {
        String consumedWaterStr = request.getParameter("consumedWater");
        String sleptHoursStr = request.getParameter("sleptHours");

        double consumedWater = 0.0;
        double sleptHours = 0.0;

        java.sql.Connection connection = null;
        java.sql.PreparedStatement memberQueryStmt = null;
        java.sql.PreparedStatement totalQueryStmt = null;
        java.sql.PreparedStatement insertStmt = null;
        java.sql.PreparedStatement updateStmt = null;
        java.sql.ResultSet rs = null;

        try {
            if (consumedWaterStr != null && !consumedWaterStr.isEmpty()) {
                consumedWater = Double.parseDouble(consumedWaterStr);
            }
            if (sleptHoursStr != null && !sleptHoursStr.isEmpty()) {
                sleptHours = Double.parseDouble(sleptHoursStr);
            }

            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = java.sql.DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/HealthDB", "root", "1234");

            // 1. MEMBER 테이블에서 권장 섭취량 및 수면 시간 가져오기
            String memberQuery = "SELECT water_intake, sleep_hours FROM MEMBER WHERE id = ?";
            memberQueryStmt = connection.prepareStatement(memberQuery);
            memberQueryStmt.setString(1, sessionId);
            rs = memberQueryStmt.executeQuery();

            double waterIntake = 0.0;
            double sleepHours = 0.0;
            if (rs.next()) {
                waterIntake = rs.getDouble("water_intake");
                sleepHours = rs.getDouble("sleep_hours");
            }
            rs.close();
            memberQueryStmt.close();

            // 2. 현재 누적 섭취량 가져오기
            String totalQuery = "SELECT IFNULL(SUM(consumed_water), 0) AS total_water, IFNULL(SUM(consumed_sleep), 0) AS total_sleep " +
                                "FROM USER_RECORDS WHERE user_id = ?";
            totalQueryStmt = connection.prepareStatement(totalQuery);
            totalQueryStmt.setString(1, sessionId);
            rs = totalQueryStmt.executeQuery();

            double totalWater = 0.0;
            double totalSleep = 0.0;
            if (rs.next()) {
                totalWater = rs.getDouble("total_water");
                totalSleep = rs.getDouble("total_sleep");
            }
            rs.close();
            totalQueryStmt.close();

            // 3. 입력 값 검증: 누적 섭취량이 권장 섭취량을 초과하지 않도록
            if ((totalWater + consumedWater) > waterIntake) {
                warningMessage = "총 물 섭취량이 권장 섭취량(" + String.format("%.1f", waterIntake) + "L)을 초과할 수 없습니다.";
            } else if ((totalSleep + sleptHours) > sleepHours) {
                warningMessage = "총 수면 시간이 권장 수면 시간(" + String.format("%.1f", sleepHours) + "시간)을 초과할 수 없습니다.";
            } else {
                // 4. USER_RECORDS에 데이터 추가
                String insertQuery = "INSERT INTO USER_RECORDS (user_id, consumed_water, consumed_sleep, record_date) VALUES (?, ?, ?, NOW())";
                insertStmt = connection.prepareStatement(insertQuery);
                insertStmt.setString(1, sessionId);
                insertStmt.setDouble(2, consumedWater);
                insertStmt.setDouble(3, sleptHours);
                insertStmt.executeUpdate();
                insertStmt.close();

                // 5. MEMBER 테이블의 남은 섭취량 업데이트
                String updateQuery = "UPDATE MEMBER SET remaining_water = ?, remaining_sleep = ? WHERE id = ?";
                updateStmt = connection.prepareStatement(updateQuery);
                updateStmt.setDouble(1, waterIntake - (totalWater + consumedWater));
                updateStmt.setDouble(2, sleepHours - (totalSleep + sleptHours));
                updateStmt.setString(3, sessionId);
                updateStmt.executeUpdate();
                updateStmt.close();

                response.sendRedirect("welcome.jsp?msg=updateSuccess");
                return; // 메시지 없이 성공적으로 리디렉션
            }

        } catch (Exception e) {
            warningMessage = "오류가 발생했습니다: " + e.getMessage();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (memberQueryStmt != null) try { memberQueryStmt.close(); } catch (Exception e) {}
            if (totalQueryStmt != null) try { totalQueryStmt.close(); } catch (Exception e) {}
            if (insertStmt != null) try { insertStmt.close(); } catch (Exception e) {}
            if (updateStmt != null) try { updateStmt.close(); } catch (Exception e) {}
            if (connection != null) try { connection.close(); } catch (Exception e) {}
        }
    } else {
        warningMessage = "로그인 상태가 아닙니다.";
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Update Metrics</title>
    <!-- SweetAlert2 CSS 및 JS 추가 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
</head>
<body>
<% if (warningMessage != null) { %>
<script>
    Swal.fire({
        title: '알림',
        text: "<%= warningMessage %>",
        icon: 'warning',
        confirmButtonText: '확인'
    }).then(() => {
        window.history.back(); // 이전 페이지로 돌아가기
    });
</script>
<% } %>
</body>
</html>
