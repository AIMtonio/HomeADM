-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIRECEPCIONESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESCON`;DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESCON`(
# ===========================================================
# ------- STORE PARA CONSULTAR LAS RECEPCIONES SPEI ---------
# ===========================================================
	Par_NumeroRecep    	BIGINT(20),				-- Numero de recepcion
	Par_Estatus       	CHAR(1),                -- Estatus SAFI
	Par_EstatusRecep   	INT(3),                 -- Estatus
	Par_TipoPagoID    	INT(2),                 -- Cuenta de ahorroID
	Par_NumCon			TINYINT UNSIGNED,       -- Tipo de consulta

	/* Parámetros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore:BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Con_Principal	INT(11);
	DECLARE	Con_Estatus		CHAR;
	DECLARE	Con_Recepciones	INT(11);
	DECLARE	Con_TotReci		INT(11);


	-- ASIGNACION  DE CONSTANTES
	SET	Cadena_Vacia	:= '';				-- Constante cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Constante Fecha vacia
	SET	Entero_Cero		:= 0;				-- Constante entero cero
	SET	Con_Principal	:= 1;				-- Consulta principal
	SET	Con_Estatus		:= 2;				-- COnsulta por estatus
	SET	Con_Recepciones	:= 3;				-- COnsulta de recepciones
	SET Con_TotReci		:= 4;				-- Consulta total de recepciones

	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			FolioSpeiRecID,							TipoPagoID,			TipoCuentaOrd,		FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,
			FNDECRYPTSAFI(NombreOrd) AS NombreOrd,	FNDECRYPTSAFI(RFCOrd) AS RFCOrd,		TipoOperacion,
			FORMAT(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),2) AS MontoTransferir,
			CONCAT(FORMAT(IVAComision,2)) AS IVA,	InstiRemitenteID,	InstiReceptoraID,	FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,
			FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,	FNDECRYPTSAFI(RFCBeneficiario) AS RFCBeneficiario,
			TipoCuentaBen,							FNDECRYPTSAFI(ConceptoPago) AS ConceptoPago,
			ClaveRastreo,							CuentaBenefiDos,	NombreBenefiDos,	RFCBenefiDos,
			TipoCuentaBenDos,						ConceptoPagoDos,	ClaveRastreoDos,	ReferenciaCobranza,
			ReferenciaNum,							Estatus,			PrioridadEnvio,		FechaOperacion,
			FechaCaptura,							ClavePago,			AreaEmiteID,		EstatusRecep,
			CausaDevol,								InfAdicional,		RepOperacion,		Firma,
			Folio,									FolioBanxico,		FolioPaquete,		FolioServidor,
			Topologia
		FROM SPEIRECEPCIONES
			WHERE	NumeroRecep	= Par_NumeroRecep;
	END IF;


	IF(Par_NumCon = Con_Estatus) THEN
		SELECT
			FolioSpeiRecID,							TipoPagoID,			TipoCuentaOrd,		FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,
			FNDECRYPTSAFI(NombreOrd) AS NombreOrd,	FNDECRYPTSAFI(RFCOrd) AS RFCOrd,		TipoOperacion,
			FORMAT(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),2) AS MontoTransferir,
			CONCAT(FORMAT(IVAComision,2)) AS IVA,	InstiRemitenteID,	InstiReceptoraID,	FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,
			FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,	FNDECRYPTSAFI(RFCBeneficiario) AS RFCBeneficiario,
			TipoCuentaBen,							FNDECRYPTSAFI(ConceptoPago) AS ConceptoPago,
			ClaveRastreo,							Estatus,			Firma
		FROM SPEIRECEPCIONES
			WHERE	NumeroRecep	= Par_NumeroRecep
			  AND	Estatus		= Par_Estatus;
	END IF;


	IF(Par_NumCon = Con_Recepciones) THEN
		-- CONSULTA PARA RECIBIR ORDENES DE PAGO
		SELECT
			FolioSpeiRecID,		FNDECRYPTSAFI(NombreOrd) AS NombreOrd,		TipoCuentaOrd,		FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,
			FNDECRYPTSAFI(RFCOrd) AS RFCOrd,
			FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,
			TipoCuentaBen,		FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,
			FNDECRYPTSAFI(RFCBeneficiario) AS RFCBeneficiario,				ClaveRastreo,
			FNDECRYPTSAFI(ConceptoPago) AS ConceptoPago,
			FORMAT(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),2) AS MontoTransferir,
			CONCAT(FORMAT(IVAComision,2)) AS IVA,
			InstiRemitenteID,	InstiReceptoraID,	ReferenciaNum,			ReferenciaCobranza,	TipoPagoID,
			ClavePago,			Prioridad,			Firma,					Folio,				FechaOperacion
		FROM SPEIRECEPCIONES
			WHERE	FechaOperacion	= Fecha_Vacia
			ORDER BY Prioridad,FechaCaptura ASC;
	END IF;


	IF(Par_NumCon = Con_TotReci) THEN
		-- CONSULTA TOTAL DE RECIBIDOS
		SELECT	COUNT(ClaveRastreo) AS Tot_Recepciones
			FROM SPEIRECEPCIONES;
	END IF;

END TerminaStore$$