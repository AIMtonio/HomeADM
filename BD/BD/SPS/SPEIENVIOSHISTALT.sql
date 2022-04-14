-- SP SPEIENVIOSHISTALT

DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIENVIOSHISTALT`;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSHISTALT`(
	Par_FechaHist			DATETIME,			-- Fecha de historico

	Par_Salida				CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(20),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
	)
TerminaStore: BEGIN


	-- DECLARACION DE CONSTANTES

	DECLARE Entero_Cero		INT(11);			-- Entero vacio
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia		DATE;				-- Fecha vacia
	DECLARE SalidaSI		CHAR(1);			-- Salida si
	DECLARE SalidaNO		CHAR(1);			-- Salida no

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero			:= 0;				-- Entero_Cero
	SET Cadena_Vacia		:= '';				-- Cadena_Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha_Vacia
	SET SalidaSI			:= 'S';				-- Salida SI
	SET SalidaNO			:= 'N';				-- Salida NO
	SET Par_NumErr			:= 0;				-- Parametro numero de error
	SET Par_ErrMen			:= '';				-- Parametro mensaje de error


INSERT INTO SPEIENVIOSHIST(
	SpeiEnvHisID,		ClaveRastreo,		TipoPagoID,			CuentaAho,				TipoCuentaOrd,
	CuentaOrd,			NombreOrd,			RFCOrd,				MonedaID,				TipoOperacion,
	MontoTransferir,	IVAPorPagar,		ComisionTrans,		IVAComision,			InstiRemitenteID,
	TotalCargoCuenta,	InstiReceptoraID,	CuentaBeneficiario,	NombreBeneficiario,		RFCBeneficiario,
	TipoCuentaBen,		ConceptoPago,		CuentaBenefiDos,	NombreBenefiDos,		RFCBenefiDos,
	TipoCuentaBenDos,	ConceptoPagoDos,	ReferenciaCobranza,	ReferenciaNum,			PrioridadEnvio,
	FechaAutorizacion,	EstatusEnv,			ClavePago,			UsuarioEnvio,			AreaEmiteID,
	Estatus,			FechaRecepcion,		FechaEnvio,			CausaDevol,				FechaCan,
	Comentario,			FechaOPeracion,		Firma,				UsuarioAutoriza,		UsuarioVerifica,
	FechaVerifica,		OrigenOperacion,	NumIntentos,		FolioSTP,				PIDTarea,
	EmpresaID,			Usuario,			FechaActual,		DireccionIP,			ProgramaID,
	Sucursal,			NumTransaccion)
	SELECT
		FolioSpeiID,		ClaveRastreo,		TipoPagoID,			CuentaAho,				TipoCuentaOrd,
		CuentaOrd,			NombreOrd,			RFCOrd,				MonedaID,				TipoOperacion,
		MontoTransferir,	IVAPorPagar,		ComisionTrans,		IVAComision,			InstiRemitenteID,
		TotalCargoCuenta,	InstiReceptoraID,	CuentaBeneficiario,	NombreBeneficiario,		RFCBeneficiario,
		TipoCuentaBen,		ConceptoPago,		CuentaBenefiDos,	NombreBenefiDos,		RFCBenefiDos,
		TipoCuentaBenDos,	ConceptoPagoDos,	ReferenciaCobranza,	ReferenciaNum,			PrioridadEnvio,
		FechaAutorizacion,	EstatusEnv,			ClavePago,			UsuarioEnvio,			AreaEmiteID,
		Estatus,			FechaRecepcion,		FechaEnvio,			CausaDevol,				FechaCan,
		Comentario,			FechaOPeracion,		Firma,				UsuarioAutoriza,		UsuarioVerifica,
		FechaVerifica,		OrigenOperacion,	Entero_Cero,		Entero_Cero,			Cadena_Vacia,
		EmpresaID,			Usuario,			FechaActual,		DireccionIP,			ProgramaID,
		Sucursal,			NumTransaccion
	FROM SPEIENVIOS SE
		WHERE month(SE.FechaRecepcion) = month(date_add(Par_FechaHist,interval -1 month));

	DELETE FROM SPEIENVIOS WHERE month(FechaRecepcion) = month(date_add(Par_FechaHist,interval -1 month));

-- Fin del SP
END TerminaStore$$