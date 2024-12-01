CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,           -- 아이템 ID
    order_id INT NOT NULL,                            -- 주문 ID
    product_id VARCHAR(10) NOT NULL,                  -- 상품 ID
    quantity INT NOT NULL,                            -- 수량
    price INT NOT NULL,                               -- 개별 상품 가격
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8;
