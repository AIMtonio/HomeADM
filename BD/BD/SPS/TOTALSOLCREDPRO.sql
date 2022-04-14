-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TOTALSOLCREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TOTALSOLCREDPRO`;
DELIMITER $$


CREATE PROCEDURE `TOTALSOLCREDPRO`(
/* Obtiene los datos para el reporte de proyeccion de credito generado en la pantalla de solicitud de credito */
	Par_SolicitudCreditoID 		INT(11),		-- Numero de la solicitud de credito
    OUT Par_ImporteTotal		DECIMAL(12,2),	-- Importe total calculado capital + intereses + iva
    OUT Par_NumCuotas			INT(11),		-- Numero total de las cuotas

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(12)
		)

TerminaStore: BEGIN

/* Declaracion de Constantes */
DECLARE SalidaNO			CHAR(1);		# No habra datos de salida
DECLARE Entero_Cero			INT;
DECLARE TasFija				INT;			# Tasa Fija
DECLARE PagCrecientes		CHAR(1);		# Pago de capital crecientes
DECLARE PagIguales			CHAR(1);		# Pagos iguales
DECLARE PagLibres			CHAR(1);		# Pagos libres
DECLARE TipoCalIntGlobal	INT;			# Tipo calculo interes  Monto Original (Saldos Globales)
DECLARE Decimal_Cero		DECIMAL(14,2);  # Decimal Cero
DECLARE Cons_SI				CHAR(1);

/* Declaracion de Variables */
DECLARE Var_NumTransaccion	BIGINT;			# No. de transaccion que genera la simulaion
DECLARE Var_NumErr			INT(11);		# No. de error generado
DECLARE Var_ErrMen			VARCHAR(100);	# Descripcion del error
DECLARE Var_MontoCuoProm	DECIMAL(14,4);	# Monto promedio de las cuotas
DECLARE Var_FechaVen		DATE;			# Fecha de vencimiento

DECLARE Var_Monto			DECIMAL(12,2);		# Monto a prestar
DECLARE Var_TasaFija		DECIMAL(12,4);		# Taza Anualizada
DECLARE Var_Frecuencia		CHAR(1);			# Frecuencia de capital; de pago semanal, mensual, quincenal, etc
DECLARE Var_FrecuenciaInt	CHAR(1);			# Frecuencia de interes, de pago semanal, mensual, quincenal, etc
DECLARE Var_Periodicidad	INT(11);			# Periodicidad de capital, no de dias correspondiente a la frecuencia

DECLARE Var_PeriodicidadInt	INT(11);			# Periodicidad de interes, no de dias correspondiente a la frecuencia
DECLARE Var_DiaPago			CHAR(1);			# Dia de pago de capital F fin de Mes, A aniversario, D dia del mes
DECLARE Var_DiaPagoInt		CHAR(1);			# Dia de pago de interes F fin de Mes, A aniversario, D dia del mes
DECLARE Var_DiaMes			INT(2);				# Solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para capital
DECLARE Var_DiaMesInt		INT(2);				# Solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para interes

DECLARE Var_FechaInicio		DATE;				# Fecha en que inicia la primer amortizacion
DECLARE Var_NumCuotas		INT;				# No. de amortizaciones de capital
DECLARE Var_NumCuotasInt	INT;				# No. de amortizaciones de capital
DECLARE Var_ProducCreditoID	INT;				# producto de credito
DECLARE Var_ClienteID		INT;				# Cliente al que se le dara el credito

DECLARE Var_DiaHabilSig		CHAR;				# Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)
DECLARE Var_AjustaFecAmo	CHAR;				# Indica si se ajusta a fecha de vencimiento  (S- Si) ultima amortizacion(N - no)
DECLARE Var_AjusFecExiVen	CHAR;				# Indica si se ajusta la fecha  de vencimiento a fecha de exigibilidad  (S- si se ajusta N- no se ajusta)
DECLARE Var_ComApertura		DECIMAL(14,2);		# Costo de la comision por apertura
DECLARE Var_CalculoInt		INT(11);			# tipo de calculo de interes
DECLARE Var_TipoCalculoInt	INT(11);			# tipo de calculo de interes

DECLARE Var_TipoPagCap		CHAR(1);			# Tipo de pago de capital
DECLARE Var_CAT				DECIMAL(14,4);		# Costo Anual Total
#SEGUROS -------------------------------------------------------------------------------
DECLARE Var_CobraSeguroCuota CHAR(1);			-- Cobra Seguro por cuota
DECLARE Var_CobraIVASeguroCuota CHAR(1);		-- Cobra IVA seguro por cuota
DECLARE Var_MontoSeguroCuota DECIMAL(12,2);		-- Cobra seguro por cuota el credito
DECLARE Var_ConvenioNomina		BIGINT UNSIGNED;	-- Convenio de nomina

/* Asignacion de constantes */
SET SalidaNO				:= 'N';
SET Entero_Cero				:= 0;
SET Cons_SI					:= 'S';
SET TasFija					:= 1;
SET PagCrecientes			:= 'C';
SET PagIguales				:= 'I';
SET PagLibres				:= 'L';
SET TipoCalIntGlobal		:= 2;
SET Decimal_Cero			:= 0.00;

CALL TRANSACCIONESPRO(Aud_NumTransaccion);

SET Var_NumTransaccion:=Aud_NumTransaccion;

SELECT 	MontoAutorizado,		TasaFija,			FrecuenciaCap,		FrecuenciaInt,			PeriodicidadCap,
		PeriodicidadInt,		DiaPagoCapital,		DiaPagoInteres,		DiaMesCapital,			DiaMesInteres,
		FechaInicio,			NumAmortizacion,	NumAmortInteres,	ProductoCreditoID,		ClienteID,
        Cons_SI,				AjusFecUlVenAmo,	AjusFecExiVen,		MontoPorComAper,		CalcInteresID,
        TipoCalInteres,			TipoPagoCapital,	ValorCAT,			CobraSeguroCuota,		CobraIVASeguroCuota,
		MontoSeguroCuota,		ConvenioNominaID
 INTO
		Var_Monto,				Var_TasaFija,		Var_Frecuencia,		Var_FrecuenciaInt,		Var_Periodicidad,
		Var_PeriodicidadInt,	Var_DiaPago,		Var_DiaPagoInt,		Var_DiaMes,				Var_DiaMesInt,
		Var_FechaInicio,		Var_NumCuotas,		Var_NumCuotasInt,	Var_ProducCreditoID,	Var_ClienteID,
        Var_DiaHabilSig,		Var_AjustaFecAmo,	Var_AjusFecExiVen,	Var_ComApertura,		Var_CalculoInt,
        Var_TipoCalculoInt,		Var_TipoPagCap, 	Var_CAT, 			Var_CobraSeguroCuota, Var_CobraIVASeguroCuota,
		Var_MontoSeguroCuota,	Var_ConvenioNomina
    FROM  SOLICITUDCREDITO
		WHERE SolicitudCreditoID=Par_SolicitudCreditoID;

		SET Var_CobraSeguroCuota := IFNULL(Var_CobraSeguroCuota, 'N');
		SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota, 'N');
		SET Var_MontoSeguroCuota := IFNULL(Var_MontoSeguroCuota, Entero_Cero);

-- -------------------------------------------------------------------------------------------
IF(Var_TipoCalculoInt = TipoCalIntGlobal) THEN
	DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Aud_NumTransaccion;
			CALL PRINCIPALSIMSALGLOPRO (
				Var_ConvenioNomina,
				Var_Monto,				Var_TasaFija,				Var_Periodicidad,		Var_Frecuencia,				Var_DiaPago,
				Var_DiaMes,				Var_FechaInicio,			Var_NumCuotas,			Var_ProducCreditoID,		Var_ClienteID,
				Var_DiaHabilSig,		Var_AjustaFecAmo,			Var_AjusFecExiVen,		Var_ComApertura,			Decimal_Cero,
				Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Entero_Cero,				SalidaNO,
                Var_NumErr,				Var_ErrMen,					Var_NumTransaccion,		Var_NumCuotas,				Var_CAT,
                Var_MontoCuoProm,		Var_FechaVen,				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,
                Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

ELSE
	IF(Var_CalculoInt = TasFija ) THEN
		CASE Var_TipoPagCap
			WHEN PagCrecientes THEN
				/* -- tasa fija pagos crecientes*/
				CALL CREPAGCRECAMORPRO (
					Var_ConvenioNomina,
					Var_Monto,				Var_TasaFija,				Var_Periodicidad,		Var_Frecuencia,			Var_DiaPago,
					Var_DiaMes,				Var_FechaInicio,			Var_NumCuotas,			Var_ProducCreditoID,	Var_ClienteID,
					Var_DiaHabilSig,		Var_AjustaFecAmo,			Var_AjusFecExiVen,		Var_ComApertura,		Decimal_Cero,
					Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Entero_Cero,			SalidaNO,
                    Var_NumErr,				Var_ErrMen,					Var_NumTransaccion,		Var_NumCuotas,			Var_CAT,
                    Var_MontoCuoProm,		Var_FechaVen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
                    Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

			WHEN PagIguales THEN
				# tasa fija, pagos iguales
				CALL PRINCIPALSIMPAGIGUAPRO (
					Var_ConvenioNomina,
					Var_Monto,				Var_TasaFija,				Var_Periodicidad,		Var_PeriodicidadInt,		Var_Frecuencia,
					Var_FrecuenciaInt,		Var_DiaPago,				Var_DiaPagoInt,			Var_FechaInicio,			Var_NumCuotas,
					Var_NumCuotasInt,		Var_ProducCreditoID,		Var_ClienteID,			Var_DiaHabilSig,			Var_AjustaFecAmo,
					Var_AjusFecExiVen,		Var_DiaMesInt,				Var_DiaMes,				Var_ComApertura,			Decimal_Cero,
					Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Entero_Cero,				SalidaNO,
                    Var_NumErr,				Var_ErrMen,					Var_NumTransaccion,		Var_NumCuotas,				Var_NumCuotasInt,
                    Var_CAT,				Var_MontoCuoProm,			Var_FechaVen,			Par_EmpresaID,				Aud_Usuario,
                    Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			WHEN PagLibres THEN
				SET Var_NumTransaccion := Aud_NumTransaccion;
			END CASE ;
	END IF;

	# Tasa variable, pagos iguales
	IF(Var_CalculoInt != TasFija ) THEN
		IF(Var_TipoPagCap = PagIguales )THEN
			CALL PRINCIPALSIMPAGIGUAPRO (
					Var_ConvenioNomina,
					Var_Monto,				Var_TasaFija,				Var_Periodicidad,		Var_PeriodicidadInt,		Var_Frecuencia,
					Var_FrecuenciaInt,		Var_DiaPago,				Var_DiaPagoInt,			Var_FechaInicio,			Var_NumCuotas,
					Var_NumCuotasInt,		Var_ProducCreditoID,		Var_ClienteID,			Var_DiaHabilSig,			Var_AjustaFecAmo,
					Var_AjusFecExiVen,		Var_DiaMesInt,				Var_DiaMes,				Var_ComApertura,			Decimal_Cero,
					Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota, 	Entero_Cero,				SalidaNO,
                    Var_NumErr,				Var_ErrMen,					Var_NumTransaccion,		Var_NumCuotas,				Var_NumCuotasInt,
                    Var_CAT,				Var_MontoCuoProm,			Var_FechaVen,			Par_EmpresaID,				Aud_Usuario,
                    Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);
		END IF;
	END IF;

END IF; # fin de tipo de pago de capital

# Obtiene el total del Importe de la tabla temporal en las que se han guardado por los sp
SELECT 	SUM(Tmp_Capital + Tmp_Interes + Tmp_Iva + IFNULL(Tmp_MontoSeguroCuota,0) + IFNULL(Tmp_IVASeguroCuota,0))
INTO 	Par_ImporteTotal
	FROM TMPPAGAMORSIM
		WHERE NumTransaccion = Var_NumTransaccion;

SET Par_ImporteTotal 	:= IFNULL(Par_ImporteTotal,Var_Monto);
SET Par_NumCuotas		:= IFNULL(Var_NumCuotas,Entero_Cero);
DELETE
	FROM TMPPAGAMORSIM
		WHERE NumTransaccion= Var_NumTransaccion;

END TerminaStore$$