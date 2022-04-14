-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAINTERMORACOMARRENDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERAINTERMORACOMARRENDAPRO`;
DELIMITER $$


CREATE PROCEDURE `GENERAINTERMORACOMARRENDAPRO`(
# =====================================================================================
# -- STORED PROCEDURE PARA EL CALCULO DE INTERESES MORATORIOS, COMISIONES,
# -- TRASPASO A CARTERA VENCIDO PARA LAS AMORTIZACIONES DE ARRENDAMIENTOS
# -- Y CAMBIO DE COLUMNAS DEL SALDO CAPITAL Y SALDO INTERES PARA LOS CASOS DE VIGENTE A VENCIDO, DE VIGENTE A ATRASADO Y DE ATRASADO A VENCIDO.
# =====================================================================================
	Par_Fecha				DATE,				-- Fecha del proceso de calculo para moratorios, comisiones, cambio de estatus, saldo capital e interes capital.

	Par_Salida				CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr		INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(100);	-- Variable de control
	DECLARE Var_ArrendaID			BIGINT(12);		-- ID del arrendamiento
	DECLARE Var_ArrendaAmortiID		INT(4);			-- ID de la amortizacion
	DECLARE Var_ClienteID			INT(11);		-- ID del cliente

	DECLARE Var_ProducArrendaID		INT(4);			-- ID del producto
	DECLARE Var_TipoArrenda			CHAR(1);		-- Tipo de arrendamiento
	DECLARE Var_FechaInicio			DATE;			-- Fecha de inicio de la amortizacion
	DECLARE Var_FechaVencim			DATE;			-- Fecha de vencimiento de la amortizacion
	DECLARE Var_FechaExigible		DATE;			-- Fecha exigible

	DECLARE Var_EstatusAmorti		CHAR(1);		-- Estatus de la amortizacion
	DECLARE Var_FactorMora			DECIMAL(14,2);	-- Factor Moratorio
	DECLARE Var_FacMoratorio		DECIMAL(14,2);	-- Factor Moratorio dependiendo del tipo de cobo T o N
	DECLARE Var_TasaFijaAnual		DECIMAL(5,2);	-- Tasa Fija Anual
	DECLARE Var_TipCobComMorato		CHAR(1);		-- Tipo de Cobro por comision de moratorio (N/T)
	DECLARE Var_EstatusArrenda		CHAR(1);		-- Estatus del arrendamiento

	DECLARE Var_SaldoMoratorios		DECIMAL(14,4);	-- Saldo por Moratorios
	DECLARE Var_SaldoCapital		DECIMAL(14,4);	-- Saldo capital actual
	DECLARE Var_SaldoInteres		DECIMAL(14,4);	-- Saldo de intereses actuales
	DECLARE Var_DiasVencimiento		INT(11);		-- Dias de vencimiento del arrendamiento (couta mas antigua)
	DECLARE Var_SaldComFaltPago		DECIMAL(14,4);	-- Saldo por comisiones por falta de pago

	DECLARE Var_CobFaltaPago		CHAR(1);		-- Variable para saber si cobra comision
	DECLARE Var_TipCobFalPago		CHAR(1);		-- Variable para el cobro de comision por falta de pago
	DECLARE Var_NumAmortiFalPag    	INT;			-- Numero de cobros por falta de pago
	DECLARE Var_MontoFalPag			DECIMAL(14,2); 	-- Comision calculada por falta de pago
	DECLARE Var_Consecutivo			BIGINT(12);		-- Consecutivo para el registro del movimiento
	DECLARE Var_CobraMora			CHAR(1);		-- Se cobra mora
	DECLARE Var_DiaHabilSig			DATE;			-- Dia habil siguiente
	DECLARE Var_DiasInteres			INT(11);		-- Dias que hay de una fecha a otra
	DECLARE Var_DiasAtraso			INT(11);		-- Dias de atraso de una fecha a otra
	DECLARE Var_IntereMor			DECIMAL(12,2);	-- Interes moratorio generado por n dias de atraso
	DECLARE Var_DescComision		VARCHAR(50);	-- Descripcion de comision por falta de pago
	DECLARE Var_DescMoratorio		VARCHAR(50);	-- Descripcion de intereses moratorios

	DECLARE Var_DescCapitalVen		VARCHAR(50);	-- Descripcion de capital vencido
	DECLARE Var_DescCapitAtra		VARCHAR(50);	-- Descripcion de capital atrasado
	DECLARE Var_DescInterVenci		VARCHAR(50);	-- Descripcion de intereses vencido
	DECLARE Var_DescInterAtra		VARCHAR(50);	-- Descripcion de intereses atrasado

	DECLARE Var_Poliza				BIGINT;			-- Numero generado de la poliza
	DECLARE Var_Plazo				CHAR(1);    	-- Tipo de plazo C = corto o L = largo
	DECLARE Var_SucursArrenda		INT(11);		-- Sucursal origen del arrendamiento
	DECLARE Var_DescCapVigente		VARCHAR(50);	-- Descripcion de capital vigente
	DECLARE Var_DescInterVig		VARCHAR(50);	-- Descripcion de intereses vigente

	DECLARE Var_DescAComFPago		VARCHAR(50);	-- Descripcion comision por falta de pago.
	DECLARE Var_DescAIMorato		VARCHAR(50);	-- Descripcion por intereses moratorios.
	DECLARE Var_NumRegistros		INT;			-- Numero de registros que seran procesados por el sp:GENERAINTERMORACOMARRENDAPRO
	DECLARE Var_NumCoutasVen		INT;			-- Numero de coutas vencidas que tiene el arrendamiento

	DECLARE Var_DiasDif				INT(11);		-- Dias de diferencia entre una fecha y otra
	DECLARE Var_MontoMinPago		DECIMAL(12,2);	-- Monto minimo de pago

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);		-- Entero cero
	DECLARE Salida_Si				CHAR(1);		-- Indica que si se devuelve un mensaje de salida
	DECLARE Salida_No				CHAR(1);		-- Indica que no se devuelve un mensaje de salida
	DECLARE Decimal_Cero			DECIMAL(14,2);	-- Decimal 0

	DECLARE Var_CobComiFalPagSi		CHAR(1);		-- Cobra comision por falta de pago
	DECLARE Var_MontoComision		DECIMAL(14,4);	-- Monto de comision por falta de pago
	DECLARE Var_PorFaltaPago		CHAR(1);		-- Tipo de cobro por falta de pago
	DECLARE Est_Atrasado			CHAR(1);		-- Estatus de atraso para las amortizaciones
	DECLARE Est_Vigente				CHAR(1);		-- Estatus de vigente para las amortizaciones

	DECLARE Var_DiasAtraso90		INT(11);		-- Dias de atraso para cartera vencida
	DECLARE Est_Vencida				CHAR(1);		-- Estatus de vencido para las amortizaciones
	DECLARE Var_NaturaCargo			CHAR(1);		-- Naturaleza del Movimiento Cargo
	DECLARE Var_MonedaID			INT(11);		-- ID del tipo de moneda Peso
	DECLARE Var_CobraMoraSi			CHAR(1);		-- Se Cobra Interes Moratorios

	DECLARE Var_MoraNVeces			CHAR(1);		-- Tipo de Cobro de Moratorios: N Veces la Tasa Ordinaria
	DECLARE Var_MoraTasaFi			CHAR(1);		-- Tipo de Cobro de Moratorios: T Tasa fija u ordinaria
	DECLARE Var_PrimerCoutAtra		INT(11);		-- Primer cuota atrasada
	DECLARE Var_MontoMinimo			DECIMAL(12,2);	-- Monto minimo
	DECLARE Var_Si					CHAR(1);		-- Variable Si
	DECLARE Var_No					CHAR(1);		-- Variable No

	DECLARE Var_DesCieDia			VARCHAR(50);	-- Descripcion del cierre de dia
	DECLARE Var_DiasDiferencia		INT(11);		-- Un Dia de diferencia entre la fecha actual y el siguiente habil

	DECLARE Var_TipConCapVen		INT(4);			-- Tipo de concepto para Capital vencido
	DECLARE Var_TipConIntVen		INT(4);			-- Tipo de concepto para Interes vencido
	DECLARE Var_TipConCapAtra		INT(4);			-- Tipo de concepto para Capital atrasada
	DECLARE Var_TipConIntAtra		INT(4);			-- Tipo de concepto para Interes atrasada
	DECLARE Var_TipConComiFalPa		INT(4);			-- Tipo de concepto par comision por falta de pago

	DECLARE Var_TipConIntMorato		INT(4);			-- Tipo de concepto par intereses moratorios
	DECLARE Var_TipConCapVig		INT(4);			-- Tipo de concepto para Capital vigente
	DECLARE Var_TipConIntVig		INT(4);			-- Tipo de concepto para Interes vigente
	DECLARE Var_TipConAComiFPag		INT(4);			-- Tipo de concepto para abono por comision de falta de pago
	DECLARE Var_TipConAInMorato		INT(4);			-- Tipo de concepto para abono por interes moratorios

	DECLARE Var_TipMovCapVen		INT(4);			-- Tipo de movimiento para Capital vencido
	DECLARE Var_TipMovIntVen		INT(4);			-- Tipo de movimiento para interes vencido
	DECLARE Var_TipMovCapAtra		INT(4);			-- Tipo de movimiento para Capital atrasado
	DECLARE Var_TipMovIntAtra		INT(4);			-- Tipo de movimiento para interes atrasado
	DECLARE Var_TipMovMorato		INT(4);			-- Tipo de movimiento para interes moratorios

	DECLARE Var_TipMovComi			INT(4);			-- Tipo de movimiento para comisiones por falta de pago
	DECLARE Var_TipMovCapVig		INT(4);			-- Tipo de movimiento para Capital vigente
	DECLARE Var_TipMovIntVig		INT(4);			-- Tipo de movimiento para interes vigente

	DECLARE Var_DescCapVen			VARCHAR(50);	-- Descripcion capital vencido
	DECLARE Var_DescCapAtra			VARCHAR(50);	-- Descripcion capital atrasado
	DECLARE Var_DescIntVen			VARCHAR(50);	-- Descripcion interes vencido
	DECLARE Var_DescIntAtra			VARCHAR(50);	-- Descripcion interes atrasado
	DECLARE Var_DescIntMorato		VARCHAR(50);	-- Descripcion por intereses moratorios.

	DECLARE Var_DescCapitalVig		VARCHAR(50);	-- Descripcion de capital vigente
	DECLARE Var_DescInterVigen		VARCHAR(50);	-- Descripcion de intereses vigente
	DECLARE Var_DescAComFalPago		VARCHAR(50);	-- Descripcion comision por falta de pago.
	DECLARE Var_DescAIntMorato		VARCHAR(50);	-- Descripcion por intereses moratorios.
	DECLARE Var_DescComFalPago		VARCHAR(50);	-- Descripcion comision por falta de pago.

	DECLARE Var_NaturaAbono			CHAR(1);		-- Naturaleza del Movimiento Abono
	DECLARE Var_PlazoCorto			CHAR(1);    	-- Plazo C = corto
	DECLARE Var_PlazoLargo			CHAR(1);    	-- Plazo L = largo
	DECLARE Var_PolAutomatica		CHAR(1);		-- Poliza automatica
	DECLARE Var_ConceptoConta		INT(4);			-- Tipo de Concepto contable tabla:CONCEPTOSCONTA.

	DECLARE AltaPoliza_No			CHAR(1);		-- No dar de alta el encabezado de la poliza
	DECLARE AltaDePoliza_Si			CHAR(1);		-- Alta del detalle de la poliza en:DETALLEPOLIZA
	DECLARE AltaDePoliza_No			CHAR(1);		-- No Alta del detalle de la poliza en:DETALLEPOLIZA
	DECLARE AltaMovs_Si				CHAR(1);		-- Se registra el movimiento en la tabla: ARRENDAMIENTOMOVS
	DECLARE AltaMovs_No				CHAR(1);		-- No se registra el movimiento en la tabla: ARRENDAMIENTOMOVS

	DECLARE Var_DesMonMinimo		VARCHAR(50);	-- Descripcion del monto minimo



	-- Declaracion del cursor: Datos de las cuotas que no fueron pagadas hasta la fecha exigible o tienen un saldo pendiente de pago
	DECLARE CURSORINTERMOR CURSOR FOR
    SELECT	arrenda.ArrendaID,		amorti.ArrendaAmortiID,		amorti.ClienteID,		arrenda.ProductoArrendaID,		arrenda.TipoArrenda,
			amorti.FechaInicio,		amorti.FechaVencim,			amorti.FechaExigible,	amorti.Estatus,					arrenda.FactorMora,
			arrenda.TasaFijaAnual,	arrenda.TipCobComMorato,  	arrenda.Estatus,		amorti.SaldoMoratorios,			amorti.SaldComFaltPago,
			(amorti.SaldoCapVigent + amorti.SaldoCapAtrasad + amorti.SaldoCapVencido) AS SaldoCapital,
			(amorti.SaldoInteresVigente + amorti.SaldoInteresAtras + amorti.SaldoInteresVen) AS SaldoIntereses,
			FNDIASVENCIMIENTOARRENDA(Par_Fecha,arrenda.ArrendaID) AS DiasVencimiento,
			arrenda.SucursalID
		FROM ARRENDAAMORTI AS amorti
		INNER JOIN ARRENDAMIENTOS AS arrenda ON amorti.ArrendaID = arrenda.ArrendaID
		WHERE	amorti.FechaExigible <= FUNCIONDIAHABIL(Par_Fecha,1,1)
		  AND	amorti.Estatus IN (Est_Vigente,Est_Atrasado,Est_Vencida)
		  AND	arrenda.Estatus IN (Est_Vigente,Est_Vencida)
		ORDER BY arrenda.ArrendaID,amorti.ArrendaAmortiID;

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';								-- Valor de cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';					-- Valor de fecha vacia.
	SET	Entero_Cero				:= 0;								-- Valor de entero cero.
	SET Salida_Si				:= 'S';      						-- Si se devuelve una salida Si
	SET Salida_No				:= 'N';      						-- NO se devuelve una salida No
	SET	Decimal_Cero			:= 0.0;								-- Valor de decimal cero.

	SET Var_CobComiFalPagSi     := 'S';             				-- Si Cobra Comision por Falta de Pago
	SET Var_MontoComision		:= 203.50;							-- Monto de la comision que se cobra
	SET Var_PorFaltaPago      	:= 'P';								-- Tipo de Cobro por falta de pago(evento)
	SET Est_Atrasado      		:= 'A';								-- Estatus atrasado= A
	SET Est_Vigente 			:= 'V';             				-- Estatus vigente = V

	SET Var_DiasAtraso90 		:= 90;              				-- Dias de atraso 90
	SET Est_Vencida 			:= 'B';             				-- Estatus vencido = B
	SET Var_NaturaCargo			:= 'C';             				-- Cargo = C
	SET Var_MonedaID			:= 1;								-- Moneda 1= peso
	SET Var_CobraMoraSi			:= 'S';								-- Si se cobra Interes Moratorio = S

	SET Var_MoraNVeces     		:= 'N';                				-- N Veces la Tasa Ordinaria
	SET Var_MoraTasaFi     		:= 'T';                				-- Tasa Ordinaria
	SET Var_PrimerCoutAtra		:= 1;								-- Primera couta atrasada
	SET	Var_MontoMinimo			:= 0.01;							-- Valor de monto minimo
	SET Var_Si					:= 'S';      						-- Valor Si
	SET Var_No					:= 'N';      						-- Valor No

	SET Var_DesCieDia			:= 'CIERRE DIARIO ARRENDAMIENTO';	-- Descripcion cierre
	SET Var_DiasDiferencia		:= 1;								-- Un dia de diferencia entre la fehca actual y la siguiente habil

	SET Var_TipConCapVen 		:= 3;              					-- Concepto 3 para Capital vencido   Tabla:CONCEPTOSARRENDA
	SET Var_TipConIntVen 		:= 21;              				-- Concepto 21 para interes vencido  Tabla:CONCEPTOSARRENDA
	SET Var_TipConCapAtra 		:= 2;              					-- Concepto 2 para capital atrasado  Tabla:CONCEPTOSARRENDA
	SET Var_TipConIntAtra 		:= 20;              				-- Concepto 20 para interes atrasado Tabla:CONCEPTOSARRENDA
	SET Var_TipConComiFalPa 	:= 15;              				-- Concepto 15 par comision por falta de pago Tabla:CONCEPTOSARRENDA

	SET Var_TipConIntMorato 	:= 33;              				-- Concepto 33 par interese moratorios Tabla:CONCEPTOSARRENDA
	SET Var_TipConCapVig 		:= 1;              					-- Concepto 1 para Capital vigente   Tabla:CONCEPTOSARRENDA
	SET Var_TipConIntVig 		:= 19;              				-- Concepto 19 para interes vigente   Tabla:CONCEPTOSARRENDA
	SET Var_TipConAComiFPag 	:= 22;              				-- Concepto 22 para abono comision Tabla:CONCEPTOSARRENDA
	SET Var_TipConAInMorato 	:= 23;              				-- Concepto 23 para interes mora  Tabla:CONCEPTOSARRENDA

	SET Var_TipMovCapVen 		:= 3;              					-- Movimiento 3 para Capital vencido   Tabla:TIPOSMOVSARRENDA
	SET Var_TipMovIntVen 		:= 12;              				-- Movimiento 12 para interes vencido  Tabla:TIPOSMOVSARRENDA
	SET Var_TipMovCapAtra 		:= 2;              					-- Movimiento 2 para Capital atrasado  Tabla:TIPOSMOVSARRENDA
	SET Var_TipMovIntAtra 		:= 11;              				-- Movimiento 11 para interes atrasado Tabla:TIPOSMOVSARRENDA

	SET Var_TipMovCapVig 		:= 1;              					-- movimiento 1 para Capital vigente   Tabla:TIPOSMOVSARRENDA
	SET Var_TipMovIntVig 		:= 10;              				-- movimiento 10 para interes vigente   Tabla:TIPOSMOVSARRENDA
	SET Var_TipMovMorato 		:= 15;              				-- Movimiento 15 para moratorios, Tabla:TIPOSMOVSARRENDA
	SET Var_TipMovComi 			:= 40;              				-- Movimiento 40 para comisiones por falta de pago, Tabla:TIPOSMOVSARRENDA

	SET Var_DescCapVen			:= 'CAPITAL VENCIDO';				-- Descripcion capital vencido
	SET Var_DescCapAtra			:= 'CAPITAL ATRASADO';				-- Descripcion capital atrasado
	SET Var_DescIntVen			:= 'INTERES VENCIDO';				-- Descripcion interes vencido
	SET Var_DescIntAtra			:= 'INTERES ATRASADO';				-- Descripcion interes atrasado
	SET Var_DescCapitalVig		:= 'CAPITAL VIGENTE';				-- Descripcion capital vigente

	SET Var_DescInterVigen		:= 'INTERES VIGENTE';				-- Descripcion interes vigente
	SET Var_DescAComFalPago		:= 'INGRESOS POR COM. FALTA PAGO';	-- Descripcion abono por comisiones
	SET Var_DescAIntMorato		:= 'INGRESOS POR INT. MORATORIOS';	-- Descripcion abono de interes mora
	SET Var_DescComFalPago		:= 'COMISION POR FALTA DE PAGO';	-- Descripcion de comision por falta de pago
	SET Var_DescIntMorato		:= 'INTERES MORATORIO DEVENGADO';	-- Descripcion por intereses moratorios

	SET Var_NaturaAbono			:= 'A';             				-- Abono = A
	SET Var_PlazoCorto			:= 'C';             				-- Plazo C = corto
	SET Var_PlazoLargo			:= 'L';             				-- Plazo L = largo
	SET Var_PolAutomatica		:= 'A';								-- Tipo de Poliza: Automatica
	SET Var_ConceptoConta		:= 840;								-- Tipo de Proceso Contable de la tabla:CONCEPTOSCONTA

	SET AltaPoliza_No			:= 'N';								-- Alta del Encabezado de la Poliza: NO
	SET AltaDePoliza_Si			:= 'S';								-- Alta de la Poliza: SI
	SET AltaDePoliza_No			:= 'N';								-- Alta de la Poliza: No
	SET AltaMovs_Si				:= 'S';								-- Alta del Movimiento: SI
	SET AltaMovs_No				:= 'N';								-- Alta del Movimiento: NO

	SET Var_DesMonMinimo		:= 'MontoMinPago';					-- Descripcion del monto minimo


	-- Valores por default si son nulos
	SET Par_Fecha			:= IFNULL(Par_Fecha,Fecha_Vacia);
	SET Var_Control			:= IFNULL(Var_Control,Cadena_Vacia);

	-- calculo del dia habil siguiente
	SET Var_DiaHabilSig := FUNCIONDIAHABIL(Par_Fecha,1,1);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: GENERAINTERMORACOMARRENDAPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

	-- Monto minimo de pago
	SELECT	ValorParametro
	  INTO	Var_MontoMinPago
		FROM PARAMGENERALES
		WHERE LlaveParametro = Var_DesMonMinimo;

	-- Descripcion de los conceptos de arrendamiento
	SELECT	Descripcion
	  INTO	Var_DescMoratorio
		FROM CONCEPTOSARRENDA
		WHERE	ConceptoArrendaID = Var_TipConIntMorato;

	SELECT	Descripcion
	  INTO	Var_DescComision
		FROM CONCEPTOSARRENDA
		WHERE	ConceptoArrendaID = Var_TipConComiFalPa;

	SELECT	Descripcion
	  INTO	Var_DescCapitalVen
		FROM CONCEPTOSARRENDA
		WHERE	ConceptoArrendaID = Var_TipConCapVen;

	SELECT	Descripcion
	  INTO	Var_DescCapitAtra
		FROM CONCEPTOSARRENDA
		WHERE	ConceptoArrendaID = Var_TipConCapAtra;

	SELECT	Descripcion
	  INTO	Var_DescInterVenci
		FROM CONCEPTOSARRENDA
		WHERE	ConceptoArrendaID = Var_TipConIntVen;

	SELECT	Descripcion
	  INTO	Var_DescInterAtra
		FROM CONCEPTOSARRENDA
		WHERE	ConceptoArrendaID = Var_TipConIntAtra;

	SELECT	Descripcion
	  INTO	Var_DescCapVigente
		FROM CONCEPTOSARRENDA
		WHERE	ConceptoArrendaID = Var_TipConCapVig;

	SELECT	Descripcion
	  INTO	Var_DescInterVig
		FROM CONCEPTOSARRENDA
		WHERE	ConceptoArrendaID = Var_TipConIntVig;

	SELECT	Descripcion
	  INTO	Var_DescAComFPago
		FROM CONCEPTOSARRENDA
		WHERE	ConceptoArrendaID = Var_TipConAComiFPag;

	SELECT	Descripcion
	  INTO	Var_DescAIMorato
		FROM CONCEPTOSARRENDA
		WHERE	ConceptoArrendaID = Var_TipConAInMorato;

	SET Var_MontoMinPago	:= IFNULL(Var_MontoMinPago,Var_MontoMinimo);
	SET Var_DescComision	:= IFNULL(Var_DescComision,Var_DescComFalPago);
	SET Var_DescMoratorio	:= IFNULL(Var_DescMoratorio,Var_DescIntMorato);
	SET Var_DescCapitalVen	:= IFNULL(Var_DescCapitalVen,Var_DescCapVen);
	SET Var_DescCapitAtra	:= IFNULL(Var_DescCapitAtra,Var_DescCapAtra);
	SET Var_DescInterVenci	:= IFNULL(Var_DescInterVenci,Var_DescIntVen);
	SET Var_DescInterAtra	:= IFNULL(Var_DescInterAtra,Var_DescIntAtra);
	SET Var_DescCapVigente	:= IFNULL(Var_DescCapVigente,Var_DescCapitalVig);
	SET Var_DescInterVig	:= IFNULL(Var_DescInterVig,Var_DescInterVigen);
	SET Var_DescAComFPago	:= IFNULL(Var_DescAComFPago,Var_DescAComFalPago);
	SET Var_DescAIMorato	:= IFNULL(Var_DescAIMorato,Var_DescAIntMorato);

	-- Numero de registros a procesar
	SELECT	COUNT(amorti.ArrendaAmortiID)
	  INTO	Var_NumRegistros
		FROM ARRENDAAMORTI AS amorti
		INNER JOIN ARRENDAMIENTOS AS arrenda ON amorti.ArrendaID = arrenda.ArrendaID
		WHERE	amorti.FechaExigible <= Var_DiaHabilSig
		  AND	amorti.Estatus IN (Est_Vigente,Est_Atrasado,Est_Vencida)
		  AND	arrenda.Estatus IN (Est_Vigente,Est_Vencida);
	SET Var_NumRegistros	:= IFNULL(Var_NumRegistros,Entero_Cero);

	-- Se ejecuta el maestro poliza si hay minimo un registro a procesar
	IF (Var_NumRegistros > Entero_Cero) THEN
		CALL MAESTROPOLIZAALT(Var_Poliza,		Par_EmpresaID,		Par_Fecha,     	Var_PolAutomatica,	Var_ConceptoConta,
							  Var_DesCieDia,	Salida_No,			Aud_Usuario,    Aud_FechaActual,	Aud_DireccionIP,
							  Aud_ProgramaID,	Aud_Sucursal,       Aud_NumTransaccion);
	END IF;

	-- Diferencia de dias respecto al dia habil siguiente y la fecha actual
	SET Var_DiasDif		:= DATEDIFF(Var_DiaHabilSig,Par_Fecha);

	-- Se abre y recorre el cursor;
	OPEN CURSORINTERMOR;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLO:LOOP
				FETCH CURSORINTERMOR INTO
					Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,			Var_ProducArrendaID, 	Var_TipoArrenda,
					Var_FechaInicio,	Var_FechaVencim,		Var_FechaExigible,		Var_EstatusAmorti,		Var_FactorMora,
					Var_TasaFijaAnual,	Var_TipCobComMorato,	Var_EstatusArrenda,		Var_SaldoMoratorios,	Var_SaldComFaltPago,
					Var_SaldoCapital,	Var_SaldoInteres,		Var_DiasVencimiento,	Var_SucursArrenda;

					-- ------------------------- Proceso y Calculos -------------------------------------
					-- Se inicializan valores en cada iteracion
					SET Var_CobFaltaPago	:= Var_CobComiFalPagSi;
					SET Var_TipCobFalPago	:= Var_PorFaltaPago;
					SET Var_NumAmortiFalPag	:= Entero_Cero;
					SET Var_MontoFalPag		:= Decimal_Cero;
					SET Par_NumErr			:= Entero_Cero;
					SET Par_ErrMen			:= Entero_Cero;
					SET Var_Consecutivo		:= Entero_Cero;
					SET Var_CobraMora		:= Var_CobraMoraSi;
					SET Var_IntereMor       := Decimal_Cero;
					SET Var_DiasAtraso		:= Entero_Cero;
					SET Var_DiasInteres 	:= Entero_Cero;
					SET Var_Plazo			:= Var_PlazoCorto;
					SET Var_NumCoutasVen	:= Entero_Cero;

					--  TRASPASO A CARTERA VENCIDA --
					-- Se suma a los dias de atraso del arrendamiento el numero de dias hasta la fecha habil siguiente por si alguno vence en dias inhabiles.
					IF (Var_DiasDif > Var_DiasDiferencia) THEN
						SET Var_DiasVencimiento	:= Var_DiasVencimiento + (Var_DiasDif-1);
					END IF;

					-- Si la fecha de exigible <= fecha actual y la amortizacion tiene el estatus vigente.
					IF (Var_EstatusAmorti = Est_Vigente) THEN
						-- Numero de coutas vencidas que presenta el arrendamiento
						SELECT	COUNT(amorti.ArrendaAmortiID)
						  INTO	Var_NumCoutasVen
							FROM ARRENDAAMORTI amorti
							WHERE	amorti.ArrendaID = Var_ArrendaID
							  AND	amorti.Estatus = Est_Vencida;

						SET Var_NumCoutasVen	:= IFNULL(Var_NumCoutasVen,Entero_Cero);

						-- Se vence la amortizacion si el arrendamiento tiene >= 90 dias o tiene almenos una couta vencida
						IF ((Var_DiasVencimiento >= Var_DiasAtraso90 OR Var_NumCoutasVen > Entero_Cero )AND Var_FechaExigible < Var_DiaHabilSig ) THEN
							-- Se cambia el estatus de vigente a vencido
							UPDATE ARRENDAAMORTI SET
								Estatus = Est_Vencida,
								SaldoCapVigent = 0.0,
								SaldoInteresVigente = 0.0,
								SaldoCapAtrasad = 0.0,
								SaldoInteresAtras = 0.0,
								SaldoCapVencido = Var_SaldoCapital,
								SaldoInteresVen = Var_SaldoInteres
								WHERE	ArrendaID = Var_ArrendaID
								  AND	ArrendaAmortiID = Var_ArrendaAmortiID
								  AND	Estatus = Est_Vigente;
							-- llamado al sp de la contabilidad
							-- Se hace cargo a capital vigente de manera operativa y contable.
							IF(Var_SaldoCapital > Var_MontoMinPago)THEN
								CALL CONTAARRENDAPRO(Par_Fecha, 		Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
													Var_TipConCapVig,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
													Var_MonedaID, 		Var_DesCieDia,		Var_DescCapVigente,		Var_SaldoCapital,
													AltaPoliza_No,		Entero_Cero,		AltaDePoliza_Si,		AltaMovs_Si,
													Var_TipConCapVig,	Var_TipMovCapVig,	Var_NaturaCargo,		Cadena_Vacia,
													Var_Plazo,			Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
													Var_Poliza,			Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
													Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
													Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

								-- Se hace el abono a capital vencido de manera operativa y contable.
								CALL CONTAARRENDAPRO(Par_Fecha, 		Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
													Var_TipConCapVen,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
													Var_MonedaID, 		Var_DesCieDia,		Var_DescCapitalVen,		Var_SaldoCapital,
													AltaPoliza_No,		Entero_Cero,		AltaDePoliza_Si,		AltaMovs_Si,
													Var_TipConCapVen,	Var_TipMovCapVen,	Var_NaturaAbono,		Cadena_Vacia,
													Var_Plazo,			Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
													Var_Poliza,			Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
													Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
													Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
							END IF;

							IF(Var_SaldoInteres > Var_MontoMinPago)THEN
								-- Se hace el cargo al Intereses vigente de manera operativa y contable.
								CALL CONTAARRENDAPRO(Par_Fecha, 		Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
													Var_TipConIntVig,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
													Var_MonedaID, 		Var_DesCieDia,		Var_DescInterVig,		Var_SaldoInteres,
													AltaPoliza_No,		Entero_Cero,		AltaDePoliza_Si,		AltaMovs_Si,
													Var_TipConIntVig,	Var_TipMovIntVig,	Var_NaturaCargo,		Cadena_Vacia,
													Var_Plazo,			Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
													Var_Poliza,			Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
													Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
													Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

								-- Se hace el abono al Intereses vencido de manera operativa y contable.
								CALL CONTAARRENDAPRO(Par_Fecha, 		Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
													Var_TipConIntVen,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
													Var_MonedaID, 		Var_DesCieDia,		Var_DescInterVenci,		Var_SaldoInteres,
													AltaPoliza_No,		Entero_Cero,		AltaDePoliza_Si,		AltaMovs_Si,
													Var_TipConIntVen,	Var_TipMovIntVen,	Var_NaturaAbono,		Cadena_Vacia,
													Var_Plazo,			Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
													Var_Poliza,			Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
													Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
													Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
							END IF;
						END IF;
						-- De vigente a atrasado cuando no se pago a la fecha exigible
						IF (Var_DiasVencimiento < Var_DiasAtraso90 AND Var_FechaExigible < Var_DiaHabilSig AND Var_NumCoutasVen <= Entero_Cero) THEN
							-- Se cambia el estatus de vigente a atrasado y  se actualizan los saldo capital e interes a atrasado
							UPDATE ARRENDAAMORTI SET
								Estatus = Est_Atrasado,
								SaldoCapVigent = 0.0,
								SaldoInteresVigente = 0.0,
								SaldoCapVencido = 0.0,
								SaldoInteresVen = 0.0,
								SaldoCapAtrasad = Var_SaldoCapital,
								SaldoInteresAtras = Var_SaldoInteres
								WHERE	ArrendaID = Var_ArrendaID
								  AND	ArrendaAmortiID = Var_ArrendaAmortiID
								  AND	Estatus = Est_Vigente;

							IF(Var_SaldoCapital > Var_MontoMinPago)THEN
								-- Se registra el paso de capital de vigente a atrasado de manera operativa
								CALL CONTAARRENDAPRO(Par_Fecha, 		Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
													Var_TipConCapAtra,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
													Var_MonedaID, 		Var_DesCieDia,		Var_DescCapitAtra,		Var_SaldoCapital,
													AltaPoliza_No,		Entero_Cero,		AltaDePoliza_No,		AltaMovs_Si,
													Var_TipConCapAtra,	Var_TipMovCapAtra,	Var_NaturaCargo,		Cadena_Vacia,
													Var_Plazo,			Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
													Var_Poliza,			Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
													Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
													Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
							END IF;

							IF(Var_SaldoInteres > Var_MontoMinPago)THEN
								-- Se registra el paso de intereses de vigente a atrasado de manera operativa
								CALL CONTAARRENDAPRO(Par_Fecha, 		Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
													Var_TipConIntAtra,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
													Var_MonedaID, 		Var_DesCieDia,		Var_DescInterAtra,		Var_SaldoInteres,
													AltaPoliza_No,		Entero_Cero,		AltaDePoliza_No,		AltaMovs_Si,
													Var_TipConIntAtra,	Var_TipMovIntAtra,	Var_NaturaCargo,		Cadena_Vacia,
													Var_Plazo,			Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
													Var_Poliza,			Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
													Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
													Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
							END IF;
						END IF;
					END IF;

					-- Si la numero de atrasos de la primera cuota es >= 90 dias, se cambian todos los estatus de las amortizaciones atrasadas a vencidas
					IF (Var_DiasVencimiento >= Var_DiasAtraso90 AND Var_EstatusAmorti = Est_Atrasado) THEN
						-- Se cambia el estatus de las las cuotas de atrasadas (A) a vencido(B). Y saldos de capital e interes
							UPDATE ARRENDAAMORTI SET
								Estatus = Est_Vencida,
								SaldoCapVencido = Var_SaldoCapital,
								SaldoInteresVen = Var_SaldoInteres,
								SaldoCapAtrasad = 0.0,
								SaldoInteresAtras = 0.0,
								SaldoCapVigent = 0.0,
								SaldoInteresVigente = 0.0
								WHERE	ArrendaID = Var_ArrendaID
								  AND	ArrendaAmortiID = Var_ArrendaAmortiID
								  AND	Estatus = Est_Atrasado;

						IF(Var_SaldoCapital > Var_MontoMinPago)THEN
							-- Se registra el paso de capital de atrasado a vencido de manera operativa cuando la couta tiene >= 90 dias de atraso
							CALL CONTAARRENDAPRO(Par_Fecha, 		Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
												Var_TipConCapVen,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
												Var_MonedaID, 		Var_DesCieDia,		Var_DescCapitalVen,		Var_SaldoCapital,
												AltaPoliza_No,		Entero_Cero,		AltaDePoliza_No,		AltaMovs_Si,
												Var_TipConCapVen,	Var_TipMovCapVen,	Var_NaturaCargo,		Cadena_Vacia,
												Var_Plazo,			Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
												Var_Poliza,			Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
												Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
												Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
						END IF;

						IF(Var_SaldoInteres > Var_MontoMinPago)THEN
							-- Se registra el paso del interes de atrasado a vencido de manera operativa cuando la couta tiene >= 90 dias de atraso
							CALL CONTAARRENDAPRO(Par_Fecha, 		Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
												Var_TipConIntVen,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
												Var_MonedaID, 		Var_DesCieDia,		Var_DescInterVenci,		Var_SaldoInteres,
												AltaPoliza_No,		Entero_Cero,		AltaDePoliza_No,		AltaMovs_Si,
												Var_TipConIntVen,	Var_TipMovIntVen,	Var_NaturaCargo,		Cadena_Vacia,
												Var_Plazo,			Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
												Var_Poliza,			Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
												Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
												Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
						END IF;
					END IF;-- FIN TRASPASO A CARTERA VENCIDA


					-- CALCULO DE COMISIONES POR FALTA DE PAGO ----
					IF ((Var_CobFaltaPago = Var_CobComiFalPagSi) AND (Var_FechaExigible = Par_Fecha)) THEN
						-- Se Cobra comision por falta de pago es decir por evento no por amortizacion
						IF (Var_TipCobFalPago = Var_PorFaltaPago)THEN
							SELECT	COUNT(amorti.ArrendaAmortiID)
								INTO	Var_NumAmortiFalPag
								FROM ARRENDAAMORTI amorti
								WHERE	amorti.ArrendaID = Var_ArrendaID
								  AND	amorti.FechaVencim <= Par_Fecha
								  AND	amorti.Estatus in (Est_Atrasado, Est_Vencida);

							SET Var_NumAmortiFalPag = IFNULL(Var_NumAmortiFalPag, Entero_Cero);
							-- Si es la primera vez que no se paga una couta de las coutas
							IF(Var_NumAmortiFalPag = Var_PrimerCoutAtra) THEN
								-- si cobra comision aqui se calcula la comision
								SET Var_MontoFalPag := ROUND((Var_SaldComFaltPago + Var_MontoComision),2);

								-- se actualiza el saldo de la comision por falta de pago en el arrendamiento
								UPDATE ARRENDAAMORTI SET
									SaldComFaltPago = Var_MontoFalPag
									WHERE	ArrendaID = Var_ArrendaID
									  AND	ArrendaAmortiID = Var_ArrendaAmortiID;

								-- Se registra de manera operativa y contable la comision por falta de pago, cargo.
								IF(Var_MontoFalPag > Var_MontoMinPago)THEN
									CALL CONTAARRENDAPRO(Par_Fecha, 			Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
														Var_TipConComiFalPa,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
														Var_MonedaID, 			Var_DesCieDia,		Var_DescComision,		Var_MontoFalPag,
														AltaPoliza_No,			Entero_Cero,		AltaDePoliza_Si,		AltaMovs_Si,
														Var_TipConComiFalPa,	Var_TipMovComi,		Var_NaturaCargo,		Cadena_Vacia,
														Var_Plazo,				Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
														Var_Poliza,				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
														Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
														Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

									-- Se registra de manera contable la comision por falta de pago, abono.
									CALL CONTAARRENDAPRO(Par_Fecha, 			Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
														Var_TipConAComiFPag,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
														Var_MonedaID, 			Var_DesCieDia,		Var_DescAComFPago,		Var_MontoFalPag,
														AltaPoliza_No,			Entero_Cero,		AltaDePoliza_Si,		AltaMovs_No,
														Var_TipConAComiFPag,	Var_TipMovComi,		Var_NaturaAbono,		Cadena_Vacia,
														Var_Plazo,				Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
														Var_Poliza,				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
														Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
														Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
								END IF;
							END IF;
						END IF;
					END IF; -- FIN DE CALCULO DE COMISIONES

					-- CALCULO DE INTERESES MORATORIOS --
					-- Cuando la fecha exigible es <= a la fecha actual es porque ya vencio con anterioridad.
					IF (Var_CobraMora = Var_CobraMoraSi AND Var_FactorMora > Entero_Cero AND Var_FechaExigible < Var_DiaHabilSig ) THEN
						-- Cuando la fecha de vencimiento es antes de la fecha exigible
						IF(Var_FechaVencim < Var_DiaHabilSig AND Var_FechaExigible = Par_Fecha)THEN
							SET Var_DiasAtraso	:= DATEDIFF(Par_Fecha,Var_FechaVencim); -- numero de dias de atraso desde que vencio a hoy

							IF (Var_DiasAtraso > Entero_Cero) THEN
								-- Se calcula el dia habil siguiente,
								-- Se saca la diferencia entre el dia habil siguiente y el dia de hoy, esto se le suma a los dias atrasados
								SET Var_DiasInteres	:= DATEDIFF(Var_DiaHabilSig,Par_Fecha);
								SET Var_DiasInteres := Var_DiasInteres + Var_DiasAtraso;
							ELSE
								SET Var_DiasInteres	:= DATEDIFF(Var_DiaHabilSig,Var_FechaVencim);
							END IF;
						ELSE
							-- Se calcula el numero de dias para el calculo de moratorios
							SET Var_DiasInteres	:= DATEDIFF(Var_DiaHabilSig,Par_Fecha);
						END IF;

						-- Tipo de cobro de moratorios cuando es n veces la tasa anual
						IF (Var_TipCobComMorato = Var_MoraNVeces) THEN
							SET Var_FacMoratorio  = Var_FactorMora * Var_TasaFijaAnual;
						END IF;
						-- Tipo de cobro Tasa fija = T
						IF(Var_TipCobComMorato = Var_MoraTasaFi) THEN
							SET Var_FacMoratorio  = Var_FactorMora;
						END IF;

						-- intereses moratorios
						SET	Var_IntereMor = ROUND(Var_SaldoCapital * ((Var_FacMoratorio/100)/360 )* Var_DiasInteres, 2);

						SET Var_SaldoMoratorios := Var_SaldoMoratorios + Var_IntereMor;
						-- Se actulizan los saldos moratorios
						UPDATE ARRENDAAMORTI SET
							SaldoMoratorios = Var_SaldoMoratorios
							WHERE	ArrendaID = Var_ArrendaID
							  AND	ArrendaAmortiID = Var_ArrendaAmortiID;

						-- Se registra de manera operativa y contable el devengamiento de los intereses moratorios, cargo.
						IF(Var_SaldoMoratorios > Var_MontoMinPago)THEN
							CALL CONTAARRENDAPRO(Par_Fecha, 		 	Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
												Var_TipConIntMorato,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
												Var_MonedaID, 		 	Var_DesCieDia,		Var_DescMoratorio,		Var_SaldoMoratorios,
												AltaPoliza_No,			Entero_Cero,		AltaDePoliza_Si,		AltaMovs_Si,
												Var_TipConIntMorato,	Var_TipMovMorato,	Var_NaturaCargo,		Cadena_Vacia,
												Var_Plazo,				Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
												Var_Poliza,				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
												Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
												Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

							-- Se registra de manera contable el devengamiento de los intereses moratorios, abono.
							CALL CONTAARRENDAPRO(Par_Fecha, 		 	Par_Fecha, 			Var_TipoArrenda,		Var_ProducArrendaID,
												Var_TipConAInMorato,	Var_ArrendaID,		Var_ArrendaAmortiID,	Var_ClienteID,
												Var_MonedaID, 		 	Var_DesCieDia,		Var_DescAIMorato,		Var_SaldoMoratorios,
												AltaPoliza_No,			Entero_Cero,		AltaDePoliza_Si,		AltaMovs_No,
												Var_TipConAInMorato,	Var_TipMovMorato,	Var_NaturaAbono,		Cadena_Vacia,
												Var_Plazo,				Var_SucursArrenda,	Aud_NumTransaccion, 	Salida_No,
												Var_Poliza,				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
												Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
												Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
						END IF;
					END IF;-- FIN CALCULO DE INTERESES MORATORIOS
				-- ----------------------------- Fin Proceso y Calculos ---------------------------------
			END LOOP CICLO;
		END;
	CLOSE CURSORINTERMOR;

	END ManejoErrores;
	-- Si Par_Salida = S (SI)
	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

	-- Fin del SP
END TerminaStore$$
