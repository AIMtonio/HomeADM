-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRPAGOINICIALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRPAGOINICIALPRO`;
DELIMITER $$

CREATE PROCEDURE `ARRPAGOINICIALPRO`(
	-- SP PARA EL PAGO INICIAL DE ARRENDAMIENTO
	Par_ArrendaID					BIGINT(12),			-- ID del arrendamiento
	Par_MontoPagar					DECIMAL(14,4),		-- Monto a pagar
	Par_ModoPago					CHAR(1),			-- Modo de pago Efectivo o Cuenta
	Par_Poliza						BIGINT,				-- Poliza

	Par_Salida						CHAR(1),			-- Salida
	INOUT Par_NumErr				INT(11),			-- Numero de error
	INOUT Par_ErrMen				VARCHAR(400),		-- Mensaje de Error
	INOUT Par_Consecutivo			BIGINT,				-- Consecutivo

	Par_EmpresaID					INT(11),			-- Numero de empresa
	Aud_Usuario						INT(11),			-- Numero de usuario
	Aud_FechaActual					DATETIME,			-- Fecha del sistema
	Aud_DireccionIP					VARCHAR(15),		-- Direccion IP
	Aud_ProgramaID					VARCHAR(50),		-- Numero de programa
	Aud_Sucursal					INT(11),			-- Numero de sucursal
	Aud_NumTransaccion				BIGINT(20)			-- Numero de transaccion
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(100);		-- Variable de control
	DECLARE Var_SalSegArrenda		DECIMAL(14, 4);		-- Saldo de seguro inmobiliario de la tabla de ARRENDAMIENTOS
	DECLARE Var_SalSegVidaArr		DECIMAL(14, 4);		-- Saldo de seguro de vida de la tabla de ARRENDAMIENTOS
	DECLARE Var_SalCapArrenda		DECIMAL(14, 4);		-- Saldo del capital de la tabla de ARRENDAMIENTOS
	DECLARE Var_SalComFaltaPagA		DECIMAL(14, 4);		-- Saldo de la comision por falta de pago de la tabla de ARRENDAMIENTOS
	DECLARE Var_SaldoMorArrenda		DECIMAL(14, 4);		-- Saldo moratorio de la tabla de ARRENDAMIENTOS
	DECLARE Var_SalComisArrenda		DECIMAL(14, 4);		-- Saldo por otras comision de pago de la tabla de ARRENDAMIENTOS
	DECLARE	Var_SaldoInteres		DECIMAL(14, 4);		-- Saldo del interes de la tabla de ARRENDAMIENTO
	DECLARE Var_EstatusArrenda		CHAR(1);			-- Estatus del arrendamiento
	DECLARE Var_MonedaID			INT(11);			-- Id de la moneda
	DECLARE Var_FechaVen			DATE; 				-- Fecha de vencimiento del arrendamiento
	DECLARE Var_FecAplicacion		DATE;				-- Fecha de aplicacion
	DECLARE Var_EsHabil				CHAR(1);			-- Es dia habil
	DECLARE Var_IVASucurs			DECIMAL(12, 2);		-- IVA aplicado al arrendamiento
	DECLARE Var_SucCliente			INT(11);			-- Sucursal del cliente
	DECLARE Var_ClienteID			BIGINT;				-- Id del cliente
	DECLARE Var_ProdArrendaID		INT(11);			-- Id del producto del arrendamiento
	DECLARE Var_NumAmorti			INT(11);			-- Numero de amortizacion del arrendamiento
	DECLARE Var_FechaSis			DATE;				-- Fecha del sistema
	DECLARE Var_LineaArrenda		BIGINT;				-- Linea del arrendamiento
	DECLARE Var_TasaArrenda			DECIMAL(14,4);		-- Tasa del arrendamiento
	DECLARE Var_RefePoliza			VARCHAR(150);		-- Referencia de la poliza
	DECLARE Var_TipoArrenda			CHAR(1);			-- Tipo de arrendamiento
	DECLARE Var_Plazo				CHAR(1);			-- Plazo del arrendamiento
	DECLARE Var_MontoEnganche		DECIMAL(14,2);		-- Monto del Enganche
	DECLARE Var_IVAEnganche			DECIMAL(14,2);		-- IVA del enganche
	DECLARE Var_MontoComApe			DECIMAL(14,2);		-- Comision por apertura
	DECLARE Var_IVAComApe			DECIMAL(14,2);		-- IVA de comision por apertura
	DECLARE Var_OtroGastos			DECIMAL(14,2);		-- Otros gastos
	DECLARE Var_IVAOtrosGastos		DECIMAL(14,2);		-- IVA de otros gastos
	DECLARE Var_CantRentaDepo		INT(11);			-- Cantidad de rentas en deposito
	DECLARE Var_MontoDeposito		DECIMAL(14,2);		-- Monto de rentas en deposito
	DECLARE Var_IVADeposito			DECIMAL(14,2);		-- IVA de rentas en deposito
	DECLARE Var_TipoPagoSeguro		INT(11);			-- Tipo de pago de seguro anual
	DECLARE Var_MontoSeguro			DECIMAL(14,2);		-- Monto del seguro anual
	DECLARE Var_TipoPagoSegVida		INT(11);			-- Tipo de pago de seguro de vida anual
	DECLARE Var_MontoSegVida		DECIMAL(14,2);		-- Monto del seguro de vida anual
	DECLARE Var_Cuenta				VARCHAR(200);		-- Guarda el numero de cuenta contable
	DECLARE Var_EsRentaAnticip		CHAR(1);			-- Es renta anticipado Si/ No
	DECLARE Var_TipRenAdelanta		CHAR(1);			-- Tipo de renta Adelantada (Primera o Ultima)
	DECLARE Var_NumRenAdelantada	INT(11);			-- Numero de rentas adelantadas
	DECLARE Var_RentaAnticipada		DECIMAL(14,2);		-- Renta Anticipada
	DECLARE Var_IVARenAnticipa		DECIMAL(14,2);		-- IVA de la renta anticipada
	DECLARE Var_RentAdelantadas		DECIMAL(14,2);		-- Rentas adelantada
	DECLARE Var_IVARenAdelanta		DECIMAL(14,2);		-- IVA de las rentas adelantada
	DECLARE Mon_MinPago				DECIMAL(14,2);		-- Valor monto minimo
	DECLARE Var_TotalPagoIni		DECIMAL(14,2);		-- Monto total del pago inicial.
	DECLARE Var_Diferencia			DECIMAL(14,2);		-- Diferencia entre el  monto a pagar -pago inicial
	DECLARE Var_ArrendaID 			BIGINT(12);			-- Numero del arrendamiento
	DECLARE Var_ArrendaAmortiID		INT(4);				-- Numero de amortizacion

	DECLARE	Var_CapitalRenta		DECIMAL(14, 4);		-- Monto de la cuota de Capital de acuerdo al plan de pagos de la tabla de ARRENDAAMORTI
	DECLARE	Var_InteresRenta		DECIMAL(14, 4);		-- Monto de la cuota de Interes de acuerdo al plan de pagos de la tabla de ARRENDAAMORTI
	DECLARE	Var_IVARenta			DECIMAL(14, 4);		-- Monto de la cuota de IVA de RENTA de acuerdo al plan de pagos de la tabla de ARRENDAAMORTI
	DECLARE Var_Seguro				DECIMAL(14, 4);		-- Monto de la cuota de Seguro de acuerdo al plan de pagos de la tabla de ARRENDAAMORTI
	DECLARE	Var_SeguroVida			DECIMAL(14, 4);		-- Monto de la cuota de Seguro de Vida de acuerdo al plan de pagos de la tabla de ARRENDAAMORTI
	DECLARE	Var_IVACapital			DECIMAL(14, 4);		-- IVA del capital
	DECLARE	Var_IVAInteres			DECIMAL(14, 4);		-- IVA del interes del capital
	DECLARE	Var_IVASeguro			DECIMAL(14, 4);		-- IVA del seguro
	DECLARE	Var_IVASeguroVida		DECIMAL(14, 4);		-- IVA del seguro vida
	DECLARE Var_CtePagIva 			CHAR(1);			-- VARIABLE PARA  GUARDAR SU EL CLIENTE PAGA O NO IVA


	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;				-- Fecha vacia
	DECLARE Entero_Cero				INT(11);			-- Entero cero
	DECLARE Decimal_Cero			DECIMAL(14,2);		-- Decimal cero
	DECLARE Nat_Abono				CHAR(1);			-- Naturaleza del movimiento de tipo abono
    DECLARE Nat_Cargo				CHAR(1);			-- Naturaleza del movimiento de tipo cargo
	DECLARE	Par_SalidaSI			CHAR(1);			-- Salida SI
	DECLARE	Par_SalidaNO			CHAR(1);			-- Salida NO
	DECLARE AltaPoliza_NO			CHAR(1);			-- Alta poliza NO
	DECLARE AltaPolArrenda_SI		CHAR(1);			-- Alta poliza SI
	DECLARE AltaMovsArrenda_SI		CHAR(1);			-- Alta movimientos SI
	DECLARE AltaMovsArrenda_NO		CHAR(1);			-- Alta movimientos NO
	DECLARE Con_MontoMin			CHAR(20);			-- Concepto del monto minimo
	DECLARE Con_PagEfectivo			CHAR(1);			-- Pago en efectivo
	DECLARE Des_PagoIniArrenda		VARCHAR(50);		-- Pago de arrendamiento
	DECLARE Con_PagInicial			INT(11);			-- Concepto de Pago Inicial
	DECLARE Est_Autorizado			CHAR(1);			-- Estatus autorizado
	DECLARE Mov_PagoInicial			INT(11);			-- Movimiento de Pago Inicial
	DECLARE Var_ConcBancos			INT(11);			-- Concepto de movimientos de bancos del dia de la tabla CONCEPTOSCONTA
	DECLARE Var_ConcCaptacion		INT(11);			-- Concepto de cargo a cuenta de captacion de la tabla CONCEPTOSCONTA
	DECLARE Var_TipoPagContado		INT(11);			-- Tipo de pago de seguro y seguro de vida
	DECLARE Var_ConcEnganche		INT(11);			-- Concepto de Enganche de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConcIVAEnganche		INT(11);			-- Concepto de IVA del Enganche de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConcComApe			INT(11);			-- Concepto de Comision por Apertura de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConcIVAComApe		INT(11);			-- Concepto de IVA de Comision por Apertura de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConcOtrosGastos		INT(11);			-- Concepto de Otros Gastos de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConcIVAOtrGastos	INT(11);			-- Concepto de IVA de Otros Gastos de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConcRentasDep		INT(11);			-- Concepto de Rentas en Deposito de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConcIVARentasDep	INT(11);			-- Concepto de IVA de Rentas en Deposito de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConcSeg				INT(11);			-- Concepto de Seguro de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConcSegVida			INT(11);			-- Concepto de Seguro de Vida de la tabla CONCEPTOSARRENDA
	DECLARE Var_TipoInstruID		INT(11);			-- Tipo de Intrumento
	DECLARE Var_LlaveCtaCapta		VARCHAR(50);		-- Llave para tabla PARAMGENERALES
	DECLARE Var_RentAnticipaSI		CHAR(1);			-- Es renta anticipado Si= S
	DECLARE Var_RentAnticipaNo		CHAR(1);			-- Es renta anticipado No= N
	DECLARE Var_PrimeraRentas		CHAR(1);			-- Tipo de renta Adelnatada (Primera o Ultima)
	DECLARE Var_UltimasRentas		CHAR(1);			-- Tipo de renta Adelnatada (Primera o Ultima)
	DECLARE Var_ConRenAdelanta		INT(11);			-- Concepto de Rentas adelantadas de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConIVARenAdela		INT(11);			-- Concepto de IVA de rentas adelantas de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConRenAnticipa		INT(11);			-- Concepto de Renta Anticipada de la tabla CONCEPTOSARRENDA
	DECLARE Var_ConIVARenAntic		INT(11);			-- Concepto de IVA de Renta Anticipa de la tabla CONCEPTOSARRENDA
	DECLARE Con_PlazoCorto			CHAR(1);			-- Concepto plazo corto
	DECLARE Con_PlazoLargo			CHAR(1);			-- Concepto plazo largo

	DECLARE Est_Pagado				CHAR(1);			-- Estatus Pagado
	DECLARE Con_SegInmobiliario		INT(11);			-- Concepto del seguro
	DECLARE Con_SegVida				INT(11);			-- Concepto del seguro de vida
	DECLARE Con_IVASeguroVida		INT(11);			-- Concepto del IVA del seguro de vida
	DECLARE Con_IVASeguroInmob		INT(11);			-- Concepto del IVA del seguro
	DECLARE Con_IntVigente			INT(11);			-- Concepto del interes vigente
	DECLARE Con_CapVigente	  		INT(11);			-- Concepto del capital vigente
	DECLARE Con_IVACapital	  		INT(11);			-- Concepto del IVA del capital
	DECLARE Con_IVAInteres	  		INT(11);			-- Concepto del IVA del interes
	DECLARE Var_NO 					CHAR(1);			-- Variable no
	DECLARE Var_SI 					CHAR(1);			-- Variable si
	DECLARE Var_ConSobraPagIni		INT(11);			-- Concepto de sobrante de pago inicial
	DECLARE Var_PrimeraAmorti		INT(4);				-- Primera amortizacion del arrendamiento

	DECLARE Var_NomenclaturaCR		VARCHAR(3);			-- Nomenclatura de Centro de Costo
	DECLARE For_SucOrigen   		CHAR(3);			-- Nomenclatura CC &SO
	DECLARE	For_SucCliente			CHAR(3);			-- Nomenclatura CC &SC
	DECLARE Var_NomenclaturaSC		INT(11);
	DECLARE Var_NomenclaturaSO		INT(11);
	DECLARE Var_CentroCostosID		INT (11);			-- ID de Centro de Costos


	-- Declaracion del cursor
	DECLARE CURSORAMORTI CURSOR FOR
		SELECT	Amo.ArrendaID,			Amo.ArrendaAmortiID,		Amo.CapitalRenta,		Amo.InteresRenta,	Amo.Seguro,
				Amo.SeguroVida
			FROM ARRENDAAMORTI Amo
			INNER JOIN ARRENDAMIENTOS Arrenda ON Arrenda.ArrendaID = Amo.ArrendaID
			WHERE	Arrenda.ArrendaID	= Par_ArrendaID
			  AND	Amo.Estatus = Est_Pagado
			  AND	Arrenda.Estatus= Est_Autorizado
			ORDER BY Amo.ArrendaAmortiID;

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';						-- String Vacio
	SET	Fecha_Vacia					:= '1900-01-01'; 			-- Fecha Vacia
	SET	Entero_Cero					:= 0;						-- Entero en Cero
	SET	Decimal_Cero				:= 0.00;					-- Decimal Cero
	SET	Nat_Abono					:= 'A';						-- Naturaleza de Abono.
	SET	Nat_Cargo					:= 'C';						-- Naturaleza de Cargoo
	SET	Par_SalidaNO				:= 'N';						-- Ejecutar Store sin Regreso o Mensaje de Salida
	SET	Par_SalidaSI				:= 'S';						-- Ejecutar Store Con Regreso o Mensaje de Salida
	SET	AltaPoliza_NO				:= 'N';						-- Constante para poliza NO
	SET	AltaPolArrenda_SI			:= 'S';						-- Poliza SI
	SET	AltaMovsArrenda_SI			:= 'S';						-- Alta de movimientos SI
	SET	AltaMovsArrenda_NO			:= 'N';						-- Alta de movimientos NO
	SET Des_PagoIniArrenda			:= 'PAGO INICIAL';			-- Valor de descripcion pago inicial de arrendamiento
	SET	Con_MontoMin				:= 'MontoMinPago';			-- Valor concepto monto minimo
	SET	Con_PagEfectivo				:= 'E';						-- Valor pago efectivo
	SET	Con_PagInicial				:= 35;						-- Valor del pago inicial de la tabla CONCEPTOSARRENDA
	SET	Est_Autorizado				:= 'A';						-- Estatus autorizado.
	SET	Mov_PagoInicial				:= 51;						-- Valor del Pago Inicial de la tabla TIPOSMOVSARRENDA
	SET	Var_ConcBancos				:= 826;						-- Concepto de movimientos de bancos del dia de la tabla CONCEPTOSCONTA
	SET	Var_ConcCaptacion			:= 840;						-- Concepto de cargo a cuenta de captacion de la tabla CONCEPTOSCONTA
	SET	Var_TipoPagContado			:= 1;						-- Tipo de pago contado para seguro y seguro de vida
	SET Var_ConcEnganche			:= 37;						-- Concepto de Enganche de la tabla CONCEPTOSARRENDA
	SET Var_ConcIVAEnganche			:= 38;						-- Concepto de IVA del Enganche de la tabla CONCEPTOSARRENDA
	SET Var_ConcComApe				:= 39;						-- Concepto de Comision por Apertura de la tabla CONCEPTOSARRENDA
	SET Var_ConcIVAComApe			:= 40;						-- Concepto de IVA de Comision por Apertura de la tabla CONCEPTOSARRENDA
	SET Var_ConcOtrosGastos			:= 41;						-- Concepto de Otros Gastos de la tabla CONCEPTOSARRENDA
	SET Var_ConcIVAOtrGastos		:= 42;						-- Concepto de IVA de Otros Gastos de la tabla CONCEPTOSARRENDA
	SET Var_ConcRentasDep			:= 43;						-- Concepto de Rentas en Deposito de la tabla CONCEPTOSARRENDA
	SET Var_ConcIVARentasDep		:= 44;						-- Concepto de IVA de Rentas en Deposito de la tabla CONCEPTOSARRENDA
	SET Var_ConcSeg					:= 57;						-- Concepto de Seguro de la tabla CONCEPTOSARRENDA
	SET Var_ConcSegVida				:= 58;						-- Concepto de Seguro de Vida de la tabla CONCEPTOSARRENDA
	SET Var_TipoInstruID			:= 29;						-- Tipo Instrumento ARRENDAMIENTO. Tabla TIPOINSTRUMENTOS
	SET Var_LlaveCtaCapta			:= 'CtaCaptacionArrenda';	-- Llave para tabla PARAMGENERALES
	SET Var_RentAnticipaSI			:= 'S';						-- Renta Anticipada Si
	SET Var_RentAnticipaNo			:= 'N';						-- Renta Anticipada No
	SET Var_PrimeraRentas			:= 'P';						-- Primeras rentas
	SET Var_UltimasRentas			:= 'U';						-- Ultimas rentas
	SET Var_ConRenAdelanta			:= 63;						-- Concepto Rentas  Adelantadas
	SET Var_ConIVARenAdela			:= 64;						-- Concepto IVA de Rentas Adelantadas
	SET Var_ConRenAnticipa			:= 65;						-- Concepto Renta Antiipada
	SET Var_ConIVARenAntic			:= 66;						-- Concepto IVA de Renta Anticipada
	SET	Con_PlazoCorto				:= 'C';						-- Valor plazo corto
	SET	Con_PlazoLargo				:= 'L';						-- Valor plazo largo

	SET	Est_Pagado					:= 'P';						-- Estatus Pagado
	SET	Con_SegInmobiliario   		:= 57;						-- Valor del seguro de la tabla CONCEPTOSARRENDA
	SET	Con_SegVida					:= 58;						-- Valor del seguro de vida de la tabla CONCEPTOSARRENDA
	SET	Con_IVASeguroVida			:= 52;						-- Valor del IVA del seguro de vida de la tabla CONCEPTOSARRENDA
	SET	Con_IVASeguroInmob			:= 53;						-- Valor del IVA del seguro de la tabla CONCEPTOSARRENDA
	SET	Con_IVACapital	  			:= 48;						-- Valor del IVA del capital de la tabla CONCEPTOSARRENDA
	SET	Con_IVAInteres	  			:= 49;						-- Valor del IVA del interes de la tabla CONCEPTOSARRENDA
	SET	Con_CapVigente	  			:= 45;						-- Valor del capital vigente de la tabla CONCEPTOSARRENDA
	SET	Con_IntVigente				:= 59;						-- Valor del interes vigente de la tabla CONCEPTOSARRENDA
	SET Var_NO  					:= 'N';						-- Permite Salida NO
	SET Var_SI 						:= 'S';						-- Permite Salida SI
	SET Var_ConSobraPagIni			:= 74;						-- Concepto de sobrante por pago inicial
	SET Var_PrimeraAmorti			:= 1; 						-- primera amortizacion del arrendamiento

	SET	Var_Plazo					:= Con_PlazoCorto;			-- Concepto de plazo corto
	SET	Aud_ProgramaID				:= 'ARRPAGOINICIALPRO';		-- Valor del programa de auditoria que ejecuta

	SET For_SucOrigen				:= '&SO';
	SET	For_SucCliente				:= '&SC';
	SET Var_CentroCostosID			:= 0;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET	Par_NumErr	:= 999;
				SET	Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										  'Disculpe las molestias que esto le ocasiona. Ref: SP-ARRPAGOINICIALPRO');
				SET Var_Control = 'sqlException' ;
		END;

		SET	Var_Control			:= Cadena_Vacia;
		SET	Par_ErrMen			:= Cadena_Vacia;
		SET	Par_NumErr			:= Entero_Cero;
		SET Par_ArrendaID		:= IFNULL(Par_ArrendaID,Entero_Cero);
		SET Par_MontoPagar		:= IFNULL(Par_MontoPagar,Decimal_Cero);
		SET Par_ModoPago		:= IFNULL(Par_ModoPago,Cadena_Vacia);
		SET Par_Poliza			:= IFNULL(Par_Poliza,Entero_Cero);

		SELECT	FechaSistema
			INTO	Var_FechaSis
			FROM	PARAMETROSSIS;

		SELECT	ValorParametro
			INTO	Mon_MinPago
			FROM	PARAMGENERALES
			WHERE	LlaveParametro	= Con_MontoMin;

		SELECT	ValorParametro
			INTO	Var_Cuenta
			FROM	PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlaveCtaCapta;

		SET	Aud_FechaActual		:= NOW();

		-- Datos del arrendmiento
		SELECT		cli.SucursalOrigen,			arrenda.ClienteID,			pro.ProductoArrendaID,			arrenda.CantCuota,			arrenda.Estatus,
					arrenda.LineaArrendaID,		arrenda.TasaFijaAnual,		arrenda.MonedaID,				arrenda.FechaUltimoVen,		arrenda.SaldoSeguro,
					arrenda.SaldoSeguroVida,	arrenda.SaldoMoratorios,	arrenda.SaldComFaltPago,		arrenda.SaldoOtrasComis,	arrenda.TipoArrenda,
					arrenda.MontoEnganche,		arrenda.IVAEnganche,		arrenda.MontoComApe,			arrenda.IVAComApe,			arrenda.OtroGastos,
					arrenda.IVAOtrosGastos,		arrenda.CantRentaDepo,		arrenda.MontoDeposito,			arrenda.IVADeposito,		arrenda.TipoPagoSeguro,
					arrenda.MontoSeguroAnual,	arrenda.TipoPagoSeguroVida,	arrenda.MontoSeguroVidaAnual,
					IFNULL((arrenda.SaldoCapVigente+arrenda.SaldoCapAtrasad+arrenda.SaldoCapVencido),Decimal_Cero),
					IFNULL((arrenda.SaldoInteresVigent+arrenda.SaldoInteresAtras+arrenda.SaldoInteresVen),Decimal_Cero),
					arrenda.EsRenAnticipada,	arrenda.TipRenAdelanta,		arrenda.NumRenAdelantada,		arrenda.RentaAnticipada,	arrenda.IVARentaAnticipa,
					arrenda.RentasAdelantadas,	arrenda.IVARenAdelanta,		arrenda.TotalPagoInicial
			INTO	Var_SucCliente,				Var_ClienteID,				Var_ProdArrendaID,				Var_NumAmorti,				Var_EstatusArrenda,
					Var_LineaArrenda,			Var_TasaArrenda,			Var_MonedaID,					Var_FechaVen,				Var_SalSegArrenda,
					Var_SalSegVidaArr,			Var_SaldoMorArrenda,		Var_SalComFaltaPagA,			Var_SalComisArrenda,		Var_TipoArrenda,
					Var_MontoEnganche,			Var_IVAEnganche,			Var_MontoComApe,				Var_IVAComApe,				Var_OtroGastos,
					Var_IVAOtrosGastos,			Var_CantRentaDepo,			Var_MontoDeposito,				Var_IVADeposito,			Var_TipoPagoSeguro,
					Var_MontoSeguro,			Var_TipoPagoSegVida,		Var_MontoSegVida,
					Var_SalCapArrenda,
					Var_SaldoInteres,
					Var_EsRentaAnticip,			Var_TipRenAdelanta,			Var_NumRenAdelantada,			Var_RentaAnticipada,		Var_IVARenAnticipa,
					Var_RentAdelantadas,		Var_IVARenAdelanta,			Var_TotalPagoIni
			FROM	ARRENDAMIENTOS arrenda
			INNER	JOIN PRODUCTOARRENDA pro ON arrenda.ProductoArrendaID	= pro.ProductoArrendaID
			INNER	JOIN CLIENTES cli ON arrenda.ClienteID	= cli.ClienteID
			WHERE	arrenda.ArrendaID = Par_ArrendaID;

		-- Se setean valores para campos nulos
		SET Var_SucCliente			:= IFNULL(Var_SucCliente,Entero_Cero);
		SET Var_ClienteID			:= IFNULL(Var_ClienteID,Entero_Cero);
		SET Var_ProdArrendaID		:= IFNULL(Var_ProdArrendaID,Entero_Cero);
		SET Var_NumAmorti			:= IFNULL(Var_NumAmorti,Entero_Cero);
		SET Var_EstatusArrenda		:= IFNULL(Var_EstatusArrenda,Cadena_Vacia);
		SET Var_LineaArrenda		:= IFNULL(Var_LineaArrenda,Entero_Cero);
		SET Var_TasaArrenda			:= IFNULL(Var_TasaArrenda,Decimal_Cero);
		SET Var_MonedaID			:= IFNULL(Var_MonedaID,Entero_Cero);
		SET Var_FechaVen			:= IFNULL(Var_FechaVen,Fecha_Vacia);
		SET Var_SalSegArrenda		:= IFNULL(Var_SalSegArrenda,Decimal_Cero);
		SET Var_SalSegVidaArr		:= IFNULL(Var_SalSegVidaArr,Decimal_Cero);
		SET Var_SaldoMorArrenda		:= IFNULL(Var_SaldoMorArrenda,Decimal_Cero);
		SET Var_SalComFaltaPagA		:= IFNULL(Var_SalComFaltaPagA,Decimal_Cero);
		SET Var_SalComisArrenda		:= IFNULL(Var_SalComisArrenda,Decimal_Cero);
		SET Var_TipoArrenda			:= IFNULL(Var_TipoArrenda,Cadena_Vacia);
		SET Var_MontoEnganche		:= IFNULL(Var_MontoEnganche,Decimal_Cero);
		SET Var_IVAEnganche			:= IFNULL(Var_IVAEnganche,Decimal_Cero);
		SET Var_MontoComApe			:= IFNULL(Var_MontoComApe,Decimal_Cero);
		SET Var_IVAComApe			:= IFNULL(Var_IVAComApe,Decimal_Cero);
		SET Var_OtroGastos			:= IFNULL(Var_OtroGastos,Decimal_Cero);
		SET Var_IVAOtrosGastos		:= IFNULL(Var_IVAOtrosGastos,Decimal_Cero);
		SET Var_CantRentaDepo		:= IFNULL(Var_CantRentaDepo,Entero_Cero);
		SET Var_MontoDeposito		:= IFNULL(Var_MontoDeposito,Decimal_Cero);
		SET Var_IVADeposito			:= IFNULL(Var_IVADeposito,Decimal_Cero);
		SET Var_TipoPagoSeguro		:= IFNULL(Var_TipoPagoSeguro,Entero_Cero);
		SET Var_MontoSeguro			:= IFNULL(Var_MontoSeguro,Decimal_Cero);
		SET Var_TipoPagoSegVida		:= IFNULL(Var_TipoPagoSegVida,Entero_Cero);
		SET Var_MontoSegVida		:= IFNULL(Var_MontoSegVida,Decimal_Cero);
		SET Var_SalCapArrenda		:= IFNULL(Var_SalCapArrenda,Decimal_Cero);
		SET Var_SaldoInteres		:= IFNULL(Var_SaldoInteres,Decimal_Cero);
		SET Var_EsRentaAnticip		:= IFNULL(Var_EsRentaAnticip,Var_RentAnticipaNo);
		SET Var_TipRenAdelanta		:= IFNULL(Var_TipRenAdelanta,Var_PrimeraRentas);
		SET Var_NumRenAdelantada	:= IFNULL(Var_NumRenAdelantada,Entero_Cero);
		SET Var_RentaAnticipada		:= IFNULL(Var_RentaAnticipada,Decimal_Cero);
		SET Var_IVARenAnticipa		:= IFNULL(Var_IVARenAnticipa,Decimal_Cero);
		SET Var_RentAdelantadas		:= IFNULL(Var_RentAdelantadas,Decimal_Cero);
		SET Var_IVARenAdelanta		:= IFNULL(Var_IVARenAdelanta,Decimal_Cero);

		SELECT	IVA
			INTO	Var_IVASucurs
			FROM	SUCURSALES
			WHERE	SucursalID	= Var_SucCliente;

		SET	Var_IVASucurs	:= IFNULL(Var_IVASucurs, Decimal_Cero);

		SELECT PagaIVA INTO Var_CtePagIva   FROM CLIENTES  WHERE ClienteID = Var_ClienteID;

		IF(IFNULL(Var_CtePagIva, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Var_CtePagIva	:= Var_SI;
		END IF;

		IF (Var_CtePagIva = Var_NO) THEN
			SET Var_IVASucurs	:= Decimal_Cero;
		END IF;


		CALL DIASFESTIVOSCAL(
			Var_FechaSis,		Entero_Cero,		Var_FecAplicacion,		Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

	-- ----------------------- PAGO INICIAL SOLO PARA ARRENDAMIENTOS AUTORIZADOS ------------------------------------------
		IF(Var_EstatusArrenda = Est_Autorizado) THEN
			IF(Par_MontoPagar	>= Mon_MinPago) THEN
			SELECT	Descripcion
					INTO	Var_RefePoliza
					FROM	CONCEPTOSARRENDA
					WHERE	ConceptoArrendaID	= Con_PagInicial;

			SELECT	NomenclaturaCR
					INTO	Var_NomenclaturaCR
					FROM	CUENTASMAYORARRENDA
					WHERE	ConceptoArrendaID	= Con_PagInicial;

			IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
				SET Var_NomenclaturaSO := Aud_Sucursal;
				IF (Var_NomenclaturaSO != Entero_Cero) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
				END IF;
			ELSE
				IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
					SET Var_NomenclaturaSC := Var_SucCliente;
					IF (Var_NomenclaturaSC != Entero_Cero ) THEN
						SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
					ELSE
						SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
					END IF;
				ELSE
					SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
				END IF;
			END IF;

				-- Movimientos de contabilidad para el total del pago inicial
				-- Abono a cartera
				CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_PagInicial,
										Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
										Var_RefePoliza,		Par_MontoPagar,			AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
										AltaMovsArrenda_SI,	Con_PagInicial,			Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
										Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
										Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				-- Cargo a cuenta de captacion
				CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
										Par_ArrendaID,		Var_MonedaID,		Par_MontoPagar,		Decimal_Cero,	Des_PagoIniArrenda,
										Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
										Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

				-- Movimientos de contabilidad para el desglose del pago inicial
				SELECT	Descripcion
					INTO	Var_RefePoliza
					FROM	CONCEPTOSARRENDA
					WHERE	ConceptoArrendaID	= Var_ConcEnganche;

				SELECT	NomenclaturaCR
					INTO	Var_NomenclaturaCR
					FROM	CUENTASMAYORARRENDA
					WHERE	ConceptoArrendaID	= Var_ConcEnganche;

				IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
					SET Var_NomenclaturaSO := Aud_Sucursal;
					IF (Var_NomenclaturaSO != Entero_Cero) THEN
						SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
					END IF;
				ELSE
					IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSC := Var_SucCliente;
						IF (Var_NomenclaturaSC != Entero_Cero ) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					ELSE
						SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
					END IF;
				END IF;

				-- Enganche
				-- Abono a cartera
				CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConcEnganche,
										Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
										Var_RefePoliza,		Var_MontoEnganche,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
										AltaMovsArrenda_SI,	Var_ConcEnganche,		Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
										Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
										Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				-- Cargo a cuenta de captacion
				CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
										Par_ArrendaID,		Var_MonedaID,		Var_MontoEnganche,	Decimal_Cero,	Des_PagoIniArrenda,
										Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
										Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

				SELECT	Descripcion
					INTO	Var_RefePoliza
					FROM	CONCEPTOSARRENDA
					WHERE	ConceptoArrendaID	= Var_ConcIVAEnganche;

				SELECT	NomenclaturaCR
					INTO	Var_NomenclaturaCR
					FROM	CUENTASMAYORARRENDA
					WHERE	ConceptoArrendaID	= Var_ConcIVAEnganche;

				IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
					SET Var_NomenclaturaSO := Aud_Sucursal;
					IF (Var_NomenclaturaSO != Entero_Cero) THEN
						SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
					END IF;
				ELSE
					IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSC := Var_SucCliente;
						IF (Var_NomenclaturaSC != Entero_Cero ) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					ELSE
						SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
					END IF;
				END IF;

				-- IVA del enganche
				-- Abono a cartera
				CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConcIVAEnganche,
										Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
										Var_RefePoliza,		Var_IVAEnganche,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
										AltaMovsArrenda_SI,	Var_ConcIVAEnganche,	Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
										Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
										Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				-- Cargo a cuenta de captacion
				CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
										Par_ArrendaID,		Var_MonedaID,		Var_IVAEnganche,	Decimal_Cero,	Des_PagoIniArrenda,
										Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
										Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

				-- Monto de comision por apertura e IVA, si son mayores que el monto minimo
				IF (Var_IVAComApe >= Mon_MinPago) THEN
					SELECT	Descripcion
						INTO	Var_RefePoliza
						FROM	CONCEPTOSARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcComApe;

					SELECT	NomenclaturaCR
						INTO	Var_NomenclaturaCR
						FROM	CUENTASMAYORARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcComApe;

					IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSO := Aud_Sucursal;
						IF (Var_NomenclaturaSO != Entero_Cero) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
						END IF;
					ELSE
						IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
							SET Var_NomenclaturaSC := Var_SucCliente;
							IF (Var_NomenclaturaSC != Entero_Cero ) THEN
								SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF;
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					END IF;

					-- Monto de comision por apertura
					-- Abono a cartera
					CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConcComApe,
											Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
											Var_RefePoliza,		Var_MontoComApe,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
											AltaMovsArrenda_SI,	Var_ConcComApe,			Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
											Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
											Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					-- Cargo a cuenta de captacion
					CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
											Par_ArrendaID,		Var_MonedaID,		Var_MontoComApe,	Decimal_Cero,	Des_PagoIniArrenda,
											Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
											Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

					SELECT	Descripcion
						INTO	Var_RefePoliza
						FROM	CONCEPTOSARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcIVAComApe;

					SELECT	NomenclaturaCR
						INTO	Var_NomenclaturaCR
						FROM	CUENTASMAYORARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcIVAComApe;

					IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSO := Aud_Sucursal;
						IF (Var_NomenclaturaSO != Entero_Cero) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
						END IF;
					ELSE
						IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
							SET Var_NomenclaturaSC := Var_SucCliente;
							IF (Var_NomenclaturaSC != Entero_Cero ) THEN
								SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF;
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					END IF;

					-- IVA del monto de comision por apertura
					-- Abono a cartera
					CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConcIVAComApe,
											Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
											Var_RefePoliza,		Var_IVAComApe,			AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
											AltaMovsArrenda_SI,	Var_ConcIVAComApe,		Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
											Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
											Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					-- Cargo a cuenta de captacion
					CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
											Par_ArrendaID,		Var_MonedaID,		Var_IVAComApe,		Decimal_Cero,	Des_PagoIniArrenda,
											Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
											Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				END IF;

				-- Otros gastos e IVA de otros gastos, si son mayores que el monto minimo
				IF (Var_IVAOtrosGastos >= Mon_MinPago) THEN
					SELECT	Descripcion
						INTO	Var_RefePoliza
						FROM	CONCEPTOSARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcOtrosGastos;

					SELECT	NomenclaturaCR
						INTO	Var_NomenclaturaCR
						FROM	CUENTASMAYORARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcOtrosGastos;

					IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSO := Aud_Sucursal;
						IF (Var_NomenclaturaSO != Entero_Cero) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
						END IF;
					ELSE
						IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
							SET Var_NomenclaturaSC := Var_SucCliente;
							IF (Var_NomenclaturaSC != Entero_Cero ) THEN
								SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF;
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					END IF;

					-- Otros gastos
					-- Abono a cartera
					CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConcOtrosGastos,
											Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
											Var_RefePoliza,		Var_OtroGastos,			AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
											AltaMovsArrenda_SI,	Var_ConcOtrosGastos,	Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
											Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
											Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					-- Cargo a cuenta de captacion
					CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
											Par_ArrendaID,		Var_MonedaID,		Var_OtroGastos,		Decimal_Cero,	Des_PagoIniArrenda,
											Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
											Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

					SELECT	Descripcion
						INTO	Var_RefePoliza
						FROM	CONCEPTOSARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcIVAOtrGastos;

					SELECT	NomenclaturaCR
						INTO	Var_NomenclaturaCR
						FROM	CUENTASMAYORARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcIVAOtrGastos;

					IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSO := Aud_Sucursal;
						IF (Var_NomenclaturaSO != Entero_Cero) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
						END IF;
					ELSE
						IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
							SET Var_NomenclaturaSC := Var_SucCliente;
							IF (Var_NomenclaturaSC != Entero_Cero ) THEN
								SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF;
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					END IF;

					-- IVA de otros gastos
					-- Abono a cartera
					CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConcIVAOtrGastos,
											Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
											Var_RefePoliza,		Var_IVAOtrosGastos,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
											AltaMovsArrenda_SI,	Var_ConcIVAOtrGastos,	Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
											Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
											Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					-- Cargo a cuenta de captacion
					CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
											Par_ArrendaID,		Var_MonedaID,		Var_IVAOtrosGastos,	Decimal_Cero,	Des_PagoIniArrenda,
											Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
											Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				END IF;

				-- Monto e IVA de rentas en deposito si existen rentas
				IF (Var_CantRentaDepo >= Entero_Cero AND Var_IVADeposito >= Mon_MinPago) THEN
					SELECT	Descripcion
						INTO	Var_RefePoliza
						FROM	CONCEPTOSARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcRentasDep;

					SELECT	NomenclaturaCR
						INTO	Var_NomenclaturaCR
						FROM	CUENTASMAYORARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcRentasDep;

					IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSO := Aud_Sucursal;
						IF (Var_NomenclaturaSO != Entero_Cero) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
						END IF;
					ELSE
						IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
							SET Var_NomenclaturaSC := Var_SucCliente;
							IF (Var_NomenclaturaSC != Entero_Cero ) THEN
								SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF;
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					END IF;

					-- Monto de rentas en deposito
					-- Abono a cartera
					CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConcRentasDep,
											Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
											Var_RefePoliza,		Var_MontoDeposito,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
											AltaMovsArrenda_SI,	Var_ConcRentasDep,		Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
											Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
											Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					-- Cargo a cuenta de captacion
					CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
											Par_ArrendaID,		Var_MonedaID,		Var_MontoDeposito,	Decimal_Cero,	Des_PagoIniArrenda,
											Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
											Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

					SELECT	Descripcion
						INTO	Var_RefePoliza
						FROM	CONCEPTOSARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcIVARentasDep;

					SELECT	NomenclaturaCR
						INTO	Var_NomenclaturaCR
						FROM	CUENTASMAYORARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcIVARentasDep;

					IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSO := Aud_Sucursal;
						IF (Var_NomenclaturaSO != Entero_Cero) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
						END IF;
					ELSE
						IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
							SET Var_NomenclaturaSC := Var_SucCliente;
							IF (Var_NomenclaturaSC != Entero_Cero ) THEN
								SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF;
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					END IF;

					-- IVA de rentas en deposito
					-- Abono a cartera
					CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConcIVARentasDep,
											Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
											Var_RefePoliza,		Var_IVADeposito,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
											AltaMovsArrenda_SI,	Var_ConcIVARentasDep,	Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
											Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
											Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					-- Cargo a cuenta de captacion
					CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
											Par_ArrendaID,		Var_MonedaID,		Var_IVADeposito,	Decimal_Cero,	Des_PagoIniArrenda,
											Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
											Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				END IF;

				-- Monto del seguro (Si el tipo de pago es contado)
				IF (Var_TipoPagoSeguro = Var_TipoPagContado AND Var_MontoSeguro >= Mon_MinPago) THEN
					SELECT	Descripcion
						INTO	Var_RefePoliza
						FROM	CONCEPTOSARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcSeg;

					SELECT	NomenclaturaCR
						INTO	Var_NomenclaturaCR
						FROM	CUENTASMAYORARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcSeg;

					IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSO := Aud_Sucursal;
						IF (Var_NomenclaturaSO != Entero_Cero) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
						END IF;
					ELSE
						IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
							SET Var_NomenclaturaSC := Var_SucCliente;
							IF (Var_NomenclaturaSC != Entero_Cero ) THEN
								SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF;
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					END IF;

					-- Abono a cartera
					CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConcSeg,
											Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
											Var_RefePoliza,		Var_MontoSeguro,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
											AltaMovsArrenda_SI,	Var_ConcSeg,			Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
											Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
											Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					-- Cargo a cuenta de captacion
					CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
											Par_ArrendaID,		Var_MonedaID,		Var_MontoSeguro,	Decimal_Cero,	Des_PagoIniArrenda,
											Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
											Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				END IF;

				-- Monto del seguro de vida (Si el tipo de pago es contado)
				IF (Var_TipoPagoSegVida = Var_TipoPagContado AND Var_MontoSegVida >= Mon_MinPago) THEN
					SELECT	Descripcion
						INTO	Var_RefePoliza
						FROM	CONCEPTOSARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcSegVida;

					SELECT	NomenclaturaCR
						INTO	Var_NomenclaturaCR
						FROM	CUENTASMAYORARRENDA
						WHERE	ConceptoArrendaID	= Var_ConcSegVida;

					IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSO := Aud_Sucursal;
						IF (Var_NomenclaturaSO != Entero_Cero) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
						END IF;
					ELSE
						IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
							SET Var_NomenclaturaSC := Var_SucCliente;
							IF (Var_NomenclaturaSC != Entero_Cero ) THEN
								SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF;
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					END IF;

					-- Abono a cartera
					CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConcSegVida,
											Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
											Var_RefePoliza,		Var_MontoSegVida,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
											AltaMovsArrenda_SI,	Var_ConcSegVida,		Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
											Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
											Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					-- Cargo a cuenta de captacion
					CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
											Par_ArrendaID,		Var_MonedaID,		Var_MontoSegVida,	Decimal_Cero,	Des_PagoIniArrenda,
											Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
											Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				END IF;

				-- *********************************************** Rentas adelantadas y Renta Anticipada. ***************************************
				-- El Arrendamiento  tiene Renta Anticipa (S=Si) o Rentas adelantadas.  Cardinal: 4/dic/2017
				IF ((Var_EsRentaAnticip = Var_RentAnticipaSI) || (Var_NumRenAdelantada >0)) THEN
					OPEN CURSORAMORTI;
					BEGIN
						DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
						CICLO:LOOP

						FETCH CURSORAMORTI INTO
							 Var_ArrendaID,		Var_ArrendaAmortiID,	Var_CapitalRenta,	Var_InteresRenta,	 Var_Seguro,
							 Var_SeguroVida;
						-- inicia ciclo
							-- Inicializaciones
							SET Par_NumErr			:= Entero_Cero;
							SET Par_ErrMen			:= Cadena_Vacia;
							SET Par_Consecutivo		:= Entero_Cero;
							SET Var_IVASeguro		:= Decimal_Cero;
							SET Var_IVASeguroVida	:= Decimal_Cero;
							SET Var_IVACapital		:= Decimal_Cero;
							SET Var_IVAInteres		:= Decimal_Cero;
							SET Var_RefePoliza 		:= Cadena_Vacia;

							-- --------------- Seguro
							IF ((Var_Seguro	>= Mon_MinPago)) THEN
								SET	Var_IVASeguro	= ROUND((Var_Seguro *  Var_IVASucurs), 2);
								SELECT	Descripcion
									INTO	Var_RefePoliza
									FROM	CONCEPTOSARRENDA
									WHERE	ConceptoArrendaID	= Con_SegInmobiliario;

								SELECT	NomenclaturaCR
									INTO	Var_NomenclaturaCR
									FROM	CUENTASMAYORARRENDA
									WHERE	ConceptoArrendaID	= Con_SegInmobiliario;

								IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
									SET Var_NomenclaturaSO := Aud_Sucursal;
									IF (Var_NomenclaturaSO != Entero_Cero) THEN
										SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
									END IF;
								ELSE
									IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
										SET Var_NomenclaturaSC := Var_SucCliente;
										IF (Var_NomenclaturaSC != Entero_Cero ) THEN
											SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
										ELSE
											SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
										END IF;
									ELSE
										SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
									END IF;
								END IF;

								CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_SegInmobiliario,
														Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
														Var_RefePoliza,		Var_Seguro,				AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
														AltaMovsArrenda_SI,	Con_SegInmobiliario,	Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
														Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
														Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
														Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

								CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
														Par_ArrendaID,		Var_MonedaID,		Var_Seguro,	Decimal_Cero,	Des_PagoIniArrenda,
														Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
														Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
														Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


								IF (Var_IVASeguro	>= Mon_MinPago)THEN
									SELECT	Descripcion
										INTO	Var_RefePoliza
										FROM	CONCEPTOSARRENDA
										WHERE	ConceptoArrendaID	= Con_IVASeguroInmob;

									SELECT	NomenclaturaCR
										INTO	Var_NomenclaturaCR
										FROM	CUENTASMAYORARRENDA
										WHERE	ConceptoArrendaID	= Con_IVASeguroInmob;

									IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
										SET Var_NomenclaturaSO := Aud_Sucursal;
										IF (Var_NomenclaturaSO != Entero_Cero) THEN
											SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
										END IF;
									ELSE
										IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
											SET Var_NomenclaturaSC := Var_SucCliente;
											IF (Var_NomenclaturaSC != Entero_Cero ) THEN
												SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
											ELSE
												SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
											END IF;
										ELSE
											SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
										END IF;
									END IF;

									CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVASeguroInmob,
															Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
															Var_RefePoliza,		Var_IVASeguro,			AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
															AltaMovsArrenda_SI,	Con_IVASeguroInmob,		Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
															Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
															Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
															Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

									CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
															Par_ArrendaID,		Var_MonedaID,		Var_IVASeguro,		Decimal_Cero,	Des_PagoIniArrenda,
															Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
															Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
															Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
								END IF;
							END IF;
							-- ----------------Seguro

							-- --------------- Seguro Vida
							IF ((Var_SeguroVida	>= Mon_MinPago)) THEN
								SET	Var_IVASeguroVida	= ROUND((Var_SeguroVida *  Var_IVASucurs), 2);
								SELECT	Descripcion
									INTO	Var_RefePoliza
									FROM	CONCEPTOSARRENDA
									WHERE	ConceptoArrendaID	= Con_SegVida;

								SELECT	NomenclaturaCR
									INTO	Var_NomenclaturaCR
									FROM	CUENTASMAYORARRENDA
									WHERE	ConceptoArrendaID	= Con_ComFalPag;

								IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
									SET Var_NomenclaturaSO := Aud_Sucursal;
									IF (Var_NomenclaturaSO != Entero_Cero) THEN
										SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
									END IF;
								ELSE
									IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
										SET Var_NomenclaturaSC := Var_SucCliente;
										IF (Var_NomenclaturaSC != Entero_Cero ) THEN
											SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
										ELSE
											SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
										END IF;
									ELSE
										SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
									END IF;
								END IF;

								CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_SegVida,
														Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
														Var_RefePoliza,		Var_SeguroVida,			AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
														AltaMovsArrenda_SI,	Con_SegVida,			Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
														Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
														Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
														Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

								CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
														Par_ArrendaID,		Var_MonedaID,		Var_SeguroVida,		Decimal_Cero,	Des_PagoIniArrenda,
														Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
														Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
														Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


								IF (Var_IVASeguroVida	>= Mon_MinPago)THEN
									SELECT	Descripcion
										INTO	Var_RefePoliza
										FROM	CONCEPTOSARRENDA
										WHERE	ConceptoArrendaID	= Con_IVASeguroVida;

									SELECT	NomenclaturaCR
										INTO	Var_NomenclaturaCR
										FROM	CUENTASMAYORARRENDA
										WHERE	ConceptoArrendaID	= Con_IVASeguroVida;

									IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
										SET Var_NomenclaturaSO := Aud_Sucursal;
										IF (Var_NomenclaturaSO != Entero_Cero) THEN
											SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
										END IF;
									ELSE
										IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
											SET Var_NomenclaturaSC := Var_SucCliente;
											IF (Var_NomenclaturaSC != Entero_Cero ) THEN
												SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
											ELSE
												SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
											END IF;
										ELSE
											SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
										END IF;
									END IF;

									CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVASeguroVida,
															Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
															Var_RefePoliza,		Var_IVASeguroVida,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
															AltaMovsArrenda_SI,	Con_IVASeguroVida,		Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
															Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
															Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
															Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

									CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
															Par_ArrendaID,		Var_MonedaID,		Var_IVASeguroVida,	Decimal_Cero,	Des_PagoIniArrenda,
															Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
															Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
															Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
								END IF;
							END IF;
							-- ----------------Seguro Vida

							-- --------------- Interes Captal
							IF (Var_InteresRenta	>= Mon_MinPago) THEN
								SET	Var_IVAInteres	= ROUND((Var_InteresRenta *  Var_IVASucurs), 2);
								SELECT	Descripcion
									INTO	Var_RefePoliza
									FROM	CONCEPTOSARRENDA
									WHERE	ConceptoArrendaID	= Con_IntVigente;

								SELECT	NomenclaturaCR
									INTO	Var_NomenclaturaCR
									FROM	CUENTASMAYORARRENDA
									WHERE	ConceptoArrendaID	= Con_IntVigente;

								IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
									SET Var_NomenclaturaSO := Aud_Sucursal;
									IF (Var_NomenclaturaSO != Entero_Cero) THEN
										SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
									END IF;
								ELSE
									IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
										SET Var_NomenclaturaSC := Var_SucCliente;
										IF (Var_NomenclaturaSC != Entero_Cero ) THEN
											SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
										ELSE
											SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
										END IF;
									ELSE
										SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
									END IF;
								END IF;

								CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IntVigente,
														Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
														Var_RefePoliza,		Var_InteresRenta,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
														AltaMovsArrenda_SI,	Con_IntVigente,			Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
														Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
														Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
														Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

								CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
														Par_ArrendaID,		Var_MonedaID,		Var_InteresRenta,	Decimal_Cero,	Des_PagoIniArrenda,
														Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
														Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
														Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


								IF (Var_IVAInteres	>= Mon_MinPago)THEN
									SELECT	Descripcion
										INTO	Var_RefePoliza
										FROM	CONCEPTOSARRENDA
										WHERE	ConceptoArrendaID	= Con_IVAInteres;

									SELECT	NomenclaturaCR
										INTO	Var_NomenclaturaCR
										FROM	CUENTASMAYORARRENDA
										WHERE	ConceptoArrendaID	= Con_IVAInteres;

									IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
										SET Var_NomenclaturaSO := Aud_Sucursal;
										IF (Var_NomenclaturaSO != Entero_Cero) THEN
											SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
										END IF;
									ELSE
										IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
											SET Var_NomenclaturaSC := Var_SucCliente;
											IF (Var_NomenclaturaSC != Entero_Cero ) THEN
												SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
											ELSE
												SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
											END IF;
										ELSE
											SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
										END IF;
									END IF;

									CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVAInteres,
															Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
															Var_RefePoliza,		Var_IVAInteres,			AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
															AltaMovsArrenda_SI,	Con_IVAInteres,			Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
															Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
															Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
															Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

									CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
															Par_ArrendaID,		Var_MonedaID,		Var_IVAInteres,		Decimal_Cero,	Des_PagoIniArrenda,
															Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
															Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
															Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
								END IF;
							END IF;
							-- ---------------- Interes Capital

							-- --------------- Captal
							IF (Var_CapitalRenta	>= Mon_MinPago) THEN
								SET	Var_IVACapital	= ROUND((Var_CapitalRenta *  Var_IVASucurs), 2);
								SELECT	Descripcion
									INTO	Var_RefePoliza
									FROM	CONCEPTOSARRENDA
									WHERE	ConceptoArrendaID	= Con_CapVigente;

								SELECT	NomenclaturaCR
									INTO	Var_NomenclaturaCR
									FROM	CUENTASMAYORARRENDA
									WHERE	ConceptoArrendaID	= Con_CapVigente;

								IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
									SET Var_NomenclaturaSO := Aud_Sucursal;
									IF (Var_NomenclaturaSO != Entero_Cero) THEN
										SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
									END IF;
								ELSE
									IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
										SET Var_NomenclaturaSC := Var_SucCliente;
										IF (Var_NomenclaturaSC != Entero_Cero ) THEN
											SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
										ELSE
											SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
										END IF;
									ELSE
										SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
									END IF;
								END IF;

								CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_CapVigente,
														Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
														Var_RefePoliza,		Var_CapitalRenta,		AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
														AltaMovsArrenda_SI,	Con_CapVigente,			Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
														Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
														Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
														Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

								CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
														Par_ArrendaID,		Var_MonedaID,		Var_CapitalRenta,	Decimal_Cero,	Des_PagoIniArrenda,
														Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
														Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
														Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


								IF (Var_IVACapital	>= Mon_MinPago)THEN
									SELECT	Descripcion
										INTO	Var_RefePoliza
										FROM	CONCEPTOSARRENDA
										WHERE	ConceptoArrendaID	= Con_IVACapital;

									SELECT	NomenclaturaCR
										INTO	Var_NomenclaturaCR
										FROM	CUENTASMAYORARRENDA
										WHERE	ConceptoArrendaID	= Con_IVACapital;

									IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
										SET Var_NomenclaturaSO := Aud_Sucursal;
										IF (Var_NomenclaturaSO != Entero_Cero) THEN
											SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
										END IF;
									ELSE
										IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
											SET Var_NomenclaturaSC := Var_SucCliente;
											IF (Var_NomenclaturaSC != Entero_Cero ) THEN
												SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
											ELSE
												SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
											END IF;
										ELSE
											SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
										END IF;
									END IF;

									CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Con_IVACapital,
															Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
															Var_RefePoliza,		Var_IVACapital,			AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
															AltaMovsArrenda_SI,	Con_IVACapital,			Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
															Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
															Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
															Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

									CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
															Par_ArrendaID,		Var_MonedaID,		Var_IVACapital,		Decimal_Cero,	Des_PagoIniArrenda,
															Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
															Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
															Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
								END IF;
							END IF;
							-- ---------------- Capital

						-- fin del ciclo
						END LOOP CICLO;
					END;
					CLOSE CURSORAMORTI;


				END IF;

				-- *********************************************** Rentas adelantadas y Renta Anticipada. ***************************************

				-- Diferencia o Sobrante despues de que se aplica el pago inicial(Monto a pagar - Pago Inicial)
				SET Var_Diferencia := ROUND((Par_MontoPagar - Var_TotalPagoIni),2);
				IF(Var_Diferencia >= Mon_MinPago) THEN
					SELECT	Descripcion
					  INTO	Var_RefePoliza
						FROM	CONCEPTOSARRENDA
						WHERE	ConceptoArrendaID	= Var_ConSobraPagIni;

					SELECT	NomenclaturaCR
						INTO	Var_NomenclaturaCR
						FROM	CUENTASMAYORARRENDA
						WHERE	ConceptoArrendaID	= Var_ConSobraPagIni;

					IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
						SET Var_NomenclaturaSO := Aud_Sucursal;
						IF (Var_NomenclaturaSO != Entero_Cero) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
						END IF;
					ELSE
						IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
							SET Var_NomenclaturaSC := Var_SucCliente;
							IF (Var_NomenclaturaSC != Entero_Cero ) THEN
								SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF;
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					END IF;
					-- Abono a cartera
					CALL CONTAARRENDAPRO (	Var_FechaSis,		Var_FecAplicacion,		Var_TipoArrenda,		Var_ProdArrendaID,	Var_ConSobraPagIni,
											Par_ArrendaID,		Entero_Cero,			Var_ClienteID,			Var_MonedaID,		Des_PagoIniArrenda,
											Var_RefePoliza,		Var_Diferencia,			AltaPoliza_NO,			Var_ConcBancos,		AltaPolArrenda_SI,
											AltaMovsArrenda_SI,	Var_ConSobraPagIni,		Mov_PagoInicial,		Nat_Abono,			Par_ModoPago,
											Var_Plazo,			Var_SucCliente,			Aud_NumTransaccion,		Par_Salida,			Par_Poliza,
											Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					-- Cargo a cuenta de captacion
					CALL DETALLEPOLIZAALT(	Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion,	Var_CentroCostosID,	Var_Cuenta,
											Par_ArrendaID,		Var_MonedaID,		Var_Diferencia,		Decimal_Cero,	Des_PagoIniArrenda,
											Var_RefePoliza,		Aud_ProgramaID,		Var_TipoInstruID,	Cadena_Vacia,	Entero_Cero,
											Cadena_Vacia,		Par_Salida,			Par_NumErr,			Par_ErrMen,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				END IF; -- si hay algun sobrante se va una cuenta de captacion
			END IF;
		END IF;

		SET Par_NumErr		:= '000';
		SET Par_ErrMen		:= 'Pago Aplicado Exitosamente';
		SET Var_Control		:= 'arrendamientoID';
	END ManejoErrores;

	IF (Par_Salida	= Par_SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$