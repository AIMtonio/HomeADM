DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIENVIOSSTPHISTALT`;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSSTPHISTALT`(
	-- STORED PROCEDURE ENCARGADO DE REALIZAR EL REGISTRO DE LAS ORDENES DE PAGO CANCELAS EN EL HISTORICO
	Par_Folio				INT(11),				-- Folio de la Orden de Pago[FolioSpeiID] de la tabla SPEIENVIOS

	Par_Salida				CHAR(1),				-- Indica si el el stored procedure regresara una respuesta
	INOUT Par_NumErr		INT(11),				-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje del Error

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(20),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(200);			-- Nombre del Control en Pantalla
	DECLARE Var_Consecutivo	BIGINT(20);				-- Numero Consecutivo

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);				-- Entero Vacio
	DECLARE Cadena_Vacia	CHAR(1);				-- Cadena Vacia
	DECLARE Fecha_Vacia		DATE;					-- Fecha Vacia
	DECLARE Salida_Si		CHAR(1);				-- Salida SI
	DECLARE Salida_No		CHAR(1);				-- Salida NO

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;					-- Entero_Cero
	SET Cadena_Vacia		:= '';					-- Cadena_Vacia
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha_Vacia
	SET Salida_Si			:= 'S';					-- Salida SI
	SET Salida_No			:= 'N';					-- Salida NO
	SET Par_NumErr			:= 0;					-- Parametro numero de error
	SET Par_ErrMen			:= '';					-- Parametro mensaje de error

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIENVIOSSTPHISTALT');
				SET Var_Control	:= 'sqlException';
			END;

		IF(Par_Folio = Entero_Cero) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Folio se encuentra Vacio.';
			SET Var_Control	:= 'Folio';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO SPEIENVIOSHIST(
			SpeiEnvHisID,						ClaveRastreo,					TipoPagoID,							CuentaAho,							TipoCuentaOrd,
			CuentaOrd,							NombreOrd,						RFCOrd,								MonedaID,							TipoOperacion,
			MontoTransferir,					IVAPorPagar,					ComisionTrans,						IVAComision,						InstiRemitenteID,
			TotalCargoCuenta,					InstiReceptoraID,				CuentaBeneficiario,					NombreBeneficiario,					RFCBeneficiario,
			TipoCuentaBen,						ConceptoPago,					CuentaBenefiDos,					NombreBenefiDos,					RFCBenefiDos,
			TipoCuentaBenDos,					ConceptoPagoDos,				ReferenciaCobranza,					ReferenciaNum,						PrioridadEnvio,
			FechaAutorizacion,					EstatusEnv,						ClavePago,							UsuarioEnvio,						AreaEmiteID,
			Estatus,							FechaRecepcion,					FechaEnvio,							CausaDevol,							FechaCan,
			Comentario,							FechaOPeracion,					Firma,								UsuarioAutoriza,					UsuarioVerifica,
			FechaVerifica,						OrigenOperacion,				NumIntentos,						FolioSTP,							PIDTarea,
			EmpresaID,							Usuario,						FechaActual,						DireccionIP,						ProgramaID,
			Sucursal,							NumTransaccion)
		SELECT
			FolioSpeiID,						ClaveRastreo,					TipoPagoID,							CuentaAho,							TipoCuentaOrd,
			FNDECRYPTSAFI(CuentaOrd),			FNDECRYPTSAFI(NombreOrd),		FNDECRYPTSAFI(RFCOrd),				MonedaID,							TipoOperacion,
			FNDECRYPTSAFI(MontoTransferir),		IVAPorPagar,					ComisionTrans,						IVAComision,						InstiRemitenteID,
			FNDECRYPTSAFI(TotalCargoCuenta),	InstiReceptoraID,				FNDECRYPTSAFI(CuentaBeneficiario),	FNDECRYPTSAFI(NombreBeneficiario),	FNDECRYPTSAFI(RFCBeneficiario),
			TipoCuentaBen,						FNDECRYPTSAFI(ConceptoPago),	CuentaBenefiDos,					NombreBenefiDos,					RFCBenefiDos,
			TipoCuentaBenDos,					ConceptoPagoDos,				ReferenciaCobranza,					ReferenciaNum,						PrioridadEnvio,
			FechaAutorizacion,					EstatusEnv,						ClavePago,							UsuarioEnvio,						AreaEmiteID,
			Estatus,							FechaRecepcion,					FechaEnvio,							CausaDevol,							FechaCan,
			Comentario,							FechaOPeracion,					Firma,								UsuarioAutoriza,					UsuarioVerifica,
			FechaVerifica,						OrigenOperacion,				NumIntentos,						FolioSTP,							PIDTarea,
			EmpresaID,							Usuario,						FechaActual,						DireccionIP,						ProgramaID,
			Sucursal,							NumTransaccion
			FROM SPEIENVIOS SE
			WHERE FolioSpeiID = Par_Folio;

		DELETE FROM SPEIENVIOS
			WHERE FolioSpeiID = Par_Folio;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= 'Historico Registrado Exitosamente';
		SET Var_Control		:= 'FolioSpeiID';
		SET Var_Consecutivo	:= Par_Folio;
	END ManejoErrores;

	IF(Par_Salida = Salida_Si)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$