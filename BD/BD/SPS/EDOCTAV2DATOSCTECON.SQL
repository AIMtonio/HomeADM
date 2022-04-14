-- EDOCTAV2DATOSCTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2DATOSCTECON;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2DATOSCTECON(
	-- SP PARA CONSULTAR LOS DATOS DEL CLIENTE PARA EL ESTADO DE CUENTA BIENESTAR
	Par_ClienteID						INT(11),					-- Identificador del cliente
	Par_NumCon							TINYINT UNSIGNED,			-- Numero de consulta
	Par_EmpresaID						INT(11),					-- Parametro de Auditoria
	Aud_Usuario							INT(11),					-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal						INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT(20)					-- Parametro de Auditoria
)

TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_FecIniMes				DATE;						-- Fecha de inicio del periodo extraido
	DECLARE Var_FecFinMes				DATE;						-- Fecha final del periodo extraido
	DECLARE Var_DiasPeriodo				VARCHAR(45);				-- Almacena el total de dias que abarca el periodo
	DECLARE Var_RutaLogo				VARCHAR(90);				-- Almacena la ruta del logo a desplegar en el estado de cuenta
	DECLARE Var_NumInstrumen			BIGINT(20);					-- Numero de las cuentas
	DECLARE Var_NumCredito				BIGINT(12);					-- Numero de Creditos
	DECLARE Var_NumCede					INT(11);					-- Numero de Cede
	DECLARE Var_NumInversion			INT(11);					-- Numero de Inversiones
	DECLARE Var_NumCarObj				INT(11);					-- Numero de cargos objetados
	DECLARE Var_FolioFiscal				VARCHAR(50);				-- Valor de UUID
	DECLARE Var_CtaAho					BIGINT(12);					-- Valor de cuentas de ahorro
	DECLARE Var_CredCliente				BIGINT(12);					-- Numero de credito
	DECLARE Var_CedeCliente				INT(11);					-- Numero de cede del cliente

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Uno					INT(1);						-- Entero Uno
	DECLARE	Cadena_Vacia				VARCHAR(1);					-- Cadena Vacia
	DECLARE	Entero_Cero					INT(11);					-- Entero Cero
	DECLARE Var_ConPrincipal			TINYINT UNSIGNED;			-- Consulta principal
	DECLARE Var_ConMuestreoPDF			TINYINT UNSIGNED;
	DECLARE Var_ConMuestreoXML			TINYINT UNSIGNED;
	DECLARE Var_ConMuestreoCorreo		TINYINT UNSIGNED;			-- Consulta de archivos de correo a enviar

	-- ASIGNACION DE CONSTANTES
	SET Entero_Uno						:= 1;						-- Entero Uno
	SET Cadena_Vacia					:= '';						-- Cadena Vacia
	SET Entero_Cero						:= 0;						-- Entero Cero
	SET Var_ConPrincipal				:= 1;						-- Consulta principal
	SET Var_ConMuestreoPDF				:= 2;						-- Consulta para determinar el universo de pdfs que se van a generar.
	SET Var_ConMuestreoXML				:= 3;						-- consulta para determinar el unniverso de xml a generar
	SET Var_ConMuestreoCorreo			:= 4;						-- Consulta de archivos de correo a enviar

	IF (Par_NumCon = Var_ConPrincipal) THEN

		SELECT		InstrumentoID
			INTO	Var_NumInstrumen
			FROM	EDOCTAV2RESUMCAPTA
			WHERE	ClienteID = Par_ClienteID
			ORDER BY TipoInstrumento, InstrumentoID
			LIMIT	Entero_Uno;

		SELECT		CreditoID
			INTO	Var_NumCredito
			FROM	EDOCTAV2RESUMCREDITOS
			WHERE	ClienteID = Par_ClienteID
			ORDER BY CreditoID
			LIMIT	Entero_Uno;

		SELECT		CargoObjetadoID
			INTO	Var_NumCarObj
			FROM	EDOCTAV2CAROBJETADOS
			WHERE	ClienteID = Par_ClienteID
			ORDER BY CargoObjetadoID
			LIMIT	Entero_Uno;

		SELECT		CuentaAhoID
			INTO	Var_CtaAho
			FROM	EDOCTAV2HEADERCTA
			WHERE	ClienteID = Par_ClienteID
			ORDER BY CuentaAhoID
			LIMIT	Entero_Uno;

		SELECT		CreditoID
			INTO	Var_CredCliente
			FROM	EDOCTAV2HEADERCRED
			WHERE	ClienteID = Par_ClienteID
			ORDER BY CreditoID
			LIMIT	Entero_Uno;

		SET Var_NumInstrumen	:= IFNULL(Var_NumInstrumen, Entero_Cero);
		SET Var_NumCredito		:= IFNULL(Var_NumCredito, Entero_Cero);
		SET Var_NumCede			:= IFNULL(Var_NumCede, Entero_Cero);
		SET Var_CredCliente		:= IFNULL(Var_CredCliente, Entero_Cero);
		SET Var_CtaAho			:= IFNULL(Var_CtaAho, Entero_Cero);
		SET Var_NumInversion	:= IFNULL(Var_NumInversion, Entero_Cero);
		SET Var_NumCarObj		:= IFNULL(Var_NumCarObj, Entero_Cero);

		SELECT		AnioMes,						SucursalID,						ClienteID,				NombreSucursalCte,					TipoPer,
					TipoPersona,					Calle,							NumInt,					NumExt,								Colonia,
					MunicipioDelegacion,			Localidad,						Estado,					CodigoPostal,						RFC,
					DireccionCompleta,				Var_NumInstrumen AS NumCuentas,	Var_CtaAho AS CtaAho,	Var_CredCliente AS CredCliente,		NombreCompleto,
					Cadena_Vacia AS FolioFiscal,	Var_NumCredito AS NumCredito,	Var_NumCede AS NumCede,	Var_NumCarObj AS NumCarObj
			FROM	EDOCTAV2DATOSCTE
			WHERE	ClienteID = Par_ClienteID
			LIMIT	Entero_Uno;
	END IF;

	IF (Par_NumCon = Var_ConMuestreoPDF) THEN
		SELECT
			RutaPRPTPlantilla AS prptName,
			CONCAT(RutaExpArchivos,'PDF/', TRIM(PrefijoEmpresa), '/', AnioMes,'/',RIGHT(CONCAT('000',SucursalID),3) ,'/',LPAD(CONVERT(ClienteID,CHAR), 10, 0),'-',AnioMes, '.pdf') as outputFile,
			ClienteID,
			FechaInicio as FechaIni,
			FechaFin   as FechaFin,
			AnioMes,
			RutaLogo,
			'' as NomInstitucion ,
			'' as ColorTitulos,
			'' as DirecFiscal,
			'' as ColorRecuadros,
			'' as NomInstitucion
		FROM EDOCTAV2DATOSCTE, EDOCTAV2PARAMS, EDOCTAV2PARAMSEJECUCION
		WHERE FIND_IN_SET(IF( TipoEjecucion = 'S', SucursalID, ClienteID), Instrumentos)
		ORDER BY   IF( TipoEjecucion = 'S', SucursalID, ClienteID) ;

	END IF;
	IF (Par_NumCon = Var_ConMuestreoXML) THEN
		SELECT
			TIM.xmlSat AS XmlSAT,
			CONCAT(Param.RutaExpArchivos,'XML/', TRIM(Param.PrefijoEmpresa),'/', Cte.AnioMes,'/',RIGHT(CONCAT('000',Cte.SucursalID),3) ,'/',LPAD(CONVERT(Cte.ClienteID,CHAR), 10, 0), '-', Cte.AnioMes, '.xml') as rutaXml,
			Cte.ClienteID,
			Cte.AnioMes
		FROM EDOCTAV2DATOSCTE Cte
        INNER JOIN EDOCTAV2TIMBRADOINGRE TimIng ON Cte.ClienteID = TimIng.ClienteID AND Cte.AnioMes = TimIng.AnioMes
        INNER JOIN EDOCTAV2RESPTIMBRE TIM  ON Cte.ClienteID = TIM.ClienteID AND Cte.AnioMes = TIM.AnioMes AND TIM.CodigoRespuestaSW = '000000'
        INNER JOIN EDOCTAV2PARAMS Param
        INNER JOIN EDOCTAV2PARAMSEJECUCION Ejec
		WHERE FIND_IN_SET(IF( Ejec.TipoEjecucion = 'S', Cte.SucursalID, Cte.ClienteID), Ejec.Instrumentos)
        AND TimIng.EstatusTimbrado = 2
		ORDER BY   IF( Ejec.TipoEjecucion = 'S', Cte.SucursalID,Cte.ClienteID) ;

	END IF;

	IF Par_NumCon = Var_ConMuestreoCorreo THEN
		SELECT	pdf.ClienteID,	MAX(pdf.RutaArchivo) AS RutaPDF,	MAX(pdf.PesoByte) AS PesoPDF,	IFNULL(MAX(xml.RutaArchivo), Cadena_Vacia) AS RutaXML,	IFNULL(MAX(xml.PesoByte), Entero_Cero) AS PesoXML
			FROM EDOCTAV2DATOSCTE AS cte
			INNER JOIN CLIENTES AS cli ON cte.ClienteID = cli.ClienteID
			INNER JOIN EDOCTAV2PARAMS AS params ON cte.AnioMes = params.MesProceso AND params.EnvioAutomatico = 'S'
			INNER JOIN EDOCTAV2PDFGENERADOS AS pdf ON cte.AnioMes = pdf.AnioMes AND cte.ClienteID = pdf.ClienteID
			LEFT JOIN EDOCTAV2XMLGENERADOS AS xml ON pdf.AnioMes = xml.AnioMes AND pdf.ClienteID = xml.ClienteID
			INNER JOIN EDOCTAV2PARAMSEJECUCION AS ejec ON IF(ejec.TipoEjecucion = 'S', cte.SucursalID, cte.ClienteID) = CAST(ejec.Instrumentos AS UNSIGNED)
			WHERE FIND_IN_SET(IF(ejec.TipoEjecucion = 'S', cte.SucursalID, cte.ClienteID), ejec.Instrumentos)
			  AND IFNULL(cli.Correo, Cadena_Vacia) <> Cadena_Vacia
			GROUP BY pdf.ClienteID, xml.ClienteID;
	END IF;

END TerminaStore$$
