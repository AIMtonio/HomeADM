DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIENVIOSCON`;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSCON`(
# =====================================================================================
# ------- STORE PARA REALIZAR CONSULTAS DE ENVIO SPEI ---------
# =====================================================================================
	Par_Folio				BIGINT(20),				-- Folio Spei
	Par_Estatus				CHAR(1),				-- Estatus Spei
	Par_EstatusEnv			INT(3),					-- Estatus Envio
	Par_TipoPagoID			INT(2),					-- Tipo de Pago
	Par_NumCon				TINYINT UNSIGNED,		-- Numero de consulta

/* Parámetros de Auditoria */
	Par_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(20),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia	CHAR(1);				-- Cadena Vacia
	DECLARE Fecha_Vacia		DATE;					-- Fecha Vacia
	DECLARE Entero_Cero		INT(11);				-- Entero Vacio
	DECLARE Con_Principal	INT(11);				-- Consulta Principal
	DECLARE Con_Estatus		INT(11);				-- COnsulta Estatus
	DECLARE Con_TipoPago	INT(11);				-- COnsulta Tipo de Pago
	DECLARE Con_Envios		INT(11);				-- COnsulta de Envios
	DECLARE Con_EnviosFec	INT(11);				-- Consulta de Envios y Fechas
	DECLARE Con_TotEnvios	INT(11);				-- COnsulta cuenta total envios
	DECLARE Con_TotEnviar	INT(11);				-- Consulta cuenta total por enviar
	DECLARE Con_TotDevol	INT(11);				-- Consulta cuenta total devoluciones
	DECLARE Con_NumIntentos	INT(11);				-- Consulta numero de intentos de envio
	DECLARE Con_Firma		INT(11);				-- Consulta la Firma del SPEI
	DECLARE Con_CtaBenOrd	INT(11);				-- Consulta la informacion del SPEI por el numero de transaccion
	DECLARE Tp_tt			INT(2);					-- Tipo de Pago Tercero a Tercero
	DECLARE Tp_pp			INT(2);					-- Tipo de Pago Participante a Participante
	DECLARE Tp_pt			INT(2);					-- Tipo de Pago Participante a Tercero
	DECLARE Status_A		CHAR(1);				-- Status Autorizado
	DECLARE Status_E		CHAR(1);				-- Status Enviado
	DECLARE Status_V		CHAR(1);				-- Estatus Verificado
	DECLARE Status_D		CHAR(1);				-- Estatus Devuelto

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia		:= '';					-- Constante cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';		-- Constante Fecha vacia
	SET Entero_Cero			:= 0;					-- Constante entero cero
	SET Con_Principal		:= 1;					-- Consulta principal
	SET Con_Estatus			:= 2;					-- Consulta por estatus
	SET Con_TipoPago		:= 3;					-- Consulta por TipoPago
	SET Con_Envios			:= 4;					-- Consulta de envios
	SET Con_EnviosFec		:= 5;					-- Consulta de envios y fecha
	SET Con_TotEnvios		:= 6;					-- Consulta cuenta total envios
	SET Con_TotEnviar		:= 7;					-- Consulta cuenta total por enviar
	SET Con_TotDevol		:= 8;					-- Consulta cuenta total devoluciones
	SET Con_NumIntentos		:= 9;					-- Consulta el numero de intentos de envio de la orden de pago
	SET Con_Firma			:= 10;					-- Consulta la Firma del SPEI
	SET Con_CtaBenOrd		:= 11;					-- Consulta informacion del SPEi por el numero de transaccion
	SET Tp_tt				:= 1;					-- Tipo de pago tercero a tercero
	SET Tp_pp				:= 7;					-- Tipo de pago Participante a participante
	SET Tp_pt				:= 5;					-- Tipo de pago de participante a tercero
	SET Status_A			:= 'A';					-- Status de Autorizado
	SET Status_E			:= 'E';					-- Status de ENVIADO
	SET Status_V			:= 'V';					-- Estatus verificado
	SET Status_D			:= 'D';					-- Estatus devolucion

	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			FolioSpeiID,		ClaveRastreo,		TipoPagoID,				CuentaAho,				TipoCuentaOrd,
			FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,							FNDECRYPTSAFI(NombreOrd) AS NombreOrd,					FNDECRYPTSAFI(RFCOrd) AS RFCOrd,
			FORMAT(CONVERT( CASE WHEN FNDECRYPTSAFI(MontoTransferir) = '' THEN '0'
								 ELSE FNDECRYPTSAFI(MontoTransferir) END, DECIMAL(16,2)), 2) AS MontoTransferir,
			FORMAT(CONVERT( CASE WHEN FNDECRYPTSAFI(TotalCargoCuenta) = '' THEN '0'
								 ELSE FNDECRYPTSAFI(TotalCargoCuenta) END, DECIMAL(16,2)), 2) AS TotalCargoCuenta,					FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,
			FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,		FNDECRYPTSAFI(RFCBeneficiario) AS RFCBeneficiario,		FNDECRYPTSAFI(ConceptoPago) AS ConceptoPago,
			MonedaID,			TipoOperacion,
			IVAPorPagar,		ComisionTrans,		IVAComision,			InstiRemitenteID,	InstiReceptoraID,
			TipoCuentaBen,		CuentaBenefiDos,	NombreBenefiDos,		RFCBenefiDos,
			TipoCuentaBenDos,	ConceptoPagoDos,	ReferenciaCobranza,		ReferenciaNum,			PrioridadEnvio,
			FechaAutorizacion,	EstatusEnv,			ClavePago,				UsuarioEnvio,			AreaEmiteID,
			Estatus,			FechaRecepcion,		FechaEnvio,				CausaDevol,				FechaCan,
			Comentario,			FechaOperacion,		Firma,					Usuario,				DireccionIP,
			Sucursal,			OrigenOperacion
		FROM SPEIENVIOS
			WHERE FolioSpeiID = Par_Folio;
	END IF;

	IF(Par_NumCon = Con_Estatus) THEN
		SELECT
			FolioSpeiID,	ClaveRastreo,	TipoPagoID,		TipoCuentaOrd, FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,
			FNDECRYPTSAFI(NombreOrd) AS NombreOrd,			FORMAT(CONVERT( CASE WHEN FNDECRYPTSAFI(TotalCargoCuenta) = '' THEN '0'
																				 ELSE FNDECRYPTSAFI(TotalCargoCuenta) END, DECIMAL(16,2)),2) AS Total,
			FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario, FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,
			TipoCuentaBen,	EstatusEnv,		UsuarioEnvio,	Estatus
		FROM SPEIENVIOS
			WHERE FolioSpeiID = Par_Folio
			AND Estatus = Par_Estatus;
	END IF;

	IF(Par_NumCon = Con_TipoPago) THEN
		-- CONSULTA TIPO PAGO TERCERO A TERCERO
		IF(Par_TipoPagoID = Tp_tt) THEN
			SELECT
				FNDECRYPTSAFI(NombreOrd) AS NombreOrd,		TipoCuentaOrd,		FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,
				FNDECRYPTSAFI(RFCOrd) AS RFCOrd,								FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,
				TipoCuentaBen,
				FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,		FNDECRYPTSAFI(RFCBeneficiario) AS RFCBeneficiario,
				AreaEmiteID,	FNDECRYPTSAFI(ConceptoPago) AS ConceptoPago,	FORMAT(CONVERT( CASE WHEN FNDECRYPTSAFI(MontoTransferir) = '' THEN '0'
																									 ELSE FNDECRYPTSAFI(MontoTransferir) END, DECIMAL(16,2)),2) AS Monto,
				CONCAT(FORMAT(IVAPorPagar,2)) AS IVA,
				ReferenciaNum,								ReferenciaCobranza,	TipoPagoID,
				PrioridadEnvio,								ClaveRastreo,		InstiReceptoraID,
				UsuarioEnvio
			FROM SPEIENVIOS
				WHERE FolioSpeiID = Par_Folio
				AND TipoPagoID = Par_TipoPagoID;
		END IF;

		-- CONSULTA TIPO PAGO PARTICIPANTE A PARTICIPANTE
		IF(Par_TipoPagoID = Tp_pp) THEN
			SELECT
				AreaEmiteID,		FNDECRYPTSAFI(ConceptoPago) AS ConceptoPago,
				FORMAT(CONVERT( CASE WHEN FNDECRYPTSAFI(MontoTransferir) = '' THEN '0'
									 ELSE FNDECRYPTSAFI(MontoTransferir) END, DECIMAL (16,2)),2) AS Monto,
				CONCAT(FORMAT(IVAPorPagar,2)) AS IVA,	ReferenciaNum,		TipoPagoID,
				PrioridadEnvio,		ClavePago,			TipoOperacion,
				ClaveRastreo,		InstiReceptoraID,	UsuarioEnvio
			FROM SPEIENVIOS
				WHERE FolioSpeiID = Par_Folio
				AND TipoPagoID = Par_TipoPagoID;
		END IF;

		-- CONSULTA TIPO PAGO PARTICIPANTE A TERCERO
		IF(Par_TipoPagoID = Tp_pt) THEN
			SELECT
				FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,	TipoCuentaBen,	FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,
				FNDECRYPTSAFI(RFCBeneficiario) AS RFCBeneficiario,			AreaEmiteID,	FNDECRYPTSAFI(ConceptoPago) AS ConceptoPago,
				FORMAT(CONVERT( CASE WHEN FNDECRYPTSAFI(MontoTransferir) = '' THEN '0'
									 ELSE FNDECRYPTSAFI(MontoTransferir) END, DECIMAL(16,2)),2) AS Monto,		CONCAT(FORMAT(IVAPorPagar,2)) AS IVA,	ReferenciaNum,
				TipoPagoID,		PrioridadEnvio,		ClaveRastreo,			InstiReceptoraID,UsuarioEnvio
			FROM SPEIENVIOS
				WHERE FolioSpeiID = Par_Folio
				AND TipoPagoID = Par_TipoPagoID;
		END IF;
	END IF;

	IF(Par_NumCon = Con_Envios) THEN
		-- CONSULTA PARA ENVIAR ORDENES DE PAGO
		SELECT
			FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(NombreOrd)) AS NombreOrd,		TipoCuentaOrd,			FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(CuentaOrd)) AS CuentaOrd,
			CASE WHEN FNDECRYPTSAFI(RFCOrd) = '' THEN 'ND' ELSE FNDECRYPTSAFI(RFCOrd) END AS RFCOrd ,	FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(NombreBeneficiario)) AS NombreBeneficiario,
			TipoCuentaBen,																				FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(CuentaBeneficiario)) AS CuentaBeneficiario,
			CASE WHEN FNDECRYPTSAFI(RFCBeneficiario) = '' THEN 'ND' ELSE FNDECRYPTSAFI(RFCBeneficiario) END AS RFCBeneficiario ,
			AreaEmiteID,								FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(ConceptoPago)) AS ConceptoPago,
			FORMAT(CONVERT( CASE WHEN FNDECRYPTSAFI(MontoTransferir) = '' THEN '0'
								 ELSE FNDECRYPTSAFI(MontoTransferir) END, DECIMAL(16,2)),2) AS MontoTransferir,
			IVAPorPagar,
			Comentario,		ConceptoPagoDos,
			CASE
				WHEN ReferenciaNum = Entero_Cero THEN 'ND'
				WHEN ReferenciaNum != Entero_Cero THEN ReferenciaNum END AS RefNum,
			CASE
				WHEN ReferenciaCobranza = Entero_Cero THEN 'ND'
				WHEN ReferenciaCobranza != Entero_Cero THEN ReferenciaCobranza END AS ReferenciaCobranza,
			TipoPagoID,				ClavePago,
			PrioridadEnvio,			FolioSpeiID,		ClaveRastreo,
			InstiReceptoraID,		UsuarioEnvio,		CausaDevol,
			Firma,					PS.Topologia,		FolioSpeiID
		FROM SPEIENVIOS, PARAMETROSSPEI PS
			WHERE Estatus = Status_V
			ORDER BY PrioridadEnvio, FechaRecepcion ASC
		LIMIT 200;
	END IF;

	IF(Par_NumCon = Con_EnviosFec) THEN
		-- CONSULTA PARA ENVIAR ORDENES DE PAGO Y FECHA
		SELECT
			FNDECRYPTSAFI(NombreOrd) AS NombreOrd,		TipoCuentaOrd,			FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,
			FNDECRYPTSAFI(RFCOrd) AS RFCOrd,			FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,					TipoCuentaBen,
			FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,			FNDECRYPTSAFI(RFCBeneficiario) AS RFCBeneficiario,	AreaEmiteID,
			FNDECRYPTSAFI(ConceptoPago) AS ConceptoPago,						FORMAT(CONVERT( CASE WHEN FNDECRYPTSAFI(MontoTransferir) = '' THEN '0'
																									 ELSE FNDECRYPTSAFI(MontoTransferir) END, DECIMAL(16,2)),2) AS MontoTransferir,
			CONCAT(FORMAT(IVAPorPagar,2)) AS IVAPorPagar,
			Comentario,				ConceptoPagoDos,	ReferenciaNum,			ReferenciaCobranza,			TipoPagoID,
			ClavePago,				PrioridadEnvio,		FolioSpeiID,			ClaveRastreo,				InstiReceptoraID,
			UsuarioEnvio
		FROM SPEIENVIOS
			WHERE Estatus = Status_E AND (EstatusEnv !=10 AND EstatusEnv !=5 AND EstatusEnv !=6 AND EstatusEnv !=2
			AND EstatusEnv !=9)
		ORDER BY PrioridadEnvio, FechaRecepcion ASC;
	END IF;

	IF(Par_NumCon = Con_TotEnvios) THEN
	-- CONSULTA TOTAL DE ORDENES enviadas
		SELECT COUNT(ClaveRastreo) AS Tot_Spei
			FROM SPEIENVIOS
			WHERE Estatus = Status_E AND EstatusEnv != Entero_Cero;
	END IF;

	IF(Par_NumCon = Con_TotEnviar) THEN
	-- CONSULTA TOTAL DE ORDENES POR ENVIAR
		SELECT COUNT(ClaveRastreo) AS Tot_Spei
			FROM SPEIENVIOS
			WHERE Estatus = Status_V;
	END IF;

	IF(Par_NumCon = Con_TotDevol) THEN
	-- CONSULTA TOTAL DE ORDENES DEVUELTAS
		SELECT COUNT(ClaveRastreo) AS Tot_Spei
			FROM SPEIENVIOS
			WHERE Estatus = Status_D AND CausaDevol != Entero_Cero;
	END IF;

	IF(Par_NumCon = Con_NumIntentos) THEN
		SELECT NumIntentos
			FROM SPEIENVIOS
			WHERE FolioSpeiID = Par_Folio;
	END IF;

	IF(Par_NumCon = Con_Firma) THEN
	-- CONSULTA LA FIRMA DEL SPEI
		SELECT	FolioSpeiID,		Estatus,		Firma
			FROM SPEIENVIOS
			WHERE FolioSpeiID = Par_Folio;
	END IF;

	IF(Par_NumCon = Con_CtaBenOrd) THEN
		SELECT
			FolioSpeiID,			FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,		FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd
		FROM SPEIENVIOS
			WHERE NumTransaccion = Aud_NumTransaccion;
	END IF;
END TerminaStore$$