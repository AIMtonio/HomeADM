-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINCREDCANCELACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINCREDCANCELACT`;DELIMITER $$

CREATE PROCEDURE `MINCREDCANCELACT`(
/* SP QUE ACTUALIZA LOS INTERESES DE LAS AMORTIZACIONES Y DEL PAGARÉ */
	Par_CreditoID					BIGINT(12),			-- Número del Crédito Activo (CREDITOS).
	Par_Numero						INT(11),			-- Número de la Ministración a Cancelar.
	Par_Salida						CHAR(1),			-- Tipo de Salida.
	INOUT Par_NumErr				INT(11),			-- Número de Error.
	INOUT Par_ErrMen				VARCHAR(400),		-- Mensaje de Error.

	/* Parametros de Auditoria */
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),

	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_FechaSistema			DATE;				-- Fecha del sistema
DECLARE Var_AmortizacionID			INT(11);			-- Número de Amortización
DECLARE Var_UltimaMinistracion		INT(11);			-- Número de la Última Ministración
DECLARE Var_EstatusMinistracion		CHAR(1);			-- Estatus de la Ministración
DECLARE Var_TipoCancelacion			CHAR(1);			-- Tipo de Cancelación
DECLARE Var_MontoCancelar			DECIMAL(14,2);		-- Monto de la Ministración Cancelada
DECLARE Var_MontoDiferencia			DECIMAL(14,2);		-- Monto diferencia.
DECLARE Var_SaldoCapVigente			DECIMAL(14,2);		-- Monto de la Amortización.
DECLARE	Var_FechaPagoMinis			DATE;				-- Fecha de Pago Pactada de desembolso de la ministración
DECLARE Var_TotalAmor				INT(11);			-- Numero total de amortizaciones.
DECLARE Var_TotalAmorVivas			INT(11);			-- Numero total de amortizaciones vivas.
DECLARE Var_Consecutivo				BIGINT(12);			-- Número consecutivo
DECLARE Var_Control					VARCHAR(50);		-- Control id

-- Declaracion de Constantes
DECLARE Cadena_Vacia				CHAR(1);
DECLARE Fecha_Vacia					DATE;
DECLARE Entero_Cero					INT(11);
DECLARE Entero_Uno					INT(11);
DECLARE Decimal_Cero				DECIMAL(12, 2);
DECLARE TipoActInteres				INT(11);
DECLARE PrimerMinistracion			INT(11);
DECLARE TipoUltCuota				CHAR(1);
DECLARE TipoSigCuota				CHAR(1);
DECLARE TipoProrrateo				CHAR(1);
DECLARE SalidaSI					CHAR(1);
DECLARE SalidaNO					CHAR(1);
DECLARE EstatusPagado     			CHAR(1);
DECLARE EstatusActivo     			CHAR(1);
DECLARE EstatusInactivo    			CHAR(1);
DECLARE EstatusVencido    			CHAR(1);
DECLARE EstatusVigente    			CHAR(1);
DECLARE EstatusAtrasado				CHAR(1);
DECLARE EstatusCancelado			CHAR(1);
DECLARE Tipo_InstitucionFondeo		CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia    				:= '';              -- Cadena Vacia
SET Fecha_Vacia     				:= '1900-01-01';	-- Fecha Vacia
SET Entero_Cero     				:= 0;               -- Entero en Cero
SET Entero_Uno   					:= 1;    	        -- Entero en Uno
SET Decimal_Cero    				:= 0.00;            -- Decimal Cero
SET TipoActInteres 					:= 1;    	        -- Tipo de actualizacion para los intereses
SET PrimerMinistracion				:= 1;    	        -- Número de la Primer Ministración.
SET TipoUltCuota					:= 'U';				-- Tipo de Cancelacion: Ultimas cuotas
SET TipoSigCuota					:= 'I';				-- Tipo de Cancelacion: A las cuotas siguientes inmediatas
SET TipoProrrateo					:= 'V';				-- Tipo de Cancelacion: Prorrateo en cuotas vivas
SET SalidaSI        				:= 'S';             -- El Store si Regresa una Salida
SET SalidaNO        				:= 'N';             -- El Store no Regresa una Salida
SET EstatusPagado     				:= 'P';            	-- Estatus: Pagado
SET EstatusActivo     				:= 'A';            	-- Estatus: Activo
SET EstatusInactivo    				:= 'I';            	-- Estatus: Inactivo
SET EstatusVencido    				:= 'B';            	-- Estatus: Vencido
SET EstatusVigente    				:= 'V';            	-- Estatus: Vigente
SET EstatusAtrasado					:= 'A';				-- Estatus: Atrasado
SET EstatusCancelado				:= 'C';             -- Estatus: Cancelado
SET Tipo_InstitucionFondeo			:= 'F';				-- Fondeo por Financiamiento

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-MINCREDCANCELACT');
			SET Var_Control := 'sqlException';
		END;

	-- Se obtiene la ultima ministración del calendario de ministraciones.
	SET Var_UltimaMinistracion := (SELECT MAX(Numero) FROM MINISTRACREDAGRO WHERE CreditoID = Par_CreditoID);
	SET Var_UltimaMinistracion := IFNULL(Var_UltimaMinistracion, Entero_Cero);

	-- Se obiente el tipo de cancelación
	SET Var_TipoCancelacion	:= (SELECT Cre.TipoCancelacion FROM CREDITOS Cre WHERE Cre.CreditoID = Par_CreditoID);
	SET Var_TipoCancelacion	:= IFNULL(Var_TipoCancelacion, Cadena_Vacia);

	SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS LIMIT 1;
	SET Aud_FechaActual		:= NOW();


	/* Si es la última ministración que se cancela y la ministración no es la primero y el tipo de cancelación es por últimas cuotas
	 * entonces se registran las amoritzaciónes que fueron canceladas (con saldo cero). */
	IF (Par_Numero = Var_UltimaMinistracion AND Par_Numero != Entero_Uno AND Var_TipoCancelacion = TipoUltCuota) THEN
		-- SE REGISTRAN LAS AMORTIZACIONES CANCELADAS EN AMORTICREDITO
		INSERT INTO AMORTICREDITO(
			AmortizacionID,			CreditoID,				ClienteID,				CuentaID,				FechaInicio,
			FechaVencim,			FechaExigible,			Estatus,				FechaLiquida,			Capital,
			Interes,				IVAInteres,				SaldoCapVigente,		SaldoCapAtrasa,			SaldoCapVencido,
			SaldoCapVenNExi,		SaldoInteresOrd,		SaldoInteresAtr,		SaldoInteresVen,		SaldoInteresPro,
			SaldoIntNoConta,		SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMorato,			SaldoComFaltaPa,
			SaldoIVAComFalP,		SaldoOtrasComis,		SaldoIVAComisi,			ProvisionAcum,			SaldoCapital,
			SaldoMoraVencido,		SaldoMoraCarVen,		MontoSeguroCuota,		IVASeguroCuota,			SaldoSeguroCuota,
			SaldoIVASeguroCuota,	SaldoComisionAnual,		EmpresaID,				Usuario,				FechaActual,
			DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
		SELECT
			AmortizacionID,			CreditoID,				ClienteID,				CuentaID,				FechaInicio,
			FechaVencim,			FechaExigible,			Estatus, 				FechaLiquida,			Capital,
			Interes, 				IVAInteres,				SaldoCapVigente,		SaldoCapAtrasa,			SaldoCapVencido,
			SaldoCapVenNExi,		SaldoInteresOrd,		SaldoInteresAtr,		SaldoInteresVen,		SaldoInteresPro,
			Entero_Cero,			SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMorato,			SaldoComFaltaPa,
			SaldoIVAComFalP,		SaldoOtrasComis,		SaldoIVAComisi,			ProvisionAcum,			SaldoCapital,
			SaldoMoraVencido,		SaldoMoraCarVen,		MontoSeguroCuota,		IVASeguroCuota,			SaldoSeguroCuota,
			SaldoIVASeguroCuota,	SaldoComisionAnual,		Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
			FROM AMORTICREDITOAGRO
				WHERE CreditoID			= Par_CreditoID
					AND Estatus			= EstatusCancelado
					AND	FechaLiquida	= Var_FechaSistema
					AND NumTransaccion	= Aud_NumTransaccion;
	END IF;

	-- SE GUARDAN LOS CAMBIOS REALIZADOS EN EL PAGARÉ DEL CRÉDITO.
	CALL PAGARECREDITOAGROALT(
		Par_CreditoID,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr	:= Entero_Cero;
	SET Par_ErrMen	:= 'Ministracion de Credito Cancelada Exitosamente.';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_CreditoID AS Consecutivo;
	END IF;

END TerminaStore$$