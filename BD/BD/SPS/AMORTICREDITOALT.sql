-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOALT`;

DELIMITER $$
CREATE PROCEDURE `AMORTICREDITOALT`(
	/* SP PARA REGISTRAR LAS AMORTIZACIONES DEL CALENDARIO DE PAGOS DE UN CREDITO */
	Par_CreditoID			BIGINT(12),
	Par_NumTransSim			BIGINT,
	Par_ClienteID			INT(11),
	Par_CuentaID			BIGINT(12),
	Par_MontoCre			DECIMAL(12,2),

	Par_NumAlta				TINYINT UNSIGNED,
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(12)
)
TerminaStore: BEGIN

	# Declaracion de Variables
	DECLARE	NTransacCred 		INT;
	DECLARE	NTransacSimu  		INT;
	DECLARE	NumTotalAmor  		INT;
	DECLARE	FechaVenCred		DATE;
	DECLARE	SumCapiAmort		DECIMAL(12,2);
	DECLARE	FechaVenAmort 		DATE;
	DECLARE	Num_Amortizacion	INT;
	DECLARE	Var_CrediAmorCre 	INT;
	DECLARE	FechaLiquida 		DATE;
	DECLARE	SaldoCapVigente 	DECIMAL(12,2);
	DECLARE	SaldoCapAtrasa 		DECIMAL(12,2);
	DECLARE	SaldoCapVencido 	DECIMAL(12,2);
	DECLARE	SaldoCapVenNExi 	DECIMAL(12,2);
	DECLARE	SaldoInteresOrd 	DECIMAL(12,2);
	DECLARE	SaldoInteresAtr 	DECIMAL(12,2);
	DECLARE	SaldoInteresVen 	DECIMAL(12,2);
	DECLARE	SaldoInteresPro 	DECIMAL(12,2);
	DECLARE	SaldoIVAInteres 	DECIMAL(12,2);
	DECLARE	SaldoMoratorios 	DECIMAL(12,2);
	DECLARE	SaldoIVAMorato  	DECIMAL(12,2);
	DECLARE	SaldoComFaltaPa 	DECIMAL(12,2);
	DECLARE	SaldoIVAComFalP 	DECIMAL(12,2);
	DECLARE	SaldoComServGar 	DECIMAL(12,2);
	DECLARE	SaldoIVAComSerGar 	DECIMAL(12,2);
	DECLARE	SaldoOtrasComis 	DECIMAL(12,2);
	DECLARE	SaldoIVAComisi 		DECIMAL(12,2);
	DECLARE	SaldoMoraVencido	DECIMAL(12,2);
	DECLARE	SaldoMoraCarVen		DECIMAL(12,2);
	DECLARE SaldoMontoSeguroCuota	DECIMAL(12,2);
	DECLARE SaldoIVASeguroCuota		DECIMAL(12,2);
	DECLARE Var_SaldoComisionAnual	DECIMAL(14,2);			# Saldo de Comision Anual
	DECLARE MaxConsecutivo			INT(11);
	DECLARE Var_MaxConsecutivo		INT(4);
	DECLARE Var_Estatus 			CHAR(1);
	DECLARE Var_Control 			VARCHAR(50);

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE	SalidaNO				CHAR(1);
	DECLARE	SalidaSI				CHAR(1);
	DECLARE Alta_CreNuevo			INT(11);
	DECLARE Alta_CreReestructura 	INT(11);
	DECLARE Estatus_Inactivo		CHAR(1);
	DECLARE Estatus_Vigente			CHAR(1);

	-- Asignacion  de constantes
	SET	Entero_Cero				:= 0;			-- Constante Entero valor cero
	SET Decimal_Cero			:= 0.00;		-- Constante DECIMAL Cero
	SET	Estatus_Inactivo		:= 'I';			--  Estatus Inactivo
	SET Estatus_Vigente			:= 'V';			-- Estatus vigente
	SET	SalidaNO				:= 'N';			-- Constante Salida NO
	SET	SalidaSI				:= 'S';			-- Constante Salida SI
	SET Alta_CreNuevo			:= 1;			-- Alta de amortizaciones para credito nuevo o renovacion
	SET Alta_CreReestructura 	:= 2;			-- Alta de amortizaciones para credito reestructura

	-- Inicializaciones
	SET	FechaLiquida			:= '1900-01-01';	-- Constante de Fecha de liquidacion
	SET	SaldoCapVigente			:= 0; 				-- Inicializacion de saldo de capital vigente
	SET	SaldoCapAtrasa 			:= 0;				-- Inicializacion de saldo de capital atrasado
	SET	SaldoCapVencido			:= 0; 				-- Inicializacion de saldo de capital vigente
	SET	SaldoCapVenNExi			:= 0;				-- Inicializacion de saldo de capital vencido no exigible
	SET	SaldoInteresOrd			:= 0; 				-- Inicializacion de saldo de interes ordinario
	SET	SaldoInteresAtr			:= 0;				-- Inicializacion de saldo de interes atrasado
	SET	SaldoInteresVen			:= 0; 				-- Inicializacion de saldo de interes vencido
	SET	SaldoInteresPro			:= 0;				-- Inicializacion de saldo de interes provisionado
	SET	SaldoIVAInteres			:= 0;				-- Inicializacion de saldo de IVA interes
	SET	SaldoMoratorios			:= 0;				-- Inicializacion de saldo de moratorios
	SET	SaldoIVAMorato			:= 0;				-- Inicializacion de saldo de IVA  moratorio
	SET	SaldoComFaltaPa			:= 0;				-- Inicializacion de saldo de Comision por falta de pago
	SET	SaldoIVAComFalP			:= 0;				-- Inicializacion de saldo de IVA Comision por falta de pago
	SET	SaldoComServGar			:= 0;				-- Inicializacion de saldo de Comision por Servicio de Garantia Agro
	SET	SaldoIVAComSerGar		:= 0;				-- Inicializacion de saldo de IVA Comision por Servicio de Garantia Agro
	SET	SaldoOtrasComis			:= 0;				-- Inicializacion de saldo de otras comisiones
	SET	SaldoIVAComisi 			:= 0;				-- Inicializacion de saldo de IVA otras comisiones
	SET	SaldoMoraVencido		:= 0;				-- Inicializacion de saldo de Moratorio Vencido
	SET	SaldoMoraCarVen			:= 0;				-- Inicializacion de saldo de Moratorio de Cartera Vencida
	SET SaldoMontoSeguroCuota	:= 0;				-- Inicializacion del Monto por seguro por cuota
	SET SaldoIVASeguroCuota		:= 0;				-- Inicializacion de IVA por seguro por cuota
	SET Var_SaldoComisionAnual	:= 0;				-- Inicializacion de Comision por Anualidad de Credito



	SELECT	SUM(Tmp_Capital),	MAX(Tmp_Consecutivo),	MAX(Tmp_FecFin)
	INTO 	SumCapiAmort,		NumTotalAmor,			FechaVenAmort
	FROM TMPPAGAMORSIM
	WHERE	NumTransaccion= Par_NumTransSim
	GROUP BY NumTransaccion;


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTICREDITOALT');
			SET Var_Control := 'sqlexception';
		END;

		IF(Par_MontoCre != SumCapiAmort) THEN
			SET Par_NumErr := 1;
			SET	Par_ErrMen := 'La Suma de Amortizaciones y el Monto de Credito No Coinciden.';
			LEAVE ManejoErrores;
		END IF;



		# 1.- Alta de amortizaciones para credito nuevo o renovacion
		IF(Par_NumAlta = Alta_CreNuevo)THEN
			SET Var_Estatus	:= Estatus_Inactivo;

			CALL `AMORTICREDITOBAJ`(
					Par_CreditoID,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
					Aud_NumTransaccion);
			SET Aud_FechaActual := NOW();

			INSERT INTO `AMORTICREDITO`(
					AmortizacionID,				CreditoID,				ClienteID,				CuentaID,				FechaInicio,
					FechaVencim,				FechaExigible,			Estatus,				FechaLiquida,			Capital,
					Interes,					IVAInteres,				SaldoCapVigente,		SaldoCapAtrasa,			SaldoCapVencido,
					SaldoCapVenNExi,			SaldoInteresOrd,		SaldoInteresAtr,		SaldoInteresVen,		SaldoInteresPro,
					SaldoIntNoConta,			SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMorato,			SaldoComFaltaPa,
					SaldoIVAComFalP,			SaldoComServGar,		SaldoIVAComSerGar,		MontoOtrasComisiones,	MontoIVAOtrasComisiones,
					MontoIntOtrasComis,			MontoIVAIntComisi,
					SaldoOtrasComis,			SaldoIVAComisi,			ProvisionAcum,			SaldoCapital,			SaldoMoraVencido,
					SaldoMoraCarVen,			MontoSeguroCuota,		IVASeguroCuota,			SaldoSeguroCuota,		SaldoIVASeguroCuota,
					SaldoComisionAnual,
					EmpresaID,					Usuario,				FechaActual,			DireccionIP,			ProgramaID,
					Sucursal,					NumTransaccion)
			SELECT
					Tmp_Consecutivo,			Par_CreditoID,			Par_ClienteID,			Par_CuentaID,			Tmp_FecIni,
					Tmp_FecFin,					Tmp_FecVig,				Var_Estatus, 			FechaLiquida,			Tmp_Capital,
					Tmp_Interes, 				Tmp_Iva,				SaldoCapVigente,		SaldoCapAtrasa,			SaldoCapVencido,
					SaldoCapVenNExi,			SaldoInteresOrd,		SaldoInteresAtr,		SaldoInteresVen,		SaldoInteresPro,
					Entero_Cero,				SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMorato,			SaldoComFaltaPa,
					SaldoIVAComFalP,			Entero_Cero,			Entero_Cero,			Tmp_OtrasComisiones,	Tmp_IVAOtrasComisiones,
					Tmp_InteresOtrasComisiones, Tmp_IVAInteresOtrasComisiones,
					SaldoOtrasComis,			SaldoIVAComisi,			Entero_Cero,			Tmp_Insoluto,			SaldoMoraVencido,
					SaldoMoraCarVen,			Tmp_MontoSeguroCuota,	Tmp_IVASeguroCuota,		SaldoMontoSeguroCuota,	SaldoIVASeguroCuota,
					Var_SaldoComisionAnual,
					Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,				Par_NumTransSim
			FROM TMPPAGAMORSIM
			WHERE NumTransaccion	= Par_NumTransSim;
		END IF;

		IF(Par_NumAlta = Alta_CreReestructura)THEN
			SET Var_Estatus	:= Estatus_Vigente;

			SET Var_MaxConsecutivo	:= (SELECT MAX(AmortizacionID) FROM AMORTICREDITO WHERE CreditoID	= Par_CreditoID);
			INSERT INTO `AMORTICREDITO`(
					AmortizacionID,			CreditoID,					ClienteID,			CuentaID,					FechaInicio,
					FechaVencim,			FechaExigible,				Estatus,			FechaLiquida,				Capital,
					Interes,				IVAInteres,					SaldoCapVigente,	SaldoCapAtrasa,				SaldoCapVencido,
					SaldoCapVenNExi,		SaldoInteresOrd,			SaldoInteresAtr,	SaldoInteresVen,			SaldoInteresPro,
					SaldoIntNoConta,		SaldoIVAInteres,			SaldoMoratorios,	SaldoIVAMorato,				SaldoComFaltaPa,
					SaldoIVAComFalP,		SaldoComServGar,			SaldoIVAComSerGar,  SaldoOtrasComis,			SaldoIVAComisi,
					ProvisionAcum,			SaldoCapital,				SaldoMoraVencido,	SaldoMoraCarVen,			MontoSeguroCuota,
					IVASeguroCuota,			SaldoSeguroCuota,			SaldoIVASeguroCuota,SaldoComisionAnual,			EmpresaID,
					Usuario,				FechaActual,				DireccionIP,		ProgramaID,					Sucursal,
					NumTransaccion)
			SELECT	Tmp_Consecutivo +
					Var_MaxConsecutivo,		Par_CreditoID,				Par_ClienteID,			Par_CuentaID,			Tmp_FecIni,
					Tmp_FecFin,				Tmp_FecVig,					Var_Estatus, 			FechaLiquida,			Tmp_Capital,
					Tmp_Interes, 			Tmp_Iva,					SaldoCapVigente,		SaldoCapAtrasa,			SaldoCapVencido,
					SaldoCapVenNExi,		SaldoInteresOrd,			SaldoInteresAtr,		SaldoInteresVen,		SaldoInteresPro,
					Entero_Cero,			SaldoIVAInteres,			SaldoMoratorios,		SaldoIVAMorato,			SaldoComFaltaPa,
					SaldoIVAComFalP,		Entero_Cero,				Entero_Cero,			SaldoOtrasComis,		SaldoIVAComisi,
					Entero_Cero,			Tmp_Insoluto,				SaldoMoraVencido,		SaldoMoraCarVen,		Tmp_MontoSeguroCuota,
					Tmp_IVASeguroCuota,		SaldoMontoSeguroCuota,		SaldoIVASeguroCuota,	Var_SaldoComisionAnual,	Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
					Par_NumTransSim
			FROM TMPPAGAMORSIM
			WHERE NumTransaccion	= Par_NumTransSim;

			CALL TMPPAGAMORSIMBAJ(
				Par_NumTransSim,	SalidaNO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);
		END IF;


		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Amortizaciones Guardadas.';

	END ManejoErrores;  -- End del Handler de Errores


	 IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				'creditoID' 	AS control,
				Par_CreditoID 	AS consecutivo;
	 END IF;


END TerminaStore$$