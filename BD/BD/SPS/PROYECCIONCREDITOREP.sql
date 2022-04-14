-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROYECCIONCREDITOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROYECCIONCREDITOREP`;
DELIMITER $$


CREATE PROCEDURE `PROYECCIONCREDITOREP`(
/* Obtiene los datos para el reporte de proyeccion de credito generado en la pantalla de solicitud de credito */
	Par_ConvenioNominaID    BIGINT UNSIGNED,# Numero del Convenio de Nomina
	Par_Monto			DECIMAL(12,2),		# Monto a prestar
	Par_TasaFija		DECIMAL(12,4),		# Taza Anualizada
	Par_Frecuencia		CHAR(1),			# Frecuencia de capital, de pago semanal, mensual, quincenal, etc
	Par_FrecuenciaInt	CHAR(1),			# Frecuencia de interes, de pago semanal, mensual, quincenal, etc
	Par_Periodicidad	INT(11),			# Periodicidad de capital, no de dias correspondiente a la frecuencia

	Par_PeriodicidadInt	INT(11),			# Periodicidad de interes, no de dias correspondiente a la frecuencia
	Par_DiaPago			CHAR(1),			# Dia de pago de capital F fin de Mes, A aniversario, D dia del mes
	Par_DiaPagoInt		CHAR(1),			# Dia de pago de interes F fin de Mes, A aniversario, D dia del mes
	Par_DiaMes			INT(2),				# Solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para capital
	Par_DiaMesInt		INT(2),				# Solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para interes

	Par_FechaInicio		DATE,				# Fecha en que inicia la primer amortizacion
	Par_NumCuotas		INT,				# No. de amortizaciones de capital
	Par_NumCuotasInt	INT,				# No. de amortizaciones de capital
	Par_ProducCreditoID	INT,				# producto de credito
	Par_ClienteID		INT,				# Cliente al que se le dare el credito

	Par_DiaHabilSig		CHAR,				# Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)
	Par_AjustaFecAmo	CHAR,				# Indica si se ajusta a fecha de vencimiento  (S- Si) ultima amortizacion(N - no)
	Par_AjusFecExiVen	CHAR,				# Indica si se ajusta la fecha  de vencimiento a fecha de exigibilidad  (S- si se ajusta N- no se ajusta)
	Par_ComApertura		DECIMAL(14,2),		# Costo de la comision por apertura
	Par_CalculoInt		INT(11),			# tipo de calculo de interes
	Par_TipoCalculoInt	INT(11),			# tipo de calculo de interes

	Par_TipoPagCap		CHAR(1),			# Tipo de pago de capital
	Par_CAT				DECIMAL(14,4),		# Costo Anual Total
    Par_CobraSeguroCuota    CHAR(1),                -- Cobra Seguro por cuota
    Par_CobraIVASeguroCuota CHAR(1),                -- Cobra IVA Seguro por cuota
    Par_MontoSeguroCuota     DECIMAL(12,2),         -- Monto Seguro por Cuota

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
			)

TerminaStore: BEGIN

    /* Declaracion de Constantes */
    DECLARE SalidaNO			CHAR(1);		# No habra datos de salida
    DECLARE TasFija				INT;			# Tasa Fija
    DECLARE PagCrecientes		CHAR(1);		# Pago de capital crecientes
    DECLARE PagIguales			CHAR(1);		# Pagos iguales
    DECLARE PagLibres			CHAR(1);		# Pagos libres
    DECLARE TipoCalIntGlobal	INT;			# Tipo calculo interes  Monto Original (Saldos Globales)
    DECLARE Entero_Cero			INT;			# Entero Cero
    DECLARE Decimal_Cero		DECIMAL(14,2);  # Decimal Cero

    /* Declaracion de Variables */
    DECLARE Var_NumTransaccion	BIGINT;			# No. de transaccion que genera la simulaion
    DECLARE Var_NumErr			INT(11);		# No. de error generado
    DECLARE Var_ErrMen			VARCHAR(400);	# Descripcion del error
    DECLARE Var_NumCuotas		INT(11);		# No. de cuotas de capital
    DECLARE Var_NumCuotasInt	INT(11);		# No. de cuotas de interes
    DECLARE Var_MontoCuoProm	DECIMAL(14,4);	# Monto promedio de las cuotas
    DECLARE Var_FechaVen		DATE;			# Fecha de vencimiento

    /* Asignacion de constantes */
    SET SalidaNO				:= 'N';
	SET Entero_Cero				:= 0;
    SET TasFija					:= 1;
    SET PagCrecientes			:= 'C';
    SET PagIguales				:= 'I';
    SET PagLibres				:= 'L';
    SET TipoCalIntGlobal		:= 2;
    SET Decimal_Cero			:= 0.00;
    -- -------------------------------------------------------------------------------------------
    IF(Par_TipoCalculoInt = TipoCalIntGlobal) THEN
    	DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Aud_NumTransaccion;
    			CALL PRINCIPALSIMSALGLOPRO (
					Par_ConvenioNominaID,
    				Par_Monto,				Par_TasaFija,				Par_Periodicidad,		Par_Frecuencia,				Par_DiaPago,
    				Par_DiaMes,				Par_FechaInicio,			Par_NumCuotas,			Par_ProducCreditoID,		Par_ClienteID,
    				Par_DiaHabilSig,		Par_AjustaFecAmo,			Par_AjusFecExiVen,		Par_ComApertura,			Decimal_Cero,
    				Par_CobraSeguroCuota,	Par_CobraIVASeguroCuota,	Par_MontoSeguroCuota,	Entero_Cero,			SalidaNO,
                    Var_NumErr,				Var_ErrMen,					Var_NumTransaccion,		Var_NumCuotas,	 			Par_CAT,
                    Var_MontoCuoProm,		Var_FechaVen,				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,
                    Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

    ELSE

    		IF(Par_CalculoInt = TasFija ) THEN
    			CASE Par_TipoPagCap
    				WHEN PagCrecientes THEN
    					/* -- tasa fija pagos crecientes*/
    					CALL CREPAGCRECAMORPRO (
							Par_ConvenioNominaID,
    						Par_Monto,				Par_TasaFija,				Par_Periodicidad,		Par_Frecuencia,			Par_DiaPago,
    						Par_DiaMes,				Par_FechaInicio,			Par_NumCuotas,			Par_ProducCreditoID,	Par_ClienteID,
    						Par_DiaHabilSig,		Par_AjustaFecAmo,			Par_AjusFecExiVen,		Par_ComApertura,		Decimal_Cero,
    						Par_CobraSeguroCuota, 	Par_CobraIVASeguroCuota, 	Par_MontoSeguroCuota,	Entero_Cero,			SalidaNO,
                            Var_NumErr,				Var_ErrMen,					Var_NumTransaccion,		Var_NumCuotas,			Par_CAT,
                            Var_MontoCuoProm,		Var_FechaVen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
                            Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

    				WHEN PagIguales THEN
    					# tasa fija, pagos iguales
    					CALL PRINCIPALSIMPAGIGUAPRO (
							Par_ConvenioNominaID,
    						Par_Monto,				Par_TasaFija,				Par_Periodicidad,		Par_PeriodicidadInt,		Par_Frecuencia,
    						Par_FrecuenciaInt,		Par_DiaPago,				Par_DiaPagoInt,			Par_FechaInicio,			Par_NumCuotas,
    						Par_NumCuotasInt,		Par_ProducCreditoID,		Par_ClienteID,			Par_DiaHabilSig,			Par_AjustaFecAmo,
    						Par_AjusFecExiVen,		Par_DiaMesInt,				Par_DiaMes,				Par_ComApertura,			Decimal_Cero,
    						Par_CobraSeguroCuota, 	Par_CobraIVASeguroCuota, 	Par_MontoSeguroCuota,	Entero_Cero,				SalidaNO,
                            Var_NumErr,				Var_ErrMen,					Var_NumTransaccion,		Var_NumCuotas,				Var_NumCuotasInt,
                            Par_CAT,				Var_MontoCuoProm,			Var_FechaVen,			Par_EmpresaID,				Aud_Usuario,
                            Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);


    				WHEN PagLibres THEN
    					SET Var_NumTransaccion := Aud_NumTransaccion;
    				END CASE ;
    		END IF;



    		-- ----------------------------------------------------------------------------------------------
    		# Tasa variable, pagos iguales
    		IF(Par_CalculoInt != TasFija ) THEN
    			IF(Par_TipoPagCap = PagIguales )THEN

    				CALL PRINCIPALSIMPAGIGUAPRO (
						Par_ConvenioNominaID,
						Par_Monto,				Par_TasaFija,				Par_Periodicidad,		Par_PeriodicidadInt,		Par_Frecuencia,
						Par_FrecuenciaInt,		Par_DiaPago,				Par_DiaPagoInt,			Par_FechaInicio,			Par_NumCuotas,
						Par_NumCuotasInt,		Par_ProducCreditoID,		Par_ClienteID,			Par_DiaHabilSig,			Par_AjustaFecAmo,
						Par_AjusFecExiVen,		Par_DiaMesInt,				Par_DiaMes,				Par_ComApertura,			Decimal_Cero,
						Par_CobraSeguroCuota, 	Par_CobraIVASeguroCuota, 	Par_MontoSeguroCuota,	Entero_Cero,				SalidaNO,
                        Var_NumErr,				Var_ErrMen,					Var_NumTransaccion,		Var_NumCuotas,				Var_NumCuotasInt,
                        Par_CAT,				Var_MontoCuoProm,			Var_FechaVen,			Par_EmpresaID,				Aud_Usuario,
                        Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);
    			END IF;
    		END IF;

    END IF; # fin de tipo de pago de capital



    	# Obtiene las amortizaciones calculadas de la tabla temporal en las que se han guardado por los sp
    		SELECT Tmp_Consecutivo AS Cuota,	Tmp_FecIni AS FechaInicio,		Tmp_FecFin AS FechaVencimiento,
    				   Tmp_FecVig AS FechaPago,		Tmp_Capital AS Capital,			Tmp_Interes AS Interes,
    				   Tmp_Iva AS IVAInteres,		Tmp_SubTotal AS TotalCuota,		Tmp_Insoluto AS SaldoCapital,
    				   Tmp_MontoSeguroCuota AS MontoSeguroCuota,
                       Tmp_IVASeguroCuota AS IVASeguroCuota,
                       Tmp_OtrasComisiones AS MontoOtrasComisiones,
                       Tmp_IVAOtrasComisiones AS MontoIVAOtrasComisiones
    				FROM TMPPAGAMORSIM
    				WHERE NumTransaccion = Var_NumTransaccion;


    	# Elimina amortizaciones temporales si no se trata de un pago de capital libre
    	IF(Par_TipoPagCap != PagLibres) THEN
    			DELETE
    				FROM TMPPAGAMORSIM
    				WHERE NumTransaccion= Var_NumTransaccion;
    	END IF;

END TerminaStore$$