<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
    <link rel="stylesheet" href="../resources/css/sweetalert2.min.css">
    <script src="../resources/js/sweetalert2.all.min.js"></script>
    <script type="text/javascript">
    	function checkForm() {
    		if (!document.newMember.id.value) {
    			alert("아이디를 입력하세요.");
    			return false;
    		}

    		if (!document.newMember.password.value) {
    			alert("비밀번호를 입력하세요.");
    			return false;
    		}

    		if (document.newMember.password.value != document.newMember.password_confirm.value) {
    			alert("비밀번호를 동일하게 입력하세요.");
    			return false;
    		}

    		if (!document.newMember.name.value) {
    			alert("성명을 입력하세요.");
    			return false;
    		}

    		if (!document.newMember.ageGroup.value) {
    			alert("연령대를 선택하세요.");
    			return false;
    		}

    		return true;
    	}

        function toggleOptionalFields() {
            var optionalFields = document.getElementById('optionalFields');
            var toggleButton = document.getElementById('toggleButton');
            if (optionalFields.style.display === 'none' || optionalFields.style.display === '') {
                optionalFields.style.display = 'block';
                toggleButton.textContent = '선택 입력 필드 숨기기'; // Change button text
            } else {
                optionalFields.style.display = 'none';
                toggleButton.textContent = '선택 입력 필드 보이기';
            }
        }
    </script>
    <title>회원 가입</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
<div class="container py-4">
   <jsp:include page="../templates/menu.jsp" />

   <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">회원 가입</h1>
            <p class="col-md-8 fs-4">Membership Joining</p>      
        </div>
    </div>
	
   <div class="row align-items-md-stretch text-center">
   <div class="text-end"> 
			<a href="?language=ko" >Korean</a> | <a href="?language=en" >English</a>
		</div>	
        <form name="newMember" action="processAddMember.jsp" method="post" onsubmit="return checkForm()">
            <!-- 필수 입력 필드 -->
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="id" /></label>
                <div class="col-sm-3">
                    <input name="id" type="text" class="form-control" placeholder="id" required>
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="password" /></label>
                <div class="col-sm-3">
                    <input name="password" type="password" class="form-control" placeholder="password" required>
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="passwordConfirm" /></label>
                <div class="col-sm-3">
                    <input name="password_confirm" type="password" class="form-control" placeholder="password confirm" required>
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="name" /></label>
                <div class="col-sm-3">
                    <input name="name" type="text" class="form-control" placeholder="name" required>
                </div>
            </div>
            <div class="mb-3 row">
            	<label class="col-sm-2"><fmt:message key="gender" /></label>
                <div class="col-sm-3">
                	<input name="gender" type="radio" value="남"><fmt:message key="male" />
                    <input name="gender" type="radio" value="여"><fmt:message key="female" />
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="ageGroup" /></label>
                <div class="col-sm-3">
                    <select id="ageGroup" name="ageGroup" class="form-select" required>
                        <option value=""><fmt:message key="choose" /></option>
                        <option value="20s">20s</option>
                        <option value="30s">30s</option>
                        <option value="40s">40s</option>
                        <option value="50s">50s</option>
                        <option value="60s">60s</option>
                    </select>
                </div>
            </div>

            <!-- 선택 입력 필드 표시/숨기기 버튼 -->
            <div class="mb-3 row">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="button" id="toggleButton" class="btn btn-secondary" onclick="toggleOptionalFields()"><fmt:message key="optinalFields" /></button>
                </div>
            </div>

            <!-- 선택 입력 필드 -->
            <div id="optionalFields" style="display: none;">

                <!-- 생일 (선택) -->
                <div class="mb-3 row">
                    <label class="col-sm-2"><fmt:message key="birth" /></label>
                    <div class="col-sm-10">
                        <div class="row">
                            <div class="col-sm-2">
                                <input type="text" name="birthyy" maxlength="4" class="form-control" placeholder=<fmt:message key="year" />>
                            </div>
                            <div class="col-sm-2">
                                <select name="birthmm" class="form-select">
                                    <option value=""><fmt:message key="month" /></option>
                                    <option value="01">1</option>
                                    <option value="02">2</option>
                                    <option value="03">3</option>
                                    <option value="04">4</option>
                                    <option value="05">5</option>
                                    <option value="06">6</option>
                                    <option value="07">7</option>
                                    <option value="08">8</option>
                                    <option value="09">9</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                    <option value="12">12</option>
                                </select>
                            </div>
                            <div class="col-sm-2">
                                <input type="text" name="birthdd" maxlength="2" class="form-control" placeholder=<fmt:message key="day" />>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 이메일 (선택) -->
                <div class="mb-3 row">
                    <label class="col-sm-2"><fmt:message key="email" /></label>
                    <div class="col-sm-10">
                        <div class="row">
                            <div class="col-sm-4">
                                <input type="text" name="mail1" maxlength="50" class="form-control" placeholder="email">
                            </div> @
                            <div class="col-sm-3">
                                <select name="mail2" class="form-select">
                                    <option value="naver.com">naver.com</option>
                                    <option value="daum.net">daum.net</option>
                                    <option value="gmail.com">gmail.com</option>
                                    <option value="nate.com">nate.com</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 전화번호 (선택) -->
                <div class="mb-3 row">
                    <label class="col-sm-2"><fmt:message key="phoneNumber" /></label>
                    <div class="col-sm-3">
                        <input name="phone" type="text" class="form-control" placeholder="phone">
                    </div>
                </div>
                <!-- 주소 (선택) -->
                <div class="mb-3 row">
                    <label class="col-sm-2"><fmt:message key="address" /></label>
                    <div class="col-sm-5">
                        <input name="address" type="text" class="form-control" placeholder="address">
                    </div>
                </div>
            </div>

            <!-- 제출 및 취소 버튼 -->
            <div class="mb-3 row">
                <div class="col-sm-offset-2 col-sm-10">
                    <input type="submit" class="btn btn-primary" value=<fmt:message key="submit" />>
                    <input type="reset" class="btn btn-secondary" value=<fmt:message key="cancel" />>
                </div>
            </div>
        </form>
    </div>
    <jsp:include page="../templates/footer.jsp" />  
</div>
</fmt:bundle>
</body>
</html>
