CREATE TABLE member (
    id VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    name VARCHAR(100),
    gender VARCHAR(10),
    birth DATE,
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255),
    age_group VARCHAR(10),
    water_intake DECIMAL(3,1),
    sleep_hours DECIMAL(3,1),
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remaining_water DECIMAL(3,1) DEFAULT 0,
    remaining_sleep DECIMAL(3,1) DEFAULT 0
);
