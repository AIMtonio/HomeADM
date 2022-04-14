-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNMASCARA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNMASCARA`;DELIMITER $$

CREATE FUNCTION `FNMASCARA`(
		unformatted_value varchar(50),
        format_string CHAR(50)
) RETURNS char(50) CHARSET latin1
    DETERMINISTIC
BEGIN

	DECLARE input_len TINYINT;
	DECLARE output_len TINYINT;
	DECLARE temp_char CHAR;


	SET input_len = LENGTH(unformatted_value);
	SET output_len = LENGTH(format_string);

	WHILE ( output_len > 0 ) DO

	SET temp_char = SUBSTR(format_string, output_len, 1);
	IF ( temp_char = '#' ) THEN
	IF ( input_len > 0 ) THEN
	SET format_string = INSERT(format_string, output_len, 1, SUBSTR(unformatted_value, input_len, 1));
	SET input_len = input_len - 1;
	ELSE
	SET format_string = INSERT(format_string, output_len, 1, '0');
	END IF;
	END IF;

	SET output_len = output_len - 1;
	END WHILE;

	RETURN format_string;
END$$