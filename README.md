# Build Your Health

## 🌟 Project Overview
Build Your Health는 사용자의 건강과 웰빙을 지원하기 위해 개발된 웹 애플리케이션입니다.
이 프로젝트는 건강 데이터 관리, 상품 구매 및 리뷰, 건강 컨텐츠 추천 등의 기능을 통해 사용자가 더 건강한 생활 습관을 형성하고 유지할 수 있도록 돕습니다.
   
## 🧩 Key Features
1. 건강 데이터 기록:
   - 하루 물 섭취량과 수면 시간을 기록하고, 목표를 시각화된 퍼센트 바(progress bar)로 확인할 수 있습니다.
2. 쇼핑 기능:
   - 건강 관련 상품을 탐색하고, 장바구니를 통해 손쉽게 구매할 수 있습니다.
   - 사용자가 작성한 리뷰 및 평점 시스템으로 구매 결정을 지원합니다.
3. 게시판 및 콘텐츠 관리:
   - 추천 컨텐츠를 확인하거나, 게시판에서 건강 관련 정보와 의견을 공유할 수 있습니다.
4. 관리자 전용 기능:
   - 관리자는 상품 등록/편집, 컨텐츠 관리를 통해 플랫폼을 효율적으로 운영할 수 있습니다.

## 🏗️ Project Structure

```
BuildYourHealth
├── .classpath              # Eclipse classpath 설정
├── .project                # Eclipse 프로젝트 설정
├── .settings/              # Eclipse 관련 설정
├── build/classes/          # 빌드된 클래스 파일
│   ├── dao/                # 데이터베이스 관련 DAO 클래스
│   ├── dto/                # 데이터 전송 객체(DTO)
│   ├── filter/             # 필터 클래스
│   ├── mvc/controller/     # MVC 컨트롤러 클래스
│   ├── mvc/database/       # 데이터베이스 연결 및 유틸리티 클래스
│   └── mvc/model/          # 비즈니스 로직 및 데이터 접근 클래스
├── src/main/
│   ├── java/               # 자바 소스코드
│   │   ├── dao/            # DAO 소스코드
│   │   ├── dto/            # DTO 소스코드
│   │   ├── filter/         # 필터 소스코드
│   │   └── mvc/            # MVC 구조 소스코드
│   └── webapp/             # 웹 리소스 및 JSP 파일
│       ├── board/          # 게시판 관련 JSP 파일
│       ├── cart/           # 장바구니 관련 JSP 파일
│       ├── content/        # 콘텐츠 관련 JSP 파일
│       ├── member/         # 회원 관련 JSP 파일
│       ├── order/          # 주문 관련 JSP 파일
│       ├── product/        # 상품 관련 JSP 파일
│       ├── resources/      # CSS, JS, 이미지, SQL 스크립트
│       ├── review/         # 리뷰 관련 JSP 파일
│       ├── templates/      # 공통 템플릿 파일
│       ├── user/           # 사용자 전용 페이지 (메인 홈페이지 포함)
│       │   └── welcome.jsp # 메인 홈페이지
│       └── WEB-INF/        # 설정 파일 및 라이브러리
└── README.md               # 프로젝트 설명 파일

```

## ⚙️ 개발 환경
-  Java 8
- JDK 20
- Apache Tomcat 10.1
- MySQL 8.0

## 🌐 Core Features
### 1. Main Homepage
- 메인 홈페이지는 src/main/webapp/user/welcome.jsp입니다.
- 사용자는 메인 홈페이지에서 자신의 건강 데이터를 기록하거나 쇼핑, 추천 콘텐츠 확인 등을 시작할 수 있습니다.
### 2. User Features
- 물 섭취량과 수면 시간 기록
- 상품 탐색 및 구매
- 건강 관련 콘텐츠 및 게시판 참여
### 3. Admin Features
- 상품 등록, 편집 및 삭제
- 추천 콘텐츠 관리
- 전체 시스템 유지보수

## 🛠️ Technologies Used
#### Frontend:
- HTML5, CSS3, JSP, Bootstrap, SweetAlert2
#### Backend:
- Java, Servlet, JSP
#### Database:
- MySQL
#### Architecture:
- MVC (Model-View-Controller)

## 📈 Future Improvements
#### 사용자 데이터 분석
사용자의 기록 데이터를 바탕으로 건강 목표 달성을 위한 맞춤형 추천 시스템 추가
#### 모바일 지원
반응형 디자인 개선 및 모바일 애플리케이션 개발
#### 보안 강화
JWT 인증 및 암호화된 비밀번호 저장
