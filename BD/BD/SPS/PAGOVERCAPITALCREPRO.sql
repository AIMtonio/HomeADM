-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOVERCAPITALCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOVERCAPITALCREPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOVERCAPITALCREPRO`(
-- -----------------------------------------------------------------------------------
# ========= REALIZA EL PAGO DE CAPITAL DE UN CREDITO DE MANERA VERTICAL ==============
-- -----------------------------------------------------------------------------------
	Par_CreditoID 			BIGINT(12),			# ID de credito al que se le efectuara el pago
	Par_MontoPagar	 		DECIMAL(12,2),	# Monto del pago que esta realizando
	Par_ModoPago			CHAR(1),		# Forma de pago Efectivo o con cargo a cuenta
	Par_CuentaAhoID 		BIGINT,			# ID de la cuenta de ahorro sobre la cual se haran los movimientos
	Par_Poliza				BIGINT,			# Numero de poliza
	Par_OrigenPago			CHAR(1),		# Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_Salida 				CHAR(1),

	INOUT Par_NumErr 		INT(11),
	INOUT Par_ErrMen 		VARCHAR(400),
	INOUT Par_MontoSaldo	DECIMAL(12,2),

	Par_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
	Aud_FechaActual 		DATETIME,
	Aud_DireccionIP 		VARCHAR(15),
	Aud_ProgramaID 			VARCHAR(50),
	Aud_Sucursal 			INT(11),
	Aud_NumTransaccion 		BIGINT(20)
	)
TerminaStore: BEGIN

	# Declaracion de Variables
	DECLARE Var_CreditoID 			BIGINT(12);			# Almacena el Credito del socio
	DECLARE Var_AmortizacionID		int(4);					# Almacena el numero de amortizacion
	DECLARE Var_SaldoCapVigente		decimal(12,2);			# Almacena el saldo de capital vigente

	DECLARE Var_SaldoCapAtrasa		decimal(12,2);			# Almacena el saldo de capital atrasado
	DECLARE Var_SaldoCapVencido		decimal(12,2);			# Almacena el saldo de capital vencido
	DECLARE Var_SaldoCapVenNExi		decimal(12,2);			# Almacena el saldo de capital vencido no exigible
	DECLARE Var_MonedaID 			int;					# Almacena el valor de la moneda
	DECLARE Var_FechaInicio 		date;					# Almacena la fecha de inicio de la amortizacion

    DECLARE Var_FechaVencim 		date;					# Almacena la fecha de vencimiento de la amortizacion
	DECLARE Par_Consecutivo			bigint;					# Consecutivo
	DECLARE VarControl 		 		char(20);				# Almacena el elmento que es incorrecto
	DECLARE Var_CueSaldo			decimal(12,2);			# Saldo actual disponible en la cuenta
	DECLARE Var_CueMoneda			int;					# Tipo de moneda de la cuenta

    DECLARE Var_CueEstatus			char(1);				# Estatus de la cuenta
	DECLARE Var_SaldoPago 			decimal(14,4);			# Almacena el saldo a pagar
	DECLARE Var_CuentaAhoStr		varchar(20);			# Almacena la cuenta
	DECLARE Var_CreditoStr			varchar(20);			# Almacena el credito
    DECLARE VarSucursalLin 			int;		 			# Variables para el Cursor

    DECLARE MonedaLinea 			int(11);				# Moneda de linea de credito
	DECLARE Var_CueClienteID		bigint;					# Cuenta del cliente
	DECLARE Var_SucCliente 			int;					# Sucursal del socio
	DECLARE Var_ClienteID			bigint;					# Numero de socio
	DECLARE Var_ProdCreID			int;					# Almacena el producto de credito

    DECLARE Var_ClasifCre			char(1);				# Clasificacion del credito
	DECLARE Var_NumAmorti			int;					# Numero de amortizacion
	DECLARE Var_SubClasifID 		int;					# Sub clasificacion del credito
	DECLARE Var_ManejaLinea			char(1);				# Variable para guardar el valor de si o no maneja linea el producto de credit
	DECLARE Var_EsRevolvente		char(1);				# Variable para saber si es revolvente la linea

    DECLARE Var_LineaCredito		bigint;					# Variable para guardar la linea de credito
	DECLARE Var_CantidPagar			decimal(14,2);			# Indica el monto a pagar
	DECLARE Var_FechaSistema		date;					# Fecha del sistema
	DECLARE Var_FecAplicacion 		date;					# Almacena la fecha de aplicacion
	DECLARE Var_EsHabil				char(1);				# Almacena del dia habil

    DECLARE Var_MaxAmoCapita 		int;					# Maximo amortizacion de capital
	DECLARE Var_MontoPago			decimal(14,2);			# Almacena el monto de pago
	DECLARE Var_SalCapitales		DECIMAL(14,2);
	DECLARE Var_EsLineaCreditoAgroRevolvente	CHAR(1);-- Es Linea de Credito Agro Revolvente
	DECLARE Var_EsLineaCreditoAgro 				CHAR(1);	-- Es linea de Credito Agro

	# Declaracion de Constantes
	DECLARE Cadena_Vacia 		char(1);				# String Vacio
	DECLARE Fecha_Vacia 		date;					# Fecha Vacia
	DECLARE Entero_Cero 		int;					# Entero en Cero
	DECLARE Decimal_Cero 		decimal(12,2);			# Decimal Cero
	DECLARE Decimal_Cien 		decimal(12,2);			# Decimal en Cien

	DECLARE Esta_Activo 		char(1);				# Estatus Activo
	DECLARE Esta_Cancelado 		char(1);				# Estatus Cancelado
	DECLARE Esta_Inactivo 		char(1);				# Estatus Inactivo
	DECLARE Esta_Vencido 		char(1);				# Estatus Vencido
	DECLARE Esta_Vigente 		char(1);				# Estatus Vigente

	DECLARE Esta_Atrasado 		char(1);				# Estatus Atrasado
	DECLARE Esta_Pagado 		char(1);				# Estatus Pagado
	DECLARE Par_SalidaNO 		char(1);				# Ejecutar Store sin Regreso o Mensaje de Salida
	DECLARE Par_SalidaSI 		char(1);				# Ejecutar Store Con Regreso o Mensaje de Salida
	DECLARE Var_AltaPoliza 		char(1);

	DECLARE AltaPoliza_SI 		char(1);				# Alta de la Poliza Contable: SI
	DECLARE AltaPoliza_NO 		char(1);				# Alta de la Poliza Contable: NO
	DECLARE AltaPolCre_NO 		char(1);				# Alta de la Poliza Contable de Credito: NO
	DECLARE AltaPolCre_SI 		char(1);				# Alta de la Poliza Contable de Credito: SI
	DECLARE AltaMovAho_SI 		char(1);				# Alta de los Movimientos de Ahorro: SI.

	DECLARE AltaMovAho_NO 		char(1);				# Alta de los Movimientos de Ahorro: NO
	DECLARE Nat_Cargo 	 		char(1);				# Naturaleza de Cargo
	DECLARE Nat_Abono 			char(1);				# Naturaleza de Abono.
	DECLARE Coc_PagoCred 		int;					# Numero de pago de credito
	DECLARE Aho_PagoCred 		char(4);				# Concepto de Ahorro: Pago de Credito

    DECLARE Con_AhoCapital 		int;					# Concepto Contable de Ahorro: Pasivo
	DECLARE Tol_DifPago			decimal(10,4);			# Diferencia de pago
	DECLARE Des_PagoCred		varchar(50);			# Concepto Contable de Cartera: Pago de Credito
	DECLARE Con_PagoCred		varchar(50);			# Descripcion: Pago de Credito
	DECLARE SiManejaLinea		char(1);				# Si maneja linea

    DECLARE NoManejaLinea		char(1);				# NO maneja linea
	DECLARE SiEsRevolvente		char(1);				# Si Es Revolvente
	DECLARE NoEsRevolvente		char(1);				# NO Es Revolvente
	DECLARE Mon_MinPago 		decimal(12,2);			# Monto minimo de pago
	DECLARE ConcepCtaOrdenDeu	int;					# Linea Credito Cta. Orden

    DECLARE ConcepCtaOrdenCor	int;					# Linea Credito Corr. Cta Orden
	DECLARE AltaMov_NO 			char(1);
	DECLARE Con_SI 				CHAR(1);				-- Constante SI
	DECLARE Con_NO 				CHAR(1);				-- Constante NO
	DECLARE Con_CarCtaOrdenDeuAgro			INT(11);		-- Concepto Cuenta Ordenante Deudor Agro
	DECLARE Con_CarCtaOrdenCorAgro			INT(11);		-- Concepto Cuenta Ordenante Corte Agro

	# Declaracion del cursor para el pago del capital
	DECLARE CURSORAMORTIZACIONES CURSOR FOR
	select	Amo.CreditoID,			Amo.AmortizacionID,		Amo.SaldoCapVigente,	Amo.SaldoCapAtrasa,
			Amo.SaldoCapVencido,	Amo.SaldoCapVenNExi,	Cre.MonedaID,			Amo.FechaInicio,
            Amo.FechaVencim
		from	AMORTICREDITO	Amo,
				CREDITOS		Cre
		where	Amo.CreditoID 	= Cre.CreditoID
		 and	Cre.CreditoID	= Par_CreditoID
		 and	(Cre.Estatus	= Esta_Vigente
		 or		Cre.Estatus	= Esta_Vencido)
		 and	(Amo.Estatus	= Esta_Vigente
		 or		Amo.Estatus	= Esta_Vencido
		 or		Amo.Estatus	= Esta_Atrasado)
		order by FechaExigible;


	# Asignacion de Constantes
	Set Cadena_Vacia 		:= '';
	Set Fecha_Vacia 		:= '1900-01-01';
	Set Entero_Cero 		:= 0;
	Set Decimal_Cero 		:= 0.00;
	Set Decimal_Cien 		:= 100.00;

	Set Esta_Activo 		:= 'A';
	Set Esta_Cancelado 		:= 'C';
	Set Esta_Inactivo 		:= 'I';
	Set Esta_Vencido 		:= 'B';
	Set Esta_Vigente 		:= 'V';

	Set	Esta_Pagado 		:= 'P';
	Set Esta_Atrasado 		:= 'A';
	Set Aho_PagoCred 		:= '101';
	Set Con_AhoCapital 		:= 1;
	Set Par_SalidaNO 		:= 'N';

    Set Par_SalidaSI 		:= 'S';
	Set SiManejaLinea		:= 'S';
	Set NoManejaLinea		:= 'N';
	Set SiEsRevolvente		:= 'S';
	Set NoEsRevolvente		:= 'N';

	Set AltaPoliza_SI 		:= 'S';
	Set AltaPoliza_NO 		:= 'N';
	Set AltaPolCre_SI 		:= 'S';
	Set AltaPolCre_NO 		:= 'N';
	Set AltaMovAho_NO 		:= 'N';

    Set AltaMovAho_SI 		:= 'S';
	Set Nat_Cargo			:= 'C';
	Set Nat_Abono 			:= 'A';
	Set Coc_PagoCred 		:= 54;
	Set Tol_DifPago 		:= 0.05;

	Set Mon_MinPago 		:= 0.01;
	Set Des_PagoCred 		:= 'PAGO DE CREDITO';
	Set Con_PagoCred 		:= 'PAGO DE CREDITO';
	Set Aud_ProgramaID 		:= 'PAGOCREDITOPRO';
	Set ConcepCtaOrdenDeu	:= 53;
	Set ConcepCtaOrdenCor	:= 54;
    Set AltaMov_NO 			:= 'N';
	SET Con_SI 				:= 'S';
	SET Con_NO 				:= 'N';
	SET Con_CarCtaOrdenDeuAgro			:= 138;
	SET Con_CarCtaOrdenCorAgro			:= 139;

	select FechaSistema	into Var_FechaSistema from PARAMETROSSIS;

	ManejoErrores: BEGIN

	select Cli.SucursalOrigen, 		Cre.ClienteID, 				Pro.ProducCreditoID, 		Des.Clasificacion, 		Cre.NumAmortizacion,
			Cre.MonedaID,			Des.SubClasifID, 			Pro.ManejaLinea,			Pro.EsRevolvente, 		Cre.LineaCreditoID

	into Var_SucCliente, 			Var_ClienteID, 				Var_ProdCreID, 				Var_ClasifCre, 			Var_NumAmorti,
			Var_MonedaID, 			Var_SubClasifID, 			Var_ManejaLinea,			Var_EsRevolvente,  		Var_LineaCredito
	from PRODUCTOSCREDITO Pro,
			CLIENTES Cli,
			DESTINOSCREDITO Des,
			CREDITOS Cre
	 left outer join REESTRUCCREDITO Res on Res.CreditoDestinoID = Cre.CreditoID
		where Cre.CreditoID			= Par_CreditoID
		 and Cre.ProductoCreditoID	= Pro.ProducCreditoID
		 and Cre.ClienteID			= Cli.ClienteID
		 and Cre.DestinoCreID = Des.DestinoCreID;

 	SET Var_LineaCredito	:= IFNULL(Var_LineaCredito, Entero_Cero);
	SET Var_ManejaLinea 	:= IFNULL(Var_ManejaLinea, NoManejaLinea);
	SET Var_EsRevolvente 	:= IFNULL(Var_EsRevolvente, NoEsRevolvente);

	call DIASFESTIVOSCAL(
		Var_FechaSistema,	Entero_Cero,		Var_FecAplicacion,			Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion);



	call SALDOSAHORROCON(Var_CueClienteID, 	Var_CueSaldo,	 Var_CueMoneda, 	Var_CueEstatus,	 Par_CuentaAhoID);
			if(IFNULL(Par_CuentaAhoID, Entero_Cero) = Entero_Cero) then
				set Par_NumErr		:= 7;
				set Par_ErrMen		:= 'La Cuenta no Existe.';
				set VarControl		:= 'cuentaAhoID';
				leave ManejoErrores;
			END IF;

	Set Var_SaldoPago := Par_MontoPagar;
	Set Var_CuentaAhoStr := convert(Par_CuentaAhoID, char(15));
	Set Var_CreditoStr := convert(Par_CreditoID, char(15));

	SET Var_LineaCredito	:= IFNULL(Var_LineaCredito, Entero_Cero);

	IF( Var_LineaCredito <> Entero_Cero ) THEN
		SET Var_EsLineaCreditoAgroRevolvente := ( SELECT EsRevolvente
												  FROM LINEASCREDITO
												  WHERE LineaCreditoID = Var_LineaCredito
													AND EsAgropecuario = Con_SI);
		SET Var_EsLineaCreditoAgro := ( SELECT EsAgropecuario
										FROM LINEASCREDITO
										WHERE LineaCreditoID = Var_LineaCredito
										  AND EsAgropecuario = Con_SI);
	END IF;

	SET Var_EsLineaCreditoAgroRevolvente := IFNULL(Var_EsLineaCreditoAgroRevolvente, Cadena_Vacia);
	SET Var_EsLineaCreditoAgro			 := IFNULL(Var_EsLineaCreditoAgro, Con_NO);

	# Se obtienen valores
	IF( (Var_ManejaLinea = SiManejaLinea AND Var_LineaCredito <> Entero_Cero) OR Var_EsLineaCreditoAgro = Con_SI )THEN
		select	MonedaID,	SucursalID
				into
				MonedaLinea,	VarSucursalLin
			from LINEASCREDITO
			where LineaCreditoID = Var_LineaCredito;
	end if;



	OPEN CURSORAMORTIZACIONES;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		CICLO:LOOP

		FETCH CURSORAMORTIZACIONES into
			Var_CreditoID, 			Var_AmortizacionID, 			Var_SaldoCapVigente, 		Var_SaldoCapAtrasa,
			Var_SaldoCapVencido,	Var_SaldoCapVenNExi, 			Var_MonedaID, 				Var_FechaInicio,
			Var_FechaVencim;

		-- Inicializaciones
		Set Var_CantidPagar		:= Decimal_Cero;
    	SET Var_SalCapitales    := Var_SaldoCapVigente + Var_SaldoCapAtrasa + Var_SaldoCapVencido + Var_SaldoCapVenNExi;

		if(round(Var_SaldoPago,2)	<= Decimal_Cero) then
			LEAVE CICLO;
		end if;



		if (Var_SaldoCapVencido >= Mon_MinPago) then

				if(round(Var_SaldoPago,2)	>= Var_SaldoCapVencido) then
					Set	Var_CantidPagar		:= Var_SaldoCapVencido;
				else
					Set	Var_CantidPagar		:= round(Var_SaldoPago,2);
				end if;

		 call PAGCRECAPVENPRO (
			Var_CreditoID, 		Var_AmortizacionID, 		Var_FechaInicio, 		Var_FechaVencim, 	Par_CuentaAhoID,
			Var_ClienteID, 		Var_FechaSistema, 			Var_FecAplicacion, 		Var_CantidPagar, 	Decimal_Cero,
			Var_MonedaID, 		Var_ProdCreID, 				Var_ClasifCre, 			Var_SubClasifID, 	Var_SucCliente,
			Des_PagoCred, 		Var_CuentaAhoStr, 			Par_Poliza, 			Var_SalCapitales,	Par_OrigenPago,
			Par_NumErr,			Par_ErrMen,					Par_Consecutivo, 		Par_EmpresaID,		Par_ModoPago,
			Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

			-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
			update AMORTICREDITO Tem
				set NumTransaccion = Aud_NumTransaccion
					where AmortizacionID = Var_AmortizacionID
					and CreditoID = Par_CreditoID;

				Set Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

				if( Var_LineaCredito != Entero_Cero) then /* si el credito tiene linea de credito*/
					if( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) then /* si maneja linea de credito*/
						if( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) then /* si es revolvente */
							update LINEASCREDITO set
								Pagado				= ifnull(Pagado,Entero_Cero) + Var_CantidPagar,
								SaldoDisponible		= ifnull(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,
								SaldoDeudor			= ifnull(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							where LineaCreditoID	= Var_LineaCredito;

							/* se genera la parte contable solo cuando es revolvente */
							if(Par_Poliza = Entero_Cero)then
								set Var_AltaPoliza	:= AltaPoliza_SI;
							else
								set Var_AltaPoliza	:= AltaPoliza_NO;
							end if;

							IF( Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
								SET ConcepCtaOrdenDeu := Con_CarCtaOrdenDeuAgro;
								SET ConcepCtaOrdenCor := Con_CarCtaOrdenCorAgro;
							END IF;

								/* se manda a llamar a sp que genera los detalles contables de lineas de credito .*/
							call CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
								Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
								Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Des_PagoCred,			Var_LineaCredito,
								Var_AltaPoliza,		Coc_PagoCred,			AltaPolCre_SI,			AltaMovAho_NO,			ConcepCtaOrdenDeu,
								Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,				Par_NumErr,				Par_ErrMen,
                                Par_Poliza,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
                                Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
							call CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
								Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
								Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Des_PagoCred,			Var_LineaCredito,
								AltaPoliza_NO,		Coc_PagoCred,			AltaPolCre_SI,			AltaMovAho_NO,			ConcepCtaOrdenCor,
								Cadena_Vacia,		Nat_Abono,				Nat_Abono,				Par_NumErr,				Par_ErrMen,
                                Par_Poliza,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
                                Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
						else
							update LINEASCREDITO set
								Pagado				= ifnull(Pagado,Entero_Cero) + Var_CantidPagar,
								SaldoDeudor			= ifnull(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							where LineaCreditoID	= Var_LineaCredito;
						end if;
					end if;
				end if;

				if(round(Var_SaldoPago,2)	<= Decimal_Cero) then
					LEAVE CICLO;
				end if;
			end if;


			if (Var_SaldoCapAtrasa >= Mon_MinPago) then

				if(round(Var_SaldoPago,2)	>= Var_SaldoCapAtrasa) then
					Set	Var_CantidPagar		:= Var_SaldoCapAtrasa;
				else
					Set	Var_CantidPagar		:= round(Var_SaldoPago,2);
				end if;

			call PAGCRECAPATRPRO (
				 Var_CreditoID, 	Var_AmortizacionID, 	Var_FechaInicio,		Var_FechaVencim, 		Par_CuentaAhoID,
				 Var_ClienteID, 	Var_FechaSistema, 		Var_FecAplicacion, 		Var_CantidPagar, 		Decimal_Cero,
				 Var_MonedaID,		Var_ProdCreID, 			Var_ClasifCre, 			Var_SubClasifID, 		Var_SucCliente,
				 Des_PagoCred, 		Var_CuentaAhoStr, 		Par_Poliza, 			Var_SalCapitales,		Par_OrigenPago,
				 Par_NumErr,		Par_ErrMen,				Par_Consecutivo, 		Par_EmpresaID, 			Par_ModoPago,
				 Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,
				 Aud_NumTransaccion);
				-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
					update AMORTICREDITO Tem
					set NumTransaccion = Aud_NumTransaccion
						where AmortizacionID = Var_AmortizacionID
							and CreditoID = Par_CreditoID;

				if( Var_LineaCredito != Entero_Cero) then /* si el credito tiene linea de credito*/
					if( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) then /* si maneja linea de credito*/
						if( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) then /* si es revolvente */
							update LINEASCREDITO set
								Pagado				= ifnull(Pagado,Entero_Cero) + Var_CantidPagar,
								SaldoDisponible		= ifnull(SaldoDisponible,Entero_Cero) + Var_CantidPagar,
								SaldoDeudor			= ifnull(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							where LineaCreditoID	= Var_LineaCredito;
							/* se genera la parte contable solo cuando es revolvente */
							if(Par_Poliza = Entero_Cero)then
								set Var_AltaPoliza	:= AltaPoliza_SI;
							else
								set Var_AltaPoliza	:= AltaPoliza_NO;
							end if;

							IF( Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
								SET ConcepCtaOrdenDeu := Con_CarCtaOrdenDeuAgro;
								SET ConcepCtaOrdenCor := Con_CarCtaOrdenCorAgro;
							END IF;

								/* se manda a llamar a sp que genera los detalles contables de lineas de credito .*/
							call CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
								Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
								Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Des_PagoCred,			Var_LineaCredito,
								Var_AltaPoliza,		Coc_PagoCred,			AltaPolCre_SI,			AltaMovAho_NO,			ConcepCtaOrdenDeu,
								Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,				Par_NumErr,				Par_ErrMen,
                                Par_Poliza,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
                                Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
							call CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
								Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
								Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Des_PagoCred,			Var_LineaCredito,
								AltaPoliza_NO,		Coc_PagoCred,			AltaPolCre_SI,			AltaMovAho_NO,			ConcepCtaOrdenCor,
								Cadena_Vacia,		Nat_Abono,				Nat_Abono,				Par_NumErr,				Par_ErrMen,
                                Par_Poliza,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
                                Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
						else
							update LINEASCREDITO set
								Pagado				= ifnull(Pagado,Entero_Cero) + Var_CantidPagar,
								SaldoDeudor			= ifnull(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							where LineaCreditoID	= Var_LineaCredito;
						end if;
					end if;
				end if;

				Set	Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

				if(round(Var_SaldoPago,2)	<= Decimal_Cero) then
					LEAVE CICLO;
				end if;

			end if;


		if (Var_SaldoCapVigente >= Mon_MinPago) then

				if(Var_SaldoPago	>= Var_SaldoCapVigente) then
					Set Var_CantidPagar := Var_SaldoCapVigente;
				else
					Set Var_CantidPagar := Var_SaldoPago;
				end if;

			call PAGCRECAPVIGPRO (
				 Var_CreditoID, 	Var_AmortizacionID, 	Var_FechaInicio, 		Var_FechaVencim,	Par_CuentaAhoID,
				 Var_ClienteID, 	Var_FechaSistema, 		Var_FecAplicacion, 		Var_CantidPagar, 	Decimal_Cero,
				 Var_MonedaID, 		Var_ProdCreID, 			Var_ClasifCre, 			Var_SubClasifID, 	Var_SucCliente,
				 Con_PagoCred, 		Var_CuentaAhoStr, 		Par_Poliza, 			Var_SalCapitales,	Par_OrigenPago,
				 Par_NumErr,		 Par_ErrMen,			Par_Consecutivo, 		Par_EmpresaID, 		Par_ModoPago,
				 Aud_Usuario,		 Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,
				 Aud_NumTransaccion);


		 update AMORTICREDITO Tem
				set NumTransaccion = Aud_NumTransaccion
					where AmortizacionID = Var_AmortizacionID
						and CreditoID = Par_CreditoID;

			Set Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

			/* =================== Se realizan los cambios a LINEASCREDITO ========================== */

			if( Var_LineaCredito != Entero_Cero) then /* si el credito tiene linea de credito*/
				if( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) then /* si maneja linea de credito*/
					if( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) then /* si es revolvente */
						update LINEASCREDITO set
							Pagado				= ifnull(Pagado,Entero_Cero) + Var_CantidPagar,
							SaldoDisponible		= ifnull(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,
							SaldoDeudor			= ifnull(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

							Usuario				= Aud_Usuario,
							FechaActual			= Aud_FechaActual,
							DireccionIP			= Aud_DireccionIP,
							ProgramaID			= Aud_ProgramaID,
							Sucursal			= Aud_Sucursal,
							NumTransaccion		= Aud_NumTransaccion
						where LineaCreditoID	= Var_LineaCredito;
						/* se genera la parte contable solo cuando es revolvente */
						if(Par_Poliza = Entero_Cero)then
							set Var_AltaPoliza	:= AltaPoliza_SI;
						else
							set Var_AltaPoliza	:= AltaPoliza_NO;
						end if;

						IF( Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
							SET ConcepCtaOrdenDeu := Con_CarCtaOrdenDeuAgro;
							SET ConcepCtaOrdenCor := Con_CarCtaOrdenCorAgro;
						END IF;

							/* se manda a llamar a sp que genera los detalles contables de lineas de credito .*/
						call CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
							Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
							Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Des_PagoCred,			Var_LineaCredito,
							Var_AltaPoliza,		Coc_PagoCred,			AltaPoliza_SI,			AltaMov_NO,				ConcepCtaOrdenDeu,
							Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,				Par_NumErr,				Par_ErrMen,
                            Par_Poliza,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
                            Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
						call CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
							Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
							Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Des_PagoCred,			Var_LineaCredito,
							AltaPoliza_NO,		Coc_PagoCred,			AltaPoliza_SI,			AltaMov_NO,				ConcepCtaOrdenCor,
							Cadena_Vacia,		Nat_Abono,				Nat_Abono,				Par_NumErr,				Par_ErrMen,
                            Par_Poliza,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
                            Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
					else
						update LINEASCREDITO set
							Pagado				= ifnull(Pagado,Entero_Cero) + Var_CantidPagar,
							SaldoDeudor			= ifnull(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

							Usuario				= Aud_Usuario,
							FechaActual			= Aud_FechaActual,
							DireccionIP			= Aud_DireccionIP,
							ProgramaID			= Aud_ProgramaID,
							Sucursal			= Aud_Sucursal,
							NumTransaccion		= Aud_NumTransaccion
						where LineaCreditoID	= Var_LineaCredito;
					end if;
				end if;
			end if;
		/* ========================================================================== */


			if(Var_SaldoPago	<= Decimal_Cero) then
				LEAVE CICLO;
			end if;

		end if;


		set Var_SaldoCapVenNExi := ifnull(Var_SaldoCapVenNExi, Decimal_Cero);
		if (Var_SaldoCapVenNExi >= Mon_MinPago) then

			 if(Var_SaldoPago	>= Var_SaldoCapVenNExi) then
				Set	Var_CantidPagar := Var_SaldoCapVenNExi;
				else
				Set	Var_CantidPagar := Var_SaldoPago;
			 end if;

			 call PAGCRECAPVNEPRO (
				Var_CreditoID,	 	Var_AmortizacionID, 	Var_FechaInicio,		Var_FechaVencim, 	Par_CuentaAhoID,
				Var_ClienteID,	 	Var_FechaSistema, 		Var_FecAplicacion,		Var_CantidPagar, 	Decimal_Cero,
				Var_MonedaID, 		Var_ProdCreID, 			Var_ClasifCre,			Var_SubClasifID, 	Var_SucCliente,
				Con_PagoCred, 		Var_CuentaAhoStr, 		Par_Poliza, 			Var_SalCapitales,	Par_OrigenPago,
				Par_NumErr,			Par_ErrMen,				Par_Consecutivo, 		Par_EmpresaID, 		Par_ModoPago,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);


			 update AMORTICREDITO Tem
				set NumTransaccion = Aud_NumTransaccion
					where AmortizacionID = Var_AmortizacionID
						and CreditoID = Par_CreditoID;

			Set Var_SaldoPago := Var_SaldoPago - Var_CantidPagar;
				/* =================== Se realizan los cambios a LINEASCREDITO========================== */

				if( Var_LineaCredito != Entero_Cero) then /* si el credito tiene linea de credito*/
					if( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) then /* si maneja linea de credito*/
						if( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) then /* si es revolvente */
							update LINEASCREDITO set
								Pagado				= ifnull(Pagado,Entero_Cero) + Var_CantidPagar,
								SaldoDisponible		= ifnull(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,
								SaldoDeudor			= ifnull(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							where LineaCreditoID	= Var_LineaCredito;
							/* se genera la parte contable solo cuando es revolvente */
							if(Par_Poliza = Entero_Cero)then
								set Var_AltaPoliza	:= AltaPoliza_SI;
							else
								set Var_AltaPoliza	:= AltaPoliza_NO;
							end if;

							IF( Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
								SET ConcepCtaOrdenDeu := Con_CarCtaOrdenDeuAgro;
								SET ConcepCtaOrdenCor := Con_CarCtaOrdenCorAgro;
							END IF;

								/* se manda a llamar a sp que genera los detalles contables de lineas de credito .*/
							call CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
								Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
								Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Des_PagoCred,			Var_LineaCredito,
								Var_AltaPoliza,		Coc_PagoCred,			AltaPoliza_SI,			AltaMov_NO,				ConcepCtaOrdenDeu,
								Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,				Par_NumErr,				Par_ErrMen,
                                Par_Poliza,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
                                Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
							call CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
								Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
								Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Des_PagoCred,			Var_LineaCredito,
								AltaPoliza_NO,		Coc_PagoCred,			AltaPoliza_SI,			AltaMov_NO,				ConcepCtaOrdenCor,
								Cadena_Vacia,		Nat_Abono,				Nat_Abono,				Par_NumErr,				Par_ErrMen,
                                Par_Poliza,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
                                Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
						else
							update LINEASCREDITO set
								Pagado				= ifnull(Pagado,Entero_Cero) + Var_CantidPagar,
								SaldoDeudor			= ifnull(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							where LineaCreditoID	= Var_LineaCredito;
						end if;
					end if;
				end if;
			/* ========================================================================== */

			 if(Var_SaldoPago <= Decimal_Cero) then
				LEAVE CICLO;
			 end if;

		end if;
	END LOOP;
	END;
	CLOSE CURSORAMORTIZACIONES;

	Set Var_MontoPago	 := Par_MontoPagar - Var_SaldoPago;


	if (Var_MontoPago	>= Mon_MinPago) then

		 update AMORTICREDITO Amo Set
		 Estatus = Esta_Pagado,
		 FechaLiquida = Var_FechaSistema
				where (SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi +
					 SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro +
					 SaldoIntNoConta + SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen +
					 SaldoComFaltaPa + SaldoComServGar + SaldoOtrasComis ) <= Tol_DifPago
				 and Amo.CreditoID 	= Par_CreditoID
		 and FechaExigible > Var_FechaSistema
				 and Estatus 	!= Esta_Pagado
		 and Amo.NumTransaccion = Aud_NumTransaccion;


		 select max(AmortizacionID) into Var_MaxAmoCapita
		 from AMORTICREDITO Amo
			where CreditoID 	= Par_CreditoID
			and Estatus 	!= Esta_Pagado
			and ( SaldoCapVigente + SaldoCapAtrasa +
		 SaldoCapVencido + SaldoCapVenNExi ) > Entero_Cero;

		 set Var_MaxAmoCapita := ifnull(Var_MaxAmoCapita, Entero_Cero);

			update AMORTICREDITO Amo Set
				 Estatus = Esta_Pagado,
				 FechaLiquida = Var_FechaSistema
				where CreditoID 	= Par_CreditoID
				and (SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi +
					 SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro +
					 SaldoIntNoConta + SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen +
					 SaldoComFaltaPa + SaldoComServGar + SaldoOtrasComis ) = Entero_Cero
				 and Estatus 	!= Esta_Pagado
				 and AmortizacionID > Var_MaxAmoCapita;

			# Consulta las amortizaciones que no estan pagadas
			 select count(distinct(AmortizacionID)) into Var_NumAmorti
				from AMORTICREDITO
				where CreditoID	= Par_CreditoID
					and Estatus	in(Esta_Vigente, Esta_Atrasado, Esta_Vencido );


			 set Var_NumAmorti := IFNULL(Var_NumAmorti, Entero_Cero);

		 call DEPOSITOPAGOCREPRO (
			Par_CreditoID, 		Var_MontoPago,		Var_FechaSistema,		Par_EmpresaID,		Par_SalidaNO,
			Par_NumErr, 		Par_ErrMen, 		Par_Consecutivo,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP, 	Aud_ProgramaID, 	Aud_Sucursal,			Aud_NumTransaccion);

	end if;


	set Par_MontoSaldo := Var_SaldoPago;


END ManejoErrores; # End del Handler de Errores


	if(Par_Salida = Par_SalidaSI) then
		select CONVERT(Par_NumErr, char) as NumErr,
				Par_ErrMen 		as ErrMen,
				VarControl	 	as control,
				Par_CreditoID 	as consecutivo;
	end if;

END TerminaStore$$