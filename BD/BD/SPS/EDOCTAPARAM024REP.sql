DELIMITER ;

DROP PROCEDURE IF EXISTS `EDOCTAPARAM024REP`;

DELIMITER $$

CREATE PROCEDURE `EDOCTAPARAM024REP`(
	-- SP QUE SIRVE DE APOYO PARA LA GENERACION DE LOS REPORTES DE ESTADO DE CUENTA DEL CLIENTE CREDICLUB
	Par_SucursalIni		INT(11),		-- Sucursal de Inicio
	Par_SucursalFin		INT(11),		-- Sucursal Fin
	Par_CliInicio		INT(11),		-- ClienteID de Inicio
	Par_CliFin			INT(11)			-- ClienteID Final
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_AnioMes			INT;
	DECLARE Var_StrAnioMes		VARCHAR(10);
	DECLARE Var_FechaInicio		DATE;
	DECLARE Var_FechaFin		DATE;
	DECLARE Tex_FechaInicio		VARCHAR(50);

	DECLARE Tex_FechaFin		VARCHAR(50);
	DECLARE Var_InstitucionID	INT;
	DECLARE Var_NumeroTelefono	VARCHAR(20);

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Cadena_NO			CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;		-- Entero Cero
	SET Cadena_Vacia			:= '';		 -- Cadena vacia
	SET Cadena_NO				:= 'N';		 -- Cadena SI

 -- Se obtiene el nombre y numero de telefono de la institucion
	SELECT InstitucionID,TelefonoLocal
	INTO Var_InstitucionID, Var_NumeroTelefono
	FROM PARAMETROSSIS;

	SET Var_InstitucionID := IFNULL(Var_InstitucionID, Entero_Cero);
	SET Var_NumeroTelefono := IFNULL(Var_NumeroTelefono, Cadena_Vacia);

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

	IF (CHAR_LENGTH(Var_StrAnioMes) > 6) THEN
		-- Se obtiene la fecha inicial
		SET Var_FechaInicio := DATE(CONCAT(LEFT(Var_StrAnioMes, 6),'01'));
		-- Se obtiene la fecha final
		SET Var_FechaFin := DATE_ADD(Var_FechaInicio,INTERVAL 6 MONTH);
		SET Var_FechaFin := DATE_ADD(Var_FechaFin,INTERVAL -1 DAY);
	ELSE
		-- Se obtiene la fecha inicial
		SET Var_FechaInicio := CONCAT(SUBSTRING(Var_StrAnioMes,1,4), '-',
							  SUBSTRING(Var_StrAnioMes,5,2), '-',
							  '01');
		 -- Se obtiene la fecha final
		SET Var_FechaFin := LAST_DAY(Var_FechaInicio);
	END IF;

	-- Se obtiene los datos de cliente para generar el reporte en PDF
	SELECT DISTINCT(Edo.ClienteID),
			RutaReporte AS rptName,
			CONCAT(RutaExpPDF, Var_StrAnioMes,'/', LPAD(CONVERT(Edo.SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Edo.ClienteID,CHAR), 10, 0),
			'-',Var_StrAnioMes, '.pdf') AS outputFile,
			Var_FechaInicio AS FechaInicio,
			Var_FechaFin AS FechaFin, Ins.Nombre, CONCAT(Ins.DirFiscal, ' ',Ins.RFC,', Teléfono: ',Var_NumeroTelefono) AS DirFiscal,
			IF(Com.EsSuperTasas = 'N', Par.RutaLogo, Par.RutaSupTasaLogo) AS RutaLogo,
			Edo.AnioMes
		FROM EDOCTADATOSCTE Edo
		INNER JOIN EDOCTADATOSCTECOM Com ON Com.ClienteID = Edo.ClienteID,
			 EDOCTAPARAMS Par
		INNER JOIN INSTITUCIONES Ins ON Ins.InstitucionID =  Var_InstitucionID
		WHERE Edo.SucursalID >= Par_SucursalIni AND Edo.SucursalID <= Par_SucursalFin
			AND Edo.ClienteID	BETWEEN Par_CliInicio AND Par_CliFin
		ORDER BY Edo.ClienteID ASC;

END TerminaStore$$
