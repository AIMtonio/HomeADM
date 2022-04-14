-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAPARAMREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAPARAMREP`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAPARAMREP`(
	-- SP QUE SIRVE DE APOYO PARA LA GENERACION DE LOS REPORTES DE ESTADO DE CUENTA
	Par_SucursalIni		INT(11),		-- Sucursal de Inicio
    Par_SucursalFin    	INT(11),		-- Sucursal Fin
	Par_CliInicio		INT(11),		-- ClienteID de Inicio
	Par_CliFin			INT(11),		-- ClienteID Final
	Par_Prefijo			VARCHAR(50)		-- Prefijo del Usuario logueado
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_AnioMes     	INT;
	DECLARE Var_StrAnioMes  	VARCHAR(10);
	DECLARE Var_FechaInicio 	DATE;
	DECLARE Var_FechaFin    	DATE;
	DECLARE Tex_FechaInicio 	VARCHAR(50);

    DECLARE Tex_FechaFin    	VARCHAR(50);
	DECLARE Var_InstitucionID   INT;
	DECLARE Var_NumeroTelefono  VARCHAR(20);

	-- Declaracion de constantes
	DECLARE Entero_Cero     INT;
	DECLARE Cadena_Vacia	CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero     := 0;        -- Cadena vacia
	SET Cadena_Vacia    := '';		 -- Cadena vacia

 -- Se obtiene el nombre y numero de telefono de la institucion
	SELECT InstitucionID
	INTO Var_InstitucionID
	FROM PARAMETROSSIS;

	SET Var_InstitucionID := IFNULL(Var_InstitucionID, Entero_Cero);

	SELECT		TelefonoEmpresa
		INTO	Var_NumeroTelefono
		FROM	INSTITUCIONES
		WHERE	InstitucionID	= Var_InstitucionID;

	SET Var_NumeroTelefono := IFNULL(Var_NumeroTelefono, Cadena_Vacia);

	IF Var_NumeroTelefono = Cadena_Vacia THEN
		SELECT		TelefonoLocal
			INTO	Var_NumeroTelefono
			FROM	PARAMETROSSIS;

		SET Var_NumeroTelefono	:= IFNULL(Var_NumeroTelefono, Cadena_Vacia);
	END IF;

	SET lc_time_names= 'es_MX';

	  -- Se obtiene el año y mes para el estado de cuenta del cliente
	SELECT MAX(AnioMes) INTO Var_AnioMes
		FROM EDOCTADATOSCTE Edo;

	SET Var_AnioMes := IFNULL(Var_AnioMes, 0);

	IF (Var_AnioMes != 0) THEN
		SET Var_StrAnioMes = CONVERT(Var_AnioMes, CHAR);
	ELSE
		SET Var_StrAnioMes = '190001';
	END IF;
	-- Se obtiene la fecha inicial
	SET Var_FechaInicio := CONCAT(SUBSTRING(Var_StrAnioMes,1,4), '-',
                              SUBSTRING(Var_StrAnioMes,5,2), '-',
                              '01');
	 -- Se obtiene la fecha final
	SET Var_FechaFin    := LAST_DAY(Var_FechaInicio);

	SET Tex_FechaInicio := CONCAT(
							'1 de ',
							UPPER(SUBSTRING(DATE_FORMAT(Var_FechaInicio, '%M'),1,1)),
							SUBSTRING(DATE_FORMAT(Var_FechaInicio, '%M'),2,
									  CHARACTER_LENGTH(DATE_FORMAT(Var_FechaInicio, '%M'))-1),
							' del ', SUBSTRING(Var_StrAnioMes,1,4));

	SET Tex_FechaFin := CONCAT(
							DATE_FORMAT(Var_FechaFin, '%e'), ' de ',
							UPPER(SUBSTRING(DATE_FORMAT(Var_FechaFin, '%M'),1,1)),
							SUBSTRING(DATE_FORMAT(Var_FechaFin, '%M'),2,
									  CHARACTER_LENGTH(DATE_FORMAT(Var_FechaFin, '%M'))-1),
							' del ', SUBSTRING(Var_StrAnioMes,1,4));
	-- Se obtiene los datos de cliente para generar el reporte en PDF
	SELECT DISTINCT(ClienteID),
		   RutaReporte AS rptName,
		   CONCAT(RutaExpPDF, Par_Prefijo, '/', Var_StrAnioMes,'/', LPAD(CONVERT(SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(ClienteID,CHAR), 10, 0),
		   '-',Var_StrAnioMes, '.pdf') AS outputFile,
			 Var_FechaInicio AS FechaInicio,
		   Var_FechaFin AS FechaFin, Ins.Nombre, CONCAT(Ins.DirFiscal, ' ',Ins.RFC,', Teléfono: ',Var_NumeroTelefono) AS DirFiscal,
		   Par.RutaLogo, Edo.AnioMes
		FROM EDOCTADATOSCTE Edo,
			 EDOCTAPARAMS Par
		INNER JOIN INSTITUCIONES Ins ON Ins.InstitucionID =  Var_InstitucionID
		WHERE Edo.SucursalID >= Par_SucursalIni AND Edo.SucursalID <= Par_SucursalFin
			AND Edo.ClienteID	BETWEEN Par_CliInicio AND Par_CliFin
		ORDER BY Edo.ClienteID ASC;

END TerminaStore$$