-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSMSENVIOMENSAJEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISSMSENVIOMENSAJEALT`;DELIMITER $$

CREATE PROCEDURE `HISSMSENVIOMENSAJEALT`(
	-- SP para dar de alta en historico los mensajes ya enviados o fallidos de SMSENVIOMENSAJE
	Par_Salida			CHAR(1),		-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr    INT(11),		-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen    VARCHAR(400),	-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID		INT(11),		-- Parametros de auditoria
	Aud_Usuario			INT(11),		-- Parametros de auditoria
	Aud_FechaActual		DATETIME,		-- Parametros de auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametros de auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametros de auditoria
	Aud_Sucursal		INT(11),		-- Parametros de auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);			-- Entero Cero
	DECLARE SalidaSI			CHAR(1);			-- Salida SI
	DECLARE SalidaNO			CHAR(1);			-- Salida NO
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;				-- Fecha vacia
	DECLARE Est_Enviado			CHAR(1);			-- Estatus enviado
	DECLARE Est_NoEnviado		CHAR(1);			-- Estatus no enviado
	DECLARE Est_Exito			CHAR(1);			-- Estatus exito
	DECLARE Est_Error			CHAR(1);			-- Estatus error
	DECLARE Var_ClasifSalida	CHAR(1);			-- Clasificacion salida

	-- Asignacion de constantes
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET	SalidaSI				:= 'S';				-- Salida SI
	SET	SalidaNO				:= 'N';				-- Salida NO
	SET	Cadena_Vacia			:= '';				-- Cadena vacia
	SET	Fecha_Vacia     		:= '1900-01-01';	-- Fecha vacia
	SET	Est_Enviado				:= 'E';				-- Estatus enviado
	SET	Est_NoEnviado			:= 'N';				-- Estatus no enviado
	SET	Est_Exito				:= 'E';				-- Estatus exito
	SET	Est_Error				:= 'F';				-- Estatus error
	SET	Var_ClasifSalida		:= 'S';				-- Clasificacion salida

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-HISSMSENVIOMENSAJEALT');
			SET Var_Control = 'sqlException';
		END;

		INSERT INTO HISSMSENVIOMENSAJE
		SELECT	sms.EnvioID,			sms.Estatus,		sms.Remitente,		sms.Receptor,		sms.FechaRealEnvio,
				sms.Mensaje,			sms.ColMensaje,		sms.FechaProgEnvio,	sms.CodExitoErr,	sms.CampaniaID,
				sms.CodigoRespuesta,	sms.FechaRespuesta,	sms.DatosCliente,	sms.SistemaID,		sms.EmpresaID,
				sms.Usuario,			sms.FechaActual,	sms.DireccionIP,	sms.ProgramaID,		sms.Sucursal,
				sms.NumTransaccion
			FROM SMSENVIOMENSAJE AS sms
			INNER JOIN SMSCAMPANIAS AS cam ON sms.CampaniaID = cam.CampaniaID AND cam.Clasificacion = Var_ClasifSalida
			WHERE	(sms.Estatus = Est_Enviado
			  AND	sms.CodExitoErr = Est_Exito)
			   OR	(sms.Estatus = Est_NoEnviado
			  AND	sms.CodExitoErr = Est_Error);

		CALL HISSMSENVMENADICALT (	SalidaNO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
		IF (Par_NumErr <> Entero_Cero) THEN
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Registros copiados exitosamente';
		SET Var_Control	:= Cadena_Vacia;
	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control,
				Entero_Cero	AS consecutivo;
	END IF;
END TerminaStore$$