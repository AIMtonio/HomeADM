-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCALRFCMENOR
DELIMITER ;
DROP FUNCTION IF EXISTS `FNCALRFCMENOR`;

DELIMITER $$
CREATE FUNCTION `FNCALRFCMENOR`(
	-- funcion generica que calcular el RFC de un socio menor
	-- Modulo Regulatorios

	Par_CliNombre			VARCHAR(350),	-- Nombre del menor
	Par_CliApePat			VARCHAR(200),	-- Apellido Paterno
	Par_CliApeMat			VARCHAR(200),	-- Apellido Materno
	Par_CliFecNac			DATE,			-- Fecha de Nacimiento
	Par_TipoResultado		CHAR(2)			-- OR.- Mantiene texto original
											-- MA.- El resultado lo pasa en Mayusculas
											-- MI.- El resultado lo pasa en Minusculas
) RETURNS varchar(13) CHARSET latin1
    DETERMINISTIC
BEGIN


	-- Declaracion de variables
	DECLARE Var_RFC				VARCHAR(13);		-- Valor de RFC

	-- Declaracion de constantes
	DECLARE	Con_appOriginal		VARCHAR(200);		-- Apellido Paterno Original
	DECLARE	Con_CliNomHom		VARCHAR(350);		-- Cliente Nombre
	DECLARE	Con_CliAppHom		VARCHAR(200);		-- Cliente Apellido Paterno
	DECLARE	Con_CliApmHom		VARCHAR(200);		-- Cliente Apellido Materno
	DECLARE	Con_StrFecNac		VARCHAR(10);		-- Fecha de Naciemento String
	DECLARE	Con_StrFecNac2		VARCHAR(10);		-- Fecha de Naciemento String 2
	DECLARE	Con_StrFecNac3		VARCHAR(10);		-- Fecha de Naciemento String 3
	DECLARE	Con_Aux				VARCHAR(5);			-- Auxiliar
	DECLARE	Con_Pos				INT(11);			-- Posicion
	DECLARE	Con_RFC				VARCHAR(13);		-- RFC
	DECLARE	Con_CliRFC			VARCHAR(13);		-- RFC Cliente
	DECLARE	Con_CadenaVacia		CHAR(1);			-- Cadena Vacia
	DECLARE	Con_Fecha_Vacia		DATE;				-- Fecha Vacia
	DECLARE	Con_CadFormada		VARCHAR(70);		-- Cadena Formada
	DECLARE	Con_SalidaSI		CHAR(1);			-- Salida SI
	DECLARE Con_EnteroCero		INT(11);			-- Entero Cero
	DECLARE Con_SinHomoclave	VARCHAR(3);			-- Sin homo Clave
	DECLARE Con_Espacio			CHAR(1);			-- Constante espacio
	DECLARE Con_EnteroUno		INT(11);			-- Constante Uno
	DECLARE Con_EnteroDos		INT(11);			-- Constante Dos
	DECLARE Con_EnteroTres		INT(11);			-- Constante Tres
	DECLARE Con_EnteroCuatro	INT(11);			-- Constante Cuatro
	DECLARE Con_EnteroCinco		INT(11);			-- Constante Cinco
	DECLARE Con_EnteroSeis		INT(11);			-- Constante Seis
	DECLARE Con_EnteroSiete		INT(11);			-- Constante Siete
	DECLARE Con_EnteroNueve		INT(11);			-- Constante Nueve
	DECLARE Con_ValorX			CHAR(1);			-- Constante X
	DECLARE Con_ValorJ			CHAR(2);			-- Constante J
	DECLARE Con_ValorMA			CHAR(3);			-- Constante Maria
	DECLARE Con_Jose			VARCHAR(5);			-- Constante jose
	DECLARE Con_Maria			VARCHAR(6);			-- Constante Maria
	DECLARE Con_VocalA			CHAR(1);			-- Constante A
	DECLARE Con_VocalE			CHAR(1);			-- Constante E
	DECLARE Con_VocalI			CHAR(1);			-- Constante I
	DECLARE Con_VocalO			CHAR(1);			-- Constante O
	DECLARE	Con_VocalU			CHAR(1);			-- Constante U
	DECLARE TextoOriginal		CHAR(2);		-- Texto original
	DECLARE TextoMayusculas		CHAR(2);		-- Texto en Mayusculas
	DECLARE TextoMinusculas		CHAR(2);		-- Texto en Minusculas

	-- Asignacion de constantes
	SET Con_CadenaVacia			:= '';
	SET Con_RFC					:= '';
	SET Con_CliRFC				:= '';
	SET Con_CadFormada			:= '';
	SET Con_appOriginal			:= Par_CliApePat;
	SET Con_EnteroCero			:= 0;
	SET Con_SinHomoclave		:= '333';
	SET Con_Espacio				:= ' ';
	SET Con_ValorX				:= 'X';
	SET Con_ValorJ				:= 'J ';
	SET Con_ValorMA				:= 'MA ';
	SET Con_Jose				:= 'JOSE ';
	SET Con_Maria				:= 'MARIA ';
	SET Con_EnteroUno			:= 1;
	SET Con_EnteroDos			:= 2;
	SET Con_EnteroTres			:= 3;
	SET Con_EnteroCuatro		:= 4;
	SET Con_EnteroCinco			:= 5;
	SET Con_EnteroSeis			:= 6;
	SET Con_EnteroSiete			:= 7;
	SET Con_EnteroNueve			:= 9;
	SET Con_VocalA				:= 'A';
	SET Con_VocalE				:= 'E';
	SET Con_VocalI				:= 'I';
	SET Con_VocalO				:= 'O';
	SET Con_VocalU				:= 'U';
	SET TextoOriginal			:= 'OR';
	SET TextoMayusculas			:= 'MA';
	SET TextoMinusculas			:= 'MI';
	SET Con_Fecha_Vacia			:= '1900-01-01';

	-- Se setean los parametros por si alguno esta vacio.
	SET Par_CliNombre := IFNULL(Par_CliNombre,Con_CadenaVacia);
	SET Par_CliApePat := IFNULL(Par_CliApePat, Con_CadenaVacia);
	SET Par_CliApeMat := IFNULL(Par_CliApeMat, Con_CadenaVacia);
	SET Par_CliFecNac := IFNULL(Par_CliFecNac, Con_Fecha_Vacia);
	SET Par_TipoResultado := IFNULL(Par_TipoResultado, TextoOriginal);

	IF( Par_CliNombre = Con_Espacio OR Par_CliNombre=Con_CadenaVacia ) THEN
		SET Par_CliNombre := Con_CadenaVacia;
	END IF;

	IF( Par_CliApePat = Con_Espacio OR Par_CliApePat = Con_CadenaVacia ) THEN
		SET Par_CliApePat := Con_CadenaVacia;
	END IF;

	IF( Par_CliApeMat = Con_Espacio OR Par_CliApeMat = Con_CadenaVacia )THEN
		SET Par_CliApeMat := Con_CadenaVacia;
	END IF;

	IF( Par_CliApeMat = Con_CadenaVacia AND Par_CliApePat = Con_CadenaVacia ) THEN
		SET Par_CliApePat := Con_CadenaVacia;
		SET Par_CliApeMat := Con_CadenaVacia;
	END IF;

	-- Limpieza de Datos.
	SET Con_StrFecNac	:= SUBSTR(Par_CliFecNac,Con_EnteroTres,Con_EnteroDos);
	SET Con_StrFecNac2	:= SUBSTR(Par_CliFecNac,Con_EnteroSeis,Con_EnteroDos);
	SET Con_StrFecNac3	:= SUBSTR(Par_CliFecNac,Con_EnteroNueve,Con_EnteroDos);
	SET Con_StrFecNac	:= CONCAT(Con_StrFecNac,Con_StrFecNac2,Con_StrFecNac3);

	SET	Par_CliNombre := FNLIMPIACARACTERESPECIAL(Par_CliNombre,Con_EnteroTres);
	SET	Par_CliApePat := FNLIMPIACARACTERESPECIAL(Par_CliApePat,Con_EnteroTres);
	SET	Par_CliApeMat := FNLIMPIACARACTERESPECIAL(Par_CliApeMat,Con_EnteroTres);
	SET	Con_CliNomHom := Par_CliNombre;
	SET	Con_CliAppHom := Par_CliApePat;
	SET	Con_CliApmHom := Par_CliApeMat;

	SET	Con_CliNomHom := FNLIMPIACARACTERESPECIAL(Con_CliNomHom,Con_EnteroUno);
	SET	Con_CliAppHom := FNLIMPIACARACTERESPECIAL(Con_CliAppHom,Con_EnteroUno);
	SET	Con_CliApmHom := FNLIMPIACARACTERESPECIAL(Con_CliApmHom,Con_EnteroUno);

	SET	Par_CliNombre := FNLIMPIACARACTERESPECIAL(Con_CliNomHom,Con_EnteroDos);
	SET	Par_CliApePat := FNLIMPIACARACTERESPECIAL(Par_CliApePat,Con_EnteroDos);
	SET	Par_CliApeMat := FNLIMPIACARACTERESPECIAL(Par_CliApeMat,Con_EnteroDos);

	IF( (IFNULL(Con_CliNomHom,Con_Espacio) = Con_Espacio) OR (Con_CliNomHom=Con_CadenaVacia) )THEN
		SET Con_CliNomHom := Con_CadenaVacia;
	END IF;
	IF( (IFNULL(Con_CliAppHom, Con_Espacio) = Con_Espacio) OR (Con_CliAppHom=Con_CadenaVacia) )THEN
		SET Con_CliAppHom := Con_CadenaVacia;
	END IF;
	IF( (IFNULL(Con_CliApmHom, Con_Espacio) = Con_Espacio) OR (Con_CliApmHom=Con_CadenaVacia) )THEN
		SET Con_CliApmHom := Con_CadenaVacia;
	END IF;
	IF( (IFNULL(Par_CliNombre, Con_Espacio) = Con_Espacio) OR (Par_CliNombre=Con_CadenaVacia) ) THEN
		SET Par_CliNombre := Con_CadenaVacia;
	END IF;
	IF( (IFNULL(Par_CliApePat, Con_Espacio) = Con_Espacio) OR (Par_CliApePat=Con_CadenaVacia) ) THEN
		SET Par_CliApePat := Con_CadenaVacia;
	END IF;
	IF( (IFNULL(Par_CliApeMat, Con_Espacio) = Con_Espacio) OR (Par_CliApeMat=Con_CadenaVacia) ) THEN
		SET Par_CliApeMat := Con_CadenaVacia;
	END IF;


	IF( Par_CliNombre <> REPLACE(Par_CliNombre, Con_Espacio, Con_ValorX) ) THEN
		IF( SUBSTRING(Par_CliNombre, Con_EnteroUno, Con_EnteroDos) = Con_ValorJ )THEN
			SET	Par_CliNombre := SUBSTRING(Par_CliNombre, Con_EnteroTres, LENGTH(Par_CliNombre) );
		END IF;
	END IF;
	IF( Par_CliNombre <> REPLACE(Par_CliNombre,Con_Espacio, Con_ValorX) ) THEN
		IF( SUBSTRING(Par_CliNombre, Con_EnteroUno, Con_EnteroTres) = Con_ValorMA)THEN
			SET	Par_CliNombre := SUBSTRING(Par_CliNombre, Con_EnteroCuatro, LENGTH(Par_CliNombre) );
		END IF;
	END IF;
	IF( Par_CliNombre <> REPLACE(Par_CliNombre, Con_Espacio, Con_ValorX) ) THEN
		IF( SUBSTRING(Par_CliNombre, Con_EnteroUno, Con_EnteroCinco) = Con_Jose )THEN
			SET	Par_CliNombre := SUBSTRING(Par_CliNombre, Con_EnteroSeis, LENGTH(Par_CliNombre) );
		END IF;
	END IF;
	IF( Par_CliNombre <> REPLACE(Par_CliNombre,Con_Espacio, Con_ValorX) ) THEN
		IF( SUBSTRING(Par_CliNombre, Con_EnteroUno, Con_EnteroSeis) = Con_Maria )THEN
			SET	Par_CliNombre := SUBSTRING(Par_CliNombre, Con_EnteroSiete, LENGTH(Par_CliNombre) );
		END IF;
	END IF;

	SET Con_CliRFC := Con_CadenaVacia;

	IF( (Par_CliApeMat=Con_CadenaVacia) OR (Par_CliApePat=Con_CadenaVacia) ) THEN
		IF( Par_CliApePat =Con_CadenaVacia)THEN
			SET Par_CliApePat := Par_CliApeMat;
		IF( LENGTH(Par_CliApePat) < Con_EnteroDos ) THEN
			SET Con_CliRFC := CONCAT(SUBSTR(Par_CliApePat,Con_EnteroUno,Con_EnteroUno),SUBSTR(Par_CliNombre,Con_EnteroUno,Con_EnteroDos));

			IF( CHARINDEX( Con_Espacio, Par_CliNombre) > Con_EnteroCero ) THEN
				SET Con_CliRFC := CONCAT(LTRIM(Con_CliRFC),SUBSTR(Par_CliNombre, CHARINDEX( Con_Espacio, Par_CliNombre)+Con_EnteroUno, Con_EnteroUno));
			ELSE
				SET Con_CliRFC := CONCAT(LTRIM(Con_CliRFC),Con_ValorX);
			END IF;
		ELSE
			SET Con_CliRFC := CONCAT(SUBSTR(Par_CliApePat,Con_EnteroUno,Con_EnteroDos),SUBSTR(Par_CliNombre,Con_EnteroUno,Con_EnteroDos));
		END IF;
	    SET Par_CliApePat := Con_CadenaVacia;
	END IF;
	END IF;


	IF(Par_CliApePat!=Con_CadenaVacia) THEN


	IF( LENGTH(LTRIM(RTRIM(Par_CliApePat))) <= Con_EnteroDos ) THEN
		SET Con_CliRFC= CONCAT(SUBSTR(Par_CliApePat,Con_EnteroUno,Con_EnteroUno),SUBSTR(Par_CliApeMat,Con_EnteroUno,Con_EnteroUno),SUBSTR(Par_CliNombre,Con_EnteroUno,Con_EnteroDos));

	ELSE
		SET Con_CliRFC := SUBSTR(Par_CliApePat,Con_EnteroUno,Con_EnteroUno);
		SET Con_Pos=Con_EnteroDos;
		WHILE Con_Pos <=LENGTH(Par_CliApePat) DO
			SET Con_Aux := SUBSTR(Par_CliApePat,Con_Pos,Con_EnteroUno);
			IF( (Con_Aux = Con_VocalA) OR (Con_Aux = Con_VocalE) OR (Con_Aux = Con_VocalI) OR (Con_Aux = Con_VocalO) OR (Con_Aux = Con_VocalU) ) THEN
				SET Con_CliRFC := CONCAT(RTRIM(Con_CliRFC),SUBSTR(Par_CliApePat,Con_Pos,Con_EnteroUno));
				SET Con_Pos := LENGTH(RTRIM(Par_CliApePat));
			END IF;
			SET Con_Pos := Con_Pos + Con_EnteroUno;
		END WHILE;
		SET Con_CliRFC := CONCAT(RTRIM(Con_CliRFC),SUBSTR(Par_CliApeMat,Con_EnteroUno,Con_EnteroUno),SUBSTR(Par_CliNombre,Con_EnteroUno,Con_EnteroUno));
	END IF;
	END IF;

	IF(Par_CliApeMat=Con_CadenaVacia) THEN
	IF( LENGTH(LTRIM(RTRIM(Par_CliApePat))) <= Con_EnteroDos ) THEN
		SET Con_CliRFC= CONCAT(SUBSTR(Par_CliApePat,Con_EnteroUno,Con_EnteroDos),SUBSTR(Par_CliApeMat,Con_EnteroUno,Con_EnteroUno),SUBSTR(Par_CliNombre,Con_EnteroUno,Con_EnteroDos));

	ELSE
		SET Con_CliRFC := SUBSTR(Par_CliApePat,Con_EnteroUno,Con_EnteroUno);
		SET Con_Pos=Con_EnteroDos;
		WHILE Con_Pos <=LENGTH(Par_CliApePat) DO
			SET Con_Aux := SUBSTR(Par_CliApePat,Con_Pos,Con_EnteroUno);
			IF( (Con_Aux = Con_VocalA) OR (Con_Aux = Con_VocalE) OR (Con_Aux = Con_VocalI) OR (Con_Aux = Con_VocalO) OR (Con_Aux = Con_VocalU) ) THEN
				SET Con_CliRFC := CONCAT(RTRIM(Con_CliRFC),SUBSTR(Par_CliApePat,Con_Pos,Con_EnteroUno));
				SET Con_Pos := LENGTH(RTRIM(Par_CliApePat));
			END IF;
			SET Con_Pos := Con_Pos + Con_EnteroUno;
		END WHILE;
		SET Con_CliRFC := CONCAT(RTRIM(Con_CliRFC),SUBSTR(Par_CliApeMat,Con_EnteroUno,Con_EnteroUno),SUBSTR(Par_CliNombre,Con_EnteroUno,Con_EnteroDos));
	END IF;
	END IF;

	SET Con_Aux := RTRIM(Con_CliRFC);
	SET Con_CliRFC := CONCAT(RTRIM(Con_CliRFC),RTRIM(Con_StrFecNac),Con_SinHomoclave);

	SET Var_RFC =(RTRIM(Con_CliRFC));

	-- Da formato al texto a Mayusculas
	IF( Par_TipoResultado = TextoMayusculas ) THEN
		SET Var_RFC := TRIM(UPPER(Var_RFC));
	END IF;

	-- Da formato al texto a Minusculas
	IF( Par_TipoResultado = TextoMinusculas ) THEN
		SET Var_RFC := TRIM(LOWER(Var_RFC));
	END IF;

	-- Da formato al texto Normal
	IF( Par_TipoResultado = TextoOriginal ) THEN
		SET Var_RFC := TRIM(Var_RFC);
	END IF;


	RETURN Var_RFC;

END$$