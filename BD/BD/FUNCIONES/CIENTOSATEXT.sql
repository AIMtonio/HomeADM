-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIENTOSATEXT
DELIMITER ;
DROP FUNCTION IF EXISTS `CIENTOSATEXT`;DELIMITER $$

CREATE FUNCTION `CIENTOSATEXT`(
Par_cantidad INT
) RETURNS varchar(200) CHARSET latin1
    DETERMINISTIC
BEGIN
DECLARE resultado VARCHAR(200);
DECLARE centenas INT;
DECLARE decenas INT;
DECLARE unidades INT;

SET centenas :=FLOOR(Par_cantidad/100);
SET decenas :=FLOOR((Par_cantidad-centenas*100)/10);
SET unidades :=FLOOR(Par_cantidad-centenas*100-decenas*10);

CASE unidades
	WHEN 0 THEN
		IF(decenas = 0 AND centenas = 0)THEN
			SET resultado := 'Cero';
		ELSE
			SET resultado := '';
		END IF;

	WHEN 1 THEN	SET resultado := ' Un';
	WHEN 2 THEN SET resultado := ' Dos';
	WHEN 3 THEN SET resultado := ' Tres';
	WHEN 4 THEN SET resultado := ' Cuatro';
	WHEN 5 THEN SET resultado := ' Cinco';
	WHEN 6 THEN SET resultado := ' Seis';
	WHEN 7 THEN SET resultado := ' Siete';
	WHEN 8 THEN SET resultado := ' Ocho';
	WHEN 9 THEN SET resultado := ' Nueve';
	ELSE
		SET resultado := ' ';
END CASE;


CASE decenas
	WHEN 1 THEN
		CASE unidades
			WHEN 0 THEN SET resultado := ' Diez';
			WHEN 1 THEN SET resultado := ' Once';
			WHEN 2 THEN SET resultado := ' Doce';
			WHEN 3 THEN SET resultado := ' Trece';
			WHEN 4 THEN SET resultado := ' Catorce';
			WHEN 5 THEN SET resultado := ' Quince';
			ELSE
				SET resultado := CONCAT(' Dieci',trim(LOWER(resultado)));
		END CASE;
	WHEN 2 THEN
		IF(unidades = 0)THEN
			SET resultado := ' Veinte';
		ELSE
			SET resultado := CONCAT(' Veinti',trim(LOWER(resultado)));
		END IF;
	WHEN 3 THEN
		IF(unidades = 0)THEN
			SET resultado := ' Treinta';
		ELSE
			SET resultado := CONCAT(' Treinta y',LOWER(resultado));
		END IF;
	WHEN 4 THEN
		IF(unidades = 0)THEN
			SET resultado := ' Cuarenta';
		ELSE
			SET resultado := CONCAT(' Cuarenta y',LOWER(resultado));
		END IF;
	WHEN 5 THEN
		IF(unidades = 0)THEN
			SET resultado := ' Cincuenta';
		ELSE
			SET resultado := CONCAT(' Cincuenta y',LOWER(resultado));
		END IF;
	WHEN 6 THEN
		IF(unidades = 0)THEN
			SET resultado := ' Sesenta';
		ELSE
			SET resultado := CONCAT(' Sesenta y',LOWER(resultado));
		END IF;
	WHEN 7 THEN
		IF(unidades = 0)THEN
			SET resultado := ' Setenta';
		ELSE
			SET resultado := CONCAT(' Setenta y',LOWER(resultado));
		END IF;
	WHEN 8 THEN
		IF(unidades = 0)THEN
			SET resultado := ' Ochenta';
		ELSE
			SET resultado := CONCAT(' Ochenta y',LOWER(resultado));
		END IF;
	WHEN 9 THEN
		IF(unidades = 0)THEN
			SET resultado := ' Noventa';
		ELSE
			SET resultado := CONCAT(' Noventa y',LOWER(resultado));
		END IF;
	ELSE
		SET resultado := CONCAT(' ',resultado);
END CASE;


CASE centenas
	WHEN 1 THEN
		IF(decenas > 0 || unidades > 0) THEN
			SET resultado := CONCAT(' Ciento',resultado);
		ELSE
			SET resultado := 'Cien';
		END IF;
	WHEN 2 THEN SET resultado := CONCAT(' Doscientos',resultado);
	WHEN 3 THEN SET resultado := CONCAT(' Trescientos',resultado);
	WHEN 4 THEN SET resultado := CONCAT(' Cuatrocientos',resultado);
	WHEN 5 THEN SET resultado := CONCAT(' Quinientos',resultado);
	WHEN 6 THEN SET resultado := CONCAT(' Seiscientos',resultado);
	WHEN 7 THEN SET resultado := CONCAT(' Setecientos',resultado);
	WHEN 8 THEN SET resultado := CONCAT(' Ochocientos',resultado);
	WHEN 9 THEN SET resultado := CONCAT(' Novecientos',resultado);
	ELSE
		SET resultado := CONCAT(' ',resultado);
END CASE;

RETURN resultado;
END$$