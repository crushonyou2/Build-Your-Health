# Build Your Health

건강한 생활 습관을 위한 올인원 웹 애플리케이션입니다.  
사용자는 물 섭취량과 수면 시간 등을 기록하고, 건강 관련 상품을 탐색하거나 추천 콘텐츠를 확인하며 웰빙을 관리할 수 있습니다.

## 🔗 배포 링크
👉 [Demo Site 바로가기](https://crushonyou2.github.io/Build-Your-Health/)

---

## 🌟 Project Overview

**Build Your Health**는 건강 데이터 기록, 상품 쇼핑 및 리뷰, 추천 콘텐츠 제공 등 다양한 기능을 통해  
사용자가 **더 건강한 라이프스타일을 형성하고 유지할 수 있도록 돕는 웹 애플리케이션**입니다.

---

## 🧩 주요 기능 (Key Features)

### ✅ 사용자 기능
- **건강 기록**  
  하루 물 섭취량 및 수면 시간을 입력하고, 목표 달성률을 퍼센트 바로 시각화
- **상품 쇼핑**  
  건강 관련 상품 탐색, 장바구니 기능, 리뷰 및 별점 시스템
- **게시판 및 콘텐츠**  
  건강 관련 게시글 공유, 추천 콘텐츠 확인

### 🔒 관리자 기능
- 상품 등록, 편집, 삭제
- 추천 콘텐츠 등록 및 관리
- 전체 시스템 유지보수

---

## 🏗️ 폴더 구조

```plaintext
BuildYourHealth/
├── .classpath / .project / .settings/     # Eclipse 설정
├── build/classes/                         # 컴파일된 클래스 파일
│   ├── dao/
│   ├── dto/
│   ├── filter/
│   └── mvc/
├── src/main/
│   ├── java/
│   │   ├── dao/
│   │   ├── dto/
│   │   ├── filter/
│   │   └── mvc/
│   └── webapp/
│       ├── board/
│       ├── cart/
│       ├── content/
│       ├── member/
│       ├── order/
│       ├── product/
│       ├── review/
│       ├── templates/
│       ├── user/
│       │   └── welcome.jsp     # 메인 홈페이지
│       ├── resources/          # CSS, JS, 이미지, SQL 등
│       └── WEB-INF/            # 설정 파일
└── README.md
```

---

## ⚙️ 개발 환경
- Java 8 / JDK 20
- Apache Tomcat 10.1
- MySQL 8.0
- JSP 기반 MVC 아키텍처
- Eclipse IDE

---

## 🛠️ 사용 기술 (Tech Stack)
- JSP / Servlet
- HTML5, CSS3, JavaScript
- MySQL (JDBC 기반 데이터 연동)
- Tomcat (로컬 서버 실행)
