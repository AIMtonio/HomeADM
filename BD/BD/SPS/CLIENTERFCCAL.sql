-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTERFCCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTERFCCAL`;DELIMITER $$

CREATE PROCEDURE `CLIENTERFCCAL`(
/*SP Para generar el RFC del cliente*/
	Cli_Nombre			 VARCHAR(150),
	Cli_ApePat			 VARCHAR(50),
	Cli_ApeMat			 VARCHAR(50),
	Cli_FecNac			 DATETIME
	)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_Control		VARCHAR(100);			-- Variable de control
DECLARE Var_Consecutivo	VARCHAR(70);			-- Variable consecutivo

-- Declaracion de constantes
DECLARE	appOriginal		VARCHAR(50);
DECLARE	Cli_NomHom		VARCHAR(70);
DECLARE	Cli_AppHom		VARCHAR(50);
DECLARE	Cli_ApmHom		VARCHAR(50);
DECLARE	Str_FecNac		VARCHAR(10);
DECLARE	Str_FecNac2		VARCHAR(10);
DECLARE	Str_FecNac3		VARCHAR(10);
DECLARE	Cli_HomCve		VARCHAR(3);
DECLARE	aux				VARCHAR(5);
DECLARE	pos				INT;
DECLARE	C_RFC			VARCHAR(13);
DECLARE	Cli_RFC			VARCHAR(13);
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	CadFormada		VARCHAR(70);
DECLARE	Salida_SI		CHAR(1);
DECLARE Entero_Cero		INT(11);

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia	:='';
SET C_RFC			:= '';
SET Cli_RFC			:= '';
SET CadFormada		:= '';
SET appOriginal		:= Cli_ApePat;
SET Entero_Cero		:= 0;



IF( (IFNULL(Cli_Nombre,' ') = ' ') OR (Cli_Nombre=Cadena_Vacia) ) THEN
	SELECT	'001' as NumErr,
			'El Nombre no Puede Estar Vacio.' AS RFC;
	LEAVE TerminaStore;
END IF;

IF( (	IFNULL(Cli_ApePat, ' ') = ' ') OR (Cli_ApePat=Cadena_Vacia) ) THEN
	SET Cli_ApePat := Cadena_Vacia;
END IF;

IF( (IFNULL(Cli_ApeMat,' ') = ' ') OR (Cli_ApeMat=Cadena_Vacia) )THEN
	SET Cli_ApeMat := Cadena_Vacia;
END IF;

IF( (Cli_ApeMat=Cadena_Vacia) AND (Cli_ApePat=Cadena_Vacia) ) THEN
	SELECT	'Ambos apellidos no Pueden Estar Vacios.' AS RFC;
	LEAVE TerminaStore;
END IF;

SET Str_FecNac	:= SUBSTR(Cli_FecNac,3,2);
SET Str_FecNac2	:= SUBSTR(Cli_FecNac,6,2);
SET Str_FecNac3	:= SUBSTR(Cli_FecNac,9,2);
SET Str_FecNac	:= CONCAT(Str_FecNac,Str_FecNac2,Str_FecNac3);

SET	Cli_Nombre := FNLIMPIACARACTERESPECIAL(Cli_Nombre,'3');
SET	Cli_ApePat := FNLIMPIACARACTERESPECIAL(Cli_ApePat,'3');
SET	Cli_ApeMat := FNLIMPIACARACTERESPECIAL(Cli_ApeMat,'3');
SET	Cli_NomHom := Cli_Nombre;
SET	Cli_AppHom := Cli_ApePat;
SET	Cli_ApmHom := Cli_ApeMat;

SET	Cli_NomHom := FNLIMPIACARACTERESPECIAL(Cli_NomHom,'1');
SET	Cli_AppHom := FNLIMPIACARACTERESPECIAL(Cli_AppHom,'1');
SET	Cli_ApmHom := FNLIMPIACARACTERESPECIAL(Cli_ApmHom,'1');

SET	Cli_Nombre := FNLIMPIACARACTERESPECIAL(Cli_NomHom,'2');
SET	Cli_ApePat := FNLIMPIACARACTERESPECIAL(Cli_ApePat,'2');
SET	Cli_ApeMat := FNLIMPIACARACTERESPECIAL(Cli_ApeMat,'2');

IF( (IFNULL(Cli_NomHom, ' ') = ' ') OR (Cli_NomHom=Cadena_Vacia) )THEN
	SET Cli_NomHom := Cadena_Vacia;
END IF;
IF( (IFNULL(Cli_AppHom, ' ') = ' ') OR (Cli_AppHom=Cadena_Vacia) )THEN
	SET Cli_AppHom := Cadena_Vacia;
END IF;
IF( (IFNULL(Cli_ApmHom, ' ') = ' ') OR (Cli_ApmHom=Cadena_Vacia) )THEN
	SET Cli_ApmHom := Cadena_Vacia;
END IF;
IF( (IFNULL(Cli_Nombre, ' ') = ' ') OR (Cli_Nombre=Cadena_Vacia) ) THEN
	SET Cli_Nombre := Cadena_Vacia;
END IF;
IF( (IFNULL(Cli_ApePat, ' ') = ' ') OR (Cli_ApePat=Cadena_Vacia) ) THEN
	SET Cli_ApePat := Cadena_Vacia;
END IF;
IF( (IFNULL(Cli_ApeMat, ' ') = ' ') OR (Cli_ApeMat=Cadena_Vacia) ) THEN
	SET Cli_ApeMat := Cadena_Vacia;
END IF;


IF( Cli_Nombre <> REPLACE(Cli_Nombre, ' ', 'X') ) THEN
	IF( SUBSTRING(Cli_Nombre, 1, 2) = 'J ' )THEN
		SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 3, LENGTH(Cli_Nombre) );
	END IF;
END IF;
IF( Cli_Nombre <> REPLACE(Cli_Nombre,' ', 'X') ) THEN
	IF( SUBSTRING(Cli_Nombre, 1, 3) = 'MA ' )THEN
		SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 4, LENGTH(Cli_Nombre) );
	END IF;
END IF;
IF( Cli_Nombre <> REPLACE(Cli_Nombre, ' ', 'X') ) THEN
	IF( SUBSTRING(Cli_Nombre, 1, 5) = 'JOSE ' )THEN
		SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 6, LENGTH(Cli_Nombre) );
	END IF;
END IF;
IF( Cli_Nombre <> REPLACE(Cli_Nombre,' ', 'X') ) THEN
	IF( SUBSTRING(Cli_Nombre, 1, 6) = 'MARIA ' )THEN
		SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 7, LENGTH(Cli_Nombre) );
	END IF;
END IF;

SET Cli_RFC := Cadena_Vacia;

IF( (Cli_ApeMat=Cadena_Vacia) OR (Cli_ApePat=Cadena_Vacia) ) THEN
	IF( Cli_ApePat =Cadena_Vacia)THEN
		SET Cli_ApePat := Cli_ApeMat;
	IF( LENGTH(Cli_ApePat) < 2 ) THEN
		SET Cli_RFC := CONCAT(SUBSTR(Cli_ApePat,1,1),SUBSTR(Cli_Nombre,1,2));

		IF( CHARINDEX( ' ', Cli_Nombre) > 0 ) THEN
			SET Cli_RFC := CONCAT(LTRIM(Cli_RFC),SUBSTR(Cli_Nombre, CHARINDEX( ' ', Cli_Nombre)+1, 1));
		ELSE
			SET Cli_RFC := CONCAT(LTRIM(Cli_RFC),'X');
		END IF;
	ELSE
		SET Cli_RFC := CONCAT(SUBSTR(Cli_ApePat,1,2),SUBSTR(Cli_Nombre,1,2));
	END IF;
    SET Cli_ApePat := Cadena_Vacia;
END IF;
END IF;


IF(Cli_ApePat!=Cadena_Vacia) THEN


IF( LENGTH(LTRIM(RTRIM(Cli_ApePat))) <= 2 ) THEN
	SET Cli_RFC= CONCAT(SUBSTR(Cli_ApePat,1,1),SUBSTR(Cli_ApeMat,1,1),SUBSTR(Cli_Nombre,1,2));

ELSE
	SET Cli_RFC := SUBSTR(Cli_ApePat,1,1);
	SET pos=2;
	WHILE pos <=LENGTH(Cli_ApePat) DO
		SET aux := SUBSTR(Cli_ApePat,pos,1);
		IF( (aux = 'A') OR (aux = 'E') OR (aux = 'I') OR (aux = 'O') OR (aux = 'U') ) THEN
			SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),SUBSTR(Cli_ApePat,pos,1));
			SET pos := LENGTH(RTRIM(Cli_ApePat));
		END IF;
		SET pos := pos + 1;
	END WHILE;
	SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),SUBSTR(Cli_ApeMat,1,1),SUBSTR(Cli_Nombre,1,1));
END IF;
END IF;

IF(Cli_ApeMat=Cadena_Vacia) THEN
IF( LENGTH(LTRIM(RTRIM(Cli_ApePat))) <= 2 ) THEN
	SET Cli_RFC= CONCAT(SUBSTR(Cli_ApePat,1,2),SUBSTR(Cli_ApeMat,1,1),SUBSTR(Cli_Nombre,1,2));

ELSE
	SET Cli_RFC := SUBSTR(Cli_ApePat,1,1);
	SET pos=2;
	WHILE pos <=LENGTH(Cli_ApePat) DO
		SET aux := SUBSTR(Cli_ApePat,pos,1);
		IF( (aux = 'A') OR (aux = 'E') OR (aux = 'I') OR (aux = 'O') OR (aux = 'U') ) THEN
			SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),SUBSTR(Cli_ApePat,pos,1));
			SET pos := LENGTH(RTRIM(Cli_ApePat));
		END IF;
		SET pos := pos + 1;
	END WHILE;
	SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),SUBSTR(Cli_ApeMat,1,1),SUBSTR(Cli_Nombre,1,2));
END IF;
END IF;

SET aux := RTRIM(Cli_RFC);
SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),RTRIM(Str_FecNac));

SET C_RFC = FNRFCGENHOMOCAL(Cli_NomHom,Cli_AppHom,Cli_ApmHom,Cli_RFC);


IF( aux = 'BUEI' OR aux = 'BUEY' OR aux = 'CACA' OR aux = 'CACO' OR
	aux = 'CAGA' OR aux = 'CAGO' OR aux = 'CAKA' OR aux = 'CAKO' OR
	aux = 'COGE' OR aux = 'COJA' OR aux = 'KOGE' OR aux = 'KOJO' OR
	aux = 'KAKA' OR aux = 'KULO' OR aux = 'MAME' OR aux = 'MAMO' OR
	aux = 'MEAR' OR aux = 'MEAS' OR aux = 'MEON' OR aux = 'MION' OR
	aux = 'COJE' OR aux = 'COJI' OR aux = 'COJO' OR aux = 'CULO' OR
	aux = 'FETO' OR aux = 'GUEY' OR aux = 'JOTO' OR aux = 'KACA' OR
	aux = 'KACO' OR aux = 'KAGA' OR aux = 'KAGO' OR aux = 'MOCO' OR
	aux = 'MULA' OR aux = 'PEDA' OR aux = 'PEDO' OR aux = 'PENE' OR
	aux = 'PUTA' OR aux = 'PUTO' OR aux = 'QULO' OR aux = 'RATA' OR
	aux = 'RUIN' ) THEN

	SET C_RFC := CONCAT(SUBSTR(C_RFC, 1, 3),'X',SUBSTR(C_RFC, 5, 9));
END IF;

SET C_RFC =(RTRIM(C_RFC));

SELECT	C_RFC AS RFC;

END TerminaStore$$