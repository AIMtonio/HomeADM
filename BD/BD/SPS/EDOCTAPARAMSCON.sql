-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAPARAMSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAPARAMSCON`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAPARAMSCON`(
	Par_NumCon				tinyint unsigned,

	Par_EmpresaID			int(11),
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint
	)

TerminaStore:BEGIN
-- DECLARACION DE VARIABLES    ------

-- DECLARACION DE CONSTANTES    ------
DECLARE Con_Principal		int(11);
DECLARE Con_Foranea			int(11);
DECLARE Con_SmarterW		int(11);
DECLARE Con_DatosUEAU		INT(11);

-- DECLARACION DE VARIABLES
DECLARE Var_NombreInst				VARCHAR(100);				-- Nombre de la institucion

-- ASIGNACION DE CONSTANTES
set Con_Principal		:=1;
set Con_Foranea			:=2;
set Con_SmarterW		:=3;
set Con_DatosUEAU		:=4;


	if (Par_NumCon = Con_Principal)then
		-- Modificacion a la consulta principal para agregar nuevos campos de envio de correo. Cardinal Sistemas Inteligentes
		SELECT	MontoMin,		RutaExpPDF,			RutaReporte,			InstitucionID,			CiudadUEAUID,
				CiudadUEAU,		TelefonoUEAU,		OtrasCiuUEAU,			HorarioUEAU,			DireccionUEAU,
				CorreoUEAU,		RutaCBB,			RutaCFDI,				RutaLogo,				ExtTelefonoPart,
				ExtTelefono,	TipoCuentaID,		EnvioAutomatico,		CorreoRemitente,		ServidorSMTP,
				PuertoSMTP,		UsuarioRemitente,	ContraseniaRemitente,	Asunto,					CuerpoTexto,
				RequiereAut,	TipoAut,			RutaPDI
			FROM EDOCTAPARAMS;
		-- Fin de modificacion a la consulta principal. Cardinal Sistemas Inteligentes
	end if;

	if (Par_NumCon = Con_Foranea) then
		SELECT param.RutaExpPDF, param.RutaCBB, param.RutaCFDI, Sis.RFCFactElec as RFC, param.RutaReporte
			FROM EDOCTAPARAMS param, PARAMETROSSIS Sis
			LEFT JOIN INSTITUCIONES Ins ON Sis.InstitucionID = Ins.InstitucionID;
	end if;

    IF (Par_NumCon = Con_SmarterW) THEN
		SELECT	TokenSW,URLWSSmarterWeb
			FROM EDOCTAPARAMS;
	END IF;

	-- Consulta los datos de la UEAU para el reporte de estado de cuenta para clientes nuevos
	IF (Par_NumCon = Con_DatosUEAU) THEN
		SELECT Nombre INTO Var_NombreInst
		FROM PARAMETROSSIS params
		JOIN INSTITUCIONES ins
		WHERE ins.InstitucionID = params.InstitucionID;

		SELECT	Var_NombreInst AS NombreInst,	CiudadUEAUID,		CiudadUEAU,		TelefonoUEAU,		OtrasCiuUEAU,
				HorarioUEAU, 					DireccionUEAU,		CorreoUEAU
			FROM EDOCTAPARAMS;
	END IF;

END TerminaStore$$