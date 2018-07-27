create table campaign_status (
     		campaign_status_id int UNSIGNED PRIMARY KEY,
     		campaign_status_name VARCHAR(40) not null 
)

insert into campaign_status (campaign_status_id, campaign_status_name) VALUES (1,"creata")

insert into campaign_status (campaign_status_id, campaign_status_name) VALUES (2,"avviata")

insert into campaign_status (campaign_status_id, campaign_status_name) VALUES (3,"chiusa")


CREATE table campaign (
			campaign_id   int UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			campaign_name varchar(100)  not null,
            campaign_status_id int UNSIGNED not null, 
            ts_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            ts_begin   TIMESTAMP not null DEFAULT CURRENT_TIMESTAMP,
            ts_end     TIMESTAMP not null DEFAULT CURRENT_TIMESTAMP,
            owner_id  int unsigned,
            FOREIGN KEY (campaign_status_id) REFERENCES campaign_status(campaign_status_id),
            foreign key (owner_id) references user_app(user_id)
)


create table user_info (
			user_type_id int UNSIGNED PRIMARY KEY,
			user_type_name varchar(15) not null
)

insert into user_info (user_type_id, user_type_name) VALUES (1, "worker")

insert into user_info (user_type_id, user_type_name) VALUES (2, "manager")


create table user_app (
			user_id   int UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			username  VARCHAR(80) not NULL,
			psswd     VARCHAR(56) not null,
			mail      VARCHAR(80) not null,
			user_type_id int UNSIGNED,
			FOREIGN KEY(user_type_id) REFERENCES user_info(user_type_id)
)


Create table annotation_validation_status (
			annotation_validation_id int UNSIGNED PRIMARY KEY,
			annotation_validation_name VARCHAR(15)
)

insert into annotation_validation_status VALUES (0, "invalid")

insert into annotation_validation_status VALUES (1, "valid")

CREATE TABLE validation_status (
			validation_status_id int UNSIGNED PRIMARY KEY,
			validation_status_name VARCHAR(10) not NULL
)

insert into validation_status VALUES(1,"respinta")

insert into validation_status VALUES(2, "valida")

CREATE table annotation (
			annotation_id int UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			elevation DOUBLE UNSIGNED not null,
			validation  INT(11) not null,
			peak_name VARCHAR(250) not null,
			localized_names  VARCHAR(200),
			timeslot_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			validation_status_id int UNSIGNED,
			campaign_id int UNSIGNED not null,
			user_id int UNSIGNED not null,
			peak_id int UNSIGNED not null,
			latitude DOUBLE not null,
			longitude DOUBLE not null,
			FOREIGN KEY (validation_status_id) REFERENCES validation_status(validation_status_id)
)

create table peak (
			peak_id int UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			provenance VARCHAR(100) not null,
			elevation  DOUBLE UNSIGNED,
			longitude DOUBLE UNSIGNED not null,
			latitude DOUBLE UNSIGNED not null,
			peak_name VARCHAR(250) not null,
			localized_names VARCHAR(200), 
			annotation_id int UNSIGNED,
			campaign_id int UNSIGNED not null,
			validation_status_id UNSIGNED not null,
			FOREIGN KEY (annotation_id) REFERENCES annotation(annotation_id),
			FOREIGN KEY (campaign_id) REFERENCES campaign(campaign_id)
)

create table subscribe (
			subscribe_id int UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			worker_id int unsigned not null,
			ts_date timestamp default current_timestamp,
			campaign_id int unsigned not null,
			FOREIGN KEY (worker_id) REFERENCES user_app(user_id),
			FOREIGN KEY (campaign_id) REFERENCES campaign(campaign_id)
)

