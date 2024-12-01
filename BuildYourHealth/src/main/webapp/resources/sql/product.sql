CREATE TABLE product (
    product_id VARCHAR(10) NOT NULL PRIMARY KEY,  -- 상품 ID
    product_name VARCHAR(50) NOT NULL,           -- 상품 이름
    regular_price INT,                           -- 상품 정가 가격
    discount_price INT,                          -- 상품 할인 가격
    manufacturer VARCHAR(50),                    -- 제조사
    shipping_info VARCHAR(50),                   -- 배송 정보
    image_file VARCHAR(50),                      -- 상품 이미지 파일 이름
    product_options TEXT,                        -- 옵션 정보 (JSON 형식)
    arrival_date DATE DEFAULT NULL      -- 도착 예정 날짜
) DEFAULT CHARSET=utf8;
