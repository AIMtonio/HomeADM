-- CONSTANCIARETPARAMSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSTANCIARETPARAMSCON`;
DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETPARAMSCON`(
-- ---------------------------------------------------------------- --
-- --- SP DE CONSULTA DE PARAMETROS DE CONSTANCIA DE RETENCION  --- --
-- ---------------------------------------------------------------- --
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de consulta

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)TerminaStore:BEGIN

	-- Declaracion de constantes
    DECLARE Cadena_Vacia	CHAR(1);	-- Cadena vacia
	DECLARE Entero_Cero		INT(11);	-- Entero Cero
	DECLARE Con_Principal	INT(11);	-- Consulta Principal 1:Parametros Constancia Retencion
	DECLARE Con_Foranea		INT(11);	-- Consulta Foranea 2

	-- Asignacion de Constantes
    SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Con_Principal		:= 1;
	SET Con_Foranea			:= 2;

    -- 1:Consulta Principal Parametros Constancia Retencion
	IF (Par_NumCon = Con_Principal)THEN
		SELECT  RutaReporte,	RutaExpPDF,			RutaReporte,		AnioProceso,		InstitucionID,
				RutaCBB,		RutaCFDI,			RutaLogo,			RutaCedula,			TimbraConsRet,
                NumeroRegla,	AnioEmision,		RutaETL,			CalcCierreIntReal,	GeneraConsRetPDF
		FROM CONSTANCIARETPARAMS;
	END IF;

	-- 2:Consulta Foranea
	IF (Par_NumCon = Con_Foranea) THEN
		SELECT 	Par.RutaExpPDF, 	Par.RutaCBB, 	Par.RutaCFDI, 		Sis.RFCFactElec AS RFC, 	Par.RutaReporte,
				Par.RutaLogo,		Par.RutaCedula,	Par.RutaETL,		Par.CalcCierreIntReal,		Par.GeneraConsRetPDF,
                Par.TipoProveedorWS,Par.UsuarioWS,	Par.ContraseniaWS,	Par.UrlWSDL,				Par.TokenAcceso,
                Par.TimbraConsRet,	Par.RutaArchivosCertificado,	Par.NombreCertificado,	Par.NombreLlavePriv,
                Par.RutaArchivosXSLT, Par.PassCertificado
		FROM CONSTANCIARETPARAMS Par,
			PARAMETROSSIS Sis
		LEFT JOIN INSTITUCIONES Ins
			ON Sis.InstitucionID = Ins.InstitucionID;
	END IF;

END TerminaStore$$