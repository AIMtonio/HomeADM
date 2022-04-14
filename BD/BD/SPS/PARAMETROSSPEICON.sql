-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSPEICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSPEICON`;
DELIMITER $$


CREATE PROCEDURE `PARAMETROSSPEICON`(
	-- STORE PARA CONSULTAR LOS PARAMETROS DEL SPEI
	Par_EmpresaID		INT(11),				-- ID de Empresa
	Par_NumCon			TINYINT UNSIGNED,		-- Numero de consulta

	Aud_Usuario			INT(11),				-- Parametros de Auditoria
	Aud_FechaActual		DATETIME,				-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal		INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion	BIGINT(20)				-- Parametros de Auditoria
)

TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE Hora_Vacia 			TIME;			-- Hora vacia
	DECLARE Entero_Cero			INT;			-- Entero vacio
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Decimal vacio
	DECLARE Par_NumErr			INT;			-- Numero de error
	DECLARE Par_ErrMen			VARCHAR(400);	-- Mensaje de error
	DECLARE SalidaNO			CHAR(1);		-- Variable de salida no
	DECLARE SalidaSI			CHAR(1);		-- Variable de salida si
	DECLARE Con_Principal		INT;			-- Consulta principal
	DECLARE Con_Horario			INT;			-- Consulta por horario
	DECLARE Con_UltAct			INT;			-- Consulta de ultima actualizacion de catalogos

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';			-- Constante cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';-- Constante fecha vacia
	SET Hora_Vacia				:= '00:00:00';	-- Constante hora vacia
	SET Entero_Cero				:= 0;			-- Constante entero cero
	SET Decimal_Cero			:= 0.0;			-- Constante decimal cero
	SET SalidaSI				:= 'S';			-- Constante salida SI
	SET SalidaNO				:= 'N';			-- Constante salida NO
	SET Par_NumErr				:= 0;			-- Parametro numero de error
	SET Par_ErrMen				:= '';			-- Parametro Mensaje de error
	SET Con_Principal			:= 1;			-- Consulta Principal
	SET Con_Horario 			:= 2;			-- Consulta horario
	SET Con_UltAct				:= 3;			-- Consulta de fecha de ultima actualizacion de catalogos

	-- Consulta principal
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	PS.EmpresaID,				PS.FolioEnvio,				PS.Clabe,				PS.CtaSpei,					PS.ParticipanteSpei,
				PS.HorarioInicio,			PS.HorarioFin,				PS.HorarioFinVen,		PS.FechaApertura,			PS.EstatusApertura,
				PS.ParticipaPagoMovil,		PS.FrecuenciaEnvio,			PS.Topologia,			PS.Prioridad,				FORMAT(PS.MonMaxSpeiVen,2) AS MonMaxSpeiVen,
				FORMAT(PS.MonReqAutTeso,2) AS MonReqAutTeso,			PS.SpeiVenAutTes,		PS.UltActCat,				INS.Nombre,
				PS.MonMaxSpeiBcaMovil,		PS.BloqueoRecepcion,		PS.MontoMinimoBloq,		PS.CtaContableTesoreria,	PS.SaldoMinimoCuentaSTP,
				PS.RutaKeystoreStp,			PS.AliasCertificadoStp,		PS.PasswordKeystoreStp,	PS.EmpresaSTP,				PS.TipoOperacion,
				PS.IntentosMaxEnvio,		PS.NotificacionesCorreo,	PS.CorreoNotificacion,	PS.RemitenteID,				TE.CorreoSalida,
				PS.URLWS,					PS.UsuarioContraseniaWS,	PS.Habilitado,			PS.MonReqAutDesem,			PS.URLWSPM,
				PS.URLWSPF
			FROM PARAMETROSSPEI PS
				INNER JOIN PARAMETROSSIS PT ON PT.EmpresaID	=	PS.EmpresaID
				INNER JOIN INSTITUCIONES INS ON INS.InstitucionID	=	PT.InstitucionID
				LEFT JOIN TARENVIOCORREOPARAM TE ON TE.RemitenteID = PS.RemitenteID
			WHERE	PS.EmpresaID = Par_EmpresaID;
	END IF;

	-- Consulta por horario
	IF(Par_NumCon = Con_Horario) THEN
		SELECT	PS.HorarioInicio,	PS.HorarioFin
			FROM PARAMETROSSPEI PS
			WHERE	PS.EmpresaID	= Par_EmpresaID;
	END IF;

	-- Consulta fecha de ultima actualizacion de catalogos
	IF(Par_NumCon = Con_UltAct) THEN
		SELECT	PS.UltActCat ,PS.ParticipanteSpei
			FROM PARAMETROSSPEI PS
			WHERE	PS.EmpresaID	= Par_EmpresaID;
	END IF;

-- Fin del SP
END TerminaStore$$
