/*
	circus_days_stored_procedures
    author: 	Andy Cromwell
*/

USE circus_days_db;

CREATE OR REPLACE VIEW venue_use_stats AS
	SELECT  use_id, venue_id, end_date, DATEDIFF(end_date, start_date) AS 'days',
			ROUND(total_tickets_sold / DATEDIFF(end_date, start_date), 0) AS 'average_tickets_sold',
            ROUND(total_revenue / DATEDIFF(end_date, start_date), 2) AS 'average_revenue'
	FROM venue_use
;

/* 
	The original plan was to use the total revenues from the venue uses,
    but then I realised that because certain uses were longer than others
    the results would be scewed, so I started using the average daily revenue 
    for the venue uses.
*/

DROP PROCEDURE IF EXISTS sp_venue_with_high_average_daily_revenue;
DELIMITER $$ 
CREATE PROCEDURE sp_venue_with_high_average_daily_revenue
(
	low_bound_revenue	decimal(6, 2)
)
COMMENT 'Shows only the venues where the average revenue recived daily from uses there
		is above the amount entered by the user.'
BEGIN
	SELECT venue.venue_id, venue.venue_name, venue.street_address, venue.zip_code,
			AVG(venue_use_stats.average_tickets_sold) AS 'average_tickets_sold',
            AVG(venue_use_stats.average_revenue) AS 'average_revenue'
	FROM venue JOIN venue_use_stats
		ON venue.venue_id = venue_use_stats.venue_id
	GROUP BY venue_id
	HAVING AVG(venue_use_stats.average_revenue) > low_bound_revenue
    ;
END$$
DELIMITER ;

-- ************************************************************************************

DROP PROCEDURE IF EXISTS sp_venue_not_used_recently;
DELIMITER $$
CREATE PROCEDURE sp_venue_not_used_recently
(
	date_of_interest 	date
)
COMMENT 'Shows a list of the venues that have not been used or scedualed to be used,
		since the date entered by the user, or are in the same zipcode as on that has.'
BEGIN
	SELECT venue.venue_id, venue.venue_name, venue.street_address,
		venue.zip_code, venue_use_stats.end_date AS 'last used on...'
	FROM venue LEFT JOIN venue_use_stats
		ON venue.venue_id = venue_use_stats.venue_id
	WHERE venue.zip_code NOT IN (SELECT venue.zip_code -- using zip_code insted of venue_id so that if 
								 FROM venue JOIN venue_use  -- 2 venues are in the same zip_code, neither will appear
									ON venue.venue_id = venue_use.venue_id -- because we visted that area recently.
                                 WHERE venue_use.end_date > date_of_interest)
		AND (venue_use_stats.end_date IN (SELECT MAX(end_date) FROM venue_use
										 GROUP BY venue_id)
			OR  venue_use_stats.end_date IS NULL)
	;    
END $$
DELIMITER ;

-- ***********************************************************************************

DROP PROCEDURE IF EXISTS sp_add_use_day_record;
DELIMITER $$
CREATE PROCEDURE sp_add_use_day_record
(
	new_use_id	int,
    new_use_date	date,
    new_tickets_sold	int,
    new_revenue	decimal(6, 2)
)
BEGIN

	IF new_tickets_sold IS NULL THEN
		SET new_tickets_sold = 0;
	END IF;
    
    IF new_revenue IS NULL THEN
		SET new_revenue = 0;
	END IF;

	IF new_use_id NOT IN (SELECT use_id FROM venue_use) THEN
		SELECT 'that is not a valid use_id';
	ELSEIF new_use_date NOT BETWEEN (SELECT start_date FROM venue_use WHERE use_id = new_use_id)
						AND (SELECT end_date FROM venue_use WHERE use_id = new_use_id)
		THEN SELECT 'that is not a valid use date for this venue use';
	ELSEIF new_tickets_sold < 0 OR new_revenue < 0 THEN
		SELECT 'Tickets_sold and revenue can not be negative';
	ELSE 
		INSERT INTO use_day
			(use_id, use_date, tickets_sold, revenue)
		VALUES
			(new_use_id, new_use_date, new_tickets_sold, new_revenue);
		SELECT 'the record was added';
	END IF;

END $$
DELIMITER ;

-- ***********************************************************************************

DROP TRIGGER IF EXISTS venue_use_after_use_day_insert; 
DELIMITER $$
/*
	This makes it so that when a record for a new day is added, the total
    tickets sold and total revenue for the associated venue use are increased 
    by the number of tickets sold and revenue earned on that day.
*/ 
CREATE TRIGGER venue_use_after_use_day_insert
	AFTER INSERT ON use_day
    FOR EACH ROW
BEGIN
	UPDATE venue_use
    SET total_tickets_sold = total_tickets_sold + new.tickets_sold,
        total_revenue = total_revenue + new.revenue
	WHERE use_id = new.use_id
    ;
END$$
DELIMITER ;

-- ***********************************************************************************

CREATE OR REPLACE VIEW ad_campain_stats AS
	SELECT ad_campain.campain_id, ad_campain.total_cost AS 'campain_total_cost',
		ROUND(AVG(venue_use_stats.average_tickets_sold)) AS 'average_tickets_sold', 
        ROUND(AVG(venue_use_stats.average_revenue), 2) AS 'average_revenue_per_day'
	FROM ad_campain
		JOIN venue_use
			ON ad_campain.campain_id = venue_use.campain_id
		JOIN venue_use_stats
			ON venue_use.use_id = venue_use_stats.use_id
	GROUP BY venue_use.campain_id
;

-- ***********************************************************************************

DROP PROCEDURE IF EXISTS sp_revenue_when_act_advertised_strongly;
DELIMITER $$
CREATE PROCEDURE sp_revenue_when_act_advertised_strongly
(
	act_of_intrest		varchar(50),
    cost_of_intrest		decimal(6, 2)
)
COMMENT 'Gives the average daily ticket sales and revenue for ad campains
		where more than the specified amount was spent on ads that focused 
        on the circus act entered by the user.'
BEGIN
	

	IF LOWER(act_of_intrest) NOT IN (SELECT LOWER(act_name) FROM act)
			THEN SELECT CONCAT(act_of_intrest, ' is not one of the acts in our show') AS 'Message';
	ELSEIF LOWER(act_of_intrest) NOT IN (SELECT LOWER(focus_act) FROM ad_item WHERE focus_act IS NOT NULL)
			THEN SELECT CONCAT('we have not used the ', act_of_intrest, ' as the focus of an ad') AS 'Message';
	ELSE
		SELECT ad_item.focus_act, ad_item.ad_type, ad_item.cost, ad_campain_stats.average_tickets_sold,
			ad_campain_stats.average_revenue_per_day, ad_campain_stats.campain_id
		FROM ad_item JOIN ad_campain_stats
			ON ad_item.campain_id = ad_campain_stats.campain_id
		WHERE LOWER(ad_item.focus_act) = LOWER(act_of_intrest)
			AND ad_item.cost > cost_of_intrest
		;
	END IF;
	
END$$
DELIMITER ;

-- ***********************************************************************************

DROP PROCEDURE IF EXISTS sp_add_a_venue ;
DELIMITER $$
CREATE PROCEDURE sp_add_a_venue
(
	new_venue_name	varchar(50),
    new_street_address	varchar(50),
    new_zip_code	char(5),
    new_phone_number	varchar(20),
    new_terms_of_use	varchar(500)
)
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
        
	START TRANSACTION;
    
    INSERT INTO venue
		(venue_id, venue_name, street_address, zip_code, phone_number, terms_of_use)
	VALUES
		(default, new_venue_name, new_street_address, new_zip_code, new_phone_number, new_terms_of_use)
	;
    
    IF sql_error = FALSE THEN
		COMMIT;
        SELECT 'the venue was added';
	ELSE 
		ROLLBACK;
        SELECT 'the venue was rolled back';
	END IF;

END$$
DELIMITER ;


