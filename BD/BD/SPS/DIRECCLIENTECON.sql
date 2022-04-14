-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECCLIENTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECCLIENTECON`;
DELIMITER $$

CREATE PROCEDURE `DIRECCLIENTECON`(
	# SP creada para consultar la direccion del cliente
	Par_ClienteID			INT,
	Par_DireccionID 		INT,
	Par_TipoDirecID 		INT,
	Par_NumCon				TINYINT UNSIGNED,
	Par_EmpresaID			INT,

	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
			)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_InstitNominaID   INT;

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Con_Principal		INT;
	DECLARE	Con_Foranea			INT;
	DECLARE	Con_Oficial 		INT;
	DECLARE	Var_Oficial			CHAR(1);
	DECLARE  Con_verOficial 	INT;
	DECLARE  Var_noOficial	 	CHAR(1);
	DECLARE  DirCompleta 		VARCHAR(500);
	DECLARE  DirID 				INT(11);
	DECLARE  Con_TieneDir 		INT;
	DECLARE  Con_BC 			INT;
	DECLARE  Con_Aval			INT;
	DECLARE  Con_DirecWS		INT;

	DECLARE Con_DirTrabajo   	INT;
	DECLARE Con_TarDebDireCli  	INT;
	DECLARE Con_Fiscal			INT;
	DECLARE Con_verFiscal		INT;
	DECLARE con_VerTimbrado		INT;
	DECLARE Con_TipoPersona		INT;
	DECLARE	Var_Fiscal			CHAR(1);
	DECLARE Var_noFiscal		CHAR(1);
	DECLARE Con_OficialFondeo	INT;
    DECLARE Con_DirecNumHabit	INT(11);

	-- asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero			:= 0;				-- Entero Cero
	SET	Con_Principal		:= 1;				-- Consulta Principal
	SET	Con_Foranea			:= 2;				-- Consulta Foranea
	SET	Con_Oficial			:= 3;				-- Consulta Oficial
	SET	Var_Oficial			:= 'S';				-- Si es Oficial
	SET Var_noOficial 		:= 'N';				-- No es Oficial
	SET	Var_Fiscal			:= 'S';				-- Si es Fiscal
	SET	Var_noFiscal		:= 'N';				-- No es Fiscal
	SET Con_verOficial		:= 4;				-- Consulta Direccion Oficial
	SET Con_TieneDir		:= 5;				-- Consulta Direccion
	SET Con_BC  			:= 6;				-- Consulta Buro de Credito
	SET	Con_Aval			:= 7;				-- Consulta Aval

	SET Con_DirTrabajo  	:= 8;      			-- Consulta direccion del trabajo
	SET Con_TarDebDireCli	:= 9;
	SET Con_verFiscal		:= 10;
	SET Con_Fiscal			:= 11;
	SET Con_VerTimbrado		:= 12;
	SET Con_TipoPersona		:= 13;
	SET Con_DirecWS		    := 14;
	SET Con_OficialFondeo	:= 15;
    SET Con_DirecNumHabit	:= 16;				-- Consulta que devuelve el numero de habitantes de la localidad de un cliente,

	-- Consulta La direccion oficial y el Codigo Postal del cliente
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	dir.ClienteID,			dir.DireccionID,		dir.TipoDireccionID, 	dir.EstadoID, 			dir.MunicipioID,
				dir.Calle, 				dir.NumeroCasa, 		dir.NumInterior,		dir.Piso,				dir.PrimeraEntreCalle,
				dir.SegundaEntreCalle,	dir.LocalidadID	 ,		loc.NombreLocalidad, 	dir.ColoniaID,			col.Asentamiento,
				dir.CP,					dir.DireccionCompleta,	dir.Descripcion,		dir.Latitud,			dir.Longitud,
				dir.Oficial,			dir.Fiscal,				dir.Lote,				dir.Manzana,			dir.PaisID,
				PS.Nombre AS NombrePais,dir.AniosRes
			FROM		DIRECCLIENTE dir
				INNER JOIN LOCALIDADREPUB loc	ON dir.LocalidadID= loc.LocalidadID 	AND loc.EstadoID=dir.EstadoID AND loc.MunicipioID =dir.MunicipioID
				INNER JOIN	COLONIASREPUB col	ON dir.ColoniaID = col.ColoniaID 		AND col.EstadoID=dir.EstadoID AND col.MunicipioID =dir.MunicipioID
				LEFT  JOIN PAISES PS			ON dir.PaisID = PS.PaisID
				WHERE	ClienteID =Par_ClienteID
				AND		DireccionID = Par_DireccionID;
	END IF;

	IF(Par_NumCon = Con_Foranea) THEN
		SELECT	`DireccionID`, DireccionCompleta
			FROM 		DIRECCLIENTE
				WHERE		ClienteID = Par_ClienteID
				AND		DireccionID = Par_DireccionID;
	END IF;

	IF(Par_NumCon = Con_Oficial) THEN
		SELECT	DIR.DireccionID, DIR.ClienteID, DIR.DireccionCompleta, DIR.TipoDireccionID,DIR.Oficial,
				Loc.EsMarginada
			FROM 	DIRECCLIENTE DIR
				INNER JOIN LOCALIDADREPUB Loc ON  Loc.LocalidadID= DIR.LocalidadID
						AND Loc.MunicipioID= DIR.MunicipioID
						AND Loc.EstadoID	= DIR.EstadoID
				WHERE	DIR.ClienteID = Par_ClienteID
				AND 	DIR.Oficial = Var_Oficial
				LIMIT 0,1;
	END IF;

	IF(Par_NumCon = Con_Fiscal) THEN
		SELECT Fiscal FROM DIRECCLIENTE WHERE ClienteID=Par_ClienteID AND Fiscal= Var_Fiscal;
	END IF;

	IF(Par_NumCon = Con_verOficial) THEN
		SELECT IFNULL(Oficial,Var_noOficial) , DireccionCompleta, DireccionID
			FROM DIRECCLIENTE
			WHERE  ClienteID = Par_ClienteID
			AND Oficial=Var_Oficial
		LIMIT 1;
	END IF;
	IF(Par_NumCon = Con_verFiscal) THEN
		SELECT IFNULL(Fiscal,Var_noFiscal) , DireccionCompleta, DireccionID
			FROM DIRECCLIENTE
			WHERE  ClienteID = Par_ClienteID
			AND Fiscal=Var_Fiscal ;
	END IF;


	IF(Par_NumCon = Con_TieneDir)THEN

		IF(EXISTS(SELECT DireccionID FROM DIRECCLIENTE
					WHERE TipoDireccionID = Par_TipoDirecID
					AND ClienteID = Par_ClienteID))THEN
			IF(NOT EXISTS(SELECT TipoDireccionID FROM DIRECCLIENTE
							WHERE TipoDireccionID = Par_TipoDirecID
							AND ClienteID = Par_ClienteID
							AND DireccionID= Par_DireccionID))THEN
				SELECT Var_Oficial;
				LEAVE TerminaStore;
			END IF;

			SELECT Var_noOficial;
			LEAVE TerminaStore;

		END IF;
		SELECT Var_noOficial;
	END IF;

	-- Ticket 2921 aortega
	IF(Par_NumCon = Con_BC) THEN
		SELECT  dir.ClienteID,    					  dir.DireccionID,                		dir.TipoDireccionID,    dir.EstadoID,           		dir.MunicipioID,
				TRIM(dir.Calle) AS Calle,   		  TRIM(dir.NumeroCasa) AS NumeroCasa,   CASE dir.NumInterior WHEN Cadena_Vacia THEN NULL ELSE dir.NumInterior END AS NumInterior ,        TRIM(dir.Piso) AS Piso,    TRIM(dir.PrimeraEntreCalle) AS PrimeraEntreCalle,
				dir.ColoniaID,          			  TRIM(dir.Colonia) AS Colonia,         dir.CP,                 TRIM(dir.DireccionCompleta) AS DireccionCompleta,  TRIM(dir.Descripcion) AS Descripcion,
				dir.Latitud,            			  dir.Longitud,                   		dir.Oficial,           	CASE  dir.Lote WHEN Cadena_Vacia THEN NULL ELSE dir.Lote END AS Lote  ,	  CASE  dir.Manzana WHEN Cadena_Vacia THEN NULL ELSE dir.Manzana END AS Manzana ,
				TRIM(est.EqBuroCred) AS EqBuroCred,   TRIM(mun.Nombre) AS MunicipioNombre,  dir.LocalidadID,      	TRIM(loc.NombreLocalidad) AS NombreLocalidad
			FROM        DIRECCLIENTE dir

				INNER JOIN ESTADOSREPUB     est ON dir.EstadoID     = est.EstadoID
				INNER JOIN MUNICIPIOSREPUB  mun ON dir.MunicipioID  = mun.MunicipioID AND dir.EstadoID  = mun.EstadoID
				INNER JOIN LOCALIDADREPUB loc   ON loc.MunicipioID = mun.MunicipioID AND loc.EstadoID = est.EstadoID AND loc.LocalidadID = dir.LocalidadID
				WHERE   ClienteID =Par_ClienteID
				AND     Oficial = Var_Oficial;
	END IF;


	IF(Par_NumCon = Con_Aval) THEN
		SELECT  dir.ClienteID,      dir.EstadoID,                   dir.MunicipioID,    dir.Calle,      dir.NumeroCasa,
				dir.NumInterior,        dir.ColoniaID,                      dir.Latitud,            dir.Longitud,       dir.Lote,
				dir.Manzana,            dir.CP,                 dir.LocalidadID
			FROM        DIRECCLIENTE dir
				INNER JOIN LOCALIDADREPUB loc ON dir.LocalidadID= loc.LocalidadID AND dir.MunicipioID=loc.MunicipioID AND dir.EstadoID=loc.EstadoID
				INNER JOIN  COLONIASREPUB col ON dir.ColoniaID = col.ColoniaID  AND dir.MunicipioID=col.MunicipioID AND dir.EstadoID=col.EstadoID
				WHERE   ClienteID = Par_ClienteID
				AND     Oficial = Var_Oficial;
	END IF;


	IF(Par_NumCon = Con_DirTrabajo) THEN
		SELECT  dir.ClienteID,          dir.DireccionID,        dir.TipoDireccionID,    dir.EstadoID,           dir.MunicipioID,
				dir.Calle,              dir.NumeroCasa,         dir.NumInterior,        dir.Piso,               dir.PrimeraEntreCalle,
				dir.SegundaEntreCalle,  dir.LocalidadID  ,      loc.NombreLocalidad,    dir.ColoniaID,          col.Asentamiento,
				dir.CP,                 dir.DireccionCompleta,  dir.Descripcion,        dir.Latitud,            dir.Longitud,
				dir.Oficial,            dir.Lote,               dir.Manzana

			FROM DIRECCLIENTE dir
				INNER JOIN LOCALIDADREPUB loc ON dir.LocalidadID= loc.LocalidadID AND dir.MunicipioID=loc.MunicipioID AND dir.EstadoID=loc.EstadoID
				INNER JOIN  COLONIASREPUB col ON dir.ColoniaID = col.ColoniaID AND dir.MunicipioID=col.MunicipioID AND dir.EstadoID=col.EstadoID
				WHERE   ClienteID =Par_ClienteID
				AND     TipoDireccionID = Par_TipoDirecID;

	END IF;


	IF(Par_NumCon = Con_TarDebDireCli) THEN
		SELECT  DIR.DireccionCompleta,DIR.CP
			FROM    DIRECCLIENTE DIR
				WHERE   DIR.ClienteID = Par_ClienteID
				AND     DIR.Oficial = Var_Oficial
				LIMIT 0,1;
	END IF;

    -- Consulta la direccion oficial de un cliente fondeador
	IF(Par_NumCon = Con_OficialFondeo) THEN
		SELECT	dir.EstadoID, 			dir.MunicipioID,   		dir.Calle, 				dir.NumeroCasa, 		dir.NumInterior,
				dir.Piso,				dir.PrimeraEntreCalle,	dir.SegundaEntreCalle,	dir.LocalidadID,		loc.NombreLocalidad,
				dir.ColoniaID,			col.Asentamiento,		dir.CP,					dir.DireccionCompleta
			FROM		DIRECCLIENTE dir
				INNER JOIN LOCALIDADREPUB loc ON dir.LocalidadID= loc.LocalidadID 	AND loc.EstadoID=dir.EstadoID AND loc.MunicipioID =dir.MunicipioID
				INNER JOIN	COLONIASREPUB col ON dir.ColoniaID = col.ColoniaID 		AND col.EstadoID=dir.EstadoID AND col.MunicipioID =dir.MunicipioID
					WHERE	ClienteID = Par_ClienteID
						AND 	dir.Oficial = Var_Oficial
				LIMIT 0,1;
	END IF;

    -- Consulta La direccion oficial y el Codigo Postal del cliente
	IF(Par_NumCon = Con_DirecNumHabit) THEN
		SELECT	dir.ClienteID,			loc.NumHabitantes
			FROM		DIRECCLIENTE dir
				INNER JOIN LOCALIDADREPUB loc ON dir.LocalidadID= loc.LocalidadID 	AND loc.EstadoID=dir.EstadoID AND loc.MunicipioID =dir.MunicipioID
				WHERE	ClienteID = Par_ClienteID
                AND     Oficial = Var_Oficial;
	END IF;

END TerminaStore$$