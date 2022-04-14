-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCPARAMSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCPARAMSCON`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCPARAMSCON`(
    -- SP QUE CONSULTA LOS DATOS DE EDOCTATDCPARAMS
    Par_Num_Consulta            INT(11),                -- Identificador de la Institucion
    
    Aud_EmpresaID               INT(11),                -- Parametro de Auditoria de la Empresa
    Aud_Usuario                 INT(11),                -- Parametro de Auditoria del Usuario
    Aud_FechaActual             DATETIME,               -- Parametro de Auditoria de la Fecha Actual
    Aud_DireccionIP             VARCHAR(15),            -- Parametro de Auditoria de la Direccion IP
    Aud_ProgramaID              VARCHAR(50),            -- Parametro de Auditoria del ID del Programa
    Aud_Sucursal                INT(11),                -- Parametro de auditoria de Sucursal
    Aud_NumTransaccion          BIGINT(20)              -- Parametro de auditoria del numero de Transaccion 

)
TerminaStore: BEGIN
    -- Declaracion de Constantes 
    DECLARE	Numero_Consulta			INT(11);            -- Constante del numero de consulta
    DECLARE Con_Principal			INT(11);			-- Consulta para la pantalla de parametros
	DECLARE Con_Foranea				INT(11);			-- Consulta foranea
        
    -- Asignacion de constantes
    SET Numero_Consulta := 1;                           -- Consulta principal
    SET Con_Principal	:= 2;							-- Consulta para la pantalla
	SET Con_Foranea		:= 3;							-- Consulta foranea

    IF(Par_Num_Consulta = Numero_Consulta)THEN
        SELECT EDO.TelefonoUEAU, EDO.CorreoUEAU,	EDO.DireccionUEAU,	EDO.InstitucionID,	INS.Nombre
        FROM EDOCTATDCPARAMS EDO
        INNER JOIN INSTITUCIONES AS INS ON INS.InstitucionID = EDO.InstitucionID;
    END IF;
    
    IF (Par_Num_Consulta = Con_Principal)THEN
		SELECT	MontoMin,		RutaExpPDF,			RutaReporte,			InstitucionID,			CiudadUEAUID,
				CiudadUEAU,		TelefonoUEAU,		OtrasCiuUEAU,			HorarioUEAU,			DireccionUEAU,
				CorreoUEAU,		RutaCBB,			RutaCFDI,				RutaLogo,				ExtTelefonoPart,
				ExtTelefono,	TipoCuentaID,		EnvioAutomatico,		CorreoRemitente,		ServidorSMTP,
				PuertoSMTP,		UsuarioRemitente,	ContraseniaRemitente,	Asunto,					CuerpoTexto,
				RequiereAut,	TipoAut
			FROM EDOCTATDCPARAMS;
	END IF;

	IF (Par_Num_Consulta = Con_Foranea) THEN
		SELECT param.RutaExpPDF, param.RutaCBB, param.RutaCFDI, Sis.RFCFactElec AS RFC, param.RutaReporte
			FROM EDOCTATDCPARAMS param, PARAMETROSSIS Sis 
			LEFT JOIN INSTITUCIONES Ins ON Sis.InstitucionID = Ins.InstitucionID;
	END IF;
    
END TerminaStore$$