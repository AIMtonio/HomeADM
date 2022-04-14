-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAAMORTIZAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAAMORTIZAPRO`;DELIMITER $$

CREATE PROCEDURE `ARRENDAAMORTIZAPRO`(
	-- STORED PROCEDURE PARA GENERAR EL ALTA DE LAS AMORTIZACIONES
	Par_MontoFinanciado			DECIMAL(16,2),			-- 'MONTO A FINANCIAR',
	Par_MontoSegAnual			DECIMAL(16,2),			-- MONTO DEL SEGURO ANUALIZADO
	Par_MontoSegVidaAn 			DECIMAL(16,2),			-- MONTO DEL SEGURO DE VIDA ANUALIZADO
	Par_DiasPago  				CHAR(1),				-- DIAS PAGO FIN DE MES (F) ANIVERSARIO (A)
	Par_ValorResidual 			DECIMAL(16,2),			-- MONTO DEL VALOR RESIDUAL

	Par_FechaApertura 			DATE, 					-- FECHA DE APERTURA
	Par_Periodicidad			CHAR(1),				-- PERIODICIDAD MENSUAL(M)
	Par_Plazo 					INT(11), 				-- PLAZO
	Par_Tasa 					DECIMAL(16,2),			-- TASA DE INTERES ANUAL
	Par_DiaHabil				CHAR(1),				-- INDICA SI SE TRATA DE UN DIA HABIL SIGUIENTE (S)

	Par_ClienteID 				INT(11), 				-- IDE DEL CLIENTE
	Par_ArrendaID 				BIGINT(12), 			-- id de arrendamiento

	Par_RentaAnticipada			CHAR(1),				-- Parametro para indicar si se marca la primera cuota como pagada: S o N
	Par_RentasAdelantadas		INT(11),				-- Parametro para marcar las primeras/ultimas N cuotas como pagadas
	Par_Adelanto				CHAR(1),				-- Parametro para definir si se marcan las primeras (P) o las ultimas (U) N cuotas como pagadas

	Par_Salida 					CHAR(1), 				-- Salida Si o No
	INOUT Par_NumErr 			INT(11),                -- Control de Errores: Numero de Error
	INOUT Par_ErrMen 			VARCHAR(400), 			-- Control de Errores: Descripcion del Error
	INOUT Par_NumTransacSim 	BIGINT(20), 			-- NUMERO DE TRANSACCION DEL SIMULADOR

	INOUT Par_CantCuota 		INT(11),				-- 'Cantidad de Cuotas o amortizaciones que tiene el plan de pagos del Arrendamiento',
	INOUT Par_FechaPrimerVen	DATE,  					-- 'Fecha del Primer Pago del Arrendamiento',
	INOUT Par_FechaUltimoVen	DATE, 					-- 'Fecha del ultimo Pago del Arrendamiento',
	Aud_EmpresaID 				INT(11), 				-- Parametro de Auditoria
	Aud_Usuario 				INT(11),				-- Parametro de Auditoria

	Aud_FechaActual				DATETIME, 				-- Parametro de Auditoria
	Aud_DireccionIP 			VARCHAR(15), 			-- Parametro de Auditoria
	Aud_ProgramaID 				VARCHAR(50), 			-- Parametro de Auditoria
	Aud_Sucursal 				INT(11), 				-- Parametro de Auditoria
	Aud_NumTransaccion 			BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Control				VARCHAR(100);       -- Variable de control
	DECLARE VarConsecutivo 			BIGINT(12);			-- Consecutivo

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;				-- Fecha vacia
	DECLARE Entero_Cero				INT(11);			-- Entero cero
	DECLARE Entero_Uno				INT(11);			-- Entero uno
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Decimal cero
	DECLARE Var_SI					CHAR(1);			-- Variable si
	DECLARE Var_NO 					CHAR(1);			-- Variable no
	DECLARE Est_Generado			CHAR(1);			-- Estatus de Generado
	DECLARE Var_Contado				INT(11);			-- Contado
	DECLARE Var_Financiado 			INT(11);			-- Financiado

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia				:= ''; 				-- Cadena Vacia
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero					:= 0;				-- Entero en Cero
	SET Entero_Uno					:= 1;				-- Entero UNO
	SET Decimal_Cero 				:= 0; 				-- Decimal cero
	SET Var_SI						:= 'S';				-- Permite Salida SI
	SET Var_NO 						:= 'N';				-- Permite Salida NO

	-- ASIGNACION DE VARIABLES
	SET Aud_FechaActual				:= NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: SP-ARRENDAAMORTIZAPRO');
				SET Var_Control = 'sqlException';
			END;

		-- ********************************************************************************************
		-- SE MANDA A LLAMAR SP QUE GENERA EL CALENDARIO DE AMORTIZACIONES PARA RECALCULAR LAS CUOTAS
		-- ********************************************************************************************
		CALL ARRENDASIMPAGOSPRO(
			Par_MontoFinanciado,	Par_MontoSegAnual,		Par_MontoSegVidaAn,		Par_DiasPago, 		Par_ValorResidual,
			Par_FechaApertura,		Par_Periodicidad, 		Par_Plazo, 				Par_Tasa,			Par_DiaHabil,
			Par_ClienteID,			Par_RentaAnticipada,	Par_RentasAdelantadas,	Par_Adelanto,		Var_NO,
			Par_NumErr, 			Par_ErrMen,				Par_NumTransacSim,		Par_CantCuota, 		Par_FechaPrimerVen,
			Par_FechaUltimoVen,		Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion);

		-- ********************************************************************************************
		-- SE INSERTAN LAS AMORTIZACIONES DE ARRENDAMIENTO
		-- ********************************************************************************************

		CALL ARRENDAAMORTIALT(
		-- SP para GENERAR EL ALTA DE LAS AMORTIZACIONES
			Par_ArrendaID,			Par_ClienteID, 			Var_NO, 				Par_NumErr,			Par_ErrMen,
			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr      := 000;
		SET Var_Control     := 'fechaActual';
		SET Par_ErrMen      := CONCAT('Arrendamiento agregado exitosamente: ',VarConsecutivo);
	END ManejoErrores;

		-- Se muestran los datos
	IF (Par_Salida = Var_SI) THEN
		SELECT  Par_NumErr                  AS NumErr,
				Par_ErrMen                  AS ErrMen,
				Var_Control                 AS Control,
				LPAD(VarConsecutivo, 10, 0) AS Consecutivo;
	END IF;

END TerminaStore$$