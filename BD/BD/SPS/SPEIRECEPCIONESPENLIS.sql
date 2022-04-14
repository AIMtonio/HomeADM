-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIRECEPCIONESPENLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESPENLIS`;
DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESPENLIS`(
	-- STORED PROCEDURE QUE SE ENCARGA DE PASAR AL HISTORICO LA INFORMACION DE UNA RECEPCION PENDIETE DE SPEI
	Par_PIDTarea				VARCHAR(50),		-- ID de la tarea encargada del proceso de recepcion
	Par_NumLis					TINYINT,			-- Numero de actualizacion

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- Parametro de Auditoria
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(20),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);				-- Cadena VAcia
	DECLARE	Fecha_Vacia				DATE;					-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);				-- Entero Cero
	DECLARE Lis_PIDTarea			TINYINT;				-- Lista por PID de Tarea
	
	-- Asignacion de constantes
	SET	Cadena_Vacia				:= '';					-- Cadena VAcia
	SET	Fecha_Vacia					:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero					:= 0;					-- Entero Cero
	SET Lis_PIDTarea				:= 1;					-- Lista por PID de Tarea

	-- Opcion 1 .- Lista de Recepciones pendientes de Envio por PID de Tarea
	IF(Par_NumLis = Lis_PIDTarea) THEN
		SELECT 	SpeiRecepcionPenID,								TipoPagoID,				TipoCuentaOrd,			FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,						FNDECRYPTSAFI(NombreOrd) AS NombreOrd,
				IVAComision,									TipoOperacion,			InstiRemitenteID,		FNDECRYPTSAFI(MontoTransferir) as MontoTransferir,			FNDECRYPTSAFI(RFCOrd) RFCOrd,
				FNDECRYPTSAFI(RFCBeneficiario) RFCBeneficiario,	InstiReceptoraID,		TipoCuentaBen,			FNDECRYPTSAFI(CuentaBeneficiario) as CuentaBeneficiario,	FNDECRYPTSAFI(NombreBeneficiario) as NombreBeneficiario,
				FNDECRYPTSAFI(ConceptoPago) ConceptoPago,		ClaveRastreo,			CuentaBenefiDos,		NombreBenefiDos,											RFCBenefiDos,
				TipoCuentaBenDos,								ConceptoPagoDos,		ClaveRastreoDos,		ReferenciaCobranza,											ReferenciaNum,
				Estatus,										Prioridad,				FechaOperacion,			FechaCaptura,												ClavePago,
				AreaEmiteID,									EstatusRecep,			CausaDevol,				InfAdicional,												RepOperacion,
				Firma,											Folio,					FolioBanxico,			FolioPaquete,												FolioServidor,
				Topologia,										Empresa,				Usuario,				FechaActual,												DireccionIP,
				ProgramaID,										Sucursal,				NumTransaccion
			FROM SPEIRECEPCIONESPEN
			WHERE PIDTarea = Par_PIDTarea;
	END IF;
END TerminaStore$$ 