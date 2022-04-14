-- FNSPLIT_STRING
DELIMITER ;
DROP FUNCTION IF EXISTS `FNSPLIT_STRING`;
DELIMITER $$

CREATE FUNCTION `FNSPLIT_STRING`(
	STR LONGTEXT,
	DELIM VARCHAR(12) ,
	POS INT

) RETURNS LONGTEXT CHARSET utf8
DETERMINISTIC
BEGIN
	RETURN REPLACE(
		SUBSTRING(
			SUBSTRING_INDEX(STR , DELIM , POS) ,
			CHAR_LENGTH(
				SUBSTRING_INDEX(STR , DELIM , POS - 1)
			) + 1
		) ,
		DELIM ,
		''
	);
END$$