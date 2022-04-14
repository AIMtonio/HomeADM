-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWPARAMETROSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWPARAMETROSCON`;

DELIMITER $$
CREATE PROCEDURE `APPWPARAMETROSCON`(

	Par_EmpresaID		INT(11),
	Par_ClaveUsuario	VARCHAR(45),
	Par_NumCon			TINYINT UNSIGNED,

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN


	DECLARE Var_ConPrincipal 	TINYINT UNSIGNED;
	DECLARE Var_ConLoginWeb 	TINYINT UNSIGNED;


	DECLARE VarClienteID    INT(11);
	DECLARE VarReqToken		CHAR(1);
	DECLARE VarReqCte		CHAR(1);


	SET Var_ConPrincipal 	:= 1;
	SET Var_ConLoginWeb 	:= 2;


	IF (Par_NumCon = Var_ConPrincipal) THEN
		SELECT 	EmpresaID,           NombreCortoInstit,   TextoCodigoActSMS,  IvaPorPagarSPEI,     URLFreja,
				UsuarioEnvioSPEI,    RutaArchivos,        AsuntoNotiAltaTar,  AsuntNotiCambioTar,  AsuntoNotiPagosTar,
				AsuntNotiSesionTar,  AsuntNotiTransfTar,  TiempoValidezSMS,   RemitenteTar,        LonMinCaracPass,
				TituloTransaccion,   PeriodoValidez,      TiempoMaxEspera,    TiempoAprovision,	   NumIntentos,
				TiempoInact
			FROM APPWPARAMETROS
			WHERE EmpresaID = Par_EmpresaID;
	END IF;

	IF (Par_NumCon = Var_ConLoginWeb) THEN

		SELECT 	Par.EmpresaID,				Par.NombreCortoInstit,		Par.UrlBaseWS,				Usu.Clave,						Usu.NombreCompleto,
				Usu.Correo,					Usu.TelefonoCelular,		Usu.Perfil,					Usu.FechaUltAcceso,				Usu.EmpresaID,
				Usu.UsuarioID,				Usu.ClienteID
			FROM APPWPARAMETROS Par
			INNER JOIN APPWUSUARIOS AS Usu on Usu.ClienteID = Par_ClaveUsuario
			WHERE Par.EmpresaID = Par_EmpresaID;
	END IF;

END TerminaStore$$