-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOARRENDAMIENTOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOARRENDAMIENTOPRO`;DELIMITER $$

CREATE PROCEDURE `PAGOARRENDAMIENTOPRO`(
	-- SP DE PROCESO QUE REALIZA EL PAGO DE ARRENDAMIENTO
	Par_ArrendaID			BIGINT(12),				-- Id del arrendamiento
	Par_MontoPagar			DECIMAL(14,4),			-- Monto a pagar
	Par_MonedaID			INT(11),				-- Identificador de moneda
	Par_EmpresaID			INT(11),				-- Numero de empresa
	Par_Salida				CHAR(1),				-- Salida

	Par_AltaEncPoliza		CHAR(1),				-- Alta poliza
	INOUT Var_MontoPago		DECIMAL(14,4), 			-- Monto del pago
	INOUT Var_Poliza		BIGINT,					-- Poliza
	INOUT Par_NumErr		INT(11),				-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de Error
	INOUT Par_Consecutivo	BIGINT,					-- Consecutivo
	Par_ModoPago			CHAR(1),				-- Modo de pago Efectivo o Cuenta

	-- Parametros de Auditoria
	Aud_Usuario				INT(11),				-- Numero de usuario
	Aud_FechaActual			DATETIME,				-- Fecha del sistema
	Aud_DireccionIP			VARCHAR(15),			-- Direccion IP
	Aud_ProgramaID			VARCHAR(50),			-- Numero de programa
	Aud_Sucursal			INT(11),				-- Numero de sucursal
	Aud_NumTransaccion		BIGINT(20)				-- Numero de transaccion
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_ProgOriginalID			VARCHAR(50);		-- Programa que ejecuta el sp
	DECLARE Var_Control					VARCHAR(100);		-- Variable de control
	DECLARE Var_NumRecPago				INT(11);			-- Variable para evitar hacer un pago si no ha pasado el tiempo
	DECLARE Var_ArrendaID 				BIGINT(12);			-- Numero del arrendamiento
	DECLARE Var_ArrendaAmortiID			INT(4);				-- Numero de amortizacion
	DECLARE Var_SalSegArrenda			DECIMAL(14, 4);		-- Saldo de seguro inmobiliario de la tabla de ARRENDAMIENTOS
	DECLARE Var_SalSegVidaArr			DECIMAL(14, 4);		-- Saldo de seguro de vida de la tabla de ARRENDAMIENTOS
	DECLARE Var_SalCapArrenda			DECIMAL(14, 4);		-- Saldo del capital de la tabla de ARRENDAMIENTOS
	DECLARE Var_SalComFaltaPagA			DECIMAL(14, 4);		-- Saldo de la comision por falta de pago de la tabla de ARRENDAMIENTOS
	DECLARE Var_SaldoMorArrenda			DECIMAL(14, 4);		-- Saldo moratorio de la tabla de ARRENDAMIENTOS
	DECLARE Var_SalComisArrenda			DECIMAL(14, 4);		-- Saldo por otras comision de pago de la tabla de ARRENDAMIENTOS
	DECLARE Var_SaldoCapVigente			DECIMAL(14, 4);		-- Saldo de capital vigente de la tabla de ARRENDAAMORTI
	DECLARE Var_SaldoCapAtrasa			DECIMAL(14, 4);		-- Saldo de capital atrasado de la tabla de ARRENDAAMORTI
	DECLARE Var_SaldoCapVencido			DECIMAL(14, 4);		-- Saldo de capital vencido de la tabla de ARRENDAAMORTI
	DECLARE Var_SaldoInteresVig			DECIMAL(14, 4);		-- Saldo del interes vigente de la tabla de ARRENDAAMORTI
	DECLARE Var_SaldoInteresAtr			DECIMAL(14, 4);		-- Saldo del interes atrasado de la tabla de ARRENDAAMORTI
	DECLARE Var_SaldoInteresVen			DECIMAL(14, 4);		-- Saldo del interes vencido de la tabla de ARRENDAAMORTI
	DECLARE Var_SaldoMoratorios			DECIMAL(14, 4);		-- Saldo moratorior de la tabla de ARRENDAAMORTI
	DECLARE	Var_SaldoSeguroInmob		DECIMAL(14, 4);		-- Saldo del seguro de la tabla de ARRENDAAMORTI
	DECLARE	Var_SaldoSeguroVida			DECIMAL(14, 4);		-- Saldo del seguro de vida de la tabla de ARRENDAAMORTI
	DECLARE Var_SaldoComFaltaPa			DECIMAL(14, 4);		-- Saldo de la comision por falta de pago de la tabla de ARRENDAAMORTI
	DECLARE Var_SaldoOtrasComis			DECIMAL(14, 4);		-- Saldo de otras comisiones de la tabla de ARRENDAAMORTI
	DECLARE	Var_SaldoCapital			DECIMAL(14, 4);		-- Saldo del capital de la tabla de ARRENDAAMORTI
	DECLARE	Var_SaldoInteres			DECIMAL(14, 4);		-- Saldo del interes de la tabla de ARRENDAAMORTI
	DECLARE Var_MontoIVACapital			DECIMAL(14, 4);		-- Saldo del IVA del capital de la tabla de ARRENDAAMORTI
	DECLARE Var_MontoIVAInteres			DECIMAL(14, 4);		-- Saldo del IVA del interes de la tabla de ARRENDAAMORTI
	DECLARE Var_MontoIVASeguro			DECIMAL(14, 4);		-- Saldo del IVA del segurode la tabla de ARRENDAAMORTI
	DECLARE Var_MonIVASegVida			DECIMAL(14, 4);		-- Saldo del IVA del seguro de vida de la tabla de ARRENDAAMORTI
	DECLARE Var_MontoIVAMora			DECIMAL(14, 4);		-- Saldo del IVA moratorio de la tabla de ARRENDAAMORTI
	DECLARE Var_MonIVAComFalPag 		DECIMAL(14, 4);		-- Saldo del IVA de comision por falta de pago la tabla de ARRENDAAMORTI
	DECLARE Var_MontoIVAComis 			DECIMAL(14, 4);		-- Saldo del IVA de otras comisiones de la tabla de ARRENDAAMORTI

	DECLARE	Var_CapitalRenta			DECIMAL(14, 4);		-- Monto de la cuota de Capital de acuerdo al plan de pagos de la tabla de ARRENDAAMORTI
	DECLARE	Var_InteresRenta			DECIMAL(14, 4);		-- Monto de la cuota de Interes de acuerdo al plan de pagos de la tabla de ARRENDAAMORTI
	DECLARE	Var_IVARenta				DECIMAL(14, 4);		-- Monto de la cuota de IVA de RENTA de acuerdo al plan de pagos de la tabla de ARRENDAAMORTI
	DECLARE Var_Seguro					DECIMAL(14, 4);		-- Monto de la cuota de Seguro de acuerdo al plan de pagos de la tabla de ARRENDAAMORTI
	DECLARE	Var_SeguroVida				DECIMAL(14, 4);		-- Monto de la cuota de Seguro de Vida de acuerdo al plan de pagos de la tabla de ARRENDAAMORTI

	DECLARE Var_EstatusArrenda			CHAR(1);			-- Estatus del arrendamiento
	DECLARE Nat_Abono					CHAR(1);			-- Naturaleza del movimiento de tipo abono
    DECLARE Nat_Cargo					CHAR(1);			-- Naturaleza del movimiento de tipo cargo
	DECLARE Var_MonedaID				INT(11);			-- Id de la moneda
	DECLARE Var_FechaVen				DATE; 				-- Fecha de vencimiento del arrendamiento
	DECLARE Var_FechaInicio				DATE;				-- Fecha de inicio
	DECLARE Var_FechaVencim				DATE;				-- Fecha de vencimiento de la amortizacion del arrendamiento
	DECLARE Var_FechaExigible			DATE;				-- Fecha exigible del pago del arrendamiento
	DECLARE Var_AmoEstatus				CHAR(1);			-- Amortizacion del estatus
	DECLARE Var_SaldoPago				DECIMAL(14, 4);		-- Saldo de pago
	DECLARE Var_CantidPagar				DECIMAL(14, 2);		-- Cantidad a pagar
	DECLARE Var_IVACantidPagar			DECIMAL(14, 2);		-- IVA cantidad a pagar
	DECLARE Var_FecAplicacion			DATE;				-- Fecha de aplicacion
	DECLARE Var_EsHabil					CHAR(1);			-- Es dia habil
	DECLARE Var_IVASucurs				DECIMAL(12, 2);		-- IVA aplicado al arrendamiento
	DECLARE Var_SucCliente				INT(11);			-- Sucursal del cliente
	DECLARE Var_ClienteID				BIGINT;				-- Id del cliente
	DECLARE Var_ProdArrendaID			INT(11);			-- Id del producto del arrendamiento
	DECLARE Var_NumAmorti				INT(11);			-- Numero de amortizacion del arrendamiento
	DECLARE Var_FechaSis				DATE;				-- Fecha del sistema
	DECLARE Var_LineaArrenda			BIGINT;				-- Linea del arrendamiento
	DECLARE Var_TasaArrenda				DECIMAL(14,4);		-- Tasa del arrendamiento
	DECLARE Var_RefePoliza				VARCHAR(150);		-- Referencia de la poliza
	DECLARE Var_ArrendamientoStr		VARCHAR(20);		-- String del arrendamiento
	DECLARE Var_TipoArrenda				CHAR(1);			-- Tipo de arrendamiento
	DECLARE Var_Plazo					CHAR(1);			-- Plazo del arrendamiento
	DECLARE Var_NumVencidos				INT(11);			-- Numero de arrendamientos vencidos
	DECLARE Var_NumAtrasados			INT(11);			-- Numero de arrendamientos atrasados
	DECLARE Var_TotalAmorti				INT(11);			-- Total de amortizaciones
	DECLARE Var_TotalPagados			INT(11);			-- Total pagados
	DECLARE	Var_TotalExigible			DECIMAL(14,2);		-- Variable para el monto exigible del dia
	DECLARE Var_TotalAbono				DECIMAL(14,2);		-- Variable para el total de abonos
	DECLARE Var_TotalCargo				DECIMAL(14,2);		-- Variable para el total de cargos
	DECLARE Var_TotalMovCA				DECIMAL(14,2);		-- Variable para el total de movimientos realizados(diferencia de cargos y abonos).

	-- Declaracion de constantes
	DECLARE	Par_SalidaSI		CHAR(1);					-- Salida SI
	DECLARE	Par_SalidaNO		CHAR(1);					-- Salida NO
	DECLARE	Est_Activo			CHAR(1);					-- Estatus Activo
	DECLARE	Est_Cancelado		CHAR(1);					-- Estatus Cancelado
	DECLARE	Est_Inactivo		CHAR(1);					-- Estatus Inactivo
	DECLARE	Est_Vigente			CHAR(1);					-- Estatus Vigente
	DECLARE	Est_Vencido			CHAR(1);					-- Estatus Vencido
	DECLARE	Est_Atrasado		CHAR(1);					-- Estatus Atrasado
	DECLARE Est_Pagado			CHAR(1);					-- Estatus Pagado
	DECLARE AltaPoliza_NO		CHAR(1);					-- Alta poliza NO
	DECLARE AltaPolArrenda_SI	CHAR(1);					-- Alta poliza SI
	DECLARE AltaMovsArrenda_SI	CHAR(1);					-- Alta movimientos SI
	DECLARE AltaMovsArrenda_NO	CHAR(1);					-- Alta movimientos NO
	DECLARE Cadena_Vacia		CHAR(1);					-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;						-- Fecha vacia
	DECLARE Entero_Cero			INT(11);					-- Entero cero
	DECLARE Decimal_Cero		DECIMAL(14,2);				-- Decimal cero
	DECLARE Con_Minuto			TIME;						-- Constante un minuto
	DECLARE ValorSI				CHAR(1);					-- Valor si
	DECLARE ValorNO				CHAR(1);					-- Valor no
	DECLARE Mon_MinPago			DECIMAL(14,2);				-- Valor monto minimo
	DECLARE Con_MontoMin		CHAR(20);					-- Concepto del monto minimo
	DECLARE Con_PagEfectivo		CHAR(1);					-- Pago en efectivo
	DECLARE Des_PagoArrenda		VARCHAR(50);				-- Pago de arrendamiento
	DECLARE Des_PagoIniArrenda	VARCHAR(50);				-- Pago de arrendamiento
	DECLARE Mov_CapVigente  	INT(11);					-- Movimiento de capital vigente
	DECLARE Mov_CapAtrasado 	INT(11);					-- Movimiento de capital atrasado
	DECLARE Mov_CapVencido  	INT(11);					-- Movimiento de capital vencido
	DECLARE Mov_IntVigente		INT(11);					-- Movimiento de interes vigente
	DECLARE Mov_IntAtrasado		INT(11);					-- Movimiento de interes atrasado
	DECLARE Mov_IntVencido		INT(11);					-- Movimiento de interes vencido
	DECLARE Mov_Moratorio		INT(11);					-- Movimiento de interes moratorio
	DECLARE Mov_IVACapital		INT(11);					-- Movimiento del IVA del capital
	DECLARE Mov_IVAInteres		INT(11);					-- Movimiento del IVA del interes
	DECLARE Mov_IVAIntMora		INT(11);					-- Movimiento del IVA de la mora
	DECLARE Mov_IVAComFaPag		INT(11);					-- Movimiento del IVA por falta de pago
	DECLARE Mov_IVASeguroVida	INT(11);					-- Movimiento del IVA del seguro de vida
	DECLARE Mov_IVASeguroInmob	INT(11);					-- Movimiento del IVA del seguro
	DECLARE Mov_IVAOtrasComis	INT(11);					-- Movimiento del IVA de otras comisiones
	DECLARE Mov_ComFalPag		INT(11);					-- Movimiento de Comision por falta de pago
	DECLARE Mov_OtrasComis		INT(11);					-- Movimiento de Otras comisiones
	DECLARE Mov_SegInmobiliario	INT(11);					-- Movimiento del seguro
	DECLARE Mov_SegVida			INT(11);					-- Movimiento del seguro de vida

	DECLARE Con_CapVigente	  	INT(11);					-- Concepto del capital vigente
	DECLARE Con_CapAtrasado	    INT(11);					-- Concepto del capital atrasado
	DECLARE Con_CapVencido	  	INT(11);					-- Concepto del capital vencido
	DECLARE Con_IntVigente		INT(11);					-- Concepto del interes vigente
	DECLARE Con_IntAtrasado	    INT(11);					-- Concepto del interes atrasado
	DECLARE Con_IntVencido	  	INT(11);					-- Concepto del interes vigente
	DECLARE Con_Moratorio 	  	INT(11);					-- Concepto del interes moratorio
	DECLARE Con_IVACapital	  	INT(11);					-- Concepto del IVA del capital
	DECLARE Con_IVAInteres	  	INT(11);					-- Concepto del IVA del interes
	DECLARE Con_IVAIntMora  	INT(11);					-- Concepto del IVA del interes de la mora
	DECLARE Con_IVAComFaPag 	INT(11);					-- Concepto del IVA de la comision lpor falta de pago
	DECLARE Con_IVASeguroVida	INT(11);					-- Concepto del IVA del seguro de vida
	DECLARE Con_IVASeguroInmob	INT(11);					-- Concepto del IVA del seguro
	DECLARE Con_IVAOtrasComis	INT(11);					-- Concepto del IVA de otras comisiones
	DECLARE Con_ComFalPag		INT(11);					-- Concepto de Comision por falta de pago
	DECLARE Con_OtrasComis   	INT(11);					-- Concepto de Otras comisiones
	DECLARE Con_SegInmobiliario	INT(11);					-- Concepto del seguro
	DECLARE Con_SegVida			INT(11);					-- Concepto del seguro de vida
	DECLARE Con_PagInicial		INT(11);					-- Concepto de Pago Inicial
	DECLARE Var_CtePagIva 		CHAR(1);					-- VARIABLE PARA  GUARDAR SU EL CLIENTE PAGA O NO IVA
	DECLARE Var_SI 				CHAR(1);					-- Variable si
	DECLARE Var_NO 				CHAR(1);					-- Variable no

	DECLARE Con_PlazoCorto		CHAR(1);					-- Concepto plazo corto
	DECLARE Con_PlazoLargo		CHAR(1);					-- Concepto plazo largo
	DECLARE Est_Autorizado		CHAR(1);					-- Estatus autorizado
	DECLARE Mov_PagoInicial		INT(11);					-- Movimiento de Pago Inicial

	DECLARE Var_TipSaldoSeg		INT(11);					-- Tipo de movimiento de cargo y abono de salgo seguro inmobiliario
	DECLARE Var_TipSalSegVida	INT(11);					-- Tipo de movimiento de cargo y abono de salgo seguro vida
	DECLARE Var_TipSalOtComi	INT(11);					-- Tipo de movimiento de cargo y abono de salgo otras comisiones

	-- DECLARACION DE CURSORES
	DECLARE CURSORAMORTI CURSOR FOR
		SELECT	Amo.ArrendaID,				Amo.ArrendaAmortiID,	Amo.SaldoCapVigent,		Amo.SaldoCapAtrasad,	Amo.SaldoCapVencido,
				Amo.SaldoInteresVigente,	Amo.SaldoInteresAtras,	Amo.SaldoInteresVen,	Amo.SaldoSeguro,		Amo.SaldoSeguroVida,
				Amo.SaldoMoratorios,		Amo.SaldComFaltPago,	Amo.SaldoOtrasComis,	Arrenda.MonedaID,		Amo.FechaInicio,
				Amo.FechaVencim,			Amo.FechaExigible,		Amo.Estatus,			Amo.MontoIVACapital,	Amo.MontoIVAInteres,
				Amo.MontoIVASeguro,			Amo.MontoIVASeguroVida,	Amo.MontoIVAMora,		Amo.MontoIVAComFalPag,	Amo.MontoIVAComisi,
				Amo.CapitalRenta,			Amo.InteresRenta,		Amo.IVARenta,			Amo.Seguro,				Amo.SeguroVida
			FROM	ARRENDAMIENTOS	Arrenda,
					ARRENDAAMORTI	Amo
			WHERE	Arrenda.ArrendaID	= Par_ArrendaID
			  AND	Amo.ArrendaID 		= Arrenda.ArrendaID
			  AND	(Arrenda.Estatus	= Est_Vigente
			   OR		Arrenda.Estatus	= Est_Vencido)
			  AND	(Amo.Estatus	= Est_Vigente
			   OR		Amo.Estatus	= Est_Vencido
			   OR		Amo.Estatus	= Est_Atrasado)
			ORDER BY FechaExigible;

	-- Asignacion de Constantes
	SET	Mov_CapVigente	  		:= 1;						-- Valor del capital vigente de la tabla TIPOSMOVSARRENDA
	SET	Mov_CapAtrasado			:= 2;						-- Valor del capital atrasado de la tabla TIPOSMOVSARRENDA
	SET	Mov_CapVencido	  		:= 3;						-- Valor del capital vencido de la tabla TIPOSMOVSARRENDA
	SET	Mov_IntVigente			:= 10;						-- Valor del interes vigente de la tabla TIPOSMOVSARRENDA
	SET	Mov_IntAtrasado	 		:= 11;						-- Valor del interes atrasado de la tabla TIPOSMOVSARRENDA
	SET	Mov_IntVencido	  		:= 12;						-- Valor del interes vencido de la tabla TIPOSMOVSARRENDA
	SET	Mov_Moratorio 	  		:= 15;						-- Valor del moratorio de la tabla TIPOSMOVSARRENDA
	SET	Mov_IVACapital	  		:= 19;						-- Valor del IVA del capital de la tabla TIPOSMOVSARRENDA
	SET	Mov_IVAInteres	  		:= 20;						-- Valor del IVA del interes de la tabla TIPOSMOVSARRENDA
	SET	Mov_IVAIntMora  		:= 21;						-- Valor del IVA moratorio de la tabla TIPOSMOVSARRENDA
	SET	Mov_IVAComFaPag 		:= 22;						-- Valor del IVA por falta de pago de la tabla TIPOSMOVSARRENDA
	SET	Mov_IVASeguroVida		:= 23;						-- Valor del IVA del seguro de vida de la tabla TIPOSMOVSARRENDA
	SET	Mov_IVASeguroInmob		:= 24;						-- Valor del IVA del seguro de la tabla TIPOSMOVSARRENDA
	SET	Mov_IVAOtrasComis		:= 25;						-- Valor del IVA de otras comisiones de la tabla TIPOSMOVSARRENDA
	SET	Mov_ComFalPag			:= 40;						-- Valor de comision por falta de pago de la tabla TIPOSMOVSARRENDA
	SET	Mov_OtrasComis   		:= 41;						-- Valor de otras comisiones de la tabla TIPOSMOVSARRENDA
	SET	Mov_SegInmobiliario   	:= 49;						-- Valor del seguro de la tabla TIPOSMOVSARRENDA
	SET	Mov_SegVida				:= 50;						-- Valor del seguro de vida de la tabla TIPOSMOVSARRENDA


	SET	Con_CapVigente	  		:= 1;						-- Valor del capital vigente de la tabla CONCEPTOSARRENDA
	SET	Con_CapAtrasado			:= 2;						-- Valor del capital atrasado de la tabla CONCEPTOSARRENDA
	SET	Con_CapVencido	  		:= 3;						-- Valor del capital vencido de la tabla CONCEPTOSARRENDA
	SET	Con_IntVigente			:= 19;						-- Valor del interes vigente de la tabla CONCEPTOSARRENDA
	SET	Con_IntAtrasado	 		:= 20;						-- Valor del interes atrasado de la tabla CONCEPTOSARRENDA
	SET	Con_IntVencido	  		:= 21;						-- Valor del interes vencido de la tabla CONCEPTOSARRENDA
	SET	Con_Moratorio 	  		:= 33;						-- Valor del moratorio de la tabla CONCEPTOSARRENDA
	SET	Con_IVACapital	  		:= 6;						-- Valor del IVA del capital de la tabla CONCEPTOSARRENDA
	SET	Con_IVAInteres	  		:= 7;						-- Valor del IVA del interes de la tabla CONCEPTOSARRENDA
	SET	Con_IVAIntMora  		:= 8;						-- Valor del IVA moratorio de la tabla CONCEPTOSARRENDA
	SET	Con_IVAComFaPag 		:= 9;						-- Valor del IVA por falta de pago de la tabla CONCEPTOSARRENDA
	SET	Con_IVASeguroVida		:= 10;						-- Valor del IVA del seguro de vida de la tabla CONCEPTOSARRENDA
	SET	Con_IVASeguroInmob		:= 11;						-- Valor del IVA del seguro de la tabla CONCEPTOSARRENDA
	SET	Con_IVAOtrasComis		:= 12;						-- Valor del IVA de otras comisiones de la tabla CONCEPTOSARRENDA
	SET	Con_ComFalPag			:= 15;						-- Valor de comision por falta de pago de la tabla CONCEPTOSARRENDA
	SET	Con_OtrasComis   		:= 16;						-- Valor de otras comisiones de la tabla CONCEPTOSARRENDA
	SET	Con_SegInmobiliario   	:= 17;						-- Valor del seguro de la tabla CONCEPTOSARRENDA
	SET	Con_SegVida				:= 18;						-- Valor del seguro de vida de la tabla CONCEPTOSARRENDA
	SET	Con_PagInicial			:= 35;						-- Valor del pago inicial de la tabla CONCEPTOSARRENDA

	SET	Cadena_Vacia			:= '';						-- String Vacio
	SET	Fecha_Vacia				:= '1900-01-01'; 			-- Fecha Vacia
	SET	Entero_Cero				:= 0;						-- Entero en Cero
	SET	Decimal_Cero			:= 0.00;					-- Decimal Cero
	SET Var_SI 					:= 'S';						-- Permite Salida SI
	SET Var_NO  				:= 'N';						-- Permite Salida NO

	SET	Est_Activo				:= 'A';						-- Estatus Activo
	SET	Est_Cancelado			:= 'C';						-- Estatus Cancelado
	SET	Est_Inactivo			:= 'I';						-- Estatus Inactivo
	SET	Est_Vencido				:= 'B';						-- Estatus Vencido
	SET	Est_Vigente				:= 'V';						-- Estatus Vigente
	SET	Est_Pagado				:= 'P';						-- Estatus Pagado
	SET	Est_Atrasado			:= 'A';						-- Estatus Atrasado
	SET	Par_SalidaNO			:= 'N';						-- Ejecutar Store sin Regreso o Mensaje de Salida
	SET	Par_SalidaSI			:= 'S';						-- Ejecutar Store Con Regreso o Mensaje de Salida
	SET	AltaPoliza_NO			:= 'N';						-- Constante para poliza NO
	SET	AltaPolArrenda_SI		:= 'S';						-- Poliza SI
	SET	AltaMovsArrenda_SI		:= 'S';						-- Alta de movimientos SI
	SET	AltaMovsArrenda_NO		:= 'N';						-- Alta de movimientos NO

	SET	Nat_Abono				:= 'A';						-- Naturaleza de Abono.
	SET	Nat_Cargo				:= 'C';						-- Naturaleza de Cargo.
    SET	Var_NumRecPago			:= 0;						-- Numero de arrendamientos

	SET	Aud_ProgramaID			:= 'PAGOARRENDAMIENTOPRO';	-- Valor del programa de auditoria que ejecuta
	SET	Des_PagoArrenda			:= 'PAGO DE ARRENDAMIENTO';	-- Valor de descripcion pago de arrendamiento
	SET Des_PagoIniArrenda		:= 'PAGO INICIAL';			-- Valor de descripcion pago inicial de arrendamiento
	SET	Con_Minuto				:= '00:01:00';				-- Valor de un minuto
	SET	Var_Control				:= 'arrendaID';				-- Valor control
	SET	Var_ProgOriginalID 		:= Aud_ProgramaID;			-- Valor programa
	SET	ValorSI					:= 'S';						-- Valor SI
	SET	ValorNO					:= 'N';						-- Valor NO
	SET	Con_MontoMin			:= 'MontoMinPago';			-- Valor concepto monto minimo
	SET	Con_PagEfectivo			:= 'E';						-- Valor pago efectivo

	SET	Con_PlazoCorto			:= 'C';						-- Valor plazo corto
	SET	Con_PlazoLargo			:= 'L';						-- Valor plazo largo
	SET	Est_Autorizado			:= 'A';						-- Estatus autorizado.
	SET	Mov_PagoInicial			:= 51;						-- Valor del Pago Inicial de la tabla TIPOSMOVSARRENDA

	SET Var_TipSaldoSeg			:= 67;						-- saldo seguro inmobiliario
	SET Var_TipSalSegVida		:= 69;						-- saldo seguro vida
	SET Var_TipSalOtComi		:= 71;						-- saldo otras comisiones

	SET	Var_Plazo				:= Con_PlazoCorto;			-- Concepto de plazo corto

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET	Par_NumErr	:= 999;
				SET	Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOARRENDAMIENTOPRO');
				SET Var_Control = 'sqlException';
		END;

		SELECT	FechaSistema
			INTO	Var_FechaSis
			FROM	PARAMETROSSIS;

		SELECT	ValorParametro
			INTO	Mon_MinPago
			FROM	PARAMGENERALES
			WHERE	LlaveParametro	= Con_MontoMin;

		SET	Aud_FechaActual		:= NOW();

		-- SE VALIDA QUE NO SE HAYA RECIBIDO UN PAGO DE ARRENDAMIENTO SI AUN NO PASA MAS DE UN MINUTO
		SET Var_NumRecPago	:= (SELECT COUNT(ArrendaID)
									FROM DETALLEPAGARRENDA
									WHERE ArrendaID = Par_ArrendaID
									  AND TIMEDIFF(Aud_FechaActual,FechaActual) <= Con_Minuto
									  AND	FechaPago = Var_FechaSis);

		SET	Var_NumRecPago	:= IFNULL(Var_NumRecPago, Entero_Cero);

		IF(Var_NumRecPago > Entero_Cero) THEN
				SET Par_NumErr		:= '001';
				SET Par_ErrMen		:= 'Ya se realizo un pago de arrendamiento para el cliente indicado, favor de intentarlo nuevamente en un minuto.';
				SET Par_Consecutivo	:= 0;
				SET Var_Control		:= 'arrendamientoID';
			LEAVE ManejoErrores;
		END IF;


		SELECT		cli.SucursalOrigen,			arrenda.ClienteID,			pro.ProductoArrendaID,		arrenda.CantCuota,			arrenda.Estatus,
					arrenda.LineaArrendaID,		arrenda.TasaFijaAnual,		arrenda.MonedaID,			arrenda.FechaUltimoVen,		arrenda.SaldoSeguro,
					arrenda.SaldoSeguroVida,	arrenda.SaldoMoratorios,	arrenda.SaldComFaltPago,	arrenda.SaldoOtrasComis,	arrenda.TipoArrenda,
					IFNULL((arrenda.SaldoCapVigente+arrenda.SaldoCapAtrasad+arrenda.SaldoCapVencido),Decimal_Cero),
					IFNULL((arrenda.SaldoInteresVigent+arrenda.SaldoInteresAtras+arrenda.SaldoInteresVen),Decimal_Cero)
			INTO	Var_SucCliente,				Var_ClienteID,				Var_ProdArrendaID,			Var_NumAmorti,				Var_EstatusArrenda,
					Var_LineaArrenda,			Var_TasaArrenda,			Var_MonedaID,				Var_FechaVen,				Var_SalSegArrenda,
					Var_SalSegVidaArr,			Var_SaldoMorArrenda,		Var_SalComFaltaPagA,		Var_SalComisArrenda,		Var_TipoArrenda,
					Var_SalCapArrenda,
					Var_SaldoInteres
			FROM	ARRENDAMIENTOS arrenda
			INNER	JOIN PRODUCTOARRENDA pro ON arrenda.ProductoArrendaID	= pro.ProductoArrendaID
			INNER	JOIN CLIENTES cli ON arrenda.ClienteID	= cli.ClienteID
			WHERE	arrenda.ArrendaID	= Par_ArrendaID;

		SELECT	IVA
			INTO	Var_IVASucurs
			FROM	SUCURSALES
			WHERE	SucursalID	= Var_SucCliente;

		SET	Var_IVASucurs	:= IFNULL(Var_IVASucurs, Decimal_Cero);

		SELECT PagaIVA INTO Var_CtePagIva   FROM CLIENTES  WHERE ClienteID = Var_ClienteID;

		IF(IFNULL(Var_CtePagIva, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Var_CtePagIva	:= Var_Si;
		END IF;

		IF (Var_CtePagIva = Var_No) THEN
			SET Var_IVASucurs	:= Decimal_Cero;
		END IF;

		CALL DIASFESTIVOSCAL(
			Var_FechaSis,		Entero_Cero,		Var_FecAplicacion,		Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(IFNULL(Var_EstatusArrenda, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr		:= '02';
				SET	Par_ErrMen		:= 'El Arrendamiento No Existe.';
				SET	Par_Consecutivo	:= 0;
				SET	Var_Control		:= 'arrendamientoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusArrenda	!= Est_Vigente AND
			Var_EstatusArrenda	!= Est_Vencido AND
			Var_EstatusArrenda	!= Est_Autorizado) THEN
				SET	Par_NumErr		:= '03';
				SET	Par_ErrMen		:= 'Estatus del Arrendamiento Incorrecto.';
				SET	Par_Consecutivo	:= 0;
				SET	Var_Control		:= 'montoPagarArrendamiento';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusArrenda	= Est_Autorizado) THEN
			SELECT	Descripcion
				INTO	Var_RefePoliza
				FROM	CONCEPTOSARRENDA
				WHERE	ConceptoArrendaID	= Con_PagInicial;

			IF(Par_MontoPagar	>= Mon_MinPago) THEN
				CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_PagInicial,
										Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
										Var_RefePoliza,		Par_MontoPagar,			AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
										AltaMovsArrenda_SI,	Con_PagInicial,			Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
										Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
										Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_PagInicial,
										Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
										Var_RefePoliza,		Par_MontoPagar,			AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
										AltaMovsArrenda_SI,	Con_PagInicial,			Mov_PagoInicial,		Nat_Cargo,			Par_ModoPago,
										Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
										Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
			END IF;
		ELSE
			-- Validacion del monto a pagar sea menor o igual al exigible del dia
			SELECT IFNULL(SUM(	ROUND(amo.SaldoCapVigent,2) + ROUND(amo.SaldoCapAtrasad,2) + ROUND(amo.SaldoCapVencido,2) + ROUND(amo.SaldoInteresVigente,2) +
									ROUND(amo.SaldoInteresAtras,2) + ROUND(amo.SaldoInteresVen,2) + ROUND(amo.SaldComFaltPago,2)+ ROUND(amo.SaldoOtrasComis,2) +
									ROUND(amo.SaldoSeguro,2) + ROUND(amo.SaldoMoratorios,2) + ROUND(amo.SaldoSeguroVida,2)+
									ROUND((amo.SaldComFaltPago*Var_IVASucurs),2) +
									ROUND((amo.SaldoOtrasComis*Var_IVASucurs),2) +
									ROUND((amo.SaldoSeguro*Var_IVASucurs),2) +
									ROUND((amo.SaldoSeguroVida*Var_IVASucurs),2) +
									(ROUND(InteresRenta * Var_IVASucurs, 2) - MontoIVAInteres) +              -- IVA de Interes
									(IVARenta - ROUND(InteresRenta * Var_IVASucurs, 2) - MontoIVACapital) +   -- IVA de Capital
									ROUND((amo.SaldoMoratorios*Var_IVASucurs),2)
									),Decimal_Cero)
				INTO	Var_TotalExigible
				FROM	ARRENDAAMORTI amo
				WHERE	ArrendaID		= Par_ArrendaID
				AND	FechaExigible	<= Var_FechaSis
				AND	Estatus       != Est_Pagado;

			IF(Par_MontoPagar	> Var_TotalExigible) THEN
					SET	Par_NumErr		:= '04';
					SET	Par_ErrMen		:= 'El monto a pagar no puede ser mayor al pago exigible del dia.';
					SET	Par_Consecutivo	:= 0;
					SET	Var_Control		:= 'montoPagarArrendamiento';
				LEAVE ManejoErrores;
			END IF;

			SET	Var_SaldoPago			:= Par_MontoPagar;
			SET	Var_ArrendamientoStr	:= CONVERT(Par_ArrendaID, CHAR(15));

			OPEN CURSORAMORTI;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP

				FETCH CURSORAMORTI INTO
					Var_ArrendaID,			Var_ArrendaAmortiID,	Var_SaldoCapVigente,	Var_SaldoCapAtrasa,		Var_SaldoCapVencido,
					Var_SaldoInteresVig,	Var_SaldoInteresAtr,	Var_SaldoInteresVen,	Var_SaldoSeguroInmob,	Var_SaldoSeguroVida,
					Var_SaldoMoratorios,	Var_SaldoComFaltaPa,    Var_SaldoOtrasComis,	Var_MonedaID,			Var_FechaInicio,
					Var_FechaVencim,		Var_FechaExigible,		Var_AmoEstatus,			Var_MontoIVACapital,	Var_MontoIVAInteres,
					Var_MontoIVASeguro,		Var_MonIVASegVida,		Var_MontoIVAMora,		Var_MonIVAComFalPag ,	Var_MontoIVAComis,
					Var_CapitalRenta,		Var_InteresRenta,		Var_IVARenta,			Var_Seguro,				Var_SeguroVida	;


				-- Inicializaciones
				SET Var_CantidPagar			:= Decimal_Cero;
				SET Var_IVACantidPagar		:= Decimal_Cero;
				SET Var_SaldoCapVigente		:= IFNULL(Var_SaldoCapVigente, Decimal_Cero);
				SET Var_SaldoCapAtrasa		:= IFNULL(Var_SaldoCapAtrasa, Decimal_Cero);
				SET Var_SaldoCapVencido		:= IFNULL(Var_SaldoCapVencido, Decimal_Cero);
				SET Var_SaldoInteresVig		:= IFNULL(Var_SaldoInteresVig, Decimal_Cero);
				SET Var_SaldoInteresAtr		:= IFNULL(Var_SaldoInteresAtr, Decimal_Cero);
				SET Var_SaldoInteresVen		:= IFNULL(Var_SaldoInteresVen, Decimal_Cero);
				SET Var_SaldoSeguroInmob	:= IFNULL(Var_SaldoSeguroInmob, Decimal_Cero);
				SET Var_SaldoSeguroVida		:= IFNULL(Var_SaldoSeguroVida, Decimal_Cero);
				SET Var_SaldoMoratorios		:= IFNULL(Var_SaldoMoratorios, Decimal_Cero);
				SET Var_SaldoComFaltaPa		:= IFNULL(Var_SaldoComFaltaPa, Decimal_Cero);
				SET Var_SaldoOtrasComis		:= IFNULL(Var_SaldoOtrasComis, Decimal_Cero);
				SET	Var_MontoIVACapital		:= IFNULL(Var_MontoIVACapital, Decimal_Cero);
				SET	Var_MontoIVAInteres		:= IFNULL(Var_MontoIVAInteres, Decimal_Cero);
				SET	Var_MontoIVASeguro		:= IFNULL(Var_MontoIVASeguro, Decimal_Cero);
				SET	Var_MonIVASegVida		:= IFNULL(Var_MonIVASegVida, Decimal_Cero);
				SET	Var_MontoIVAMora		:= IFNULL(Var_MontoIVAMora, Decimal_Cero);
				SET	Var_MonIVAComFalPag 	:= IFNULL(Var_MonIVAComFalPag , Decimal_Cero);
				SET	Var_MontoIVAComis		:= IFNULL(Var_MontoIVAComis, Decimal_Cero);
				SET	Var_CapitalRenta		:= IFNULL(Var_CapitalRenta, Decimal_Cero);
				SET	Var_InteresRenta		:= IFNULL(Var_InteresRenta, Decimal_Cero);
				SET	Var_IVARenta			:= IFNULL(Var_IVARenta, Decimal_Cero);
				SET	Var_Seguro				:= IFNULL(Var_Seguro, Decimal_Cero);
				SET	Var_SeguroVida			:= IFNULL(Var_SeguroVida, Decimal_Cero);
				SET Var_TotalAbono			:= Decimal_Cero;
				SET Var_TotalCargo			:= Decimal_Cero;
				SET Var_TotalMovCA			:= Decimal_Cero;



				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

				--  =======================================================================================
				--  =============   APLICACION DE PAGO DE COMISION FALTA DE PAGO  ==========================
				-- Comision por falta de pago
				IF (Var_SaldoComFaltaPa	>= Mon_MinPago) THEN


					SET	Var_IVACantidPagar	= ROUND((Var_SaldoComFaltaPa *  Var_IVASucurs), 2);

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoComFaltaPa + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoComFaltaPa;
					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;

					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_ComFalPag;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_ComFalPag,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_ComFalPag,			Mov_ComFalPag,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


					IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IVAComFaPag;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVAComFaPag,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVAComFaPag,		Mov_IVAComFaPag,		Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


					END IF;

					SET	Var_SaldoComFaltaPa		:= Var_SaldoComFaltaPa - Var_CantidPagar;
					SET	Var_MonIVAComFalPag 	:= Var_MonIVAComFalPag  + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET	NumTransaccion		= Aud_NumTransaccion,
							MontoIVAComFalPag	= Var_MonIVAComFalPag ,
							SaldComFaltPago		= Var_SaldoComFaltaPa
						WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
						AND		ArrendaID		= Par_ArrendaID;

					UPDATE ARRENDAMIENTOS
						SET	MontoIVAComFalPag	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVAComFalPag'),
							SaldComFaltPago		= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldComFaltPago')
						WHERE	ArrendaID		= Par_ArrendaID;


					SET	Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);	-- calculo saldo despues de pago
					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;

				END IF;

				--  ===================================================================================
				--  =============   APLICACION DE PAGO DE OTRAS COMISIONES   ==========================
				-- Pago otras comisiones
				IF (Var_SaldoOtrasComis	>= Mon_MinPago) THEN

					SET	Var_IVACantidPagar	= ROUND((Var_SaldoOtrasComis *  Var_IVASucurs), 2);

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoOtrasComis + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoOtrasComis;
					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;

					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_OtrasComis;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_OtrasComis,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_OtrasComis,			Mov_OtrasComis,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


                    IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IVAOtrasComis;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVAOtrasComis,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVAOtrasComis,		Mov_IVAOtrasComis,		Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;

					SET	Var_SaldoOtrasComis	:= Var_SaldoOtrasComis - Var_CantidPagar;
					SET	Var_MontoIVAComis	:= Var_MontoIVAComis + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET	NumTransaccion		= Aud_NumTransaccion,
							MontoIVAComisi		= Var_MontoIVAComis,
							SaldoOtrasComis		= Var_SaldoOtrasComis
						WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
						AND	ArrendaID	= Par_ArrendaID;

					UPDATE	ARRENDAMIENTOS
						SET	MontoIVAComisi	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVAComisi'),
							SaldoOtrasComis	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldoOtrasComis')
						WHERE	ArrendaID	= Par_ArrendaID;

					-- Se obtiene el monto disponible para realizar los pagos siguientes
					SET	Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar +Var_IVACantidPagar);
					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;

				END IF;

				--  =======================================================================================
				--  =============   APLICACION DE PAGO DE MORATORIOS  ==========================
				-- Pago de moratorios
				IF (Var_SaldoMoratorios >= Mon_MinPago) THEN

					SET	Var_IVACantidPagar	= ROUND((Var_SaldoMoratorios *  Var_IVASucurs), 2);

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoMoratorios + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoMoratorios;
					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;

					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_Moratorio;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_Moratorio,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_Moratorio,			Mov_Moratorio,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


                    IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IVAIntMora;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVAIntMora,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVAIntMora,			Mov_IVAIntMora,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


					SET Var_SaldoMoratorios	:= Var_SaldoMoratorios - Var_CantidPagar;
					SET Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET	NumTransaccion		= Aud_NumTransaccion,
							MontoIVAMora		= Var_MontoIVAMora,
							SaldoMoratorios		= Var_SaldoMoratorios
						WHERE ArrendaAmortiID	= Var_ArrendaAmortiID
						AND ArrendaID		= Par_ArrendaID;

					UPDATE	ARRENDAMIENTOS
						SET	MontoIVAMora	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVAMora'),
							SaldoMoratorios	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldoMoratorios')
						WHERE ArrendaID	= Par_ArrendaID;


					-- Se obtiene el monto disponible para realizar los pagos siguientes
					SET	Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;

				END IF;

				--  =================================================================================================
				--  =============   APLICACION DE PAGO DE SEGURO DEL BIEN (NORMAL)  ==================================
				-- Pago de seguro inmobiliario
				IF (Var_SaldoSeguroInmob	>= Mon_MinPago) THEN
					-- Suma y Resta  de cargo y abono realizadas por seguro inmobiliario
					SELECT	ROUND(SUM(Monto),2)
					  INTO	Var_TotalAbono
						FROM ARRCARGOABONO
						WHERE	ArrendaAmortiID = Var_ArrendaAmortiID
						  AND	ArrendaID = Var_ArrendaID
						  AND	Naturaleza = Nat_Abono
						  AND	TipoConcepto = Var_TipSaldoSeg;
					SET Var_TotalAbono	:= IFNULL(Var_TotalAbono,Decimal_Cero);

					SELECT	ROUND(SUM(Monto),2)
					  INTO	Var_TotalCargo
						FROM ARRCARGOABONO
						WHERE	ArrendaAmortiID = Var_ArrendaAmortiID
						  AND	ArrendaID = Var_ArrendaID
						  AND	Naturaleza = Nat_Cargo
						  AND	TipoConcepto = Var_TipSaldoSeg;

					SET Var_TotalCargo	:= IFNULL(Var_TotalCargo,Decimal_Cero);
					SET Var_TotalMovCA	:= IFNULL(ROUND((Var_TotalCargo - Var_TotalAbono),2),Decimal_Cero);

					SET	Var_IVACantidPagar	= ROUND(((Var_Seguro + Var_TotalMovCA) *  Var_IVASucurs), 2) - Var_MontoIVASeguro;

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoSeguroInmob + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoSeguroInmob;
					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;

					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_SegInmobiliario;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_SegInmobiliario,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_SegInmobiliario,	Mov_SegInmobiliario,	Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


                    IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IVASeguroInmob;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVASeguroInmob,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVASeguroInmob,		Mov_IVASeguroInmob,		Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;

					SET	Var_SaldoSeguroInmob	:= Var_SaldoSeguroInmob - Var_CantidPagar;
					SET	Var_MontoIVASeguro		:= Var_MontoIVASeguro + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET	NumTransaccion	= Aud_NumTransaccion,
							MontoIVASeguro	= Var_MontoIVASeguro,
							SaldoSeguro		= Var_SaldoSeguroInmob
						WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
						AND		ArrendaID		= Par_ArrendaID;

					UPDATE	ARRENDAMIENTOS
						SET	MontoIVASeguro	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVASeguro'),
							SaldoSeguro		= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldoSeguro')
						WHERE	ArrendaID	= Par_ArrendaID;

					-- Se obtiene el monto disponible para realizar los pagos siguientes
					SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;

				END IF;

				--  =================================================================================================
				--  =============   APLICACION DE PAGO DE SEGURO DE VIDA    ==================================

				-- Pago de seguro de vidaVar_MontoIVACapital
				IF (Var_SaldoSeguroVida	>= Mon_MinPago) THEN
					-- Suma y Resta  de cargo y abono realizadas por seguro de vida
					SELECT	ROUND(SUM(Monto),2)
					  INTO	Var_TotalAbono
						FROM ARRCARGOABONO
						WHERE	ArrendaAmortiID = Var_ArrendaAmortiID
						  AND	ArrendaID = Var_ArrendaID
						  AND	Naturaleza = Nat_Abono
						  AND	TipoConcepto = Var_TipSalSegVida;
					SET Var_TotalAbono	:= IFNULL(Var_TotalAbono,Decimal_Cero);

					SELECT	ROUND(SUM(Monto),2)
					  INTO	Var_TotalCargo
						FROM ARRCARGOABONO
						WHERE	ArrendaAmortiID = Var_ArrendaAmortiID
						  AND	ArrendaID = Var_ArrendaID
						  AND	Naturaleza = Nat_Cargo
						  AND	TipoConcepto = Var_TipSalSegVida;

					SET Var_TotalCargo	:= IFNULL(Var_TotalCargo,Decimal_Cero);
					SET Var_TotalMovCA	:= IFNULL(ROUND((Var_TotalCargo - Var_TotalAbono),2),Decimal_Cero);

					SET	Var_IVACantidPagar	= ROUND(((Var_SeguroVida + Var_TotalMovCA)*  Var_IVASucurs), 2) - Var_MonIVASegVida;

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoSeguroVida + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoSeguroVida;
					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;

					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_SegVida;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_SegVida,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_SegVida,			Mov_SegVida,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


                    IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IVASeguroVida;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVASeguroVida,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVASeguroVida,		Mov_IVASeguroVida,		Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;

					SET	Var_SaldoSeguroVida		:= Var_SaldoSeguroVida - Var_CantidPagar;
					SET	Var_MonIVASegVida	:= Var_MonIVASegVida + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET	NumTransaccion		= Aud_NumTransaccion,
							MontoIVASeguroVida	= Var_MonIVASegVida,
							SaldoSeguroVida		= Var_SaldoSeguroVida
						WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
						AND		ArrendaID		= Par_ArrendaID;

					UPDATE	ARRENDAMIENTOS
						SET	MontoIVASeguroVida	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVASeguroVida'),
							SaldoSeguroVida		= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldoSeguroVida')
						WHERE	ArrendaID	= Par_ArrendaID;

					-- Se obtiene el monto disponible para realizar los pagos siguientes
					SET	Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;

				END IF;

				--  =================================================================================================
				--  =============   APLICACION DE PAGO DE INTERES VENCIDO ==================================
				-- Pago de interes vencido
				IF (Var_SaldoInteresVen	>= Mon_MinPago) THEN
					SET	Var_IVACantidPagar	= ROUND((Var_InteresRenta *  Var_IVASucurs), 2) - Var_MontoIVAInteres;

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoInteresVen + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoInteresVen;
					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;

					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IntVencido;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IntVencido,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IntVencido,			Mov_IntVencido,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
					END IF;


                    IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IVAInteres;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVAInteres,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVAInteres,			Mov_IVAInteres,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;

					SET	Var_SaldoInteresVen	:= Var_SaldoInteresVen - Var_CantidPagar;
					SET	Var_MontoIVAInteres	:= Var_MontoIVAInteres + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET	NumTransaccion	= Aud_NumTransaccion,
							MontoIVAInteres	= Var_MontoIVAInteres,
							SaldoInteresVen	= Var_SaldoInteresVen
						WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
						AND		ArrendaID		= Par_ArrendaID;

					UPDATE	ARRENDAMIENTOS
						SET	MontoIVAInteres	=  FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVAInteres'),
							SaldoInteresVen	=  FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldoInteresVen')
						WHERE ArrendaID	= Par_ArrendaID;

					-- Se obtiene el monto disponible para realizar los pagos siguientes
					SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;

				END IF;

				--  =================================================================================================
				--  =============   APLICACION DE PAGO DE INTERES ATRASADO   ==================================
				-- Pago de interes atrasado
				IF (Var_SaldoInteresAtr	>= Mon_MinPago) THEN
					SET	Var_IVACantidPagar	= ROUND((Var_InteresRenta *  Var_IVASucurs), 2) - Var_MontoIVAInteres;

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoInteresAtr + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoInteresAtr;
					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;

					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IntAtrasado;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IntAtrasado,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IntAtrasado,		Mov_IntAtrasado,		Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


                    IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IVAInteres;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVAInteres,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVAInteres,			Mov_IVAInteres,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;

					SET	Var_SaldoInteresAtr	:= Var_SaldoInteresAtr - Var_CantidPagar;
					SET	Var_MontoIVAInteres	:= Var_MontoIVAInteres + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET	NumTransaccion	= Aud_NumTransaccion,
							MontoIVAInteres	= Var_MontoIVAInteres,
							SaldoInteresAtras	= Var_SaldoInteresAtr
						WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
						AND		ArrendaID		= Par_ArrendaID;

					UPDATE	ARRENDAMIENTOS
						SET	MontoIVAInteres		= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVAInteres'),
							SaldoInteresAtras	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldoInteresAtras')
						WHERE	ArrendaID	= Par_ArrendaID;

					-- Se obtiene el monto disponible para realizar los pagos siguientes
					SET	Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;

				END IF;

				--  =================================================================================================
				--  =============   APLICACION DE PAGO DE INTERES VIGENTE    ==================================
				-- Pago de interes vigente
				IF (Var_SaldoInteresVig	>= Mon_MinPago) THEN
					SET	Var_IVACantidPagar	= ROUND((Var_InteresRenta *  Var_IVASucurs), 2) - Var_MontoIVAInteres;

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoInteresVig + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoInteresVig;
					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;

					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IntVigente;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IntVigente,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IntVigente,			Mov_IntVigente,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


                    IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_IVAInteres;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVAInteres,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVAInteres,			Mov_IVAInteres,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;

					SET	Var_SaldoInteresVig	:= Var_SaldoInteresVig - Var_CantidPagar;
					SET	Var_MontoIVAInteres	:= Var_MontoIVAInteres + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET		NumTransaccion		= Aud_NumTransaccion,
								MontoIVAInteres		= Var_MontoIVAInteres,
								SaldoInteresVigente	= Var_SaldoInteresVig
						WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
						AND		ArrendaID		= Par_ArrendaID;

					UPDATE	ARRENDAMIENTOS
						SET	MontoIVAInteres		= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVAInteres'),
							SaldoInteresVigent	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldoInteresVigente')
						WHERE	ArrendaID	= Par_ArrendaID;

					-- Se obtiene el monto disponible para realizar los pagos siguientes
					SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;

				END IF;

				--  =================================================================================================
				--  =============   APLICACION DE PAGO DE CAPITAL VENCIDO    ==================================
				-- Pago de capital vencido
				IF (Var_SaldoCapVencido	>= Mon_MinPago) THEN
					SET	Var_IVACantidPagar	= Var_IVARenta - ROUND((Var_InteresRenta *  Var_IVASucurs), 2) - Var_MontoIVACapital;

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoCapVencido + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoCapVencido;

					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;


					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID = Con_CapVencido;

                        CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_CapVencido,
											Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
											Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
											AltaMovsArrenda_SI,	Con_CapVencido,			Mov_CapVencido,			Nat_Abono,			Par_ModoPago,
											Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
											Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


                    IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID = Con_IVACapital;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVACapital,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVACapital,			Mov_IVACapital,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
					END IF;


					SET	Var_SaldoCapVencido	:= Var_SaldoCapVencido - Var_CantidPagar;
					SET	Var_MontoIVACapital	:= Var_MontoIVACapital + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET	NumTransaccion	= Aud_NumTransaccion,
							MontoIVACapital	= Var_MontoIVACapital,
							SaldoCapVencido	= Var_SaldoCapVencido
						WHERE ArrendaAmortiID	= Var_ArrendaAmortiID
						AND			ArrendaID	= Par_ArrendaID;

					UPDATE	ARRENDAMIENTOS
						SET	MontoIVACapital	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVACapital'),
							SaldoCapVencido	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldoCapVencido')
						WHERE ArrendaID = Par_ArrendaID;

					IF (Var_SaldoCapVencido	<= Mon_MinPago)THEN
						UPDATE	ARRENDAAMORTI
							SET	Estatus=Est_Pagado
							WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
							AND		ArrendaID		= Par_ArrendaID;
					END IF;

					SET	Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);

					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;
				END IF;

				--  =================================================================================================
				--  =============   APLICACION DE PAGO DE CAPITAL ATRASADO    ==================================
				-- Pago de capital atrasado
				IF (Var_SaldoCapAtrasa	>= Mon_MinPago) THEN
					SET	Var_IVACantidPagar	= Var_IVARenta - ROUND((Var_InteresRenta *  Var_IVASucurs), 2) - Var_MontoIVACapital;

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoCapAtrasa + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoCapAtrasa;
					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;

					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_CapAtrasado;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_CapAtrasado,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_CapAtrasado,		Mov_CapAtrasado,		Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


                    IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID = Con_IVACapital;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVACapital,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVACapital,			Mov_IVACapital,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


					SET	Var_SaldoCapAtrasa	:= Var_SaldoCapAtrasa - Var_CantidPagar;
					SET	Var_MontoIVACapital	:= Var_MontoIVACapital + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET	NumTransaccion	= Aud_NumTransaccion,
							MontoIVACapital	= Var_MontoIVACapital,
							SaldoCapAtrasad	= Var_SaldoCapAtrasa
						WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
						AND		ArrendaID		= Par_ArrendaID;

					UPDATE	ARRENDAMIENTOS
						SET	MontoIVACapital	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVACapital'),
							SaldoCapAtrasad	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldoCapAtrasad')
						WHERE ArrendaID = Par_ArrendaID;

					IF (Var_SaldoCapAtrasa	<= Mon_MinPago)THEN
						UPDATE	ARRENDAAMORTI
							SET	Estatus	= Est_Pagado
							WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
							AND		ArrendaID		= Par_ArrendaID;
					END IF;


					SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);

					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;
				END IF;

				--  =================================================================================================
				--  =============   APLICACION DE PAGO DE CAPITAL VIGENTE    ==================================
				-- Pago de capital vigente
				IF (Var_SaldoCapVigente	>= Mon_MinPago) THEN
					SET	Var_IVACantidPagar	= Var_IVARenta - ROUND((Var_InteresRenta *  Var_IVASucurs), 2) - Var_MontoIVACapital;

					IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoCapVigente + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:= Var_SaldoCapVigente;
					ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVASucurs)) * Var_IVASucurs, 2);
					END IF;

					IF (Var_CantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID	= Con_CapVigente;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_CapVigente,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_CantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_CapVigente,			Mov_CapVigente,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;


                    IF (Var_IVACantidPagar	>= Mon_MinPago)THEN
						SELECT	Descripcion
							INTO	Var_RefePoliza
							FROM	CONCEPTOSARRENDA
							WHERE	ConceptoArrendaID = Con_IVACapital;

						CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVACapital,
												Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoArrenda,
												Var_RefePoliza,		Var_IVACantidPagar,		AltaPoliza_NO,			Entero_Cero,		AltaPolArrenda_SI,
												AltaMovsArrenda_SI,	Con_IVACapital,			Mov_IVACapital,			Nat_Abono,			Par_ModoPago,
												Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Var_Poliza,
												Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					END IF;

					SET	Var_SaldoCapVigente	:= Var_SaldoCapVigente - Var_CantidPagar;
					SET	Var_MontoIVACapital	:= Var_MontoIVACapital + Var_IVACantidPagar;

					UPDATE	ARRENDAAMORTI
						SET	NumTransaccion	= Aud_NumTransaccion,
							MontoIVACapital	= Var_MontoIVACapital,
							SaldoCapVigent	= Var_SaldoCapVigente
						WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
						AND		ArrendaID		= Par_ArrendaID;

					UPDATE	ARRENDAMIENTOS
						SET	MontoIVACapital	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'MontoIVACapital'),
							SaldoCapVigente	= FNCALCULASALDOSARRENDAMIENTOS (Par_ArrendaID,'SaldoCapVigente')
						WHERE	ArrendaID	= Par_ArrendaID;

					-- Se actualiza el estatus si se ha cubierto el capital vencido
					IF (Var_SaldoCapVigente	<= Mon_MinPago)THEN
						UPDATE	ARRENDAAMORTI
							SET	Estatus	= Est_Pagado
							WHERE	ArrendaAmortiID	= Var_ArrendaAmortiID
							AND		ArrendaID		= Par_ArrendaID;
					END IF;

					SET	Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);

					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;
				END IF;

				END LOOP CICLO;
			END;
		CLOSE CURSORAMORTI;

		-- Se actualiza el estatus del arrendamiento cuando han sido pagados
		IF((Var_EstatusArrenda	= Est_Vencido)|| (Var_EstatusArrenda	= Est_Vigente))THEN
			SELECT	COUNT(ArrendaAmortiID)
				INTO	Var_NumVencidos
				FROM	ARRENDAAMORTI
				WHERE	Estatus		= Est_Vencido
				AND		ArrendaID	= Par_ArrendaID;

			SELECT	COUNT(ArrendaAmortiID)
				INTO	Var_NumAtrasados
				FROM	ARRENDAAMORTI
				WHERE	Estatus		= Est_Atrasado
				AND		ArrendaID	= Par_ArrendaID;

			SELECT	COUNT(ArrendaID)
				INTO	Var_TotalAmorti
				FROM	ARRENDAAMORTI
				WHERE	ArrendaID	= Par_ArrendaID;

			SELECT	COUNT(Estatus)
				INTO	Var_TotalPagados
				FROM	ARRENDAAMORTI
				WHERE	ArrendaID	= Par_ArrendaID
				AND		Estatus		= Est_Pagado;

			-- Cuando ya no existan amortizaciones vencidas o atrasadas el estatus del arrendamiento pasa a Vigente
			IF((Var_NumVencidos	= Entero_Cero) && (Var_NumAtrasados	= Entero_Cero))THEN
				UPDATE ARRENDAMIENTOS
					SET	Estatus	= Est_Vigente
					WHERE	ArrendaID	= Par_ArrendaID;
			END IF;

			-- Cuando todas las amortizaciones han sido pagadas el arrendamiento pasa a estatus pagado
			IF(Var_TotalAmorti	= Var_TotalPagados)THEN
				UPDATE ARRENDAMIENTOS
					SET		Estatus		= Est_Pagado
					WHERE	ArrendaID	= Par_ArrendaID;
			END IF;

		END IF;
	END IF;

	SET Par_NumErr			:= '000';
		SET Par_ErrMen		:= 'Pago Aplicado Exitosamente';
		SET Par_Consecutivo	:= 0;
		SET Var_Control		:= 'arrendamientoID';
	END ManejoErrores;

	IF (Par_Salida	= ValorSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$