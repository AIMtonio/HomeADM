-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNDECIMALALETRA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNDECIMALALETRA`;DELIMITER $$

CREATE FUNCTION `FNDECIMALALETRA`(
	Par_cantidad DECIMAL(18,9),
	Par_Aux1 VARCHAR(200)

) RETURNS varchar(400) CHARSET latin1
    DETERMINISTIC
BEGIN

DECLARE resultado VARCHAR(400);
DECLARE resultadoFrac VARCHAR(400);
DECLARE digitosFraccion INT(12);
DECLARE fraccion INT(12);
DECLARE fraccionC INT(12);
DECLARE fraccionm INT(12);
DECLARE fraccionMi INT(12);
DECLARE centenas INT(12);
DECLARE miles INT(12);
DECLARE millones INT(12);
DECLARE Entero_Dos INT;
SET resultado	:= '';

SET millones 	:= FLOOR((Par_cantidad)/1000000);
SET miles 		:= FLOOR((Par_cantidad - millones*1000000)/1000);
SET centenas	:= FLOOR((Par_cantidad-millones*1000000-miles*1000));
SET Entero_Dos 	:= 2;

CASE millones
	WHEN 0	THEN SET resultado := CONCAT(resultado, '');
	WHEN 1	THEN SET resultado := 'Un Millon';
	ELSE
			SET resultado := CONCAT(resultado, CIENTOSATEXT(millones) , ' Millones');
END CASE;

CASE miles
	WHEN 0	THEN SET resultado := CONCAT(resultado, '');
	ELSE
			SET resultado := CONCAT(resultado, CIENTOSATEXT(miles) , ' Mil');
END CASE;


CASE
	WHEN centenas = 1	THEN SET resultado := CONCAT(resultado, 'Uno');
	WHEN centenas > 1	THEN SET resultado := CONCAT(resultado, CIENTOSATEXT(centenas));
	ELSE
		SET resultado := CONCAT(resultado, '');

END CASE;

IF(millones = 0 AND miles = 0 AND centenas = 1)THEN
	SET resultado := 'UNO';
END IF;

IF(millones = 0 AND miles = 0 AND centenas = 0)THEN
	SET resultado := 'CERO';
END IF;


SET resultadoFrac	:= '';

SET digitosFraccion := IFNULL(cast(Par_Aux1 AS unsigned), 0);

SET fraccion 	:= 0;
SET fraccionC 	:= 0;
SET fraccionm 	:= 0;
SET fraccionMi 	:= 0;
CASE digitosFraccion
	WHEN 1 THEN

		SET fraccion 	:= FLOOR((Par_cantidad - FLOOR(Par_cantidad))*10);
		CASE
			WHEN fraccion = 0 THEN
				SET resultadoFrac := 'CERO';
			WHEN fraccion = 1 THEN
				SET resultadoFrac := 'UNO';
			ELSE
				SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccion));
		END CASE;
	WHEN 2 THEN
		SET fraccion 	:= FLOOR((Par_cantidad - FLOOR(Par_cantidad))*100);
		CASE
			WHEN fraccion = 0 THEN
				SET resultadoFrac := 'CERO';
			WHEN fraccion = 1 THEN
				SET resultadoFrac := 'CERO UNO';
			WHEN fraccion < 10 THEN
				SET resultadoFrac := CONCAT('CERO', CIENTOSATEXT(fraccion));
			ELSE
				SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccion));
		END CASE;
	WHEN 3 THEN
		SET 	fraccion := FLOOR((Par_cantidad - FLOOR(Par_cantidad))*1000);
		CASE
			WHEN fraccion = 0 THEN
				SET resultadoFrac := 'CERO';
			WHEN fraccion = 1 THEN
				SET resultadoFrac := 'CERO CERO UNO';
			WHEN fraccion < 10 THEN
				SET resultadoFrac := CONCAT('CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100 THEN
				SET resultadoFrac := CONCAT('CERO', CIENTOSATEXT(fraccion));
			ELSE
				SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccion));
		END CASE;
	WHEN 4 THEN
		SET fraccion 	:= FLOOR((Par_cantidad - FLOOR(Par_cantidad))*10000);
		CASE
			WHEN fraccion = 0 THEN
				SET resultadoFrac := 'CERO';
			WHEN fraccion = 1 THEN
				SET resultadoFrac := 'CERO CERO CERO UNO';
			WHEN fraccion < 10 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100 THEN
				SET resultadoFrac := CONCAT('CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 1000 THEN
				SET resultadoFrac := CONCAT('CERO', CIENTOSATEXT(fraccion));
			ELSE
				SET fraccionm := FLOOR(fraccion / 1000);
				SET fraccionC := FLOOR(fraccion - fraccionm*1000);
				IF fraccionm > 0 THEN
					SET resultadoFrac := CONCAT( CIENTOSATEXT(fraccionm), ' mil');
				END IF;
				CASE
					WHEN fraccionC = 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, ' Uno');
					WHEN fraccionC > 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccionC));
					ELSE
						SET resultadoFrac := CONCAT(resultadoFrac, '');
				END CASE;
		END CASE;
	WHEN 5 THEN
		SET fraccion 	:= FLOOR((Par_cantidad - FLOOR(Par_cantidad))*100000);
		CASE
			WHEN fraccion = 0 THEN
				SET resultadoFrac := 'CERO';
			WHEN fraccion = 1 THEN
				SET resultadoFrac := 'CERO CERO CERO CERO UNO';
			WHEN fraccion < 10 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 1000 THEN
				SET resultadoFrac := CONCAT('CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 10000 THEN
				SET resultadoFrac := CONCAT('CERO', CIENTOSATEXT(fraccion));
			ELSE
				SET fraccionm := FLOOR(fraccion / 1000);
				SET fraccionC := FLOOR(fraccion - fraccionm*1000);
				IF fraccionm > 0 THEN
					SET resultadoFrac := CONCAT( CIENTOSATEXT(fraccionm), ' mil');
				END IF;
				CASE
					WHEN fraccionC = 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, ' Uno');
					WHEN fraccionC > 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccionC));
					ELSE
						SET resultadoFrac := CONCAT(resultadoFrac, '');
				END CASE;
		END CASE;
	WHEN 6 THEN
		SET fraccion 	:= FLOOR((Par_cantidad - FLOOR(Par_cantidad))*1000000);
		CASE
			WHEN fraccion = 0 THEN
				SET resultadoFrac := 'CERO';
			WHEN fraccion = 1 THEN
				SET resultadoFrac := 'CERO CERO CERO CERO CERO UNO';
			WHEN fraccion < 10 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 1000 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 10000 THEN
				SET resultadoFrac := CONCAT('CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100000 THEN
				SET resultadoFrac := CONCAT('CERO', CIENTOSATEXT(fraccion));
			ELSE
				SET fraccionm := FLOOR(fraccion / 1000);
				SET fraccionC := FLOOR(fraccion - fraccionm*1000);
				IF fraccionm > 0 THEN
					SET resultadoFrac := CONCAT( CIENTOSATEXT(fraccionm), ' mil');
				END IF;
				CASE
					WHEN fraccionC = 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, ' Uno');
					WHEN fraccionC > 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccionC));
					ELSE
						SET resultadoFrac := CONCAT(resultadoFrac, '');
				END CASE;
		END CASE;
	WHEN 7 THEN
		SET fraccion 	:= FLOOR((Par_cantidad - FLOOR(Par_cantidad))*10000000);
		CASE
			WHEN fraccion = 0 THEN
				SET resultadoFrac := 'CERO';
			WHEN fraccion = 1 THEN
				SET resultadoFrac := 'CERO CERO CERO CERO CERO CERO UNO';
			WHEN fraccion < 10 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 1000 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 10000 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100000 THEN
				SET resultadoFrac := CONCAT('CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 1000000 THEN
				SET resultadoFrac := CONCAT('CERO', CIENTOSATEXT(fraccion));
			ELSE
				SET fraccionMi 	:= FLOOR(fraccion / 1000000);
				SET fraccionm 	:= FLOOR(fraccion - fraccionMi * 1000000);
				SET fraccionC 	:= FLOOR(fraccion - fraccionMi * 1000000 - fraccionm*1000);
				IF fraccionMi = 1 THEN
					SET resultadoFrac := CONCAT( 'Un millon');
				ELSE
					SET resultadoFrac := CONCAT(CIENTOSATEXT(fraccionMi), ' millones');
				END IF;
				IF fraccionm > 0 THEN
					SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccionm), ' mil');
				END IF;
				CASE
					WHEN fraccionC = 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, ' Uno');
					WHEN fraccionC > 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccionC));
					ELSE
						SET resultadoFrac := CONCAT(resultadoFrac, '');
				END CASE;
		END CASE;
	WHEN 8 THEN
		SET fraccion 	:= FLOOR((Par_cantidad - FLOOR(Par_cantidad))*100000000);
		CASE
			WHEN fraccion = 0 THEN
				SET resultadoFrac := 'CERO';
			WHEN fraccion = 1 THEN
				SET resultadoFrac := 'CERO CERO CERO CERO CERO CERO CERO UNO';
			WHEN fraccion < 10 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 1000 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 10000 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100000 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 1000000 THEN
				SET resultadoFrac := CONCAT('CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 10000000 THEN
				SET resultadoFrac := CONCAT('CERO', CIENTOSATEXT(fraccion));
			ELSE
				SET fraccionMi 	:= FLOOR(fraccion / 1000000);
				SET fraccionm 	:= FLOOR(fraccion - fraccionMi * 1000000);
				SET fraccionC 	:= FLOOR(fraccion - fraccionMi * 1000000 - fraccionm*1000);
				IF fraccionMi = 1 THEN
					SET resultadoFrac := CONCAT( 'Un millon');
				ELSE
					SET resultadoFrac := CONCAT(CIENTOSATEXT(fraccionMi), ' millones');
				END IF;
				IF fraccionm > 0 THEN
					SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccionm), ' mil');
				END IF;
				CASE
					WHEN fraccionC = 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, ' Uno');
					WHEN fraccionC > 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccionC));
					ELSE
						SET resultadoFrac := CONCAT(resultadoFrac, '');
				END CASE;
		END CASE;
	WHEN 9 THEN
		SET fraccion 	:= FLOOR((Par_cantidad - FLOOR(Par_cantidad))*1000000000);
		CASE
			WHEN fraccion = 0 THEN
				SET resultadoFrac := 'CERO';
			WHEN fraccion = 1 THEN
				SET resultadoFrac := 'CERO CERO CERO CERO CERO CERO CERO CERO UNO';
			WHEN fraccion < 10 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 1000 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 10000 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100000 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 1000000 THEN
				SET resultadoFrac := CONCAT('CERO CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 10000000 THEN
				SET resultadoFrac := CONCAT('CERO CERO', CIENTOSATEXT(fraccion));
			WHEN fraccion < 100000000 THEN
				SET resultadoFrac := CONCAT('CERO', CIENTOSATEXT(fraccion));

			ELSE
				SET fraccionMi 	:= FLOOR(fraccion / 1000000);
				SET fraccionm 	:= FLOOR(fraccion - fraccionMi * 1000000);
				SET fraccionC 	:= FLOOR(fraccion - fraccionMi * 1000000 - fraccionm*1000);
				IF fraccionMi = 1 THEN
					SET resultadoFrac := CONCAT( 'Un millon');
				ELSE
					SET resultadoFrac := CONCAT(CIENTOSATEXT(fraccionMi), ' millones');
				END IF;
				IF fraccionm > 0 THEN
					SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccionm), ' mil');
				END IF;
				CASE
					WHEN fraccionC = 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, ' Uno');
					WHEN fraccionC > 1 THEN
						SET resultadoFrac := CONCAT(resultadoFrac, CIENTOSATEXT(fraccionC));
					ELSE
						SET resultadoFrac := CONCAT(resultadoFrac, '');
				END CASE;
		END CASE;
	ELSE
		SET fraccion 	:= 0;
		SET fraccionMi 	:= FLOOR((fraccion)/1000000);
		SET fraccionm 	:= FLOOR((fraccion - fraccionMi*1000000)/1000);
		SET fraccionC	:= FLOOR((fraccion-fraccionMi*1000000-fraccionm*1000));
		SET resultadoFrac := 'CERO';
END CASE;

SET resultadoFrac := trim(resultadoFrac);
SET resultado :=trim(resultado);

SET resultado := CONCAT( upper(resultado), ' ');
SET resultado := CONCAT( resultado, ' PUNTO ', upper(resultadoFrac));

RETURN resultado;
END$$