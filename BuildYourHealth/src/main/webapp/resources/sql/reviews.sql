CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY, -- 리뷰 ID
    product_id VARCHAR(10) NOT NULL,          -- 상품 ID (product 테이블 참조)
    user_id VARCHAR(50) NOT NULL,             -- 사용자 ID
    review TEXT NOT NULL,                     -- 리뷰 내용
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 작성 시간
    FOREIGN KEY (product_id) REFERENCES product(product_id) -- 외래 키
)  DEFAULT CHARSET=utf8;