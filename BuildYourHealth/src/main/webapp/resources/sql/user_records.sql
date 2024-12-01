create table user_records (
	record_id int auto_increment primary key,
	user_id varchar(50),
	consumed_water double default 0,
	consumed_sleep double default 0,
	record_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES MEMBER(id)
);