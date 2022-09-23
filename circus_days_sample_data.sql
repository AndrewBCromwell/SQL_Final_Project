/*
	Adding sample data circus_days_db
    Author:	Andy Cromwell
*/

USE circus_days_db;

INSERT INTO zip_code
	(zip_code, city, state)
VALUES
	('52403', 'Cedar Rapids', 'IA'),
    ('50317', 'Des Moins', 'IA'),
    ('44444', 'Someburg', 'IL'),
    ('36386', 'Sample Vill', 'OH'),
    ('83202', 'Pocatello', 'ID'),
    ('11111', 'Example Town', 'SD'),
    ('01702', 'Farmingham', 'MA')
;

INSERT INTO act
	(act_name, description)
VALUES
	('trapeze', 'People preforming gymnastics while swinging form objects suspended in the air.'),
    ('human cannon-ball', 'A person being shot out of a cannon.'),
    ('knife thrower', null),
    ('tight-rope walker', 'Someone walking from one platform to another on a samll rope many feet in the air.'),
    ('clowns', null),
    ('strong man', 'A man who lifts seamingly impossibly heavy things.')
;

INSERT INTO ad_type
	(ad_type)
VALUES
	('TV'),
    ('radio'),
    ('billboards'),
    ('posters'),
    ('pamphlets')
;

INSERT INTO ad_company
	(company_id, company_name, street_address, zip_code, phone_number)
VALUES
	(default, 'ads-R-us', '123 Sesamy St.', '36386', '(107) 133-1000'),
    (default, 'Get Attention', '2338 fake Ave.', '44444', '(211) 311-2989'),
    (default, 'CommCreative', '75 Fountain St.', '01702', '(877) 602-6664'),
    (default, 'Advert-EZ', '1960 Left Lane', '44444', '(211) 133-9892')
;

INSERT INTO ad_campain
	(campain_id, company_id, total_cost)
VALUES
	(default, 100000, 525.26),
    (default, 100001, 600.00),
    (default, 100003, 1025.69),
    (default, 100000, 223.00),
    (default, 100002, 903.33),
    (default, 100003, 500.20)
;

INSERT INTO ad_item
	(campain_id, ad_type, focus_act, cost)
VALUES
	(100000, 'radio', null, 400.00),
    (100000, 'pamphlets', null, 125.26),
    (100001, 'TV', null, 225.00),
    (100001, 'billboards', 'human cannon-ball', 375.00),
    (100002, 'posters', 'knife thrower', 125.69),
    (100002, 'TV', 'trapeze', 400.00),
    (100002, 'billboards', 'tight-rope walker', 500.00),
    (100003, 'TV', 'clowns', 223.00),
    (100004, 'radio', null, 400.00),
    (100004, 'posters', 'trapeze', 203.33),
    (100004, 'pamphlets', 'trapeze', 200.00),
    (100005, 'billboards', null, 500.20)
;

INSERT INTO venue
	(venue_id, venue_name, street_address, zip_code, phone_number, terms_of_use)
VALUES
	(default, 'Example Venue', '111 Example St.', '11111', '(111) 111-1111', 'Pay 11% of the revenue from shows.'),
    (default, 'Circus Space', '0691 Right Lane', '44444', '(400) 444-0691', 'Pay $400 per day'),
    (default, 'Ford Prefecture', '42 Hitch-hiker Dr.', '36386', '(042) 308-1978', 'Pay $42 up front, 4.2% of the revenue from shows, and by drinks for the venue staff.'),
    (default, 'Iowa State FairGrounds', '3000 E Grand Ave.', '50317', '(515) 262-3111', 'Pay $650 per day, any damages caused by visitors is our responsability'),
    (default, 'Bannock County Fairgrounds', '10588 Fairground Dr.', '83202', '(208) 221-3656.', 'Pay $1,500 per week.'),
    (default, 'Space For Rent', '543 Open Rd.', '01702', '(987) 654-3210', 'Pay $900 per day.')
;

INSERT INTO venue_use
	(use_id, venue_id, start_date, end_date, campain_id, total_tickets_sold, total_revenue)
VALUES
	(default, 100000, '2020-07-14', '2020-07-20', 100000, 231, 1039.50),
    (default, 100002, '2020-08-05', '2020-08-07', 100001, 125, 562.50),
    (default, 100001, '2020-08-14', '2020-08-16', 100001, 132, 594.00),
    (default, 100003, '2021-05-01', '2021-05-05', 100002, 145, 690.20),
    (default, 100000, '2021-05-12', '2021-05-15', 100002, 126, 598.50),
    (default, 100004, '2021-05-22', '2021-05-29', 100002, 222, 1056.72),
    (default, 100002, '2021-06-17', '2021-06-27', 100003, 191,  909.16),
    (default, 100003, '2021-07-12', '2021-08-12', 100004, 1027, 4888.52),
    (default, 100000, '2021-08-20', '2021-08-23', 100005, 156, 742.56),
    (default, 100004, '2022-05-19', '2022-06-02', null, default, default)
;

INSERT INTO use_day
	(use_id, use_date, tickets_sold, revenue)
VALUES
	(100000, '2020-07-14', 23, 103.50),
    (100000, '2020-07-15', 34, 153.00),
    (100000, '2020-07-16', default, default),
    (100000, '2020-07-17', 50, 225.00),
    (100000, '2020-07-18', default, default),
    (100000, '2020-07-19', 63, 283.50),
    (100000, '2020-07-20', 61, 274.50),
    (100001, '2020-08-06', 52, 312.00),
    (100002, '2020-08-14', 43, 258.00),
    (100003, '2021-05-01', 34, 204.00),
    (100004, '2021-05-13', 40, 234.38),
    (100005, '2021-05-24', 77, 400.50),
    (100006, '2021-06-23', 20, 101.03),
    (100007, '2021-08-01', 50, 222.22),
    (100008, '2021-08-20', 36, 156.50)
;
    
    





