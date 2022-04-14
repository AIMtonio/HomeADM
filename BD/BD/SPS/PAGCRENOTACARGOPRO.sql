-- PAGCRENOTACARGOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCRENOTACARGOPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCRENOTACARGOPRO`(
	-- SP para realizar el pago por los conceptos de notas de cargos.
	Par_CreditoID				BIGINT(12),		-- Numero de credito
	Par_AmortiCreID				INT(4),			-- Numero de amortizacion
	Par_FechaInicio				DATE,			-- Fecha de inicio
	Par_FechaVencim				DATE,			-- Fecha de Vencimiento
	Par_CuentaAhoID				BIGINT(12),		-- NUmero de cuenta de ahorro

	Par_ClienteID				BIGINT(12),		-- Numero de cliente
	Par_FechaOperacion			DATE,			-- Fecha de operacion
	Par_FechaAplicacion			DATE,			-- Fecha de aplicacion
	Par_Monto					DECIMAL(14,4),	-- Monto de operacion
	Par_IVAMonto				DECIMAL(12,2),	-- MOnto Iva de operacion

	Par_MonedaID				INT(11),		-- Tipo de moneda
	Par_ProdCreditoID			INT(11),		-- Producto de credito
	Par_Clasificacion			CHAR(1),		-- Clasificacion
	Par_SubClasifID				INT(11),		-- Subclasificacion
	Par_SucCliente				INT(11),		-- SubCliente

	Par_Descripcion				VARCHAR(100),	-- Variable de descripcion
	Par_Referencia				VARCHAR(50),	-- Referencia
	Par_Poliza					BIGINT,			-- Numero de poliza
	Par_OrigenPago				CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_Salida					CHAR(1),		-- Parametro de salida Si

	INOUT	Par_NumErr			INT(11),		-- Parametro de salida Numero de error
	INOUT	Par_ErrMen			VARCHAR(400),	-- parametro de salida  mensaje de error
	INOUT	Par_Consecutivo		BIGINT,			-- parametro consecutivo

	Par_EmpresaID				INT(11),		-- Parametro de auditoria
	Par_ModoPago				CHAR(1),
	Aud_Usuario					INT(11),		-- Parametro de auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal				INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria
)TerminaStore: BEGIN

	-- Declaracion de constante
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE	Decimal_Cero		DECIMAL(12, 2);	-- Decimal cero

	DECLARE	AltaPoliza_NO		CHAR(1);		-- Alta Poliza S = Si
	DECLARE	AltaPolCre_SI		CHAR(1);		-- Alta Poliza N = No
	DECLARE	AltaMovCre_SI		CHAR(1);		-- Alta Movimiento del credito S = Si
	DECLARE	AltaMovCre_NO		CHAR(1);		-- Alta Movimiento del credito N = No
	DECLARE	AltaMovAho_NO		CHAR(1);		-- Alta Moviento Ahorro N = No
	DECLARE	Str_SI				CHAR(1);		-- Cosntante S = SI
	DECLARE	Str_NO				CHAR(1);		-- Cosntante N = NO
	DECLARE	Nat_Cargo		CHAR(1);			-- Naturaleza del Movimiento C= Cargo
	DECLARE	Nat_Abono		CHAR(1);			-- Naturaleza del Movimiento A= Abono
	DECLARE	Mov_NotaCargoConIVA		INT(11);	-- Movimiento de credito por Nota de Cargo con iva
	DECLARE	Mov_NotaCargoSinIVA		INT(11);	-- Movimiento de credito por Nota de Cargo sin iva
	DECLARE	Mov_NotaCargoNoRecon	INT(11);	-- Movimiento de credito por Nota de Cargo no reconocido
	DECLARE	Mov_IVANotaCargo		INT(11);	-- Movimiento de credito por Nota de Cargo IVA
	DECLARE	Con_CueOrdNotaCargo		INT(11);	-- Concepto Contable: Cta. Ord. Nota de Cargo
	DECLARE	Con_CorOrdNotaCargo		INT(11);	-- Concepto Contable:Corr. Cta. Ord. Nota de Cargo
	DECLARE Con_NotRecNotaCargo		INT(11);	-- Nota de Cargo Pago No Reconocido
	DECLARE Con_IVANotaCargo		INT(11);	-- IVA de Nota de Cargo
	DECLARE Con_IngNotaCargo		INT(11);	-- Concepto de ingreso por nota de cargo

	-- Declaracion de Variable
	DECLARE varControl					CHAR(100);		-- Variable de control
	DECLARE Var_SaldoNotCargoRev		DECIMAL(12,2);	--  Variable  por el concepto de notas cargo no reconocido
	DECLARE Var_SaldoNotCargoSinIVA		DECIMAL(12,2);	--  Variable por el concepto de notas cargos sin IVA
	DECLARE Var_SaldoNotCargoConIVA		DECIMAL(12,2);	--  Variable por el concepto de notas cargos con IVA
	DECLARE Var_Cantidad				DECIMAL(12,2);	--  Variable por la cantidad

	-- Asignacion de constante
	SET	Cadena_Vacia			:= '';				-- Cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero cero
	SET	Decimal_Cero			:= 0.00;			-- Decimal cero
	SET	AltaPoliza_NO			:= 'N';				-- Alta Poliza S = Si
	SET	AltaPolCre_SI			:= 'S';				-- Alta Poliza N = No
	SET	AltaMovCre_SI			:= 'S';				-- Alta Movimiento del credito S = Si
	SET	AltaMovCre_NO			:= 'N';				-- Alta Movimiento del credito N = No
	SET	AltaMovAho_NO			:= 'N';				-- Alta Moviento Ahorro N = No
	SET	Str_SI					:= 'S';				-- Cosntante S = SI
	SET	Str_NO					:= 'N';				-- Cosntante N = NO
	SET Nat_Cargo				:= 'C';				-- Naturaleza del Movimiento C= Cargo
	SET Nat_Abono				:= 'A';				-- Naturaleza del Movimiento A= Abono
	SET	Mov_NotaCargoConIVA		:= 53;				-- Movimiento de credito por Nota de Cargo con iva
	SET	Mov_NotaCargoSinIVA		:= 54;				-- Movimiento de credito por Nota de Cargo sin iva
	SET	Mov_NotaCargoNoRecon	:= 55;				-- Movimiento de credito por Nota de Cargo no reconocido
	SET	Mov_IVANotaCargo		:= 56;				-- Movimiento de credito por Nota de Cargo IVA
	SET	Con_CueOrdNotaCargo		:= 136;				-- Concepto Contable: Cta. Ord. Nota de Cargo
	SET	Con_CorOrdNotaCargo		:= 137;				-- Concepto Contable: Corr. Cta. Ord. Nota de Cargo
	SET Con_NotRecNotaCargo		:= 133;				-- Nota de Cargo Pago No Reconocido
	SET Con_IVANotaCargo		:= 135;				-- IVA de Nota de Cargo
	SET Con_IngNotaCargo		:= 134;				-- Concepto de ingreso por nota de cargo
	SET Var_Cantidad			:= Decimal_Cero;

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: PAGCRENOTACARGOPRO');
				SET varControl = 'sqlException' ;
			END;

	SELECT SaldoNotCargoRev,	SaldoNotCargoSinIVA,	SaldoNotCargoConIVA
		INTO Var_SaldoNotCargoRev,	Var_SaldoNotCargoSinIVA,	Var_SaldoNotCargoConIVA
		FROM AMORTICREDITO
		WHERE CreditoID		= Par_CreditoID
		AND AmortizacionID = Par_AmortiCreID;

		SET Var_SaldoNotCargoRev	:= IFNULL(Var_SaldoNotCargoRev, Decimal_Cero);
		SET Var_SaldoNotCargoSinIVA	:= IFNULL(Var_SaldoNotCargoSinIVA, Decimal_Cero);
		SET Var_SaldoNotCargoConIVA	:= IFNULL(Var_SaldoNotCargoConIVA, Decimal_Cero);

	-- Realizamos el cobro por el concepto de Nota de cargo con IVA
	IF (Var_SaldoNotCargoConIVA > Entero_Cero AND Par_Monto > Entero_Cero) THEN

		IF(Var_SaldoNotCargoConIVA > Par_Monto) THEN
			SET Var_Cantidad	:= Par_Monto;
		ELSE
			SET Var_Cantidad	:= Var_SaldoNotCargoConIVA;
		END IF;

		-- Realizamos el abono ala cuenta de ingreso por nota de cargo
		CALL  CONTACREDITOSPRO (	Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,		Par_ClienteID,			Par_FechaOperacion,
									Par_FechaAplicacion,	Var_Cantidad,			Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
									Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,		Par_Referencia,			AltaPoliza_NO,
									Entero_Cero,			Par_Poliza,				AltaPolCre_SI,			AltaMovCre_SI,			Con_IngNotaCargo,
									Mov_NotaCargoConIVA,	Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
									Par_OrigenPago,			Str_NO,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
									Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Realizamos el cargo por el monto a pagar a la cuenta de orden correlativa
		CALL CONTACREDITOSPRO (	Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,		Par_ClienteID,			Par_FechaOperacion,
								Par_FechaAplicacion,	Var_Cantidad,			Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
								Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,		Par_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Par_Poliza,				AltaPolCre_SI,			AltaMovCre_NO,			Con_CorOrdNotaCargo,
								Mov_NotaCargoConIVA,	Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
								Par_OrigenPago,			Str_NO,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
								Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Realizamos el cargo por el monto a pagar a la cuenta de orden
		CALL CONTACREDITOSPRO (	Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,		Par_ClienteID,			Par_FechaOperacion,
								Par_FechaAplicacion,	Var_Cantidad,			Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
								Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,		Par_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Par_Poliza,				AltaPolCre_SI,			AltaMovCre_NO,			Con_CueOrdNotaCargo,
								Mov_NotaCargoConIVA,	Nat_Cargo,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
								Par_OrigenPago,			Str_NO,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
								Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Registramos el movimiento por el cobro del IVA
		IF (Par_IVAMonto > Decimal_Cero) THEN
			CALL CONTACREDITOSPRO (	Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,		Par_ClienteID,		Par_FechaOperacion,
									Par_FechaAplicacion,	Par_IVAMonto,			Par_MonedaID,			Par_ProdCreditoID,	Par_Clasificacion,
									Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,		Par_Referencia,		AltaPoliza_NO,
									Entero_Cero,			Par_Poliza,				AltaPolCre_SI,			AltaMovCre_SI,		Con_IVANotaCargo,
									Mov_IVANotaCargo,		Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,		Cadena_Vacia,
									Par_OrigenPago,			Str_NO,					Par_NumErr,				Par_ErrMen,			Par_Consecutivo,
									Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		SET Par_Monto	:= Par_Monto - Var_Cantidad;
		SET Var_Cantidad := Decimal_Cero;
	END IF;

	-- Realizamos el cobro por el concepto de Nota de cargo Sin IVA
	IF (Var_SaldoNotCargoSinIVA > Entero_Cero AND Par_Monto > Entero_Cero) THEN

		IF(Var_SaldoNotCargoSinIVA > Par_Monto) THEN
			SET Var_Cantidad	:= Par_Monto;
		ELSE
			SET Var_Cantidad	:= Var_SaldoNotCargoSinIVA;
		END IF;

		-- Realizamos el abono ala cuenta de ingreso por nota de cargo
		CALL  CONTACREDITOSPRO (	Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,		Par_ClienteID,			Par_FechaOperacion,
									Par_FechaAplicacion,	Var_Cantidad,			Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
									Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,		Par_Referencia,			AltaPoliza_NO,
									Entero_Cero,			Par_Poliza,				AltaPolCre_SI,			AltaMovCre_SI,			Con_IngNotaCargo,
									Mov_NotaCargoSinIVA,	Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
									Par_OrigenPago,			Str_NO,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
									Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Realizamos el cargo por el monto a pagar a la cuenta de orden correlativa
		CALL CONTACREDITOSPRO (	Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,		Par_ClienteID,			Par_FechaOperacion,
								Par_FechaAplicacion,	Var_Cantidad,			Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
								Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,		Par_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Par_Poliza,				AltaPolCre_SI,			AltaMovCre_NO,			Con_CorOrdNotaCargo,
								Mov_NotaCargoSinIVA,	Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
								Par_OrigenPago,			Str_NO,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
								Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Realizamos el cargo por el monto a pagar a la cuenta de orden
		CALL CONTACREDITOSPRO (	Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,		Par_ClienteID,			Par_FechaOperacion,
								Par_FechaAplicacion,	Var_Cantidad,			Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
								Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,		Par_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Par_Poliza,				AltaPolCre_SI,			AltaMovCre_NO,			Con_CueOrdNotaCargo,
								Mov_NotaCargoSinIVA,	Nat_Cargo,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
								Par_OrigenPago,			Str_NO,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
								Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_Monto	:= Par_Monto - Var_Cantidad;
		SET Var_Cantidad := Decimal_Cero;
	END IF;

	-- Realizamos el cobro por el concepto de Nota de cargo no reconocido
	IF (Var_SaldoNotCargoRev > Entero_Cero AND Par_Monto > Entero_Cero) THEN
		IF(Var_SaldoNotCargoRev > Par_Monto) THEN
			SET Var_Cantidad	:= Par_Monto;
		ELSE
			SET Var_Cantidad	:= Var_SaldoNotCargoRev;
		END IF;

		-- Registramos el movimiento de abono por el concepto de pago notas no reconocido.
		CALL  CONTACREDITOSPRO (	Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,		Par_ClienteID,			Par_FechaOperacion,
									Par_FechaAplicacion,	Par_Monto,				Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
									Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,		Par_Referencia,			AltaPoliza_NO,
									Entero_Cero,			Par_Poliza,				AltaPolCre_SI,			AltaMovCre_SI,			Con_NotRecNotaCargo,
									Mov_NotaCargoNoRecon,	Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
									Par_OrigenPago,			Str_NO,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
									Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_Monto	:= Par_Monto - Var_Cantidad;
		SET Var_Cantidad := Decimal_Cero;
	END IF;

	SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= 'Nota de cargo Pagado exitosamente.';
	SET varControl	:= 'producCreditoID' ;
	LEAVE ManejoErrores;
END ManejoErrores;

	IF (Par_Salida = Str_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3))	AS NumErr,
				Par_ErrMen			AS ErrMen,
				varControl			AS control,
				Par_CreditoID		AS consecutivo;
	END IF;

END TerminaStore$$
