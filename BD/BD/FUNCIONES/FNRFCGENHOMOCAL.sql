-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNRFCGENHOMOCAL
DELIMITER ;
DROP FUNCTION IF EXISTS `FNRFCGENHOMOCAL`;DELIMITER $$

CREATE FUNCTION `FNRFCGENHOMOCAL`(
/*SP PARA GENERAR LA HOMOCLAVE  DEL RFC*/
	Cli_NomVar_hom		VARCHAR(150),
	Cli_AppVar_hom		VARCHAR(50),
	Cli_ApmVar_hom		VARCHAR(50),
	RFCsHom			VARCHAR(10)
) RETURNS varchar(13) CHARSET latin1
    DETERMINISTIC
BEGIN
-- Declaracion de Variables
DECLARE Cli_RFC			VARCHAR(13);
DECLARE Var_NombreNum	VARCHAR(300);
DECLARE	Var_NomComple	VARCHAR(250);
DECLARE	Var_aux			VARCHAR(2);
DECLARE	Var_aux2		VARCHAR(2);
DECLARE	Var_hom			VARCHAR(3);
DECLARE	Var_hom2		VARCHAR(3);
DECLARE	Var_suma		INT;
DECLARE	Var_Val1		INT;
DECLARE	Var_val2		INT;
DECLARE	i				INT;
DECLARE valKey			VARCHAR(2);

SET	Var_NomComple	= CONCAT(RTRIM(Cli_AppVar_hom) ,' ', RTRIM(Cli_ApmVar_hom), ' ', RTRIM(Cli_NomVar_hom));
SET	Var_NombreNum	= '';
SET	Var_suma		= 0;
SET	Var_Val1		= 0;
SET	Var_NombreNum	:= '0';
SET	i 				:= 1;

WHILE( i <= LENGTH(Var_NomComple) ) DO
	SET valKey	 = (SELECT TABKEYVALUESRFC.ValorAsc
						FROM TABKEYVALUESRFC WHERE TABKEYVALUESRFC.KeyTab = SUBSTR(Var_NomComple, i, 1)
							AND Tipo = 1 LIMIT 1);
	SET valKey			:= IFNULL(valKey, '00');
	SET Var_NombreNum	:= CONCAT(RTRIM(Var_NombreNum), RTRIM(valKey));
	SET i				:= i + 1;
END WHILE;

SET	i			:= 1;
SET	Var_suma	:= 0;

WHILE( i < LENGTH(Var_NombreNum) ) DO
	SET Var_Val1	:= CONVERT(SUBSTR(Var_NombreNum, i,1), UNSIGNED INT );
	SET Var_val2	:= CONVERT(SUBSTR(Var_NombreNum, i+1,1), UNSIGNED INT);
	SET Var_suma	:= Var_suma + ( ( (Var_Val1*10) + Var_val2) * Var_val2 );
	SET i			:= i + 1;
END WHILE;

SET Var_Val1	:= Var_suma % 1000;
SET Var_val2	:= Var_Val1 % 34;
SET Var_Val1	:= (Var_Val1 - Var_val2) / 34;
SET Var_aux		:= CONVERT(Var_Val1, CHAR(2));
SET Var_hom		:= (SELECT ValorAsc FROM TABKEYVALUESRFC WHERE KeyTab = Var_aux AND Tipo = 2);
SET Var_hom		:= IFNULL(Var_hom, 'Z');
SET Var_aux		:= CONVERT(Var_val2,CHAR(2));
SET Var_hom2	:= (SELECT ValorAsc FROM TABKEYVALUESRFC WHERE KeyTab = Var_aux AND Tipo = 2);
SET Var_hom2	:= IFNULL(Var_hom2, 'Z');
SET Cli_RFC		:= CONCAT(RTRIM(RFCsHom),RTRIM(Var_hom),RTRIM(Var_hom2));
SET i			:= 1;
SET Var_suma	:= 0;
SET Var_Val1	:= 0 ;

WHILE( i <= LENGTH(Cli_RFC) ) DO
	SET Var_aux	:=  SUBSTR(Cli_RFC, i, 1);
	IF EXISTS(SELECT ValorAsc FROM TABKEYVALUESRFC WHERE KeyTab = Var_aux AND Tipo = 3)THEN
		SET Var_aux2	:= (SELECT ValorAsc FROM TABKEYVALUESRFC WHERE KeyTab = Var_aux AND Tipo = 3);
		SET Var_Val1	:=  CONVERT(Var_aux2,UNSIGNED INT);
		SET Var_suma	:= Var_suma + (Var_Val1 * (14-i) );
	END IF;
	SET i:=i+1;
END WHILE;

SET Var_Val1	:= Var_suma % 11;
IF(Var_Val1 = 0 ) THEN
	SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),'0');
ELSE
	IF( Var_Val1 = 10 ) THEN
		SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),'A');
	ELSE
		SET Var_Val1 := 11 - Var_Val1;
		IF( Var_Val1 = 10 ) THEN
			SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),'A');
		ELSE
			SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),RTRIM(CAST(Var_Val1 AS CHAR(2))));
		END IF;
	END IF;
END IF;

RETURN Cli_RFC;
END$$