-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONGENAMORTIZAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONGENAMORTIZAPRO`;
DELIMITER $$


CREATE PROCEDURE `FONGENAMORTIZAPRO`(
/*SP QUE SE EJECUTA CUANDO PARA GENERAR LAS AMORTIZACIONES DEL CREDITO*/
	Par_CreditoID			BIGINT(20),		# ID del credito

	Par_Salida				CHAR(1),
	INOUT Par_NumTranSim 	BIGINT,
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_CuotasCap			INT(11);	/* numero de cuotas de capital que devuelve el simulador*/
	DECLARE Var_CuotasInt			INT(11);	/* numero de cuotas de Interes que devuelve el simulador*/
	DECLARE	Var_Monto				DECIMAL(14,2);
	DECLARE	Var_TasaFija			DECIMAL(12,4);
	DECLARE	Var_PeriodicidadCap 	INT(11);
	DECLARE	Var_PeriodicidadInt		INT(11);
	DECLARE	Var_FrecuenciaInt		CHAR(1);
	DECLARE	Var_DiaPagoCapital  	CHAR(1);
	DECLARE	Var_DiaPagoInteres		CHAR(1);
	DECLARE	Var_FechaInicio			DATE;
	DECLARE	Var_NumAmortInteres		INT(11);
	DECLARE	Var_FechaInhabil		CHAR(1);
	DECLARE	Var_AjusFecUlVenAmo		CHAR(1);
	DECLARE	Var_AjusFecExiVen		CHAR(1);
	DECLARE	Var_DiaMesCapital		INT(11);
	DECLARE	Var_PagaIva				CHAR(1);
	DECLARE	Var_PorcentanjeIVA		DECIMAL(12,2);
	DECLARE	Var_CobraISR			CHAR(1);
	DECLARE	Var_MargenPriCuota		INT(11);
	DECLARE	Var_MontoCuota			DECIMAL(12,2);
	DECLARE	Var_FechaVencimien		DATE;
	DECLARE Var_NumAmortizacion		INT(11);
	DECLARE Var_TasaISR				DECIMAL(12,2);
	DECLARE Var_NumTransacSim		BIGINT(20);
	DECLARE Var_DiaMesInteres 		INT(11)	;
	DECLARE Var_FrecuenciaCap		CHAR(1);
	DECLARE Var_CapitalizaInteres	CHAR(1);
	DECLARE Var_TipoCalInteres		INT(11);
	DECLARE Var_CalcInteresID		INT(11);
	DECLARE Var_TipoPagoCapital		CHAR(1)	;
	DECLARE Var_MargenPagIgual		DECIMAL(12,2);
	DECLARE	Var_Control				VARCHAR(100);

	-- DECLARACION DE CONSTANTES
	DECLARE Salida_NO 			CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE	Fecha_Vacia			DATE;			/* Fecha Vacia*/
	DECLARE	Est_Vigente			CHAR(1);		/* Estatus Vigente corresponde con tabla CREDITOFONDEO */
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE SaldosInsolutos		INT(11);		/* Tipo de calculo de interes Saldos Insolutos*/
	DECLARE String_SI			CHAR(1);
	DECLARE TasaFijaVal			INT(11);		/* Indica el valor para la formula de tasa fija*/
	DECLARE TipoPagoCrecientes	CHAR(1);
	DECLARE TipoPagoIguales		CHAR(1);
	DECLARE TipoPagoLibres 		CHAR(1);

	-- asignacion de conatantes
	SET Salida_NO 				:='N';
	SET Salida_SI				:='S';
	SET Entero_Cero				:=0;
	SET	Fecha_Vacia				:= '1900-01-01';	/* Fecha Vacia */
	SET	Est_Vigente				:= 'N';				/* Estatus Vigente corresponde con tabla CREDITOFONDEO/AMORTIZAFONDEO */
	SET Decimal_Cero			:=0.0;
	SET SaldosInsolutos			:= 1;				/* Tipo de calculo de interes Saldos Insolutos*/
	SET String_SI				:='S';
	SET TasaFijaVal				:= 1; 				/* Indica el valor para la formula de tasa fija*/
	SET TipoPagoCrecientes		:= 'C'; 			/* Indica el tipo de pago de capital Creciente */
	SET TipoPagoIguales			:= 'I'; 			/* Indica el tipo de pago de capital Igual */
	SET TipoPagoLibres 			:= 'L';				/* Indica el tipo de pago de capital Libre*/
ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-FONGENAMORTIZAPRO');
		END;


	SELECT  Monto,				TasaFija,			PeriodicidadCap,	PeriodicidadInt,	FrecuenciaInt,
			DiaPagoCapital,		DiaPagoInteres, 	FechaInicio, 		NumAmortInteres,	FechaInhabil,
			AjusFecUlVenAmo, 	AjusFecExiVen,		DiaMesCapital,		PagaIva,			PorcentanjeIVA,
			CobraISR, 			MargenPriCuota, 	MontoCuota,			FechaVencimien, 	NumAmortizacion,
			TasaISR, 			NumTransacSim,		DiaMesInteres,		FrecuenciaCap, 		CapitalizaInteres,
			TipoCalInteres,		CalcInteresID, 		TipoPagoCapital,	MargenPagIgual
		INTO
			Var_Monto,				Var_TasaFija,		Var_PeriodicidadCap,	Var_PeriodicidadInt,	Var_FrecuenciaInt,
			Var_DiaPagoCapital,		Var_DiaPagoInteres, Var_FechaInicio, 		Var_NumAmortInteres,	Var_FechaInhabil,
			Var_AjusFecUlVenAmo, 	Var_AjusFecExiVen,	Var_DiaMesCapital,		Var_PagaIva,			Var_PorcentanjeIVA,
			Var_CobraISR, 			Var_MargenPriCuota, Var_MontoCuota,			Var_FechaVencimien,		Var_NumAmortizacion,
			Var_TasaISR, 			Var_NumTransacSim,	Var_DiaMesInteres, 		Var_FrecuenciaCap, 		Var_CapitalizaInteres,
			Var_TipoCalInteres, 	Var_CalcInteresID,	Var_TipoPagoCapital, 	Var_MargenPagIgual
		FROM CREDITOFONDEO
			WHERE CreditoFondeoID = Par_CreditoID ;

	/* Se recrea el cotizador dependiendo del tipo de calculo.*/
	IF(Var_TipoCalInteres = SaldosInsolutos) THEN /* Si se trata de Saldos Insolutos.*/
		IF(Var_CapitalizaInteres =	String_SI ) THEN /* Si capitaliza interes*/
			CALL FONCAPCAPAMORPRO( /* simula cuotas de pagos iguales de  capital con capitalizacion */
				Var_Monto, 				Var_TasaFija,			Var_PeriodicidadCap,	Var_PeriodicidadInt,	Var_FrecuenciaCap,
				Var_FrecuenciaInt,		Var_DiaPagoCapital,		Var_DiaPagoInteres,		Var_FechaInicio,		Var_NumAmortInteres,
				Var_FechaInhabil,		Var_AjusFecUlVenAmo,	Var_AjusFecExiVen,		Var_DiaMesInteres,		Var_DiaMesCapital,
				Var_PagaIva,			Var_PorcentanjeIVA,		Var_CobraISR,			Var_TasaISR,			Var_MargenPriCuota,
				Salida_NO,				Par_NumErr,				Par_ErrMen,				Var_NumTransacSim,		Var_CuotasCap,
				Var_CuotasInt,			Var_MontoCuota,			Var_FechaVencimien,		Par_EmpresaID,			Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF (Par_NumErr!=Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumTranSim := Aud_NumTransaccion;

		ELSE
			IF(Var_CalcInteresID =	TasaFijaVal ) THEN /* Si se trata de Tasa Fija.*/
				CASE Var_TipoPagoCapital
					WHEN TipoPagoCrecientes THEN

						CALL FONPAGCRECAMORPRO( /* simula cuotas de pagos crecientes de  capital */
							Var_Monto,			Var_TasaFija,			Var_PeriodicidadCap,		Var_FrecuenciaCap,		Var_DiaPagoCapital,
							Var_DiaMesCapital,	Var_FechaInicio,		Var_NumAmortizacion,		Var_PagaIva,			Var_PorcentanjeIVA,
							Var_FechaInhabil,	Var_AjusFecUlVenAmo,	Var_AjusFecExiVen,			Salida_NO,				Var_MargenPagIgual,
							Var_CobraISR,		Var_TasaISR,			Var_MargenPriCuota,			Par_NumErr,				Par_ErrMen,
							Var_NumTransacSim,	Var_CuotasCap,			Var_MontoCuota,				Var_FechaVencimien,		Par_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
							Aud_NumTransaccion);

						IF (Par_NumErr!=Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

						SET Par_NumTranSim := Aud_NumTransaccion;

					WHEN TipoPagoIguales THEN
						CALL FONPAGIGUAMORPRO( /* simula cuotas de pagos iguales de  capital */
							Var_Monto, 				Var_TasaFija,			Var_PeriodicidadCap,	Var_PeriodicidadInt,	Var_FrecuenciaCap,
							Var_FrecuenciaInt,		Var_DiaPagoCapital,		Var_DiaPagoInteres,		Var_FechaInicio,		Var_NumAmortizacion,
							Var_NumAmortInteres,	Var_FechaInhabil,		Var_AjusFecUlVenAmo,	Var_AjusFecExiVen,		Var_DiaMesInteres,
							Var_DiaMesCapital,		Var_PagaIva,			Var_PorcentanjeIVA,		Var_CobraISR,			Var_TasaISR,
							Var_MargenPriCuota,		Salida_NO,				Par_NumErr,				Par_ErrMen,				Var_NumTransacSim,
							Var_CuotasCap,			Var_CuotasInt,			Var_MontoCuota,			Var_FechaVencimien,		Par_EmpresaID,
							Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
							Aud_NumTransaccion);

						IF (Par_NumErr!=Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

						SET Par_NumTranSim := Aud_NumTransaccion;

					WHEN TipoPagoLibres THEN
						SET Par_NumTranSim := Par_NumTranSim;
				END CASE;	-- No se ocupa
			ELSE /* si no es tasa fija entonces es tasa variable*/
				CASE Var_TipoPagoCapital
					WHEN TipoPagoCrecientes THEN  /*se valida tasa variable */
						SET Par_NumErr := 03;
						SET Par_ErrMen := CONCAT("Con tasa variable, no se permiten pagos de capital Creciente.");
						LEAVE ManejoErrores;
					WHEN TipoPagoIguales THEN
						CALL FONTASVARAMORPRO(	/* SP que simula cuotas con tasa variable*/
							Var_Monto,				Var_PeriodicidadCap,	Var_PeriodicidadInt,	Var_FrecuenciaCap,		Var_FrecuenciaInt,
							Var_DiaPagoCapital,		Var_DiaPagoInteres,		Var_FechaInicio,		Var_NumAmortizacion,	Var_NumAmortInteres,
							Var_FechaInhabil,		Var_AjusFecUlVenAmo,	Var_AjusFecExiVen,		Var_DiaMesInteres,		Var_DiaMesCapital,
							Var_TasaFija,			Var_PagaIva,			Var_TasaISR,			Salida_NO,				Par_NumErr,
							Par_ErrMen,				Var_NumTransacSim,		Var_MontoCuota,			Var_FechaVencimien,		Var_CuotasCap,
							Var_CuotasInt,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
							Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

						IF (Par_NumErr!=Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

						SET Par_NumTranSim := Aud_NumTransaccion;

					WHEN TipoPagoLibres THEN
						SET Par_NumTranSim := Par_NumTranSim;
				END CASE;
			END IF;
		END IF;
	END IF;


	/* Se insertar las amortizaciones de fondeo */
	INSERT INTO AMORTIZAFONDEO (
		CreditoFondeoID,	AmortizacionID,		FechaInicio,		FechaVencimiento,		FechaExigible,
		FechaLiquida,		Estatus,			Capital,			Interes,				IVAInteres,
		SaldoCapVigente,	SaldoCapAtrasad,	SaldoInteresAtra,	SaldoInteresPro,		SaldoIVAInteres,
		SaldoMoratorios,	SaldoIVAMora,		SaldoComFaltaPa,	SaldoIVAComFalP,		SaldoOtrasComis,
		SaldoIVAComisi,		ProvisionAcum,		SaldoCapital,		EmpresaID,				Usuario,
		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,				NumTransaccion,
		Retencion,			SaldoRetencion)

	SELECT
		Par_CreditoID,		Tmp_Consecutivo,	Tmp_FecIni,			Tmp_FecFin,				Tmp_FecVig,
		Fecha_Vacia,		Est_Vigente,		Tmp_Capital,		Tmp_Interes,			Tmp_Iva,
		CASE WHEN Var_CapitalizaInteres =	String_SI AND Tmp_Capital >Entero_Cero THEN /* Si capitaliza interes*/
		Var_Monto ELSE Tmp_Capital END ,		Decimal_Cero,		Decimal_Cero,			Decimal_Cero,
		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,			Decimal_Cero,
		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Tmp_Capital,			Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion,	Tmp_Retencion,		Decimal_Cero
	FROM TMPPAGAMORSIM
		WHERE NumTransaccion = Par_NumTranSim
			AND Tmp_Consecutivo >Entero_Cero ;

	SET Par_NumErr	:= Entero_Cero;
	SET Par_ErrMen	:= "Amortizaciones Generadas Correctamente";
	SET Var_Control	:= 'creditoFondeoID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$
