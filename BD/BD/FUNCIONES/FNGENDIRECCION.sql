
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGENDIRECCION

DELIMITER ;
DROP FUNCTION IF EXISTS `FNGENDIRECCION`;

DELIMITER $$
CREATE FUNCTION `FNGENDIRECCION`(
	/* FUNCIÓN QUE ARMA LA DIRECCIÓN COMPLETA */
	Par_TipoDireccion		TINYINT,		-- TIPO DE DIRECCION
	Par_EstadoID			INT(11),		-- ESTADO
	Par_MunicipioID			INT(11),		-- MUNICIPIO
	Par_LocalidadID			INT(11),		-- LOCALIDAD
	Par_ColoniaID			INT(11),		-- COLINIA

	Par_Calle				VARCHAR(100),	-- CALLE
	Par_NumeroCasa			CHAR(10),		-- CASA NUMERO
	Par_NumInterior			CHAR(10),		-- NUM INTERIOR
	Par_Piso				CHAR(50),		-- PISO
	Par_PrimECalle			VARCHAR(50),	-- CALLE

	Par_SegECalle			VARCHAR(50),  	-- SEGUNDA CALLE
	Par_CP					CHAR(5),		-- CP
	Par_Descripcion			VARCHAR(500),	-- DESCRIPCION
	Par_Lote				CHAR(50),		-- LOTE
	Par_Manzana				CHAR(50)		-- MANZANA

) RETURNS varchar(200) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion Variables
	DECLARE Var_DireccionCompleta	VARCHAR(500);	-- DIRECCIÓN COMPLETA
	DECLARE Var_NombreEstado		VARCHAR(50);	-- NOMBRE DEL ESTADO
	DECLARE Var_NombreMunicipio		VARCHAR(50);	-- NOMBRE DEL MUNICIPIO
	DECLARE Var_NombreColonia		VARCHAR(200);	-- NOMBRE DE LA COLONIA
	DECLARE Var_CP					VARCHAR(20);	-- CÓDIGO POSTAL PARA PLD
	DECLARE Var_NumeroCasa			VARCHAR(20);	-- NÚMERO EXTERIOR.
	DECLARE Var_NumInterior			VARCHAR(20);	-- NÚMERO INTERIOR.
	DECLARE Var_MuestraTipoAsent	CHAR(1);		-- MUESTRA EL TIPO DE SENTAMIENTO EN LA COLONIA.

	-- Declaracion de Constantes
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE TipoAltaDirecc		INT;
	DECLARE TipoDirecCorta		INT;
	DECLARE TipoDirecPLD		INT;
	DECLARE TipoSoloColonia		INT;
	DECLARE Str_SI				CHAR(1);
	DECLARE Str_NO				CHAR(1);

	-- Asignacion de Constantes
	SET Estatus_Activo			:= 'A';				-- ESTATUS ACTIVO.
	SET Cadena_Vacia			:= '';				-- CADENA VACIA.
	SET Fecha_Vacia				:= '1900-01-01';	-- FECHA VACIA.
	SET Entero_Cero				:= 0;				-- ENTERO CERO.
	SET TipoAltaDirecc			:= 01;				-- FORMATO TIPO COMO SE ARMA LA DIRECCION COMPLETA EN DIRECCIONES DEL CLIENTE..
	SET TipoDirecCorta			:= 02;				-- FORMATO CORTO, SIN ESTADO, MUNICIPIO, LOCALIDAD NI COLONIA.
	SET TipoDirecPLD			:= 03;				-- FORMATO CORTO PARA REPORTES PLD.
	SET TipoSoloColonia			:= 04;				-- FORMATO CORTO CON EL NOMBRE DE LA COLONIA.
	SET Str_SI					:= 'S';				-- CONSTANTE SI.
	SET Str_NO					:= 'N';				-- CONSTANTE NO.

	SET Var_NombreEstado:= (SELECT Nombre
								FROM ESTADOSREPUB
								WHERE EstadoID = Par_EstadoID);

	SET Var_NombreMunicipio := (SELECT M.Nombre
								FROM ESTADOSREPUB E INNER JOIN  MUNICIPIOSREPUB M ON (E.EstadoID=M.EstadoID)
								WHERE E.EstadoID=Par_EstadoID AND M.MunicipioID=Par_MunicipioID);

	SET Var_NombreColonia := (SELECT TRIM(CONCAT(Col.Asentamiento))
								FROM ESTADOSREPUB E INNER JOIN MUNICIPIOSREPUB M ON (E.EstadoID=M.EstadoID)
								LEFT OUTER JOIN COLONIASREPUB Col ON (E.EstadoID=Col.EstadoID AND M.MunicipioID = Col.MunicipioID)
								WHERE E.EstadoID=Par_EstadoID AND M.MunicipioID=Par_MunicipioID
									AND Col.ColoniaID = Par_ColoniaID);


	SET Par_Calle			:= IFNULL(Par_Calle, Cadena_Vacia);
	SET Par_NumeroCasa		:= IFNULL(Par_NumeroCasa, Cadena_Vacia);
	SET Par_NumInterior		:= IFNULL(Par_NumInterior, Cadena_Vacia);
	SET Par_Piso			:= IFNULL(Par_Piso, Cadena_Vacia);
	SET Par_Lote			:= IFNULL(Par_Lote, Cadena_Vacia);
	SET Par_Manzana			:= IFNULL(Par_Manzana, Cadena_Vacia);
	SET Var_NombreEstado	:= IFNULL(Var_NombreEstado, Cadena_Vacia);
	SET Var_NombreMunicipio	:= IFNULL(Var_NombreMunicipio, Cadena_Vacia);
	SET Var_NombreColonia	:= IFNULL(Var_NombreColonia, Cadena_Vacia);

	IF(IFNULL(Par_TipoDireccion, Entero_Cero) IN(TipoAltaDirecc, TipoDirecCorta))THEN
		SET Var_DireccionCompleta := Par_Calle;

		IF(Par_NumeroCasa != Cadena_Vacia) THEN
			SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,", No. ",Par_NumeroCasa);
		END IF;

		IF(Par_NumInterior != Cadena_Vacia) THEN
			SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,", INTERIOR ",Par_NumInterior);
		END IF;

		IF(Par_Piso != Cadena_Vacia) THEN
			SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,", PISO ",Par_Piso);
		END IF;

		IF(Par_Lote != Cadena_Vacia) THEN
			SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,", LOTE ",Par_Lote);
		END IF;

		IF(Par_Manzana != Cadena_Vacia) THEN
			SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,", MANZANA ",Par_Manzana);
		END IF;

		IF(IFNULL(Par_TipoDireccion, Entero_Cero) = TipoAltaDirecc)THEN
			SET Var_DireccionCompleta := UPPER(CONCAT(Var_DireccionCompleta,", COL. ",Var_NombreColonia,", C.P ",Par_CP,", ",Var_NombreMunicipio,", ",Var_NombreEstado,"."));
		END IF;

		IF(IFNULL(Par_TipoDireccion, Entero_Cero) = TipoDirecCorta)THEN
			SET Var_DireccionCompleta := UPPER(CONCAT(Var_DireccionCompleta,"."));
		END IF;
	END IF;

	IF(IFNULL(Par_TipoDireccion, Entero_Cero) = TipoSoloColonia)THEN
		SET Var_MuestraTipoAsent := LEFT(FNPARAMGENERALES('PLDSITI_Colonia'),1);
		SET Var_MuestraTipoAsent := IF(TRIM(Var_MuestraTipoAsent) = Cadena_Vacia, Str_NO, Var_MuestraTipoAsent);

		SET Var_NombreColonia := (SELECT LEFT(TRIM(CONCAT(IF(Var_MuestraTipoAsent = Str_SI,Col.TipoAsenta,Cadena_Vacia),' ',Col.Asentamiento)),200)
									FROM ESTADOSREPUB E INNER JOIN MUNICIPIOSREPUB M ON (E.EstadoID=M.EstadoID)
										LEFT OUTER JOIN COLONIASREPUB Col ON (E.EstadoID=Col.EstadoID AND M.MunicipioID = Col.MunicipioID)
									WHERE E.EstadoID=Par_EstadoID AND M.MunicipioID=Par_MunicipioID
										AND Col.ColoniaID = Par_ColoniaID);
		SET Var_DireccionCompleta := LEFT(FNLIMPIACARACTERESGEN(Var_NombreColonia,'MA'),500);
		SET Var_DireccionCompleta := IF(CHAR_LENGTH(Var_DireccionCompleta)>Entero_Cero,Var_DireccionCompleta,'0');
	END IF;

	IF(IFNULL(Par_TipoDireccion, Entero_Cero) = TipoDirecPLD)THEN
		SET Par_Calle		:= LEFT(TRIM(IF(Par_Calle = Cadena_Vacia,'SIN CALLE',FNLIMPIACARACTERESGEN(Par_Calle,'MA'))),100);
		SET Var_NumeroCasa	:= LEFT(TRIM(IF(Par_NumeroCasa = Cadena_Vacia,Cadena_Vacia,CONCAT('NO. ',FNLIMPIACARACTERESGEN(Par_NumeroCasa,'MA')))),20);
		SET Var_NumInterior	:= LEFT(TRIM(IF((Par_NumInterior = Cadena_Vacia OR Par_NumInterior = 'NULL'),Cadena_Vacia,CONCAT('INTERIOR ',FNLIMPIACARACTERESGEN(Par_NumInterior,'MA')))),20);
		SET Var_CP			:= LEFT(TRIM(IF(Par_CP = Cadena_Vacia,Cadena_Vacia,CONCAT('C.P. ',FNLIMPIACARACTERESGEN(Par_CP,'MA')))),20);

		SET Var_DireccionCompleta := Cadena_Vacia;
		SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,IF(CHAR_LENGTH(Par_Calle)>Entero_Cero,CONCAT(' ',Par_Calle),Cadena_Vacia));
		SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,IF(CHAR_LENGTH(Var_NumeroCasa)>Entero_Cero,CONCAT(' ',Var_NumeroCasa),Cadena_Vacia));
		SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,IF(CHAR_LENGTH(Var_NumInterior)>Entero_Cero,CONCAT(' ',Var_NumInterior),Cadena_Vacia));
		SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,IF(CHAR_LENGTH(Var_CP)>Entero_Cero,CONCAT(' ',Var_CP),Cadena_Vacia));
		SET Var_DireccionCompleta := UPPER(IFNULL(Var_DireccionCompleta,Cadena_Vacia));

		SET Var_DireccionCompleta := TRIM(UPPER(CONCAT(Var_DireccionCompleta)));
	END IF;

RETURN LEFT(IFNULL(Var_DireccionCompleta, Cadena_Vacia),200);
END$$


