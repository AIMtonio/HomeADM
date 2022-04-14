-- SP EDOCTAV2PARAMSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2PARAMSCON;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2PARAMSCON (
	-- SP para la consulta de parametros de estado de cuenta
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta
	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_NombreInst		VARCHAR(100);	-- Nombre de la institucion

	-- Declaracion de constantes
	DECLARE Var_ConPrincipal	INT(11);		-- Consulta principal
	DECLARE Var_ConForanea		INT(11);		-- Consulta foranea
	DECLARE Var_ConSmarterW		INT(11);		-- Consulta de datos token y URL, SW
	DECLARE Var_ConDatosUEAU	INT(11);		-- Consulta de datos UEAU

	-- Asignacion de constantes
	SET Var_ConPrincipal		:= 1;			-- Consulta principal
	SET Var_ConForanea			:= 2;			-- Consulta foranea
	SET Var_ConSmarterW			:= 3;			-- Consulta de datos token y URL, SW
	SET Var_ConDatosUEAU		:= 4;			-- Consulta de datos UEAU

	-- Consulta principal
	IF Par_NumCon = Var_ConPrincipal THEN
		SELECT	MontoMinTimbrado,	RutaExpArchivos,	RutaPRPTPlantilla,	MesProceso,			InstitucionID,
				CiudadUEAUID,		CiudadUEAU,			TelefonoUEAU,		OtrasCiuUEAU,		HorarioUEAU,
				DireccionUEAU,		CorreoUEAU,			RutaLogo,			ExtTelefonoPart,
				ExtTelefono,		EnvioAutomatico,	RemitenteID,		Asunto,				CuerpoTexto,
				ProveedorTimbrado,	URLWSHub,			CredencialesHub,	TokenWS,			URLWSSmarterWeb,
				ClienteInstitucion,	FechaInicio,		FechaFin,			FolioProceso
			FROM EDOCTAV2PARAMS;
	END IF;

	-- Consulta foranea
	IF Par_NumCon = Var_ConForanea THEN
		SELECT param.RutaExpArchivos,	Sis.RFCFactElec AS RFC,	param.RutaPRTPPlantilla
			FROM EDOCTAV2PARAMS param, PARAMETROSSIS Sis
			LEFT JOIN INSTITUCIONES Ins ON Sis.InstitucionID = Ins.InstitucionID;
	END IF;

	-- Consulta de token y URL SW
    IF Par_NumCon = Var_ConSmarterW THEN
		SELECT	TokenSW,	URLWSSmarterWeb
			FROM EDOCTAV2PARAMS;
	END IF;

	-- Consulta los datos de la UEAU para el reporte de estado de cuenta para clientes nuevos
	IF Par_NumCon = Var_ConDatosUEAU THEN
		SELECT		Nombre
			INTO	Var_NombreInst
			FROM	PARAMETROSSIS params
			JOIN	INSTITUCIONES ins
			WHERE	ins.InstitucionID = params.InstitucionID;

		SELECT	Var_NombreInst AS NombreInst,	CiudadUEAUID,		CiudadUEAU,		TelefonoUEAU,		OtrasCiuUEAU,
				HorarioUEAU, 					DireccionUEAU,		CorreoUEAU
			FROM EDOCTAV2PARAMS;
	END IF;
END TerminaStore$$
