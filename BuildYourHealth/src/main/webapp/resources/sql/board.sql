CREATE TABLE board (
       num int not null auto_increment,
       id varchar(10) not null,
       name varchar(10) not null,
       subject varchar(100) not null,
       content text not null,
       regist_day varchar(30),
       hit int,
       ip varchar(20),
       PRIMARY KEY (num)
)default CHARSET=utf8;

ALTER TABLE board MODIFY regist_day DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE board MODIFY hit INT DEFAULT 0 NOT NULL;
ALTER TABLE board MODIFY ip VARCHAR(20) DEFAULT '' NOT NULL;
ALTER TABLE board ADD COLUMN image_file_name VARCHAR(255) DEFAULT NULL;