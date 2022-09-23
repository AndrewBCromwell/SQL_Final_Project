/*
	Circus_Days_db creation script
    Author:		Andy Cromwll
*/

DROP DATABASE IF EXISTS circus_days_db;
CREATE DATABASE circus_days_db;
USE circus_days_db;


DROP TABLE IF EXISTS 	zip_code;
CREATE TABLE			zip_code
	(zip_code		CHAR(5)		primary key,
    city			VARCHAR(50)	not null,
    state			CHAR(2)		not null
);

DROP TABLE IF EXISTS	act;
CREATE TABLE 			act
	(act_name		VARCHAR(50)	primary key,
    description		VARCHAR(100)	null
);

DROP TABLE IF EXISTS	ad_type;
CREATE TABLE 			ad_type
	(ad_type		VARCHAR(50)	primary	key
);

DROP TABLE IF EXISTS	ad_company;
CREATE TABLE			ad_company
	(company_id		INT 		primary key auto_increment,
    company_name	VARCHAR(50) not null,
    street_address	VARCHAR(150) not null,
    zip_code		CHAR(5)		not null,
    phone_number	VARCHAR(20) not null,
    CONSTRAINT fk_company_zip_code FOREIGN KEY (zip_code)
		REFERENCES zip_code (zip_code)
);
ALTER TABLE ad_company auto_increment = 100000;
CREATE INDEX idx_ad_company_name 
	ON ad_company (company_name);
    
DROP TABLE IF EXISTS	ad_campain;
CREATE TABLE			ad_campain
	(campain_id		INT 		primary key	auto_increment,
    company_id		INT 		not null,
    total_cost		DECIMAL(6, 2)	not null,
    CONSTRAINT	fk_ad_campain_company FOREIGN KEY (company_id)
		REFERENCES ad_company (company_id)
);
ALTER TABLE ad_campain auto_increment = 100000;

DROP TABLE IF EXISTS 	ad_item;
CREATE TABLE ad_item
	(campain_id		INT 		not null,
    ad_type			VARCHAR(50)	not null,
    focus_act		VARCHAR(50)	null,
    cost			DECIMAL(6, 2) not null,
    CONSTRAINT pk_ad_item PRIMARY KEY (campain_id, ad_type),
    CONSTRAINT fk_ad_item_campain_id FOREIGN KEY (campain_id)
		REFERENCES ad_campain (campain_id),
	CONSTRAINT fk_ad_item_type FOREIGN KEY (ad_type)
		REFERENCES ad_type (ad_type),
	CONSTRAINT fk_ad_item_focus_act FOREIGN KEY (focus_act)
		REFERENCES act (act_name)
);

DROP TABLE IF EXISTS venue;
CREATE TABLE venue
	(venue_id		INT			primary key auto_increment,
    venue_name		VARCHAR(50)	not null,
    street_address	VARCHAR(50)	not null,
    zip_code		CHAR(5)		not null,
    phone_number	VARCHAR(20)	not null,
    terms_of_use	VARCHAR(500) not null,
    CONSTRAINT fk_venue_zip_code FOREIGN KEY (zip_code)
		REFERENCES zip_code (zip_code)
);
ALTER TABLE venue auto_increment = 100000;
CREATE INDEX idx_venue_name 
	ON venue (venue_name);
    
DROP TABLE IF EXISTS venue_use;
CREATE TABLE venue_use
	(use_id			INT 		primary key	auto_increment,
    venue_id		INT 		not null,
    start_date		DATE 		not null,
    end_date		DATE 		not null,
    campain_id		INT 		  null,
    total_tickets_sold	INT 	  DEFAULT 0,
    total_revenue	DECIMAL(6, 2) DEFAULT 0,
    CONSTRAINT fk_venue_use_venue_id FOREIGN KEY (venue_id)
		REFERENCES venue (venue_id),
	CONSTRAINT	fk_venue_use_ad_campain_id FOREIGN KEY (campain_id)
		REFERENCES ad_campain (campain_id)
);
ALTER TABLE venue_use auto_increment = 100000;
CREATE INDEX idx_venue_use_start_date 
	ON venue_use (start_date);
CREATE INDEX idx_venue_use_revenue
	ON venue_use (total_revenue);
    
DROP TABLE IF EXISTS use_day;
CREATE TABLE use_day
	(use_id			INT 	not null,
    use_date		DATE 	not null,
    tickets_sold	INT 	DEFAULT 0,
    revenue			DECIMAL(6, 2) DEFAULT 0,
    CONSTRAINT pk_use_date PRIMARY KEY (use_id, use_date),
    CONSTRAINT fk_use_id FOREIGN KEY (use_id)
		REFERENCES venue_use (use_id)
);
    
    
	
	







    