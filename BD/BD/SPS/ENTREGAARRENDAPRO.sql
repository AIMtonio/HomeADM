-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ENTREGAARRENDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ENTREGAARRENDAPRO`;DELIMITER $$

CREATE PROCEDURE `ENTREGAARRENDAPRO`(
# ===============================================================================================
# -- STORED PROCEDURE PARA LA ENTREGA DE UN ARRENDAMIENTO
# ===============================================================================================
	Par_ArrendaID		BIGINT(12),			-- ID del arrendamiento

	Par_Salida			CHAR(1),			-- Indica si el SP genera o no una salida
	INOUT Par_NumErr	INT(11),			-- Parametro de salida que indica el num. de error
	INOUT Par_ErrMen	VARCHAR(400),		-- Parametro de salida que indica el mensaje de eror

	Par_EmpresaID		INT(11),			-- Parametros de Auditoria
	Aud_Usuario			INT(11),			-- Parametros de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal		INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(50);						-- Variable de Control
	DECLARE Var_FechaApertura	DATE;								-- Fecha de apertura
	DECLARE Var_FechaSucursal	DATE;								-- Fecha de sucursal
	DECLARE Var_SumSaldoCap		DECIMAL(14, 4);						-- Variable para el total del saldo capital
	DECLARE Var_SumSaldoInt		DECIMAL(14, 4);						-- Variable para el total del saldo de interes
	DECLARE Var_SumSeguro		DECIMAL(14, 4);						-- Variable para el total del seguro
	DECLARE Var_SumSeguroVida	DECIMAL(14, 4);						-- Variable para el total del seguro de vida
	DECLARE Var_TipoArrenda		CHAR(1);							-- Tipo de arrendamiento
	DECLARE Var_ProducArrendaID	INT(4);								-- ID del producto
	DECLARE Var_ClienteID		INT(11);							-- ID del cliente
	DECLARE Var_SucursArrenda	INT(11);							-- ID de sucursal
	DECLARE Var_DescCapVigente	VARCHAR(50);						-- Descripcion de capital vigente
	DECLARE Var_DescInterVig	VARCHAR(50);						-- Descripcion de interes vigente
	DECLARE Var_DescSeguro		VARCHAR(50);						-- Descripcion de seguro
	DECLARE Var_DescSeguroVida	VARCHAR(50);						-- Descripcion de seguro de vida
	DECLARE Var_ArrendaAmortiID	INT(11);							-- Variable para el ciclo while
	DECLARE Var_MaxAmorti		INT(11);							-- Variable para el numero de amortizaciones que tenga el arrendamiento
	DECLARE Var_SaldoCapVig		DECIMAL(14, 4);						-- Variable para el saldo capital de la amortizacion
	DECLARE Var_SaldoIntVig		DECIMAL(14, 4);						-- Variable para el saldo de interes de la amortizacion
	DECLARE Var_SaldoSeguro		DECIMAL(14, 4);						-- Variable para el seguro de la amortizacion
	DECLARE Var_SaldoSegVida	DECIMAL(14, 4);						-- Variable para el seguro de vida de la amortizacion
	DECLARE Var_Poliza			BIGINT;								-- Numero generado de la poliza
	DECLARE Var_MonedaID		INT(11);							-- ID del tipo de moneda Peso
	DECLARE Var_Estatus			CHAR(1);							-- Estatus del arrendamiento
	DECLARE Var_PagareImpreso	CHAR(1);							-- Pagare impreso
	DECLARE Var_PagoInicial		CHAR(1);							-- Estatus de pago inicial

	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);							-- Cadena Vacia
	DECLARE Entero_Cero			INT(11);							-- Entero cero
	DECLARE Decimal_Cero		DECIMAL(14,4);						-- Decimal cero
	DECLARE Salida_Si			CHAR(1);							-- Indica que si se devuelve un mensaje de salida
	DECLARE Salida_No			CHAR(1);							-- Indica que no se devuelve un mensaje de salida
	DECLARE Est_Vigente			CHAR(1);							-- Estatus vigente
	DECLARE Var_TipConCapVig	INT(4);								-- Tipo de concepto para Capital vigente
	DECLARE Var_TipConIntVig	INT(4);								-- Tipo de concepto para Interes vigente
	DECLARE Var_TipConSeguro	INT(4);								-- Tipo de concepto para Seguro
	DECLARE Var_TipConSegVida	INT(4);								-- Tipo de concepto para Seguro de vida
	DECLARE Var_TipConArrPag	INT(4);								-- Tipo de concepto para Arrendamientos por pagar
	DECLARE Var_DesPoliza		VARCHAR(50);						-- Descripcion de poliza
	DECLARE AltaPoliza_Si		CHAR(1);							-- Dar de alta el encabezado de la poliza
	DECLARE AltaPoliza_No		CHAR(1);							-- No dar de alta el encabezado de la poliza
	DECLARE AltaDePoliza_Si		CHAR(1);							-- Alta del detalle de la poliza en: DETALLEPOLIZA
	DECLARE AltaDePoliza_No		CHAR(1);							-- Alta del detalle de la poliza en: DETALLEPOLIZA
	DECLARE AltaMovs_Si			CHAR(1);							-- Se registra el movimiento en la tabla: ARRENDAMIENTOMOVS
	DECLARE AltaMovs_No			CHAR(1);							-- No se registra el movimiento en la tabla: ARRENDAMIENTOMOVS
	DECLARE Var_TipMovCapVig	INT(4);								-- Tipo de movimiento para Capital vigente
	DECLARE Var_TipMovIntVig	INT(4);								-- Tipo de movimiento para Interes vigente
	DECLARE Var_TipMovSeguro	INT(4);								-- Tipo de movimiento para Seguro
	DECLARE Var_TipMovSegVida	INT(4);								-- Tipo de movimiento para Seguro de vida
	DECLARE Var_NaturaCargo		CHAR(1);							-- Naturaleza del Movimiento Cargo
	DECLARE Var_NaturaAbono		CHAR(1);							-- Naturaleza del Movimiento Abono
	DECLARE Var_PlazoCorto		CHAR(1);							-- Plazo C = corto
	DECLARE Var_ConceptoCon		INT(11);							-- CONCEPTO CONTABLE - Tabla CONCEPTOSCONTA
	DECLARE Est_Autorizado		CHAR(1);							-- Estatus autorizado
	DECLARE Est_Pagado			CHAR(1);							-- Estatus pagado
	DECLARE Var_EsPagareImpreso	CHAR(1);							-- Pagare impreso
	DECLARE Est_PagoInicial		CHAR(1);							-- Estatus de pago inicial

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';								-- Cadena Vacia
	SET	Entero_Cero				:= 0;								-- Entero cero
	SET	Decimal_Cero			:= 0.0000;							-- Decimal cero
	SET	Salida_Si				:= 'S';								-- El SP si genera una salida
	SET Salida_No				:= 'N';								-- El SP no genera una salida
	SET Est_Vigente				:= 'V';								-- Estado vigente = V
	SET Var_TipConCapVig 		:= 1;								-- Concepto 1 para Capital vigente. Tabla: CONCEPTOSARRENDA
	SET Var_TipConIntVig 		:= 19;								-- Concepto 19 para interes vigente. Tabla: CONCEPTOSARRENDA
	SET Var_TipConSeguro 		:= 17;								-- Concepto 17 para Seguro. Tabla: CONCEPTOSARRENDA
	SET Var_TipConSegVida 		:= 18;								-- Concepto 18 para Seguro de vida. Tabla: CONCEPTOSARRENDA
	SET Var_TipConArrPag 		:= 34;								-- Concepto 34 para Arrendamientos por pagar. Tabla: CONCEPTOSARRENDA
	SET Var_DesPoliza			:= 'ENTREGA ARRENDAMIENTO';			-- Descripcion cierre
	SET AltaPoliza_Si			:= 'S';								-- Alta del Encabezado de la Poliza: SI
	SET AltaPoliza_No			:= 'N';								-- Alta del Encabezado de la Poliza: NO
	SET AltaDePoliza_Si			:= 'S';								-- Alta de la Poliza: SI
	SET AltaDePoliza_No			:= 'N';								-- Alta de la Poliza: NO
	SET AltaMovs_Si				:= 'S';								-- Alta del Movimiento: SI
	SET AltaMovs_No				:= 'N';								-- Alta del Movimiento: NO
	SET Var_TipMovCapVig 		:= 1;								-- Movimiento 1 para Capital vigente. Tabla: TIPOSMOVSARRENDA
	SET Var_TipMovIntVig 		:= 10;								-- Movimiento 10 para interes vigente. Tabla: TIPOSMOVSARRENDA
	SET Var_TipMovSeguro 		:= 49;								-- Movimiento 49 para Seguro. Tabla: TIPOSMOVSARRENDA
	SET Var_TipMovSegVida 		:= 50;								-- Movimiento 50 para Seguro de vida. Tabla: TIPOSMOVSARRENDA
	SET Var_NaturaCargo			:= 'C';								-- Cargo = C
	SET Var_NaturaAbono			:= 'A';								-- Abono = A
	SET Var_PlazoCorto			:= 'C';								-- Plazo C = corto
	SET Var_ConceptoCon			:= 841;								-- CONCEPTO CONTABLE: ENTREGA ARRENDAMIENTO
	SET Est_Autorizado			:= 'A';								-- Estado autorizado = A
	SET Est_Pagado				:= 'P';								-- Estado pagado = P
	SET Var_EsPagareImpreso		:= 'S';								-- Pagare impreso = S
	SET Est_PagoInicial			:= 'S';								-- Estatus de Pago Inicial = S

	-- Valores por default
	SET Par_ArrendaID			:= IFNULL(Par_ArrendaID, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-ENTREGAARRENDAPRO');
			SET Var_Control = 'sqlException';
		END;

		IF(Par_ArrendaID = Entero_Cero) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El numero de arrendamiento esta vacio';
			SET Var_Control := 'Par_ArrendaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	FechaApertura
			INTO Var_FechaApertura
			FROM ARRENDAMIENTOS
			WHERE	ArrendaID = Par_ArrendaID;

		SELECT	FechaSucursal
			INTO Var_FechaSucursal
			FROM SUCURSALES
			WHERE	SucursalID = Aud_Sucursal;

		IF(Var_FechaApertura != Var_FechaSucursal) THEN
			SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'La fecha de apertura no corresponde con la fecha de sistema';
			SET Var_Control := 'Var_FechaApertura';
			LEAVE ManejoErrores;
		END IF;

		SELECT		arrenda.TipoArrenda,	mon.MonedaID,			prod.ProductoArrendaID,	cli.ClienteID,	suc.SucursalID,
					arrenda.Estatus,		arrenda.PagareImpreso,	arrenda.EsPagoInicial
			INTO	Var_TipoArrenda,		Var_MonedaID,			Var_ProducArrendaID,	Var_ClienteID,	Var_SucursArrenda,
					Var_Estatus,			Var_PagareImpreso,		Var_PagoInicial
			FROM	ARRENDAMIENTOS arrenda
			INNER JOIN	MONEDAS mon				ON arrenda.MonedaID				= mon.MonedaId
			INNER JOIN	PRODUCTOARRENDA prod	ON arrenda.ProductoArrendaID	= prod.ProductoArrendaID
			INNER JOIN	CLIENTES cli			ON arrenda.ClienteID			= cli.ClienteID
			INNER JOIN	SUCURSALES suc			ON arrenda.SucursalID			= suc.SucursalID
			WHERE	ArrendaID = Par_ArrendaID;

		SET Var_MonedaID		:= IFNULL(Var_MonedaID, Entero_Cero);
		SET Var_ProducArrendaID	:= IFNULL(Var_ProducArrendaID, Entero_Cero);
		SET Var_ClienteID		:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_SucursArrenda	:= IFNULL(Var_SucursArrenda, Entero_Cero);

		IF Var_MonedaID = Entero_Cero THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'La moneda no existe.';
			SET Var_Control	:= 'Var_MonedaID';
			LEAVE ManejoErrores;
		END IF;

		IF Var_ProducArrendaID = Entero_Cero THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= 'El producto no existe.';
			SET Var_Control	:= 'Var_ProducArrendaID';
			LEAVE ManejoErrores;
		END IF;

		IF Var_ClienteID = Entero_Cero THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= 'El cliente no existe.';
			SET Var_Control	:= 'Var_ClienteID';
			LEAVE ManejoErrores;
		END IF;

		IF Var_SucursArrenda = Entero_Cero THEN
			SET Par_NumErr	:= 006;
			SET Par_ErrMen	:= 'La sucursal no existe.';
			SET Var_Control	:= 'Var_SucursArrenda';
			LEAVE ManejoErrores;
		END IF;

		IF Var_Estatus != Est_Autorizado THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen	:= 'El arrendamiento no esta autorizado.';
			SET Var_Control	:= 'Var_Estatus';
			LEAVE ManejoErrores;
		END IF;

		IF Var_PagareImpreso != Var_EsPagareImpreso THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen	:= 'El pagare no ha sido impreso.';
			SET Var_Control	:= 'Var_PagareImpreso';
			LEAVE ManejoErrores;
		END IF;

		IF Var_PagoInicial != Est_PagoInicial THEN
			SET Par_NumErr	:= 009;
			SET Par_ErrMen	:= 'El enganche no ha sido pagado.';
			SET Var_Control	:= 'Var_PagoInicial';
			LEAVE ManejoErrores;
		END IF;

		-- Actualizar el estatus de producto a vigente
		UPDATE ARRENDAAMORTI SET
			Estatus				= Est_Vigente,
			SaldoCapVigent		= CapitalRenta,
			SaldoInteresVigente	= InteresRenta,
			SaldoSeguro			= Seguro,
			SaldoSeguroVida		= SeguroVida,

			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE ArrendaID = Par_ArrendaID
		  AND Estatus <> Est_Pagado;

		SELECT		SUM(SaldoCapVigent),	SUM(SaldoInteresVigente),	SUM(SaldoSeguro),	SUM(SaldoSeguroVida)
			INTO 	Var_SumSaldoCap,		Var_SumSaldoInt,			Var_SumSeguro, 		Var_SumSeguroVida
			FROM	ARRENDAAMORTI
			WHERE	ArrendaID = Par_ArrendaID
			  AND	Estatus <> Est_Pagado;

		SET Var_SumSaldoCap		:= IFNULL(Var_SumSaldoCap, Decimal_Cero);
		SET Var_SumSaldoInt		:= IFNULL(Var_SumSaldoInt, Decimal_Cero);
		SET Var_SumSeguro		:= IFNULL(Var_SumSeguro, Decimal_Cero);
		SET Var_SumSeguroVida	:= IFNULL(Var_SumSeguroVida, Decimal_Cero);

		UPDATE ARRENDAMIENTOS SET
			Estatus		 		= Est_Vigente,
			SaldoCapVigente		= Var_SumSaldoCap,
			SaldoInteresVigent	= Var_SumSaldoInt,
			SaldoSeguro			= Var_SumSeguro,
			SaldoSeguroVida		= Var_SumSeguroVida,

			EmpresaID	 		= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE ArrendaID = Par_ArrendaID;

		SELECT		Descripcion
			INTO	Var_DescCapVigente
			FROM	CONCEPTOSARRENDA
			WHERE	ConceptoArrendaID = Var_TipConCapVig;

		SELECT		Descripcion
			INTO	Var_DescInterVig
			FROM	CONCEPTOSARRENDA
			WHERE	ConceptoArrendaID = Var_TipConIntVig;

		SELECT		Descripcion
			INTO	Var_DescSeguro
			FROM	CONCEPTOSARRENDA
			WHERE	ConceptoArrendaID = Var_TipConSeguro;

		SELECT		Descripcion
			INTO	Var_DescSeguroVida
			FROM	CONCEPTOSARRENDA
			WHERE	ConceptoArrendaID = Var_TipConSegVida;

		-- Registro de Contabilidad para Saldo capital vigente
		CALL CONTAARRENDAPRO(Var_FechaSucursal,	Var_FechaSucursal, 		Var_TipoArrenda,	Var_ProducArrendaID,	Var_TipConCapVig,
							Par_ArrendaID,		Entero_Cero,			Var_ClienteID,		Var_MonedaID, 			Var_DesPoliza,
							Var_DescCapVigente,	Var_SumSaldoCap,		AltaPoliza_Si,		Var_ConceptoCon,		AltaDePoliza_Si,
							AltaMovs_No,		Var_TipConCapVig,		Var_TipMovCapVig,	Var_NaturaCargo,		Cadena_Vacia,
							Var_PlazoCorto,		Var_SucursArrenda,		Aud_NumTransaccion,	Salida_No,				Var_Poliza,
							Par_NumErr,			Par_ErrMen,				Entero_Cero,		Par_EmpresaID,			Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		CALL CONTAARRENDAPRO(Var_FechaSucursal,	Var_FechaSucursal, 		Var_TipoArrenda,	Var_ProducArrendaID,	Var_TipConArrPag,
							Par_ArrendaID,		Entero_Cero,			Var_ClienteID,		Var_MonedaID,			Var_DesPoliza,
							Var_DescCapVigente,	Var_SumSaldoCap,		AltaPoliza_No,		Var_ConceptoCon,		AltaDePoliza_Si,
							AltaMovs_No,		Var_TipConArrPag,		Var_TipMovCapVig,	Var_NaturaAbono,		Cadena_Vacia,
							Var_PlazoCorto,		Var_SucursArrenda,		Aud_NumTransaccion,	Salida_No,				Var_Poliza,
							Par_NumErr,			Par_ErrMen,				Entero_Cero,		Par_EmpresaID,			Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		-- Registro de Contabilidad para Saldo interes vigente
		CALL CONTAARRENDAPRO(Var_FechaSucursal,	Var_FechaSucursal, 		Var_TipoArrenda,	Var_ProducArrendaID,	Var_TipConIntVig,
							Par_ArrendaID,		Entero_Cero,			Var_ClienteID,		Var_MonedaID,			Var_DesPoliza,
							Var_DescInterVig,	Var_SumSaldoInt,		AltaPoliza_No,		Var_ConceptoCon,		AltaDePoliza_Si,
							AltaMovs_No,		Var_TipConIntVig,		Var_TipMovIntVig,	Var_NaturaCargo,		Cadena_Vacia,
							Var_PlazoCorto,		Var_SucursArrenda,		Aud_NumTransaccion,	Salida_No,				Var_Poliza,
							Par_NumErr,			Par_ErrMen,				Entero_Cero,		Par_EmpresaID,			Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		CALL CONTAARRENDAPRO(Var_FechaSucursal,	Var_FechaSucursal, 		Var_TipoArrenda,	Var_ProducArrendaID,	Var_TipConArrPag,
							Par_ArrendaID,		Entero_Cero,			Var_ClienteID,		Var_MonedaID,			Var_DesPoliza,
							Var_DescInterVig,	Var_SumSaldoInt,		AltaPoliza_No,		Var_ConceptoCon,		AltaDePoliza_Si,
							AltaMovs_No,		Var_TipConArrPag,		Var_TipMovIntVig,	Var_NaturaAbono,		Cadena_Vacia,
							Var_PlazoCorto,		Var_SucursArrenda,		Aud_NumTransaccion,	Salida_No,				Var_Poliza,
							Par_NumErr,			Par_ErrMen,				Entero_Cero,		Par_EmpresaID,			Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF Var_SumSeguro > Decimal_Cero THEN
			-- Registro de Contabilidad para Saldo seguro
			CALL CONTAARRENDAPRO(Var_FechaSucursal,	Var_FechaSucursal, 		Var_TipoArrenda,	Var_ProducArrendaID,	Var_TipConSeguro,
								Par_ArrendaID,		Entero_Cero,			Var_ClienteID,		Var_MonedaID, 			Var_DesPoliza,
								Var_DescSeguro,		Var_SumSeguro,			AltaPoliza_No,		Var_ConceptoCon,		AltaDePoliza_Si,
								AltaMovs_No,		Var_TipConSeguro,		Var_TipMovSeguro,	Var_NaturaCargo,		Cadena_Vacia,
								Var_PlazoCorto,		Var_SucursArrenda,		Aud_NumTransaccion,	Salida_No,				Var_Poliza,
								Par_NumErr,			Par_ErrMen,				Entero_Cero,		Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			CALL CONTAARRENDAPRO(Var_FechaSucursal,	Var_FechaSucursal, 		Var_TipoArrenda,	Var_ProducArrendaID,	Var_TipConArrPag,
								Par_ArrendaID,		Entero_Cero,			Var_ClienteID,		Var_MonedaID,			Var_DesPoliza,
								Var_DescSeguro,		Var_SumSeguro,			AltaPoliza_No,		Var_ConceptoCon,		AltaDePoliza_Si,
								AltaMovs_No,		Var_TipConArrPag,		Var_TipMovSeguro,	Var_NaturaAbono,		Cadena_Vacia,
								Var_PlazoCorto,		Var_SucursArrenda,		Aud_NumTransaccion,	Salida_No,				Var_Poliza,
								Par_NumErr,			Par_ErrMen,				Entero_Cero,		Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
		END IF;

		IF Var_SumSeguroVida > Decimal_Cero THEN
			-- Registro de Contabilidad para Saldo seguro vida
			CALL CONTAARRENDAPRO(Var_FechaSucursal,	Var_FechaSucursal, 		Var_TipoArrenda,	Var_ProducArrendaID,	Var_TipConSegVida,
								Par_ArrendaID,		Entero_Cero,			Var_ClienteID,		Var_MonedaID,			Var_DesPoliza,
								Var_DescSeguroVida,	Var_SumSeguroVida,		AltaPoliza_No,		Var_ConceptoCon,		AltaDePoliza_Si,
								AltaMovs_No,		Var_TipConSegVida,		Var_TipMovSegVida,	Var_NaturaCargo,		Cadena_Vacia,
								Var_PlazoCorto,		Var_SucursArrenda,		Aud_NumTransaccion,	Salida_No,				Var_Poliza,
								Par_NumErr,			Par_ErrMen,				Entero_Cero,		Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			CALL CONTAARRENDAPRO(Var_FechaSucursal,	Var_FechaSucursal, 		Var_TipoArrenda,	Var_ProducArrendaID,	Var_TipConArrPag,
								Par_ArrendaID,		Entero_Cero,			Var_ClienteID,		Var_MonedaID,			Var_DesPoliza,
								Var_DescSeguroVida,	Var_SumSeguroVida,		AltaPoliza_No,		Var_ConceptoCon,		AltaDePoliza_Si,
								AltaMovs_No,		Var_TipConArrPag,		Var_TipMovSegVida,	Var_NaturaAbono,		Cadena_Vacia,
								Var_PlazoCorto,		Var_SucursArrenda,		Aud_NumTransaccion,	Salida_No,				Var_Poliza,
								Par_NumErr,			Par_ErrMen,				Entero_Cero,		Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
		END IF;

		-- Se hace un conteo de las amortizaciones que tiene el arrendamiento
		SELECT	COUNT(ArrendaAmortiID)
			INTO Var_MaxAmorti
			FROM ARRENDAAMORTI
			WHERE	ArrendaID	= Par_ArrendaID;

		SET Var_ArrendaAmortiID	:= 1;

		-- Registros de movimientos por amortizacion
		IteraCuotas: WHILE Var_ArrendaAmortiID <= Var_MaxAmorti DO
			-- Se obtienen los valores de los saldos de la amortizacion actual
			SELECT		SaldoCapVigent,		SaldoInteresVigente,	SaldoSeguro,		SaldoSeguroVida,	Estatus
				INTO	Var_SaldoCapVig,	Var_SaldoIntVig,		Var_SaldoSeguro,	Var_SaldoSegVida,	Var_Estatus
				FROM	ARRENDAAMORTI
				WHERE	ArrendaID		= Par_ArrendaID
				  AND	ArrendaAmortiID	= Var_ArrendaAmortiID;

			IF Var_Estatus = Est_Pagado THEN
				SET Var_ArrendaAmortiID	:= Var_ArrendaAmortiID + 1;
				ITERATE IteraCuotas;
			END IF;

			SET Var_SaldoCapVig		:= IFNULL(Var_SaldoCapVig, Decimal_Cero);
			SET Var_SaldoIntVig		:= IFNULL(Var_SaldoIntVig, Decimal_Cero);
			SET Var_SaldoSeguro		:= IFNULL(Var_SaldoSeguro, Decimal_Cero);
			SET Var_SaldoSegVida	:= IFNULL(Var_SaldoSegVida, Decimal_Cero);

			-- Registro de movimiento para Saldo capital vigente
			CALL ARRENDAMIENTOMOVSALT(	Par_ArrendaID,			Var_ArrendaAmortiID,	Aud_NumTransaccion,	Var_FechaSucursal,		Var_FechaSucursal,
										Var_TipMovCapVig,		Var_NaturaCargo,		Var_MonedaID,		Var_SaldoCapVig,		Var_DesPoliza,
										Var_DescCapVigente,		Var_Poliza,				Salida_No,			Par_NumErr,				Par_ErrMen,
										Entero_Cero,			Cadena_Vacia,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
										Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			-- Registro de movimiento para Saldo interes vigente
			CALL ARRENDAMIENTOMOVSALT(	Par_ArrendaID,			Var_ArrendaAmortiID,	Aud_NumTransaccion,	Var_FechaSucursal,		Var_FechaSucursal,
										Var_TipMovIntVig,		Var_NaturaCargo,		Var_MonedaID,		Var_SaldoIntVig,		Var_DesPoliza,
										Var_DescInterVig,		Var_Poliza,				Salida_No,			Par_NumErr,				Par_ErrMen,
										Entero_Cero,			Cadena_Vacia,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
										Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF Var_SaldoSeguro > Decimal_Cero THEN
				-- Registro de movimiento para Saldo seguro
				CALL ARRENDAMIENTOMOVSALT(	Par_ArrendaID,			Var_ArrendaAmortiID,	Aud_NumTransaccion,	Var_FechaSucursal,		Var_FechaSucursal,
											Var_TipMovSeguro,		Var_NaturaCargo,		Var_MonedaID,		Var_SaldoSeguro,		Var_DesPoliza,
											Var_DescSeguro,			Var_Poliza,				Salida_No,			Par_NumErr,				Par_ErrMen,
											Entero_Cero,			Cadena_Vacia,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
											Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			IF Var_SaldoSegVida > Decimal_Cero THEN
				-- Registro de movimiento para Saldo seguro vida
				CALL ARRENDAMIENTOMOVSALT(	Par_ArrendaID,			Var_ArrendaAmortiID,	Aud_NumTransaccion,	Var_FechaSucursal,		Var_FechaSucursal,
											Var_TipMovSegVida,		Var_NaturaCargo,		Var_MonedaID,		Var_SaldoSegVida,		Var_DesPoliza,
											Var_DescSeguroVida,		Var_Poliza,				Salida_No,			Par_NumErr,				Par_ErrMen,
											Entero_Cero,			Cadena_Vacia,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
											Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			SET Var_ArrendaAmortiID	:= Var_ArrendaAmortiID + 1;
		END WHILE IteraCuotas;

		-- El registro se actualizo exitosamente.
		SET	Par_NumErr	:= 000;
		SET	Par_ErrMen	:= 'Arrendamiento entregado exitosamente';
		SET Var_Control	:= 'ArrendaID';

	END ManejoErrores; -- Fin del bloque manejo de errores

	IF (Par_Salida = Salida_Si) THEN
		SELECT	Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Par_ArrendaID AS consecutivo;
	END IF;

END TerminaStore$$