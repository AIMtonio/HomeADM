-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTESTREPSPEIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPTESTREPSPEIPRO`;DELIMITER $$

CREATE PROCEDURE `TMPTESTREPSPEIPRO`(
	Par_Salida		CHAR(1),
	Par_NumErr		INT(11),
	Par_ErrMen		VARCHAR(400),

	Par_EmpresaID	INT(11),
	Aud_Usuario		INT(11),
	Aud_FechaActual	DATETIME,
	Aud_DireccionIP	VARCHAR(20),
	Aud_ProgramaID	VARCHAR(50),
	Aud_Sucursal	INT(11),
	Aud_NumTransaccion BIGINT(20)
)
TerminaStore:BEGIN
	/*Declaracion de Variables*/
	DECLARE Var_Control			VARCHAR(400);
	DECLARE Var_FolioSPEI		INT(11);
	DECLARE Var_NumTransaccion	BIGINT(20);
	DECLARE Var_CreditoID		INT(11);
	DECLARE Var_MontoPago		DECIMAL(14,2);

	-- PAGO DE CREDITO 100017636
	-- ==================================================================================================================================
	SET Var_CreditoID := 100017636;
	SET Var_MontoPago := 600.00;
	SET Var_FolioSPEI := 0;
	CALL TRANSACCIONESPRO(Var_NumTransaccion);
	CALL SPEIRECEPCIONESPRO(
		/*INOUT Par_FolioSpei,			Par_TipoPago,			Par_TipoCuentaOrd,			Par_CuentaOrd,			Par_NombreOrd,
		Par_RFCOrd,						Par_TipoOperacion,		Par_MontoTransferir,		Par_IVA,				Par_InstiRemitente,
		Par_InstiReceptora,				Par_CuentaBeneficiario,	Par_NombreBeneficiario,		Par_RFCBeneficiario,	Par_TipoCuentaBen,
		Par_ConceptoPago,				Par_ClaveRastreo,		Par_CuentaBenefiDos,		Par_NombreBenefiDos,	Par_RFCBenefiDos,
		Par_TipoCuentaBenDos,			Par_ConceptoPagoDos,	Par_ClaveRastreoDos,		Par_ReferenciaCobranza,	Par_ReferenciaNum,
		Par_Prioridad,					Par_FechaCaptura,		Par_ClavePago,				Par_AreaEmiteID,		Par_EstatusRecep,
		Par_CausaDevol,					Par_InfAdicional,		Par_Firma,					Par_Folio,				Par_FolioBanxico,
		Par_FolioPaquete,				Par_FolioServidor,		Par_Topologia,				Par_Salida,				INOUT Par_NumErr,
		INOUT Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Aud_NumTransaccion*/
		Var_FolioSPEI,					1,						40,							100018535,				'JUAN DE JESUS RAMIREZ',
		'',								0,						Var_MontoPago,				0.16,					40002,
		0,								637523001000176362,		'JUAN DE JESUS RAMIREZ',	'',						40,
		'PAGO DE CREDITO',				'2019-PC-001',			'',							'',						'',
		40,								'PAGO DE CREDITO',		'2019-PC-001',				'',						12345,
		0,								NOW(),					'',							0,						0,
		0,								'',						'637523001000176362',		0,						0,
		1001,							1001,					'T',						'N',					Par_NumErr,
		Par_ErrMen,						Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Var_NumTransaccion);

	INSERT INTO TMPTESTREPSPEI VALUES
		(Var_FolioSPEI,		Var_CreditoID, 		Var_MontoPago,		'PAGO DE CREDITO',			Par_NumErr,		Par_ErrMen);
	-- ==================================================================================================================================

	-- PAGO DE CREDITO INFERIOR 100017644
	-- ==================================================================================================================================
	SET Var_CreditoID := 100017644;
	SET Var_MontoPago := 500.00;
	SET Var_FolioSPEI := 0;
	CALL TRANSACCIONESPRO(Var_NumTransaccion);
	CALL SPEIRECEPCIONESPRO(
		/*INOUT Par_FolioSpei,			Par_TipoPago,			Par_TipoCuentaOrd,			Par_CuentaOrd,			Par_NombreOrd,
		Par_RFCOrd,						Par_TipoOperacion,		Par_MontoTransferir,		Par_IVA,				Par_InstiRemitente,
		Par_InstiReceptora,				Par_CuentaBeneficiario,	Par_NombreBeneficiario,		Par_RFCBeneficiario,	Par_TipoCuentaBen,
		Par_ConceptoPago,				Par_ClaveRastreo,		Par_CuentaBenefiDos,		Par_NombreBenefiDos,	Par_RFCBenefiDos,
		Par_TipoCuentaBenDos,			Par_ConceptoPagoDos,	Par_ClaveRastreoDos,		Par_ReferenciaCobranza,	Par_ReferenciaNum,
		Par_Prioridad,					Par_FechaCaptura,		Par_ClavePago,				Par_AreaEmiteID,		Par_EstatusRecep,
		Par_CausaDevol,					Par_InfAdicional,		Par_Firma,					Par_Folio,				Par_FolioBanxico,
		Par_FolioPaquete,				Par_FolioServidor,		Par_Topologia,				Par_Salida,				INOUT Par_NumErr,
		INOUT Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Aud_NumTransaccion*/
		Var_FolioSPEI,					1,						40,							100014467,				'MARIO ESPINAL GARCIA',
		'',								0,						Var_MontoPago,				0.16,					40002,
		0,								637523001000176443,		'MARIO ESPINAL GARCIA',		'',						40,
		'PAGO DE CREDITO',				'2019-PC-006',			'',							'',						'',
		40,								'PAGO DE CREDITO',		'2019-PC-006',				'',						12359,
		0,								NOW(),					'',							0,						0,
		0,								'',						'637523001000176443',		0,						0,
		1001,							1001,					'T',						'N',					Par_NumErr,
		Par_ErrMen,						Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Var_NumTransaccion);

	INSERT INTO TMPTESTREPSPEI VALUES
		(Var_FolioSPEI,		Var_CreditoID, 		Var_MontoPago,		'PAGO DE CREDITO INFERIOR',			Par_NumErr,		Par_ErrMen);
	-- ==================================================================================================================================

	-- PAGO y PREPAGO DE CREDITO 100017644
	-- ==================================================================================================================================
	SET Var_CreditoID := 100017644;
	SET Var_MontoPago := 250.00;
	SET Var_FolioSPEI := 0;
	CALL TRANSACCIONESPRO(Var_NumTransaccion);
	CALL SPEIRECEPCIONESPRO(
		/*INOUT Par_FolioSpei,			Par_TipoPago,			Par_TipoCuentaOrd,			Par_CuentaOrd,			Par_NombreOrd,
		Par_RFCOrd,						Par_TipoOperacion,		Par_MontoTransferir,		Par_IVA,				Par_InstiRemitente,
		Par_InstiReceptora,				Par_CuentaBeneficiario,	Par_NombreBeneficiario,		Par_RFCBeneficiario,	Par_TipoCuentaBen,
		Par_ConceptoPago,				Par_ClaveRastreo,		Par_CuentaBenefiDos,		Par_NombreBenefiDos,	Par_RFCBenefiDos,
		Par_TipoCuentaBenDos,			Par_ConceptoPagoDos,	Par_ClaveRastreoDos,		Par_ReferenciaCobranza,	Par_ReferenciaNum,
		Par_Prioridad,					Par_FechaCaptura,		Par_ClavePago,				Par_AreaEmiteID,		Par_EstatusRecep,
		Par_CausaDevol,					Par_InfAdicional,		Par_Firma,					Par_Folio,				Par_FolioBanxico,
		Par_FolioPaquete,				Par_FolioServidor,		Par_Topologia,				Par_Salida,				INOUT Par_NumErr,
		INOUT Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Aud_NumTransaccion*/
		Var_FolioSPEI,					1,						40,							100014467,				'MARIO ESPINAL GARCIA',
		'',								0,						Var_MontoPago,				0.16,					40002,
		0,								637523001000176443,		'MARIO ESPINAL GARCIA',		'',						40,
		'PAGO DE CREDITO',				'2019-PC-002',			'',							'',						'',
		40,								'PAGO DE CREDITO',		'2019-PC-002',				'',						12346,
		0,								NOW(),					'',							0,						0,
		0,								'',						'637523001000176443',		0,						0,
		1001,							1001,					'T',						'N',					Par_NumErr,
		Par_ErrMen,						Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Var_NumTransaccion);

	INSERT INTO TMPTESTREPSPEI VALUES
		(Var_FolioSPEI,		Var_CreditoID, 		Var_MontoPago,		'PAGO Y PREPAGO DE CREDITO',			Par_NumErr,		Par_ErrMen);
	-- ==================================================================================================================================

	-- PREPAGO DE CREDITO 100017652
	-- ==================================================================================================================================
	SET Var_CreditoID := 100017652;
	SET Var_MontoPago := 500.00;
	SET Var_FolioSPEI := 0;
	CALL TRANSACCIONESPRO(Var_NumTransaccion);
	CALL SPEIRECEPCIONESPRO(
		/*INOUT Par_FolioSpei,			Par_TipoPago,			Par_TipoCuentaOrd,			Par_CuentaOrd,			Par_NombreOrd,
		Par_RFCOrd,						Par_TipoOperacion,		Par_MontoTransferir,		Par_IVA,				Par_InstiRemitente,
		Par_InstiReceptora,				Par_CuentaBeneficiario,	Par_NombreBeneficiario,		Par_RFCBeneficiario,	Par_TipoCuentaBen,
		Par_ConceptoPago,				Par_ClaveRastreo,		Par_CuentaBenefiDos,		Par_NombreBenefiDos,	Par_RFCBenefiDos,
		Par_TipoCuentaBenDos,			Par_ConceptoPagoDos,	Par_ClaveRastreoDos,		Par_ReferenciaCobranza,	Par_ReferenciaNum,
		Par_Prioridad,					Par_FechaCaptura,		Par_ClavePago,				Par_AreaEmiteID,		Par_EstatusRecep,
		Par_CausaDevol,					Par_InfAdicional,		Par_Firma,					Par_Folio,				Par_FolioBanxico,
		Par_FolioPaquete,				Par_FolioServidor,		Par_Topologia,				Par_Salida,				INOUT Par_NumErr,
		INOUT Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Aud_NumTransaccion*/
		Var_FolioSPEI,					1,						40,							100000491,				'SERGIO ACEVEDO CRUZ',
		'',								0,						Var_MontoPago,				0.16,					40002,
		0,								637832001000176529,		'SERGIO ACEVEDO CRUZ',		'',						40,
		'PREPAGO DE CREDITO',			'2019-PC-003',			'',							'',						'',
		40,								'PREPAGO DE CREDITO',	'2019-PC-003',				'',						12347,
		0,								NOW(),					'',							0,						0,
		0,								'',						'637832001000176529',		0,						0,
		1001,							1001,					'T',						'N',					Par_NumErr,
		Par_ErrMen,						Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Var_NumTransaccion);

	INSERT INTO TMPTESTREPSPEI VALUES
		(Var_FolioSPEI,		Var_CreditoID, 		Var_MontoPago,		'PREPAGO DE CREDITO',			Par_NumErr,		Par_ErrMen);
	-- ==================================================================================================================================

	-- PAGO DE CREDITO 100017661
	-- ==================================================================================================================================
	SET Var_CreditoID := 100017661;
	SET Var_MontoPago := 480.00;
	SET Var_FolioSPEI := 0;
	CALL TRANSACCIONESPRO(Var_NumTransaccion);
	CALL SPEIRECEPCIONESPRO(
		/*INOUT Par_FolioSpei,			Par_TipoPago,			Par_TipoCuentaOrd,			Par_CuentaOrd,			Par_NombreOrd,
		Par_RFCOrd,						Par_TipoOperacion,		Par_MontoTransferir,		Par_IVA,				Par_InstiRemitente,
		Par_InstiReceptora,				Par_CuentaBeneficiario,	Par_NombreBeneficiario,		Par_RFCBeneficiario,	Par_TipoCuentaBen,
		Par_ConceptoPago,				Par_ClaveRastreo,		Par_CuentaBenefiDos,		Par_NombreBenefiDos,	Par_RFCBenefiDos,
		Par_TipoCuentaBenDos,			Par_ConceptoPagoDos,	Par_ClaveRastreoDos,		Par_ReferenciaCobranza,	Par_ReferenciaNum,
		Par_Prioridad,					Par_FechaCaptura,		Par_ClavePago,				Par_AreaEmiteID,		Par_EstatusRecep,
		Par_CausaDevol,					Par_InfAdicional,		Par_Firma,					Par_Folio,				Par_FolioBanxico,
		Par_FolioPaquete,				Par_FolioServidor,		Par_Topologia,				Par_Salida,				INOUT Par_NumErr,
		INOUT Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Aud_NumTransaccion*/
		Var_FolioSPEI,					1,						40,							1000004037,				'RENE GARCIA ANDRES',
		'',								0,						Var_MontoPago,				0.16,					40002,
		0,								637523001176362,		'RENE GARCIA ANDRES',		'',						40,
		'PAGO DE CREDITO',				'2019-PC-004',			'',							'',						'',
		40,								'PAGO DE CREDITO',		'2019-PC-004',				'',						12348,
		0,								NOW(),					'',							0,						0,
		0,								'',						'637523001176362',			0,						0,
		1001,							1001,					'T',						'N',					Par_NumErr,
		Par_ErrMen,						Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Var_NumTransaccion);

	INSERT INTO TMPTESTREPSPEI VALUES
		(Var_FolioSPEI,		Var_CreditoID, 		Var_MontoPago,		'PREPAGO DE CREDITO INVALIDO',			Par_NumErr,		Par_ErrMen);
	-- ==================================================================================================================================

	-- PREPAGO DE CREDITO 100017636
	-- ==================================================================================================================================
	SET Var_CreditoID := 100017636;
	SET Var_MontoPago := 650.00;
	SET Var_FolioSPEI := 0;
	CALL TRANSACCIONESPRO(Var_NumTransaccion);
	CALL SPEIRECEPCIONESPRO(
		/*INOUT Par_FolioSpei,			Par_TipoPago,			Par_TipoCuentaOrd,			Par_CuentaOrd,			Par_NombreOrd,
		Par_RFCOrd,						Par_TipoOperacion,		Par_MontoTransferir,		Par_IVA,				Par_InstiRemitente,
		Par_InstiReceptora,				Par_CuentaBeneficiario,	Par_NombreBeneficiario,		Par_RFCBeneficiario,	Par_TipoCuentaBen,
		Par_ConceptoPago,				Par_ClaveRastreo,		Par_CuentaBenefiDos,		Par_NombreBenefiDos,	Par_RFCBenefiDos,
		Par_TipoCuentaBenDos,			Par_ConceptoPagoDos,	Par_ClaveRastreoDos,		Par_ReferenciaCobranza,	Par_ReferenciaNum,
		Par_Prioridad,					Par_FechaCaptura,		Par_ClavePago,				Par_AreaEmiteID,		Par_EstatusRecep,
		Par_CausaDevol,					Par_InfAdicional,		Par_Firma,					Par_Folio,				Par_FolioBanxico,
		Par_FolioPaquete,				Par_FolioServidor,		Par_Topologia,				Par_Salida,				INOUT Par_NumErr,
		INOUT Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Aud_NumTransaccion*/
		Var_FolioSPEI,					1,						40,							100018535,				'JUAN DE JESUS RAMIREZ',
		'',								0,						Var_MontoPago,				0.16,					40002,
		0,								637523001000176362,		'MARIO ESPINAL GARCIA',		'',						40,
		'JUAN DE JESUS RAMIREZ',		'2019-PC-005',			'',							'',						'',
		40,								'PREPAGO DE CREDITO',	'2019-PC-005',				'',						12349,
		0,								NOW(),					'',							0,						0,
		0,								'',						'637523001000176362',		0,						0,
		1001,							1001,					'T',						'N',					Par_NumErr,
		Par_ErrMen,						Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,					Aud_Sucursal,			Var_NumTransaccion);

	INSERT INTO TMPTESTREPSPEI VALUES
		(Var_FolioSPEI,		Var_CreditoID, 		Var_MontoPago,		'PREPAGO DE CREDITO VALIDO',			Par_NumErr,		Par_ErrMen);
	-- ==================================================================================================================================

END TerminaStore$$