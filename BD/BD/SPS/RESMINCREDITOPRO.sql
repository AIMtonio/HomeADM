-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESMINCREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESMINCREDITOPRO`;
DELIMITER $$


CREATE PROCEDURE `RESMINCREDITOPRO`(
/*SP para el Respaldo de los Creditos cuando se realizan desembolsos o cancelaciones de ministraciones. */
	Par_CreditoID			BIGINT(12),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_InverEnGar  	INT;

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Estatus_Vigente		CHAR(1);
	DECLARE SalidaSI        	CHAR(1);
	DECLARE SalidaNO        	CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia    := '';          -- Cadena Vacia
	SET Entero_Cero     := 0;           -- Entero en Cero
	SET Decimal_Cero    := 0;           -- Decimal en Cero
	SET Estatus_Vigente := 'N';			-- Estatus Inversion: VIGENTE
	SET SalidaSI        := 'S';         -- El Store si Regresa una Salida
	SET SalidaNO        := 'N';         -- El Store no Regresa una Salida

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-RESMINCREDITOPRO');
		END;

		-- Respaldo de la informacion  de la tabla  CREDITOS antes del proceso de pago de credito
		INSERT INTO RESCREDITOSMIN (
			TranRespaldo,			CreditoID,				LineaCreditoID,			ClienteID,				CuentaID,
			MonedaID,				ProductoCreditoID,		DestinoCreID,			MontoCredito,			Relacionado,
			SolicitudCreditoID,		TipoFondeo,				InstitFondeoID,			LineaFondeo,	 		FechaInicio,
			FechaVencimien,			CalcInteresID,			TasaBase,				TasaFija,		  		SobreTasa,
			PisoTasa,				TechoTasa,				FactorMora,				FrecuenciaCap,  		PeriodicidadCap,
			FrecuenciaInt,			PeriodicidadInt,		TipoPagoCapital,		NumAmortizacion,		MontoCuota,
			FechTraspasVenc,		FechTerminacion,		IVAInteres,				IVAComisiones,			Estatus,
			FechaAutoriza,			UsuarioAutoriza,		SaldoCapVigent,			SaldoCapAtrasad,		SaldoCapVencido,
			SaldCapVenNoExi,		SaldoInterOrdin,		SaldoInterAtras,		SaldoInterVenc, 		SaldoInterProvi,
			SaldoIntNoConta,		SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMorator,		SaldComFaltPago,
			SalIVAComFalPag,		SaldoComServGar,        SaldoIVAComSerGar,      SaldoOtrasComis,		SaldoIVAComisi,
			ProvisionAcum,			PagareImpreso,          FechaInhabil,			CalendIrregular,		DiaPagoInteres,
			DiaPagoCapital, 		DiaMesInteres,          DiaMesCapital,			AjusFecUlVenAmo,  		AjusFecExiVen,
			NumTransacSim,  		FechaMinistrado,        FolioDispersion,		SucursalID,				ValorCAT,
			ClasifRegID,	  		MontoComApert,          IVAComApertura,			PlazoID,				TipoDispersion,
			TipoCalInteres,			MontoDesemb,            MontoPorDesemb,			NumAmortInteres,		AporteCliente,
			MontoSeguroVida,		SeguroVidaPagado,       ForCobroSegVida,		ComAperPagado,			ForCobroComAper,
			ClasiDestinCred,		CicloGrupo,             GrupoID,				SaldoMoraVencido,		SaldoMoraCarVen,
			MontoSeguroCuota,		IVASeguroCuota,         SaldoComAnual,			ComAperCont,			IVAComAperCont,
			ComAperReest,			IVAComAperReest,        FechaAtrasoCapital,		FechaAtrasoInteres,
			EmpresaID,				Usuario,				FechaActual,            DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion )
		SELECT
			Aud_NumTransaccion,		CreditoID,				LineaCreditoID,			ClienteID,	  			CuentaID,
			MonedaID,				ProductoCreditoID,		DestinoCreID,			MontoCredito,	 		Relacionado,
			SolicitudCreditoID,		TipoFondeo,				InstitFondeoID,			LineaFondeo,			FechaInicio,
			FechaVencimien,			CalcInteresID,			TasaBase,				TasaFija,		 		SobreTasa,
			PisoTasa,				TechoTasa,				FactorMora,				FrecuenciaCap,  		PeriodicidadCap,
			FrecuenciaInt,			PeriodicidadInt,		TipoPagoCapital,		NumAmortizacion,		MontoCuota,
			FechTraspasVenc,		FechTerminacion,		IVAInteres,				IVAComisiones,  		Estatus,
			FechaAutoriza,			UsuarioAutoriza,		SaldoCapVigent,			SaldoCapAtrasad,		SaldoCapVencido,
			SaldCapVenNoExi,		SaldoInterOrdin,		SaldoInterAtras,		SaldoInterVenc, 		SaldoInterProvi,
			SaldoIntNoConta,		SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMorator,		SaldComFaltPago,
			SalIVAComFalPag,		SaldoComServGar,        SaldoIVAComSerGar,      SaldoOtrasComis,		SaldoIVAComisi,
			ProvisionAcum,  		PagareImpreso,          FechaInhabil,			CalendIrregular,		DiaPagoInteres,
			DiaPagoCapital, 		DiaMesInteres,          DiaMesCapital,			AjusFecUlVenAmo,  		AjusFecExiVen,
			NumTransacSim,  		FechaMinistrado,        FolioDispersion,		SucursalID,				ValorCAT,
			ClasifRegID,	  		MontoComApert,          IVAComApertura,			PlazoID,				TipoDispersion,
			TipoCalInteres,  		MontoDesemb,            MontoPorDesemb,			NumAmortInteres,		AporteCliente,
			MontoSeguroVida,		SeguroVidaPagado,       ForCobroSegVida,		ComAperPagado,			ForCobroComAper,
			ClasiDestinCred,		CicloGrupo,             GrupoID,				SaldoMoraVencido,		SaldoMoraCarVen,
			MontoSeguroCuota,		IVASeguroCuota,         SaldoComAnual,			ComAperCont,			IVAComAperCont,
			ComAperReest, 			IVAComAperReest,        FechaAtrasoCapital,		FechaAtrasoInteres,
			EmpresaID,				Usuario,				FechaActual,            DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;


		-- Respaldo de la informacion  de la tabla AMORTICREDITO antes del pago de Credito
		INSERT INTO RESAMORTICREDITOMIN (
			TranRespaldo,			AmortizacionID,			CreditoID,				ClienteID,				CuentaID,
			FechaInicio,			FechaVencim,			FechaExigible,			Estatus,				FechaLiquida,
			Capital,				Interes,				IVAInteres,				SaldoCapVigente,		SaldoCapAtrasa,
			SaldoCapVencido,		SaldoCapVenNExi,		SaldoInteresOrd,		SaldoInteresAtr,		SaldoInteresVen,
			SaldoInteresPro,		SaldoIntNoConta,		SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMorato,
			SaldoComFaltaPa,		SaldoIVAComFalP,        SaldoComServGar,        SaldoIVAComSerGar,		SaldoOtrasComis,
			SaldoIVAComisi,			ProvisionAcum,          SaldoCapital,			NumProyInteres,			SaldoMoraVencido,
			SaldoMoraCarVen,		MontoSeguroCuota,       IVASeguroCuota,			SaldoSeguroCuota,		SaldoIVASeguroCuota,
			SaldoComisionAnual,		SaldoComisionAnualIVA,  EmpresaID,				Usuario,				FechaActual,
			DireccionIP,			ProgramaID,             Sucursal,				NumTransaccion)
		SELECT
			Aud_NumTransaccion,		AmortizacionID,			CreditoID,		 		ClienteID,				CuentaID,
			FechaInicio,			FechaVencim,			FechaExigible,	 		Estatus,				FechaLiquida,
			Capital,				Interes,				IVAInteres,		 		SaldoCapVigente,		SaldoCapAtrasa,
			SaldoCapVencido,		SaldoCapVenNExi,		SaldoInteresOrd,	 	SaldoInteresAtr,		SaldoInteresVen,
			SaldoInteresPro,		SaldoIntNoConta,		SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMorato,
			SaldoComFaltaPa,		SaldoIVAComFalP,        SaldoComServGar,        SaldoIVAComSerGar,		SaldoOtrasComis,
			SaldoIVAComisi,			ProvisionAcum,          SaldoCapital,			NumProyInteres,			SaldoMoraVencido,
			SaldoMoraCarVen,		MontoSeguroCuota,       IVASeguroCuota,			SaldoSeguroCuota,		SaldoIVASeguroCuota,
			SaldoComisionAnual,		SaldoComisionAnualIVA,  EmpresaID,				Usuario,				FechaActual,
			DireccionIP,			ProgramaID,             Sucursal,				NumTransaccion
		FROM AMORTICREDITO
		WHERE CreditoID = Par_CreditoID;

		-- Respalda la informacion de la tabla CREDITOSMOVS antes del proceso de pago del credito
		INSERT INTO RESCREDITOSMOVSMIN (
			TranRespaldo,			CreditoID,				AmortiCreID,			Transaccion,			FechaOperacion,
			FechaAplicacion,		TipoMovCreID,			NatMovimiento,			MonedaID,				Cantidad,
			Descripcion,			Referencia,				EmpresaID,				Usuario,				FechaActual,
			DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
		SELECT
			Aud_NumTransaccion,		CreditoID,				AmortiCreID,			Transaccion,			FechaOperacion,
			FechaAplicacion,		TipoMovCreID,			NatMovimiento,			MonedaID,				Cantidad,
			Descripcion,			Referencia,				EmpresaID,				Usuario,				FechaActual,
			DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion
		FROM CREDITOSMOVS
		WHERE CreditoID = Par_CreditoID;

		-- Respaldo de inversiones en Garantia
		SET Var_InverEnGar	:= (SELECT COUNT(CreditoID) FROM CREDITOINVGAR WHERE CreditoID = Par_CreditoID);
		SET Var_InverEnGar	:= IFNULL(Var_InverEnGar, Entero_Cero);

		IF(Var_InverEnGar > Entero_Cero)THEN
			-- Respalda La informacion de la table CREDITOINVGAR antes del proceso de pago del credito
			INSERT INTO RESCREDITOINVGARMIN (
				TranRespaldo,			CreditoInvGarID,		CreditoID,	 		InversionID,		MontoEnGar,
				FechaAsignaGar,			EmpresaID,				Usuario,			FechaActual,		DireccionIP,
				ProgramaID,				Sucursal,				NumTransaccion)
			SELECT
				Aud_NumTransaccion,		CI.CreditoInvGarID,		CI.CreditoID,		CI.InversionID,		CI.MontoEnGar,
				CI.FechaAsignaGar,		CI.EmpresaID,			CI.Usuario,			CI.FechaActual,		CI.DireccionIP,
				CI.ProgramaID,			CI.Sucursal,			CI.NumTransaccion
			FROM CREDITOINVGAR CI
			INNER JOIN INVERSIONES Inv ON Inv.InversionID = CI.InversionID AND Inv.Estatus = Estatus_Vigente
			WHERE CI.CreditoID = Par_CreditoID;
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Repaldo de Creditos Exitoso.';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Poliza AS control,
				Aud_NumTransaccion AS consecutivo;
	END IF;

END TerminaStore$$