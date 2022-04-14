-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTACREDITOSCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTACREDITOSCONTPRO`;DELIMITER $$

CREATE PROCEDURE `CONTACREDITOSCONTPRO`(
# ==================================================================
# ----   STORE PARA CONTABILIDAD DE CREDITOS CONTINGENTES---
# ===================================================================
    Par_CreditoID       	BIGINT(12),		--  Indica el numero de Credito
    Par_AmortiCreID     	INT(4),			--  Numero de Amortizacion del credito
    Par_CuentaAhoID     	BIGINT(12),		--  Cuenta de ahorro del credito
    Par_ClienteID       	BIGINT,			--  Cliente del credito
    Par_FechaOperacion  	DATE,			--  Fecha de Operacion

    Par_FechaAplicacion 	DATE,			--  Fecha de Aplicacion
    Par_Monto           	DECIMAL(14,4),	--  Monto
    Par_MonedaID        	INT,			--  moneda
    Par_ProdCreditoID   	INT,			--  producto del credito
    Par_Clasificacion   	CHAR(1),		--  Clasificacion

    Par_SubClasifica    	INT(11),		--  Sub Clasificacion
    Par_SucCliente      	INT,			--  Sucursal del cliente
    Par_Descripcion     	VARCHAR(100),
    Par_Referencia      	VARCHAR(50),
    Par_AltaEncPoliza   	CHAR(1),

    Par_ConceptoCon     	INT,
	INOUT	Par_Poliza		BIGINT,
    Par_AltaPolizaCre   	CHAR(1),
    Par_AltaMovCre      	CHAR(1),
    Par_ConcContaCre    	INT,

    Par_TipoMovCre      	INT,
    Par_NatCredito      	CHAR(1),
    Par_AltaMovAho      	CHAR(1),
    Par_TipoMovAho      	VARCHAR(4),
    Par_NatAhorro       	CHAR(1),

    Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),
	INOUT	Par_Consecutivo	BIGINT,
	Par_EmpresaID			INT(11),

	Par_ModoPago			CHAR(1),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Cargos  		DECIMAL(14,4);
	DECLARE Var_Abonos  		DECIMAL(14,4);
	DECLARE Var_CuentaStr   	VARCHAR(20);
	DECLARE Var_CreditoStr  	VARCHAR(20);
	DECLARE Var_Control			VARCHAR(100);				-- Variable de control
	DECLARE	Var_Consecutivo		VARCHAR(20);				-- Variable consecutivo
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT;
	DECLARE Decimal_Cero    DECIMAL(12, 2);
	DECLARE AltaPoliza_SI   CHAR(1);
	DECLARE AltaMovAho_SI   CHAR(1);
	DECLARE AltaMovCre_SI   CHAR(1);
	DECLARE AltaPolCre_SI   CHAR(1);
	DECLARE Nat_Cargo       CHAR(1);
	DECLARE Nat_Abono       CHAR(1);
	DECLARE Pol_Automatica  CHAR(1);
	DECLARE Salida_No       CHAR(1);
	DECLARE Con_AhoCapital  INT;
	DECLARE	Salida_SI		CHAR(1);
	-- Asignacion de Constantes
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET Entero_Cero		:= 0;
	SET Decimal_Cero	:= 0.00;
	SET AltaPoliza_SI	:= 'S';
	SET AltaMovAho_SI	:= 'S';
	SET AltaMovCre_SI	:= 'S';
	SET AltaPolCre_SI	:= 'S';
	SET Nat_Cargo		:= 'C';
	SET Nat_Abono		:= 'A';
	SET Pol_Automatica	:= 'A';
	SET Salida_No		:= 'N';
	SET Con_AhoCapital	:= 1;
	SET Salida_SI		:= 'S';
	SET Var_CreditoStr	:= CONCAT("Cred.",CONVERT(Par_CreditoID, CHAR(20)));
	SET Var_CuentaStr 	:= CONCAT("Cta.",CONVERT(Par_CuentaAhoID, CHAR));
	SET Aud_FechaActual := NOW();

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTACREDITOSCONTPRO');
				SET Var_Control := 'SQLEXCEPTION' ;
			END;

		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,			Par_EmpresaID,		Par_FechaAplicacion, 	Pol_Automatica,			Par_ConceptoCon,
				Par_Descripcion,	Salida_No, 			Par_NumErr,				Par_ErrMen,				Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_AltaMovCre = AltaMovCre_SI	) THEN
			IF(Par_NatCredito = Nat_Cargo) THEN
				SET	Var_Cargos	:= Par_Monto;
				SET	Var_Abonos	:= Decimal_Cero;
			ELSE
				SET	Var_Cargos	:= Decimal_Cero;
				SET	Var_Abonos	:= Par_Monto;
			END IF;

			CALL CREDITOCONTMOVSALT(
				Par_CreditoID,		Par_AmortiCreID,	Aud_NumTransaccion,		Par_FechaOperacion,		Par_FechaAplicacion,
				Par_TipoMovCre,		Par_NatCredito,		Par_MonedaID,			Par_Monto,				Par_Descripcion,
				Par_Referencia,		Par_Poliza,			Salida_No,				Par_NumErr,				Par_ErrMen,
				Par_Consecutivo,	Par_ModoPago,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF (Par_AltaPolizaCre = AltaPolCre_SI) THEN
			IF(Par_NatCredito = Nat_Cargo) THEN
				SET	Var_Cargos	:= Par_Monto;
				SET	Var_Abonos	:= Decimal_Cero;
			ELSE
				SET	Var_Cargos	:= Decimal_Cero;
				SET	Var_Abonos	:= Par_Monto;
			END IF;

		    CALL POLIZASCREDITOCONTPRO(
		        Par_Poliza,         Par_EmpresaID,        Par_FechaAplicacion,    Par_CreditoID,      Par_ProdCreditoID,
		        Par_SucCliente,     Par_ConcContaCre,   Par_Clasificacion,      Par_SubClasifica,   Var_Cargos,
		        Var_Abonos,         Par_MonedaID,       Par_Descripcion,        Var_CreditoStr,     Salida_No,
		        Par_NumErr,			Par_ErrMen,         Par_Consecutivo,    	Aud_Usuario,        Aud_FechaActual,
		        Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion);

		    IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF (Par_AltaMovAho = AltaMovAho_SI	) THEN
			IF(Par_NatAhorro = Nat_Cargo) THEN
				SET	Var_Cargos	:= Par_Monto;
				SET	Var_Abonos	:= Decimal_Cero;
			ELSE
				SET	Var_Cargos	:= Decimal_Cero;
				SET	Var_Abonos	:= Par_Monto;
			END IF;
			CALL CUENTASAHOMOVSALT(
				Par_CuentaAhoID, 	Aud_NumTransaccion, 	Par_FechaAplicacion, 		Par_NatAhorro, 		Par_Monto,
				Par_Descripcion,	Var_CreditoStr,			Par_TipoMovAho,				Salida_No,			Par_NumErr,
				Par_ErrMen,			Par_EmpresaID, 			Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			CALL POLIZASAHORROPRO(
				Par_Poliza,			Par_EmpresaID,		Par_FechaAplicacion, 		Par_ClienteID,		Con_AhoCapital,
				Par_CuentaAhoID,	Par_MonedaID,		Var_Cargos,					Var_Abonos,			Par_Descripcion,
				Var_CuentaStr,		Salida_No,			Par_NumErr,					Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);
			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Informacion Procesada Exitosamente.');
		SET Var_Control	:= 'cuentaAhoID' ;
		SET Var_Consecutivo := IFNULL(Par_Consecutivo, Entero_Cero);

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$