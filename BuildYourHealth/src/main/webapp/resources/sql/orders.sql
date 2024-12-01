CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,          -- 주문 ID
    user_id VARCHAR(50) NOT NULL,                     -- 사용자 ID (member 테이블 참조)
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- 주문 날짜
    delivery_date DATE NOT NULL,                      -- 배송 날짜
    total_price INT NOT NULL,                         -- 총 주문 금액
    shipping_address VARCHAR(255) NOT NULL,           -- 배송 주소
    shipping_zipcode VARCHAR(20),                     -- 우편번호
    FOREIGN KEY (user_id) REFERENCES member(id) ON DELETE CASCADE
);
