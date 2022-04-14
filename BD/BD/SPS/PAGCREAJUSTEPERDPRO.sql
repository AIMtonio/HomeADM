-- SP PAGCREAJUSTEPERDPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS PAGCREAJUSTEPERDPRO;

DELIMITER $$

CREATE PROCEDURE `PAGCREAJUSTEPERDPRO`(
	-- REALIZA LA CANCELACION DE CENTAVOS RESTANTES DE LAS CUOTAS DE CREDITO
	Par_CreditoID       BIGINT(12), 	-- Numero de credito
	Par_CuentaAhoID     BIGINT(12), 	-- Numero de cuenta de ahorro
	Par_ClienteID       BIGINT, 		-- Numero de cliente
	Par_FechaOperacion  DATE, 			-- Fecha de Operacion
	Par_FechaAplicacion DATE, 			-- Fecha de la aplicacion

	Par_MonedaID        INT, 			-- Numero de moneda
	Par_ProdCreditoID   INT, 			-- Numero de producto de credito
	Par_Clasificacion   CHAR(1), 		-- Clasificacion del credito
	Par_SubClasifID     INT, 			-- Sub clasificacion contable
	Par_SucCliente      INT, 			-- Sucursal del cliente

	Par_Poliza          BIGINT,			-- Numero de Poliza
	Par_OrigenPago		CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_Salida          CHAR(1), 		-- Salida
	INOUT Par_NumErr      INT(11), 		-- Salida
	INOUT Par_ErrMen      VARCHAR(400),	-- Salida

	INOUT Par_Consecutivo BIGINT, 		-- Salida
	Par_EmpresaID       INT(11), 		-- Auditoria
	Par_ModoPago        CHAR(1), 		-- Auditoria
	Aud_Usuario         INT(11), 		-- Auditoria
	Aud_FechaActual     DATETIME, 		-- Auditoria

	Aud_DireccionIP     VARCHAR(15), 	-- Auditoria
	Aud_ProgramaID      VARCHAR(50), 	-- Auditoria
	Aud_Sucursal        INT(11), 		-- Auditoria
	Aud_NumTransaccion  BIGINT(20) 		-- Auditoria
)
TerminaStore: BEGIN


DECLARE Var_SucursalID          INT;
DECLARE Var_CentroCostoID       INT;
DECLARE Var_TipoInstrumento     INT;
DECLARE Var_SaldoCapVigente     DECIMAL(16,2);
DECLARE Var_SaldoCapAtrasado    DECIMAL(16,2);
DECLARE Var_SaldoCapVencido     DECIMAL(16,2);
DECLARE Var_SaldoCapNoExigi     DECIMAL(16,2);
DECLARE Var_SaldoIntProvision   DECIMAL(16,2);
DECLARE Var_SaldoIntAtraso      DECIMAL(16,2);
DECLARE Var_SaldoIntVencido     DECIMAL(16,2);
DECLARE Var_SaldoIntNoConta     DECIMAL(16,2);
DECLARE Par_Monto           	DECIMAL(12,2);
DECLARE Par_IVAMonto        	DECIMAL(12,2);
DECLARE Par_Descripcion     	VARCHAR(100);
DECLARE Par_AmortiCreID     	INT(4);
DECLARE Par_FechaInicio     	DATE;
DECLARE Par_FechaVencim     	DATE;
DECLARE Var_NomenclaturaCR		VARCHAR(3);

DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12, 2);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE AltaPolCre_SI   CHAR(1);
DECLARE AltaMovCre_SI   CHAR(1);
DECLARE AltaMovCre_NO   CHAR(1);
DECLARE AltaMovAho_NO   CHAR(1);
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Salida_NO       CHAR(1);
DECLARE Salida_SI       CHAR(1);
DECLARE Var_AmoInicio	INT;
DECLARE Var_AmoFin		INT;

DECLARE Con_IngRecCapElim	INT(11);		-- Cto. recuperacion cartera eliminada
DECLARE Con_CtaOrdCapElim	INT(11);		-- Cto. cta. orden cartera eliminada
DECLARE Con_CorCapElim		INT(11);		-- Cto. cta. corr. orden cartera eliminada
DECLARE Con_AbonoIngCap		INT(11);		-- Cto. segun el estatus del credito
DECLARE Con_AbonoOrdCap		INT(11);		-- Cto. segun el estatus del credito
DECLARE Con_CargoCorCap		INT(11);		-- Cto. segun el estatus del credito
DECLARE Est_Eliminado		CHAR(1);		-- Estatus Eliminado
DECLARE Var_EstatusCred		CHAR(1);		-- Estatus del credito
DECLARE Var_EstatusAmo		CHAR(1);		-- Estatus del credito
DECLARE Var_TipoMovConta	INT;

DECLARE Mov_CapVigente      INT;
DECLARE Mov_CapAtrasado     INT;
DECLARE Mov_CapVencido      INT;
DECLARE Mov_CapVenNoExi     INT;
DECLARE Mov_IntProvision    INT;
DECLARE Mov_IntAtrasado     INT;
DECLARE Mov_IntVencido      INT;
DECLARE Mov_IntNoConta      INT;
DECLARE Con_CapVigente      INT;
DECLARE Con_CapAtrasado     INT;
DECLARE Con_CapVencido      INT;
DECLARE Con_CapVenNoExi     INT;
DECLARE Con_IntProvision    INT;
DECLARE Con_IntAtrasado     INT;
DECLARE Con_IntVencido      INT;
DECLARE Con_IntNoConta      INT;
DECLARE Cons_NO             CHAR(1);
DECLARE	For_SucOrigen		CHAR(3);
DECLARE	For_SucCliente		CHAR(3);
DECLARE Var_SaldoAjuste		DECIMAL(16,2);
DECLARE Var_ClienteEspecifico 			INT(11);
DECLARE Var_PagoPerdCentRedond          CHAR(1);
DECLARE Var_PagoMontoMaxPerd            DECIMAL(16,2);
DECLARE Var_CuentaContablePerd          VARCHAR(29);
DECLARE Var_SaldoPerdida                DECIMAL(16,2);
DECLARE	Var_DivContaIng					CHAR(1);

SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET AltaPoliza_NO   := 'N';
SET AltaPolCre_SI   := 'S';
SET AltaMovCre_SI   := 'S';
SET AltaMovCre_NO   := 'N';
SET AltaMovAho_NO   := 'N';
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Cons_NO         := 'N';

SET Mov_CapVigente      := 1;
SET Mov_CapAtrasado     := 2;
SET Mov_CapVencido      := 3;
SET Mov_CapVenNoExi     := 4;
SET Mov_IntProvision    := 14;
SET Mov_IntAtrasado     := 11;
SET Mov_IntVencido      := 12;
SET Mov_IntNoConta      := 13;
SET Var_TipoInstrumento := 11;
SET Con_CapVigente  	:= 1;
SET Con_CapAtrasado  	:= 2;
SET Con_CapVencido  	:= 3;
SET Con_CapVenNoExi  	:= 4;
SET Con_IntProvision  	:= 19;
SET Con_IntAtrasado  	:= 20;
SET Con_IntVencido  	:= 21;
SET Con_IntNoConta  	:= 11;
SET For_SucOrigen		:= '&SO';
SET For_SucCliente		:= '&SC';

SET Salida_NO           := 'N';
SET Salida_SI           := 'S';
SET Par_IVAMonto		:= 0;
SET Par_Descripcion		:= 'CENTAVOS REDONDEADOS';

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		GET DIAGNOSTICS condition 1
		@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREAJUSTEPERDPRO. [',@Var_SQLState,'-',@Var_SQLMessage,']');
		END;

	SET Var_ClienteEspecifico 	:= FNPARAMGENERALES('CliProcEspecifico');
	SET Var_PagoPerdCentRedond 	:= FNPARAMGENERALES('PagoPerdCentRedond');
	SET Var_PagoMontoMaxPerd 	:= FNPARAMGENERALES('PagoMontoMaxPerd');
	SET Var_CuentaContablePerd 	:= FNPARAMGENERALES('CuentaContablePerd');

SELECT
	MIN(AmortizacionID),MAX(AmortizacionID)
INTO
	Var_AmoInicio,Var_AmoFin
FROM AMORTICREDITO
WHERE CreditoID = Par_CreditoID
	AND NumTransaccion = Aud_NumTransaccion;

IF Var_PagoPerdCentRedond = Cons_NO THEN
	SET Par_NumErr := 0;
	SET Par_ErrMen := concat('El Parametro PagoPerdCentRedond no esta habilitado');
	LEAVE ManejoErrores;
END IF;

IF Var_PagoMontoMaxPerd <= Entero_Cero THEN
	SET Par_NumErr := 101;
	SET Par_ErrMen := concat('El Parametro PagoMontoMaxPerd no puede ser cero');
	LEAVE ManejoErrores;
END IF;

SET Var_SaldoAjuste := Entero_Cero;

WHILE Var_AmoInicio <= Var_AmoFin DO
CicloAmortizacion:BEGIN

	SELECT
		SaldoCapVigente,		SaldoCapAtrasa,			SaldoCapVencido,		SaldoCapVenNExi,
		SaldoInteresPro,		SaldoInteresAtr,		SaldoInteresVen,		SaldoIntNoConta,
		Estatus,				FechaInicio,			FechaVencim
	INTO
		Var_SaldoCapVigente,	Var_SaldoCapAtrasado,   Var_SaldoCapVencido,	Var_SaldoCapNoExigi,
		Var_SaldoIntProvision,	Var_SaldoIntAtraso,     Var_SaldoIntVencido,	Var_SaldoIntNoConta,
		Var_EstatusAmo,			Par_FechaInicio,		Par_FechaVencim
	FROM AMORTICREDITO
	WHERE CreditoID = Par_CreditoID
	AND AmortizacionID = Var_AmoInicio;

	IF Var_EstatusAmo NOT IN('V','A','B') THEN
		LEAVE CicloAmortizacion;
	END IF;

	SET Par_AmortiCreID := Var_AmoInicio;
	SET Var_SaldoPerdida := (Var_SaldoCapVigente + Var_SaldoCapAtrasado + Var_SaldoCapVencido + Var_SaldoCapNoExigi +
							 Var_SaldoIntProvision + Var_SaldoIntAtraso + Var_SaldoIntVencido + Var_SaldoIntNoConta);
	SET Var_SaldoAjuste := Decimal_Cero;


	IF (Var_SaldoPerdida > Var_PagoMontoMaxPerd) THEN
		LEAVE CicloAmortizacion;
	END IF;

	IF Var_SaldoCapVigente > Decimal_Cero THEN
		SET Par_Monto := Var_SaldoCapVigente;
		SET Var_TipoMovConta := Con_CapVigente;
		SET Var_SaldoAjuste := Var_SaldoAjuste + Par_Monto;

		CALL PAGCRECAPVIGPRO(
			Par_CreditoID,		Par_AmortiCreID,		Par_FechaInicio,		Par_FechaVencim,		Par_CuentaAhoID,
			Par_ClienteID,		Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,				Decimal_Cero,
			Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,		Par_SubClasifID,		Par_SucCliente,
			Par_Descripcion,	Par_CuentaAhoID,		Par_Poliza,				Decimal_Cero,			Par_OrigenPago,
			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,			Par_ModoPago,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF Var_SaldoCapAtrasado > Decimal_Cero THEN
		SET Par_Monto := Var_SaldoCapAtrasado;
		SET Var_TipoMovConta := Con_CapAtrasado;
		SET Var_SaldoAjuste := Var_SaldoAjuste + Par_Monto;
		CALL PAGCRECAPATRPRO (
			Par_CreditoID,		Par_AmortiCreID,		Par_FechaInicio,		Par_FechaVencim,	Par_CuentaAhoID,
			Par_ClienteID,		Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,			Decimal_Cero,
			Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,		Par_SubClasifID,	Par_SucCliente,
			Par_Descripcion,	Par_CuentaAhoID,		Par_Poliza,				Decimal_Cero,		Par_OrigenPago,
			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Par_ModoPago,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF Var_SaldoCapVencido > Decimal_Cero THEN
		SET Par_Monto := Var_SaldoCapVencido;
		SET Var_TipoMovConta := Con_CapVencido;
		SET Var_SaldoAjuste := Var_SaldoAjuste + Par_Monto;
		CALL PAGCRECAPVENPRO (
			Par_CreditoID,		Par_AmortiCreID,		Par_FechaInicio,		Par_FechaVencim,	Par_CuentaAhoID,
			Par_ClienteID,		Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,			Decimal_Cero,
			Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,		Par_SubClasifID,	Par_SucCliente,
			Par_Descripcion,	Par_CuentaAhoID,		Par_Poliza,				Decimal_Cero,		Par_OrigenPago,
			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Par_ModoPago,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF Var_SaldoCapNoExigi > Decimal_Cero THEN
		SET Par_Monto := Var_SaldoCapNoExigi;
		SET Var_TipoMovConta := Con_CapVenNoExi;
		SET Var_SaldoAjuste := Var_SaldoAjuste + Par_Monto;
		CALL PAGCRECAPVNEPRO (
			Par_CreditoID,		Par_AmortiCreID,		Par_FechaInicio,		Par_FechaVencim,	Par_CuentaAhoID,
			Par_ClienteID,		Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,			Decimal_Cero,
			Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,		Par_SubClasifID,	Par_SucCliente,
			Par_Descripcion,	Par_CuentaAhoID,		Par_Poliza,				Decimal_Cero,		Par_OrigenPago,
			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Par_ModoPago,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF Var_SaldoIntProvision > Decimal_Cero THEN
		SET Par_Monto := Var_SaldoIntProvision;
		SET Var_TipoMovConta := Con_IntProvision;
		SET Var_SaldoAjuste := Var_SaldoAjuste + Par_Monto;
		CALL PAGCREINTPROPRO (
			Par_CreditoID,		Par_AmortiCreID,		Par_FechaInicio,		Par_FechaVencim,	Par_CuentaAhoID,
			Par_ClienteID,		Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,			Par_IVAMonto,
			Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,		Par_SubClasifID,	Par_SucCliente,
			Par_Descripcion,	Par_CuentaAhoID,		Par_Poliza,				Par_OrigenPago,		Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,			Par_ModoPago,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF Var_SaldoIntAtraso > Decimal_Cero THEN
		SET Par_Monto := Var_SaldoIntAtraso;
		SET Var_TipoMovConta := Con_IntAtrasado;
		SET Var_SaldoAjuste := Var_SaldoAjuste + Par_Monto;
		CALL PAGCREINTATRPRO (
			Par_CreditoID,		Par_AmortiCreID,		Par_FechaInicio,		Par_FechaVencim,	Par_CuentaAhoID,
			Par_ClienteID,		Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,			Par_IVAMonto,
			Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,		Par_SubClasifID,	Par_SucCliente,
			Par_Descripcion,	Par_CuentaAhoID,		Par_Poliza,				Par_OrigenPago,		Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,			Par_ModoPago,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF Var_SaldoIntVencido > Decimal_Cero THEN
		SET Par_Monto := Var_SaldoIntVencido;
		SET Var_TipoMovConta := Con_IntVencido;
		SET Var_SaldoAjuste := Var_SaldoAjuste + Par_Monto;
		CALL PAGCREINTVENPRO (
			Par_CreditoID,		Par_AmortiCreID,		Par_FechaInicio,		Par_FechaVencim,	Par_CuentaAhoID,
			Par_ClienteID,		Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,			Par_IVAMonto,
			Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,		Par_SubClasifID,	Par_SucCliente,
			Par_Descripcion,	Par_CuentaAhoID,		Par_Poliza,				Par_OrigenPago,		Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,			Par_ModoPago,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF Var_SaldoIntNoConta > Decimal_Cero THEN
		SET Par_Monto			:= Var_SaldoIntNoConta;
		SET Var_TipoMovConta	:= Con_IntNoConta;
		SET Var_SaldoAjuste		:= Var_SaldoAjuste + Par_Monto;
		SET Var_DivContaIng		:= (SELECT DivideIngresoInteres FROM PARAMETROSSIS);

		CALL PAGCREINTNOCPRO (
			Par_CreditoID,		Par_AmortiCreID,		Par_FechaInicio,		Par_FechaVencim,	Par_CuentaAhoID,
			Par_ClienteID,		Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,			Par_IVAMonto,
			Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,		Par_SubClasifID,	Par_SucCliente,
			Par_Descripcion,	Par_CuentaAhoID,		Par_Poliza,				Var_DivContaIng,	Par_OrigenPago,
			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Par_ModoPago,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF IFNULL(Var_SaldoAjuste,Entero_Cero) > Entero_Cero THEN
		SET Var_NomenclaturaCR := (SELECT NomenclaturaCR FROM CUENTASMAYORCAR Ctm
									WHERE Ctm.ConceptoCarID	= Var_TipoMovConta);

		IF Var_NomenclaturaCR = For_SucOrigen  THEN
			SET Var_CentroCostoID := (SELECT CentroCostoID FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
		ELSE
			SET Var_CentroCostoID := (SELECT CentroCostoID FROM SUCURSALES WHERE SucursalID = Par_SucCliente);
		END IF;

		call DETALLEPOLIZASALT(
				Par_EmpresaID,      Par_Poliza,     Par_FechaOperacion,     Var_CentroCostoID,      Var_CuentaContablePerd,
				Par_CreditoID,      Par_MonedaID,   Par_Monto,              Decimal_Cero,           Par_Descripcion,
				Par_CreditoID,      Aud_ProgramaID, Var_TipoInstrumento,    Cadena_Vacia,           Decimal_Cero,
				Cadena_Vacia,       Salida_NO,      Par_NumErr,             Par_ErrMen,             Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
				LEAVE ManejoErrores;
		END IF;
	END IF;

END CicloAmortizacion;
	SET Var_AmoInicio := Var_AmoInicio +1;
END WHILE;

SET Par_NumErr := 0;
SET Par_ErrMen := 'Registro de Perdida en Cuota Exitoso';

END ManejoErrores;

IF Par_Salida = Salida_SI THEN
	SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen;
END IF;


END TerminaStore$$