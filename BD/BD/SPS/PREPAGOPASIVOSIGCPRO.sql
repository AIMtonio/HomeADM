-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGOPASIVOSIGCPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREPAGOPASIVOSIGCPRO`;
DELIMITER $$


CREATE PROCEDURE `PREPAGOPASIVOSIGCPRO`(
/* SP DE PROCESO QUE REALIZA EL PREPAGO CUOTAS SIGUIENTES INMEDIATAS */
	Par_CreditoFonID	BIGINT(20),		/* ID del credito Pasivo*/
	Par_MontoPagar    	DECIMAL(12, 2),	/* Monto a Pagar */
	Par_MonedaID		INT(11),		/* Identificador de la moneda*/
	Par_Finiquito		CHAR(1),		/* Indica si se trata de un Finiquito*/
	Par_AltaEncPoliza	CHAR(1),		/* Indica si se dara o no de alta un encabezado de poliza */

	Par_InstitucionID	INT(11),		/* Numero de Institucion (INSTITUCIONES) */
	Par_NumCtaInstit	VARCHAR(20),	/* Numero de Cuenta Bancaria. */
	Par_Salida        	CHAR(1),
	INOUT Var_MontoPago	DECIMAL(12,2),
	INOUT Var_Poliza	BIGINT,

	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),
	OUT	Par_Consecutivo	BIGINT,
	/* Parametros de Auditoria */
	Par_EmpresaID     	INT(11),
	Aud_Usuario		    INT(11),

	Aud_FechaActual	    DATETIME,
	Aud_DireccionIP	    VARCHAR(15),
	Aud_ProgramaID	    VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_CreditoFonID		BIGINT(12);
DECLARE Var_FechaSistema    	DATE;
DECLARE Var_FecAplicacion   	DATE;
DECLARE Var_DiasCredito     	INT;
DECLARE Var_EstatusCre      	CHAR(1);

DECLARE Var_MonedaID        	INT;
DECLARE Var_AmortizacionID  	INT;
DECLARE Var_SaldoCapVigente 	DECIMAL(14,2);
DECLARE Var_SaldoCapVenNExi 	DECIMAL(14,2);
DECLARE Var_SaldoCapAtrasad		DECIMAL(12,2);

DECLARE Var_SaldoInteresOrd		DECIMAL(12,4);
DECLARE Var_SaldoInteresAtr		DECIMAL(12,4);
DECLARE Var_SaldoMoratorios		DECIMAL(12,2);
DECLARE Var_SaldoComFaltaPa		DECIMAL(12,2);
DECLARE Var_SaldoOtrasComis		DECIMAL(12,2);

DECLARE Var_FechaInicio     	DATE;
DECLARE Var_FechaVencim     	DATE;
DECLARE Var_FechaExigible   	DATE;
DECLARE Var_SaldoInteresPro		DECIMAL(14,4);
DECLARE	Var_SaldoIntNoConta		DECIMAL(14,4);

DECLARE Var_NumAmorti			INT;
DECLARE Var_TotDeuda    		DECIMAL(14,2);
DECLARE Var_NumAtrasos  		INT;
DECLARE Var_EsHabil     		CHAR(1);
DECLARE Var_CreditoStr			VARCHAR(20);

DECLARE Var_SaldoPago       	DECIMAL(14,2);
DECLARE Var_CantidPagar     	DECIMAL(14,2);
DECLARE Var_IVACantidPagar  	DECIMAL(12, 2);
DECLARE	Var_FechaIniCal			DATE;
DECLARE	Var_EstAmorti			CHAR(1);

DECLARE	Var_DivContaIng			CHAR(1);
DECLARE Var_EsRevolvente		CHAR(1);			-- Variable para saber si es revolvente la linea */
DECLARE Var_Refinancia			CHAR(1);
DECLARE Var_PagaIva 			CHAR(1);			-- Guarda el valor para saber si el credito paga IVA*/
DECLARE Var_IVA 				DECIMAL(12,2);		-- Guarda el valor del IVA */

DECLARE Var_InstitutFondID		INT(11);			-- Guarda el valor de la institucion de fondeo */
DECLARE Var_PlazoContable		CHAR(1);			-- Guarda el valor de plazo contable C.- Corto plazo L.- Largo Plazo*/
DECLARE Var_TipoInstitID		INT(11);			-- Guarda el valor tipo de institucion */
DECLARE Var_NacionalidadIns		CHAR(1);			-- Guarda el valor de nacionalidad de la institucion*/
DECLARE Var_NumCtaInstitStr		VARCHAR(50);		-- Numero de cuenta Institucion convertida a caracter */

DECLARE Var_LineaFondeoID		INT;				-- Linea de fondeo ID */
DECLARE Var_MontoDeuda			DECIMAL(14,2);
DECLARE Var_Retencion			DECIMAL(14,2);
DECLARE Var_InteresOri			DECIMAL(14,2);
DECLARE Var_TipoRevol			CHAR(1);			-- Tipo de Revolvencia*/

DECLARE Var_MontoOtorga			DECIMAL(14,2);
DECLARE Var_CobraISR			CHAR(1);            -- No cobra ISR */
DECLARE Var_TipoFondeo			CHAR(1);            -- Tipo de Operacion: I-Inversionista, F.- Fondeador */
DECLARE Var_CantidRetener		DECIMAL(14,2);
DECLARE Var_TotalRetener		DECIMAL(14,2);

DECLARE Var_TotalBancos			DECIMAL(14,2);
DECLARE MovTesoPago				CHAR(4);			/* Indica el tipo de movimiento de tesoreria pago de credito pasivo tabla TIPOSMOVTESO */
DECLARE Var_PagoPesos			DECIMAL(14,2);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE Decimal_Cero    	DECIMAL(12, 2);
DECLARE SiPagaIVA       	CHAR(1);

DECLARE SalidaSI        	CHAR(1);
DECLARE SalidaNO        	CHAR(1);
DECLARE Esta_Pagado     	CHAR(1);
DECLARE Esta_Activo     	CHAR(1);
DECLARE Esta_Vencido    	CHAR(1);

DECLARE Esta_Vigente    	CHAR(1);
DECLARE Esta_Atrasado		CHAR(1);
DECLARE NO_EsGrupal     	CHAR(1);
DECLARE AltaPoliza_SI   	CHAR(1);
DECLARE AltaPoliza_NO   	CHAR(1);

DECLARE Pol_Automatica  	CHAR(1);
DECLARE Mon_MinPago     	DECIMAL(12,2);
DECLARE Tol_DifPago     	DECIMAL(10,4);
DECLARE Nat_Cargo       	CHAR(1);
DECLARE Nat_Abono       	CHAR(1);

DECLARE Aho_PagoCred    	CHAR(4);
DECLARE Con_AhoCapital  	INT;
DECLARE AltaMovAho_SI   	CHAR(1);
DECLARE Tasa_Fija       	INT;
DECLARE Coc_PagoCred    	INT;

DECLARE Ref_PagAnti     	VARCHAR(50);
DECLARE Con_PagoCred    	VARCHAR(50);
DECLARE NoManejaLinea		CHAR(1);		-- NO maneja linea */
DECLARE SiManejaLinea		CHAR(1);		-- Si maneja linea */
DECLARE SiEsRevolvente		CHAR(1);		-- Si Es Revolvente */

DECLARE NoEsRevolvente		CHAR(1);		-- NO Es Revolvente */
DECLARE AltaMov_NO			CHAR(1);		-- Alta de Movimientos: NO */
DECLARE TipoActInteres		INT(11);
DECLARE Cons_Si				CHAR(1);
DECLARE Cons_No				CHAR(1);
DECLARE Var_ValIVAGen		DECIMAL(14,2);
DECLARE Frec_Unico			CHAR(1);
DECLARE Var_EsReestruc		CHAR(1);
DECLARE Si_EsReestruc		CHAR(1);
DECLARE FechaReal			CHAR(1);

DECLARE RevPagoCuota    	CHAR(1);            /* Revolvencia En cada pago de cuota */
DECLARE RevLiqCre       	CHAR(1);            /* Al liquidar el credito */
DECLARE NoAplicaRev     	CHAR(1);            /* No Aplica Revolvencia */
DECLARE Des_PagoCred   	 	VARCHAR(50);
DECLARE ConContaPagoCre    	INT;				-- Concepto Contable de Cartera: Pago de Credito Pasivo - CONCEPTOSCONTA
DECLARE Var_FechaRegistro	DATE;
DECLARE Var_TipCamDof 		DECIMAL(14,2);		/* Tipo de Cambio para moneda extranjera */
DECLARE Var_TipCamFixCom	DECIMAL(14,2);		-- Tipo de cambio compra Fix
DECLARE Var_MonedaNaID 		INT(11);			/* ID de Moneda Nacionald */

/* Declaracion de cursores */
DECLARE CURSORAMORTI CURSOR FOR
	SELECT  Amo.CreditoFondeoID,	Amo.AmortizacionID,		Amo.SaldoCapVigente,	Amo.SaldoCapAtrasad,	Amo.SaldoInteresPro,
			Amo.SaldoInteresAtra,	Amo.SaldoMoratorios,	Amo.SaldoComFaltaPa,    Amo.SaldoOtrasComis,    Cre.MonedaID,
			Amo.Retencion, 			Amo.Interes
	  FROM AMORTIZAFONDEO Amo INNER JOIN CREDITOFONDEO Cre ON(Amo.CreditoFondeoID = Cre.CreditoFondeoID)
		WHERE Cre.CreditoFondeoID	= Par_CreditoFonID
			AND	Cre.Estatus = 'N'
			AND	Amo.Estatus	IN ('N')-- Vigentes
			AND Amo.FechaExigible > Var_FechaSistema
		ORDER BY Amo.FechaExigible;

DECLARE CURSORFECHAS CURSOR FOR
	SELECT  Amo.CreditoFondeoID,	Amo.AmortizacionID,		Amo.FechaInicio,		Amo.FechaVencimiento,	Amo.FechaExigible
	  FROM AMORTIZAFONDEO Amo INNER JOIN CREDITOFONDEO Cre ON(Amo.CreditoFondeoID = Cre.CreditoFondeoID)
		WHERE Cre.CreditoFondeoID	= Par_CreditoFonID
			AND	Cre.Estatus = 'N'
			AND	Amo.Estatus	IN ('N')-- Vigentes
			AND Amo.FechaExigible > Var_FechaSistema
		ORDER BY Amo.FechaExigible;

-- Asignacion de Constantes
SET Cadena_Vacia    	:= '';              	-- Cadena Vacia
SET Fecha_Vacia     	:= '1900-01-01';    	-- Fecha Vacia
SET Entero_Cero			:= 0;					-- Entero en Cero
SET Decimal_Cero    	:= 0.00;            	-- Decimal en Cero
SET SiPagaIVA       	:= 'S';             	-- El Cliente si Paga IVA
SET SalidaSI        	:= 'S';             	-- El Store si Regresa una Salida
SET SalidaNO        	:= 'N';             	-- El Store no Regresa una Salida
SET Esta_Pagado     	:= 'P';             	-- Estatus del Credito: Pagado
SET Esta_Activo     	:= 'A';             	-- Estatus: Activo
SET Esta_Vencido    	:= 'B';             	-- Estatus del Credito: Vencido
SET Esta_Vigente    	:= 'N';             	-- Estatus del Credito: Vigente
SET Esta_Atrasado		:= 'A';     			-- Estatus: Atrasado
SET NO_EsGrupal     	:= 'N';             	-- El Credito No es Grupal
SET AltaPoliza_SI   	:= 'S';             	-- SI dar de alta la Poliza Contable
SET AltaPoliza_NO   	:= 'N';             	-- NO dar de alta la Poliza Contable
SET Pol_Automatica  	:= 'A';             	-- Tipo de Poliza: Automatica
SET Mon_MinPago     	:= 0.01;            	-- Monto Minimo para Aceptar un Pago
SET Tol_DifPago     	:= 0.02;            	-- Minimo de la deuda para marcarlo como Pagado
SET Nat_Cargo       	:= 'C';             	-- Naturaleza de Cargo
SET Nat_Abono       	:= 'A';					-- Naturaleza de Abono
SET Aho_PagoCred    	:= '101';           	-- Concepto de Pago de Credito
SET Con_AhoCapital  	:= 1;               	-- Concepto de Ahorro: Capital
SET AltaMovAho_SI   	:= 'S';             	-- Alta del Movimiento de Ahorro: SI
SET Tasa_Fija       	:= 1;               	-- Tipo de Tasa de Interes: Fija
SET Coc_PagoCred    	:= 54;              	-- Concepto Contable: Pago de Credito
SET Ref_PagAnti     	:= 'PAGO ANTICIPADO CREDITO PASIVO';
SET Con_PagoCred    	:= 'PAGO DE CREDITO PASIVO';
SET Aud_ProgramaID  	:= 'PREPAGOPASIVOSIGCPRO';
SET NoManejaLinea		:= 'N';	            	-- No maneja linea
SET SiManejaLinea		:= 'S';	            	-- Si maneja linea
SET SiEsRevolvente		:= 'S';	            	-- Si Es Revolvente
SET NoEsRevolvente		:= 'N';	            	-- No Es Revolvente
SET AltaMov_NO      	:= 'N';          		-- Alta de Movimientos: NO
SET TipoActInteres		:= 1;					-- Tipo de Actualizacion (intereses)
SET Cons_Si				:= 'S';
SET Cons_No				:= 'N';
SET Frec_Unico			:= 'U';					-- Frecuencia Unica
SET Si_EsReestruc   	:= 'S';
SET FechaReal			:= 'R';
SET RevPagoCuota		:= 'P';				/* Revolvencia En cada pago de cuota*/
SET RevLiqCre   		:= 'L';				/* Al liquidar el credito*/
SET NoAplicaRev			:= 'N';				/* No Aplica Revolvencia*/
SET Des_PagoCred    	:= 'PAGO DE CREDITO PASIVO';
SET MovTesoPago			:= '31';			/* Indica el tipo de movimiento de tesoreria pago de credito pasivo tabla TIPOSMOVTESO */
SET ConContaPagoCre		:= 26;				-- Concepto Contable de Cartera: Pago de Credito Pasivo - CONCEPTOSCONTA
SET Var_MonedaNaID  	:= 1;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PREPAGOPASIVOSIGCPRO');
		END;

	SET	Par_NumErr	:= Entero_Cero;

	SELECT
			FechaSistema,		DiasCredito,		DivideIngresoInteres
	INTO 	Var_FechaSistema,	Var_DiasCredito,	Var_DivContaIng
		FROM PARAMETROSSIS;

	DELETE FROM TMPAMORTICRE
		WHERE Transaccion = Aud_NumTransaccion;

	IF (IFNULL(Par_MontoPagar,Decimal_Cero) = Decimal_Cero) THEN
		SET Par_NumErr		:= 1;
		SET Par_ErrMen		:= 'El monto a Pagar no puede ser Cero.';
		SET Par_Consecutivo	:= 0;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_MontoPagar,Decimal_Cero) < Decimal_Cero) THEN
		SET Par_NumErr		:= 2;
		SET Par_ErrMen		:= 'El monto a Pagar no puede ser menor a Cero.';
		SET Par_Consecutivo	:= 0;
		LEAVE ManejoErrores;
	END IF;

	-- se obtienen los valores requeridos para las operaciones del sp
	SELECT	Cre.Estatus,		Cre.MonedaID,		IFNULL(PagaIVA,Cons_No),		Cre.InstitutFondID,				PlazoContable,
			TipoInstitID,		NacionalidadIns,	IFNULL(PorcentanjeIVA/100,0),	IFNULL(EsRevolvente,Cons_No),	TipoRevolvencia,
			Cre.LineaFondeoID,  Cre.Monto,			IFNULL(ins.CobraISR,Cons_No),	Cre.TipoFondeador,				Cre.Refinancia
			INTO
			Var_EstatusCre,		Var_MonedaID,		Var_PagaIva,					Var_InstitutFondID,				Var_PlazoContable,
			Var_TipoInstitID,	Var_NacionalidadIns,Var_IVA,				 		Var_EsRevolvente,				Var_TipoRevol,
			Var_LineaFondeoID,	Var_MontoOtorga,	Var_CobraISR,					Var_TipoFondeo,					Var_Refinancia
		FROM CREDITOFONDEO Cre INNER JOIN LINEAFONDEADOR Lin ON(Cre.LineaFondeoID = Lin.LineaFondeoID)
			INNER JOIN INSTITUTFONDEO ins ON(Lin.InstitutFondID = ins.InstitutFondID)
		WHERE Cre.CreditoFondeoID = Par_CreditoFonID;

	/* se compara para saber si el credito pasivo paga o no iva*/
	IF(Var_PagaIva != Cons_Si) THEN
		SET Var_IVA := Decimal_Cero;
	ELSE
		SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
	END IF;

	-- Revisamos si es una Liquidacion Anticipada o Finiquito
	SET Con_PagoCred := CONCAT("PREPAGO. ", Con_PagoCred);

	-- Se obtiene el total del adeudo
	SELECT
		ROUND(IFNULL(SUM(
			ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasad,2) +
			ROUND(SaldoInteresPro + SaldoInteresAtra,2) +
			ROUND(ROUND(SaldoInteresPro + SaldoInteresAtra, 2) * Var_IVA, 2) +
			ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_IVA,2) +
			ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_IVA,2) +
			ROUND(SaldoMoratorios,2) + ROUND(ROUND(SaldoMoratorios,2) * Var_IVA,2)), Entero_Cero), 2)
	INTO Var_MontoDeuda
		FROM AMORTIZAFONDEO
			WHERE CreditoFondeoID = Par_CreditoFonID
				AND Estatus != Esta_Pagado;

	IF(Par_MontoPagar >= Var_MontoDeuda) THEN
		SET Par_NumErr      := 3;
		SET Par_ErrMen      := 'Para Liquidar el Credito, Por Favor Seleccione la Opcion Total Adeudo.' ;
		SET Par_Consecutivo	:= 0;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_EstatusCre, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr		:= 4;
		SET Par_ErrMen		:= 'El Credito indicado no Existe.';
		SET Par_Consecutivo	:= 0;
		LEAVE ManejoErrores;
	END IF;

	/* valida estatus */
	IF(Var_EstatusCre != Esta_Vigente) THEN
		SET Par_NumErr		:= 5;
		SET Par_ErrMen		:= 'El Credito tiene un estatus incorrecto o ya se encuentra pagado.';
		SET Par_Consecutivo	:= 0;
		LEAVE ManejoErrores;
	END IF;

	/* si la linea de credito es revolvente se valida recibir un tipo de revolvencia valido*/
	IF (Var_EsRevolvente = Cons_Si) THEN
		IF(Var_TipoRevol NOT IN (RevPagoCuota,RevLiqCre,NoAplicaRev)) THEN
			SET Par_NumErr		:= 6;
			SET Par_ErrMen		:= 'El Tipo de Revolvencia de la Linea No es Valido.';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- SE OBTIENEN EL NÚMERO DE AMORTIZACIONES ATRASADAS
	SELECT COUNT(AmortizacionID) INTO Var_NumAtrasos
		FROM AMORTIZAFONDEO
		WHERE CreditoFondeoID = Par_CreditoFonID
		  AND FechaExigible <= Var_FechaSistema
		  AND Estatus != Esta_Pagado;

	SET Var_NumAtrasos := IFNULL(Var_NumAtrasos, Entero_Cero);

	IF(Var_NumAtrasos > Entero_Cero) THEN
		SET Par_NumErr      := 7;
		SET Par_ErrMen      := 'Antes de Realizar un PrePago, Por Favor realice el Pago de lo Exigible y en Atraso.' ;
		SET Par_Consecutivo	:= 0;
		LEAVE ManejoErrores;
	END IF;

	CALL DIASFESTIVOSCAL(
		Var_FechaSistema,	Entero_Cero,		Var_FecAplicacion,			Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	/* si el parametro lo indica se da de alta el encabezado de la poliza */
	IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
		CALL MAESTROPOLIZASALT(
			Var_Poliza,				Par_EmpresaID,		Var_FecAplicacion,		Pol_Automatica,		ConContaPagoCre,
			Con_PagoCred,			Cons_No,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
			IF(Par_NumErr!= Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
	END IF;


	SET Var_SaldoPago	:= Par_MontoPagar;
	SET Var_CreditoStr	:= CONVERT(Par_CreditoFonID, CHAR(15));
	SET Par_NumErr		:= Entero_Cero;
	SET Par_ErrMen		:= 'PrePago de Credito Aplicado Exitosamente.';
	SET Var_PagoPesos 	:= 0;

	OPEN CURSORAMORTI;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		CICLO:LOOP

		FETCH CURSORAMORTI INTO
			Var_CreditoFonID,       Var_AmortizacionID,     Var_SaldoCapVigente,    Var_SaldoCapAtrasad,
			Var_SaldoInteresOrd,    Var_SaldoInteresAtr,    Var_SaldoMoratorios,    Var_SaldoComFaltaPa,
			Var_SaldoOtrasComis,    Var_MonedaID,           Var_Retencion,			Var_InteresOri;

		-- Inicializaciones
		SET Var_CantidPagar		:= Decimal_Cero;
		SET Var_IVACantidPagar	:= Decimal_Cero;
		SET Var_CantidRetener	:= Decimal_Cero;
		SET Var_SaldoComFaltaPa	:= IFNULL(Var_SaldoComFaltaPa, Decimal_Cero);
		SET Var_Retencion		:= IFNULL(Var_Retencion, Decimal_Cero);

		/* Se convierte el numero de cuenta de institucion a char para utilizarlo en la referencia */
		SET Var_NumCtaInstitStr := CONVERT(Par_NumCtaInstit,CHAR);

		IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

		SELECT 		FechaRegistro, 			TipCamDof,		TipCamFixCom
		 	INTO 	Var_FechaRegistro, 		Var_TipCamDof,	Var_TipCamFixCom
		FROM MONEDAS 
		WHERE MonedaId = Par_MonedaID;

		/* Pago de de Interes Ordinario */
		IF (Var_SaldoInteresOrd >= Mon_MinPago) THEN
			SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresOrd, 2) *  Var_IVA), 2);

			IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoInteresOrd + Var_IVACantidPagar)) THEN
				SET	Var_CantidPagar		:=  Var_SaldoInteresOrd;
			ELSE
				SET	Var_CantidPagar		:= Var_SaldoPago -
										   ROUND(((Var_SaldoPago)/(1+Var_IVA)) * Var_IVA, 2);

				SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVA)) * Var_IVA, 2);
			END IF;

			IF(Var_MonedaID != Var_MonedaNaID) THEN
				SET Var_PagoPesos :=Var_PagoPesos + ((Var_CantidPagar*Var_TipCamFixCom) + (Var_IVACantidPagar*Var_TipCamFixCom));
			ELSE
				SET Var_PagoPesos := Var_PagoPesos + ((Var_CantidPagar) + (Var_IVACantidPagar));
			END IF;

			/* Se manda a llamar al sp que hace el pago de interes provisionado, aplica
			** movimientos operativos y contables */
			CALL PAGCREFONINTPROPRO(
				Var_CreditoFonID,		Var_AmortizacionID,		Var_MonedaID,		Var_InstitutFondID,		Par_InstitucionID,
				Par_NumCtaInstit,		Var_PlazoContable,		Var_TipoInstitID,	Var_NacionalidadIns,	Des_PagoCred,
				Var_TipoFondeo,			Var_Poliza,				Var_CantidPagar,	Var_IVACantidPagar,		Var_FechaSistema,
				Var_FecAplicacion,		Var_NumCtaInstitStr,	Cons_No,			Par_NumErr,				Par_ErrMen,
				Par_Consecutivo,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del ciclo */
				SET Par_Consecutivo := Entero_Cero;
				LEAVE CICLO;
			ELSE
				SET Par_NumErr	:= 0;
			END IF;

			-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
			IF NOT EXISTS(SELECT Tem.Transaccion
							FROM TMPAMORTICRE Tem
							WHERE Tem.Transaccion = Aud_NumTransaccion
							  AND Tem.AmortizacionID = Var_AmortizacionID
							  AND Tem.CreditoID = Var_CreditoFonID) THEN

				INSERT INTO `TMPAMORTICRE`	(
						`Transaccion`,					`AmortizacionID`,					`CreditoID`)
				VALUES(
					Aud_NumTransaccion, Var_AmortizacionID, Var_CreditoFonID );
			END IF;


			SET Var_SaldoPago	:= Var_SaldoPago - (ROUND(Var_CantidPagar, 2) + Var_IVACantidPagar);

			-- Realizamos la Retencion de Interes, si es que Aplica Retencion
			IF ( Var_Retencion >= Mon_MinPago AND Var_CobraISR = Cons_Si) THEN
				SET Var_CantidRetener   := ROUND((Var_CantidPagar/Var_InteresOri) * Var_Retencion, 2);

				SET Var_TotalRetener    := Var_TotalRetener + Var_CantidRetener;

				IF(Var_MonedaID != Var_MonedaNaID) THEN
					SET Var_PagoPesos := Var_PagoPesos - (Var_CantidRetener*Var_TipCamFixCom);
				ELSE
					SET Var_PagoPesos := Var_PagoPesos - Var_CantidRetener;
				END IF;

				/* Se manda a llamar al sp que hace la Retencion de Interes, Realiza
				** movimientos operativos y contables */
				CALL PAGCREFONINTRETPRO(
					Var_CreditoFonID,		Var_AmortizacionID,		Var_MonedaID,		Var_InstitutFondID,		Par_InstitucionID,
					Par_NumCtaInstit,		Var_PlazoContable,		Var_TipoInstitID,	Var_NacionalidadIns,	Des_PagoCred,
					Var_TipoFondeo,			Var_Poliza,				Var_CantidRetener,	Entero_Cero,			Var_FechaSistema,
					Var_FecAplicacion,		Var_NumCtaInstitStr,	Cons_No,			Par_NumErr,				Par_ErrMen,
					Par_Consecutivo,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del ciclo */
					SET Par_Consecutivo := Entero_Cero;
					LEAVE CICLO;
				ELSE
					SET Par_NumErr	:= 0;
				END IF;
			END IF; -- EndIF de la Retencion

			/* si ya no hay saldo para aplicar se sale del ciclo */
			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF; /*fin de cobro de saldo de Interes Ordinario */

		/*Pago de Capital Vigente */
		IF (Var_SaldoCapVigente >= Mon_MinPago) THEN
			IF(Var_SaldoPago	>= Var_SaldoCapVigente) THEN
				SET	Var_CantidPagar		:= Var_SaldoCapVigente;
			ELSE
				SET	Var_CantidPagar		:= Var_SaldoPago;
			END IF;
			SET Var_IVACantidPagar	:= Decimal_Cero;

			IF(Var_MonedaID != Var_MonedaNaID) THEN
				SET Var_PagoPesos :=Var_PagoPesos + (Var_CantidPagar*Var_TipCamFixCom) ;
			ELSE
				SET Var_PagoPesos := Var_PagoPesos + (Var_CantidPagar) ;
			END IF;

			/* Se manda a llamar al sp que hace el pago de capital vigente, aplica
			** movimientos operativos y contables */
			CALL PAGCREFONCAPVIGPRO(
				Var_CreditoFonID,		Var_AmortizacionID,			Var_MonedaID,		Var_InstitutFondID,			Par_InstitucionID,
				Par_NumCtaInstit,		Var_PlazoContable,			Var_TipoInstitID,	Var_NacionalidadIns,		Des_PagoCred,
				Var_TipoFondeo,			Var_Poliza,					Var_CantidPagar,	Var_IVACantidPagar,			Var_FechaSistema,
				Var_FecAplicacion,		Var_NumCtaInstitStr,		Cons_No,			Par_NumErr,					Par_ErrMen,
				Par_Consecutivo,		Par_EmpresaID,				Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del ciclo */
				SET Par_Consecutivo := Entero_Cero;
				LEAVE CICLO;
			ELSE
				SET Par_NumErr	:= 0;
			END IF;

			-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
			IF NOT EXISTS(SELECT Tem.Transaccion
							FROM TMPAMORTICRE Tem
							WHERE Tem.Transaccion = Aud_NumTransaccion
							  AND Tem.AmortizacionID = Var_AmortizacionID
							  AND Tem.CreditoID = Var_CreditoFonID) THEN

				INSERT INTO `TMPAMORTICRE`	(
						`Transaccion`,					`AmortizacionID`,					`CreditoID`)
				VALUES(
					Aud_NumTransaccion, Var_AmortizacionID, Var_CreditoFonID );
			END IF;

			/* Se llama al metodo para aplicar la Revolvencia, si la Revolvencia es en Cada Pago de Capital */
			IF (Var_EsRevolvente = Cons_Si AND Var_TipoRevol = RevPagoCuota) THEN
				CALL CREFONAPLICAREVPRO(
					Var_LineaFondeoID,  Var_CantidPagar,    Par_MonedaID,       Var_InstitutFondID,
					Var_FechaSistema,   Var_CreditoFonID,   Var_Poliza,         Cons_No,
					Var_Poliza,         Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
					Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

					IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del ciclo */
						SET Par_Consecutivo := Entero_Cero;
						LEAVE CICLO;
					ELSE
						SET Par_NumErr	:= 0;
					END IF;
			END IF;

			SET Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

			/* si ya no hay saldo para aplicar se sale del ciclo */
			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;
		END IF; -- EndIF Var_SaldoCapVigente >= Mon_MinPago

		END LOOP CICLO;
	END;
	CLOSE CURSORAMORTI;

	IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
		LEAVE TerminaStore;
	END IF;

	IF(Var_SaldoPago < Entero_Cero) THEN
		SET Var_SaldoPago   := Entero_Cero;
	END IF;

	SET Var_MontoPago	 := Par_MontoPagar - ROUND(Var_SaldoPago,2);

	IF (Var_MontoPago	<= Decimal_Cero) THEN
		SET Par_NumErr      := 8;
		SET Par_ErrMen      := 'El Credito no Presenta Adeudos.';
		LEAVE ManejoErrores;
	ELSE

		-- Marcamos como Pagadas las Amortizaciones que hayan sido afectadas en el Prepago y
		-- Que no Presenten adeudos
		UPDATE AMORTIZAFONDEO Amo, TMPAMORTICRE Tem  SET
			Amo.Estatus			= Esta_Pagado,
			Amo.FechaLiquida	= Var_FechaSistema
			WHERE (Amo.SaldoCapVigente + Amo.SaldoCapAtrasad + Amo.SaldoInteresPro +
					Amo.SaldoInteresAtra + Amo.SaldoMoratorios + Amo.SaldoComFaltaPa +
					Amo.SaldoOtrasComis) <= Tol_DifPago
				AND Amo.CreditoFondeoID = Par_CreditoFonID
				AND Amo.Estatus != Esta_Pagado
				AND Tem.Transaccion = Aud_NumTransaccion    -- Futuras que no Tienen Capital que son de Solo Interes
				AND Tem.AmortizacionID = Amo.AmortizacionID  -- Amortizaciones que hayan Sido Afectada con el Prepago
				AND Tem.CreditoID = Amo.CreditoFondeoID;      -- Para evitar Marcar Como Pagadas, aquellas Amortizaciones

		# Consulta las amortizaciones que no estan pagadas
		SELECT COUNT(DISTINCT(AmortizacionID)) INTO Var_NumAmorti
			FROM AMORTIZAFONDEO
			WHERE CreditoFondeoID = Par_CreditoFonID
				AND Estatus	IN(Esta_Vigente, Esta_Atrasado, Esta_Vencido );

		SET Var_NumAmorti := IFNULL(Var_NumAmorti, Entero_Cero);

		# Verifica que no se haya prepagado el total del crédito pasivo
		IF (Var_NumAmorti = Entero_Cero) THEN
			SET Par_NumErr      := 9;
			SET Par_ErrMen      := 'Para Liquidar el Credito, Por Favor Seleccione la Opcion Total Adeudo.' ;
			LEAVE ManejoErrores;
		END IF;


		/* Se hace el movimiento operativo y contable de tesoreria */
		/* Se afecta la Cuenta de Bancos por el monto del Pago - La Retencion */
		SET Var_TotalBancos := IFNULL(Var_PagoPesos, Entero_Cero);

		CALL CONTAFONDEOPRO(
			Var_MonedaID,           Entero_Cero,        Var_InstitutFondID,     Par_InstitucionID,
			Par_NumCtaInstit,       Par_CreditoFonID,   Var_PlazoContable,      Var_TipoInstitID,
			Var_NacionalidadIns,    Entero_Cero,        Con_PagoCred,           Var_FechaSistema,
			Var_FecAplicacion,      Var_FecAplicacion,  Var_TotalBancos,        Var_CreditoStr,
			Var_CreditoStr,         AltaPoliza_NO,      Entero_Cero,            Cadena_Vacia,
			Nat_Abono,              Cadena_Vacia,       Nat_Cargo,              Cons_Si,
			MovTesoPago,            Cons_No,            Entero_Cero,            Entero_Cero,
			Cons_No,                Var_TipoFondeo,     Cons_No,                Var_Poliza,
			Par_Consecutivo,        Par_NumErr,         Par_ErrMen,             Par_EmpresaID,
			Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
			Aud_Sucursal,           Aud_NumTransaccion);

	END IF;

	SET	Var_FechaIniCal := Var_FechaSistema;

	-- Cursor para ReCalendarizar las Fechas de Inicio de las Cuotas, para poder devengar correctamente los intereses
	OPEN CURSORFECHAS;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		CICLOFECHAS:LOOP

		FETCH CURSORFECHAS INTO
			Var_CreditoFonID,	Var_AmortizacionID,		Var_FechaInicio,	Var_FechaVencim,	Var_FechaExigible;

		SET	Var_EstAmorti	:= Cadena_Vacia;

		IF(Var_FechaInicio >= Var_FechaSistema) THEN
			SET Var_EstAmorti := (SELECT Estatus FROM AMORTIZAFONDEO
									WHERE CreditoFondeoID = Par_CreditoFonID
										AND FechaVencimiento = Var_FechaInicio);
			SET Var_EstAmorti := IFNULL(Var_EstAmorti, Cadena_Vacia);

			IF(Var_EstAmorti = Esta_Pagado) THEN
				UPDATE AMORTIZAFONDEO SET
					FechaInicio = Var_FechaIniCal
					WHERE CreditoFondeoID = Par_CreditoFonID
						AND AmortizacionID = Var_AmortizacionID;

				SET	Var_FechaIniCal := Var_FechaVencim;
			END IF;
		END IF;
		END LOOP CICLOFECHAS;
	END;
	CLOSE CURSORFECHAS;

	DELETE FROM TMPAMORTICRE
		WHERE Transaccion = Aud_NumTransaccion;

	-- Actualizacion de los intereses
    IF(Var_Refinancia = Cons_Si) THEN
		# Recalculo de intereses con refinanciamiento
		CALL AMORTIZAFONDEOACT(
			Par_CreditoFonID,	TipoActInteres,			FechaReal,				SalidaNo,			Par_NumErr,
            Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
	ELSE
		# Recalculo de intereses sin refinanciamiento
		CALL AMORTIZAFONDEOSRACT(
			Par_CreditoFonID,	TipoActInteres,    		SalidaNO,				Par_NumErr, 		Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP, 	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);
    END IF;

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen 	:= 'PrePago de Credito Aplicado Exitosamente.';

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Poliza AS control,
			Aud_NumTransaccion AS consecutivo;
END IF;

END TerminaStore$$
