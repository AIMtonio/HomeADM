-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDITOFONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDITOFONPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGOCREDITOFONPRO`(
	/* SP que se utiliza para la aplicacion del pago de credito Pasivo*/
	Par_CreditoFonID	BIGINT(20),		/* ID del credito Pasivo*/
	Par_MontoPagar    	DECIMAL(12, 2),	/* Monto a Pagar */
	Par_MonedaID		INT,			/*Identificador de la moneda*/
	Par_Finiquito		CHAR(1),		/* Indica si se trata de un Finiquito*/
	Par_AltaEncPoliza	CHAR(1),		/* Indica si se dara o no de alta un encabezado de poliza */

	Par_InstitucionID	INT(11),		/* Numero de Institucion (INSTITUCIONES) */
	Par_NumCtaInstit	VARCHAR(20),	/* Numero de Cuenta Bancaria. */
	Par_Salida			CHAR(1),			-- Parametro de Salida
	INOUT Var_MontoPago	DECIMAL(12, 2),		-- Parametro Monto de Pago
	INOUT Var_Poliza	BIGINT(20),			-- Parametro de Poliza

	INOUT Par_NumErr		INT(11),		-- Parametro de Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de Mensaje de Error
	INOUT Par_Consecutivo	BIGINT,			-- Parametro Consecutivo

	Par_EmpresaID		INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_PagaIva 		CHAR(1);			/* Guarda el valor para saber si el credito paga IVA*/
	DECLARE Var_IVA 			DECIMAL(12,2);		/* Guarda el valor del IVA */
	DECLARE Var_InstitutFondID	INT(11);			/* Guarda el valor de la institucion de fondeo */
	DECLARE Var_PlazoContable	CHAR(1);			/* Guarda el valor de plazo contable C.- Corto plazo L.- Largo Plazo*/
	DECLARE Var_TipoInstitID	INT(11);			/* Guarda el valor tipo de institucion */

	DECLARE Var_NacionalidadIns	CHAR(1);			/* Guarda el valor de nacionalidad de la institucion*/
	DECLARE Var_NumCtaInstitStr VARCHAR(50);		/* Numero de cuenta Institucion convertida a caracter */
	DECLARE Var_CreditoStr		VARCHAR(20);
	DECLARE Var_CantidPagar     DECIMAL(14,2);
	DECLARE Var_CantidRetener   DECIMAL(14,2);
	DECLARE Var_TotalRetener    DECIMAL(14,2);
	DECLARE Var_TotalBancos     DECIMAL(14,2);
	DECLARE Var_CreditoFonID 	BIGINT(20);			/*se usa en el cursor */


	DECLARE Var_AmortizacionID	DECIMAL(12, 2);
	DECLARE Var_SaldoCapVigente	DECIMAL(12, 2);
	DECLARE Var_SaldoCapAtrasad	DECIMAL(12, 2);
	DECLARE Var_SaldoInteresOrd	DECIMAL(12, 2);
	DECLARE Var_SaldoInteresAtr	DECIMAL(12, 2);

	DECLARE Var_SaldoMoratorios	DECIMAL(12, 2);
	DECLARE Var_SaldoComFaltaPa	DECIMAL(12, 2);
	DECLARE Var_SaldoOtrasComis	DECIMAL(12, 2);
	DECLARE Var_EstatusCre      CHAR(1);
	DECLARE Var_MonedaID        INT;

	DECLARE Var_SaldoPago       DECIMAL(12, 2);
	DECLARE Var_IVACantidPagar  DECIMAL(12, 2);
	DECLARE Var_TotalExigible	DECIMAL(12, 2);
	DECLARE Var_FechaSistema    DATE;
	DECLARE Var_FecAplicacion   DATE;
	DECLARE Var_EsHabil			CHAR(1);
	DECLARE Var_MontoOtorga     DECIMAL(14,2);

	DECLARE Var_NumAmorti		INT;				/* Para guardar el numero de amortizaciones*/
	DECLARE Var_LineaFondeoID	INT;				/* Linea de fondeo ID */
	DECLARE Var_NumAmoPag		INT;
	DECLARE Var_MontoDeuda      DECIMAL(14,2);
	DECLARE Var_Retencion		DECIMAL(14,2);
	DECLARE Var_InteresOri		DECIMAL(14,2);
	DECLARE Var_EsRevolvente	CHAR(1);
	DECLARE Var_TipoRevol		CHAR(1);			/* Tipo de Revolvencia*/

	/* Declaracion de Constantes*/
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Var_SI				CHAR(1);

	DECLARE Var_NO				CHAR(1);
	DECLARE ConContaPagoCre    	INT;				-- Concepto Contable de Cartera: Pago de Credito Pasivo - CONCEPTOSCONTA
	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE AltaPoliza_SI   	CHAR(1);
	DECLARE Est_Vigente    		CHAR(1);

	DECLARE Est_Pagado     		CHAR(1);
	DECLARE Mon_MinPago     	DECIMAL(12,2);		/*Monto minimo para pago de credito */
	DECLARE Nat_Cargo       	CHAR(1);			/* Naturaleza de Cargo*/
	DECLARE Nat_Abono     	 	CHAR(1);			/* Naturaleza de Abono*/
	DECLARE MovTesoPago			CHAR(4);			/* Indica el tipo de movimiento de tesoreria pago de credito pasivo tabla TIPOSMOVTESO */

	DECLARE Par_SalidaNO    	CHAR(1);
	DECLARE Par_SalidaSI    	CHAR(1);
	DECLARE AltaPoliza_NO   	CHAR(1);
	DECLARE AltaMovCre_SI   	CHAR(1);
	DECLARE AltaMovCre_NO   	CHAR(1);

	DECLARE Finiquito_SI    	CHAR(1);
	DECLARE Finiquito_NO    	CHAR(1);
	DECLARE Tol_DifPago			DECIMAL(10,4);
	DECLARE Des_PagoCred   	 	VARCHAR(50);
	DECLARE Con_PagoCred    	VARCHAR(50);

	DECLARE RevPagoCuota    CHAR(1);            	/* Revolvencia En cada pago de cuota */
	DECLARE RevLiqCre       CHAR(1);            	/* Al liquidar el credito */
	DECLARE NoAplicaRev     CHAR(1);            	/* No Aplica Revolvencia */
	DECLARE Var_MonedaNaID 		INT(11);			/* ID de Moneda Nacionald */
	DECLARE Var_CobraISR    CHAR(1);            	/* No cobra ISR */
	DECLARE Var_TipoFondeo  CHAR(1);            	/* Tipo de Operacion: I-Inversionista, F.- Fondeador */
	DECLARE Var_Control		VARCHAR(100);

	DECLARE Var_FechaRegistro	DATE;
	DECLARE Var_FechaSis		DATE;
	DECLARE Var_TipCamDof 		DECIMAL(14,2);		/* Tipo de Cambio para moneda extranjera */
	DECLARE Var_TipCamFixCom	DECIMAL(14,2);		-- Tipo de cambio compra Fix
	DECLARE Var_PagoPesos		DECIMAL(14,2);

	/* declaracion de cursores */
	DECLARE CURSORAMORTI CURSOR FOR
		SELECT  Amo.CreditoFondeoID,	Amo.AmortizacionID,		Amo.SaldoCapVigente,	Amo.SaldoCapAtrasad,	Amo.SaldoInteresPro,
				Amo.SaldoInteresAtra,	Amo.SaldoMoratorios,	Amo.SaldoComFaltaPa,    Amo.SaldoOtrasComis,    Cre.MonedaID,
				Amo.Retencion, 			Amo.Interes
			FROM AMORTIZAFONDEO Amo,
				 CREDITOFONDEO	Cre
			WHERE	Amo.CreditoFondeoID = Cre.CreditoFondeoID
			  AND	Cre.CreditoFondeoID	= Par_CreditoFonID
			  AND	Cre.Estatus		= 'N'
			  AND	(	Amo.Estatus		= 'A'           -- En Atraso
			  OR		Amo.Estatus		= 'N'	)         -- Vigente
			ORDER BY Amo.FechaExigible;

	-- Asignacion de Constantes
	SET Cadena_Vacia	:= '';				-- String Vacio
	SET Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero		:= 0;				-- Entero en Cero
	SET Decimal_Cero	:= 0.00;			  -- Decimal Cero
	SET Var_NO			:= 'N';				/* Valor NO */

	SET Var_SI			:= 'S';				/* Valor SI */
	SET ConContaPagoCre	:= 26;				-- Concepto Contable de Cartera: Pago de Credito Pasivo - CONCEPTOSCONTA
	SET Pol_Automatica	:= 'A';				-- Tipo de Poliza: Automatica
	SET AltaPoliza_SI	:= 'S';				-- Alta de la Poliza Contable: SI
	SET Est_Vigente		:= 'N';				-- Estatus Vigente

	SET Est_Pagado		:= 'P';				-- Estatus Pagado
	SET MovTesoPago		:= '31';			/* Indica el tipo de movimiento de tesoreria pago de credito pasivo tabla TIPOSMOVTESO */
	SET Par_SalidaNO	:= 'N';				-- Ejecutar Store sin Regreso o Mensaje de Salida
	SET Par_SalidaSI	:= 'S';				  -- Ejecutar Store Con Regreso o Mensaje de Salida
	SET Finiquito_SI	:= 'S';				-- SI es un Finiquito o Liquidacion Total Anticipada

	SET Finiquito_NO    := 'N';				-- NO es un Finiquito o Liquidacion Total Anticipada
	SET AltaPoliza_NO   := 'N';				-- Alta de la Poliza Contable: NO
	SET AltaMovCre_NO   := 'N';				-- Alta de los Movimientos de Credito: NO
	SET AltaMovCre_SI   := 'S';				-- Alta de los Movimientos de Credito: SI
	SET Nat_Cargo       := 'C';			   -- Naturaleza de Cargo

	SET Nat_Abono       := 'A';			   -- Naturaleza de Abono.
	SET Tol_DifPago     := 0.02;
	SET Mon_MinPago     := 0.01;
	SET Des_PagoCred    := 'PAGO DE CREDITO PASIVO';
	SET Con_PagoCred    := 'PAGO DE CREDITO PASIVO';

	SET Aud_ProgramaID  := 'PAGOCREDITOFONPRO';
	SET RevPagoCuota	:= 'P';				/* Revolvencia En cada pago de cuota*/
	SET RevLiqCre   	:= 'L';				/* Al liquidar el credito*/
	SET NoAplicaRev		:= 'N';				/* No Aplica Revolvencia*/
	SET Var_MonedaNaID  := 1;

	-- Inicializaciones
	SET Var_TotalRetener    := Entero_Cero;
	SET Var_TotalBancos     := Entero_Cero;
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDITOFONPRO');
			SET Var_Control := 'sqlException';
		END;

		SELECT FechaSistema INTO Var_FechaSistema
			FROM PARAMETROSSIS;

		DELETE FROM TMPAMORTICRE
			WHERE Transaccion = Aud_NumTransaccion;

		IF (IFNULL(Par_MontoPagar,Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El monto a Pagar no puede ser Cero';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_MontoPagar,Decimal_Cero) < Decimal_Cero) THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'El monto a Pagar no puede ser menor a  Cero';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		-- se obtienen los valores requeridos para las operaciones del sp
		SELECT	Cre.Estatus,		Cre.MonedaID,		IFNULL(PagaIVA,Var_NO),			Cre.InstitutFondID,				PlazoContable,
				TipoInstitID,		NacionalidadIns,	IFNULL(PorcentanjeIVA/100,0),	IFNULL(EsRevolvente,Var_NO),	TipoRevolvencia,
				Cre.LineaFondeoID,  Cre.Monto,			IFNULL(ins.CobraISR,Var_NO),    Cre.TipoFondeador
				INTO
				Var_EstatusCre,		Var_MonedaID,		Var_PagaIva,					Var_InstitutFondID,				Var_PlazoContable,
				Var_TipoInstitID,	Var_NacionalidadIns,Var_IVA,				 		Var_EsRevolvente,				Var_TipoRevol,
				Var_LineaFondeoID,	Var_MontoOtorga,	Var_CobraISR,   Var_TipoFondeo
			FROM CREDITOFONDEO Cre,
				 LINEAFONDEADOR Lin,
				 INSTITUTFONDEO ins
			WHERE Cre.CreditoFondeoID = Par_CreditoFonID
			 AND Cre.LineaFondeoID 	= Lin.LineaFondeoID
			 AND ins.InstitutFondID = Lin.InstitutFondID;

		/* se compara para saber si el credito pasivo paga o no iva*/
		IF(Var_PagaIva <> Var_SI) THEN
			SET Var_IVA := Decimal_Cero;
		ELSE
			SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
		END IF;

		-- Revisamos si es una Liquidacion Anticipada o Finiquito
		 IF( Par_Finiquito = Finiquito_SI) THEN
			SET Con_PagoCred := CONCAT("LIQ ANTICIPADA. ", Con_PagoCred);

			SELECT   ROUND(
						IFNULL(
							SUM(
								ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasad,2) +
								ROUND(SaldoInteresPro + SaldoInteresAtra,2) +
								ROUND(ROUND(SaldoInteresPro + SaldoInteresAtra, 2) * Var_IVA, 2) +
								ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_IVA,2) +
								ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_IVA,2) +
								ROUND(SaldoMoratorios,2) + ROUND(ROUND(SaldoMoratorios,2) * Var_IVA,2)
								),
						Entero_Cero)
					, 2)
			INTO Var_MontoDeuda
			FROM AMORTIZAFONDEO
			WHERE CreditoFondeoID   =  Par_CreditoFonID
			  AND Estatus   <> Est_Pagado;


			IF(ABS(Var_MontoDeuda - Par_MontoPagar) > 0.05) THEN
				SET Par_NumErr		:= 100;
				SET Par_ErrMen		:= CONCAT('En una Liquidacion Anticipada el Monto de pago deber ser el Total ',
												 'del Adeudo. Adeudo Total: ', CONVERT(Var_MontoDeuda, CHAR),
												' .Monto del Pago: ', CONVERT(Par_MontoPagar, CHAR));
				SET Par_Consecutivo	:= 0;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		CALL DIASFESTIVOSCAL(
			Var_FechaSistema,	Entero_Cero,		Var_FecAplicacion,			Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(IFNULL(Var_EstatusCre, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr		:= 05;
			SET Par_ErrMen		:= 'El Credito indicado no Existe';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		/* valida estatus */
		IF(Var_EstatusCre != Est_Vigente) THEN
			SET Par_NumErr		:= 06;
			SET Par_ErrMen		:= 'El Credito tiene un estatus incorrecto o ya se encuentra pagado.';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		/* si la linea de credito es revolvente se valida recibir un tipo de revolvencia valido*/
		IF (Var_EsRevolvente = Var_SI) THEN
			IF(Var_TipoRevol != RevPagoCuota AND
				Var_TipoRevol != RevLiqCre    AND
				Var_TipoRevol != NoAplicaRev	 ) THEN
				SET Par_NumErr		:= 07;
				SET Par_ErrMen		:= 'El Tipo de Revolvencia de la Linea No es Valido';
				SET Par_Consecutivo	:= 0;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_MonedaID, Entero_Cero) <> Var_MonedaNaID) THEN
			SELECT 		FechaRegistro, 			TipCamDof,		TipCamFixCom
				 INTO 	Var_FechaRegistro, 		Var_TipCamDof,	Var_TipCamFixCom
				FROM MONEDAS
				WHERE MonedaId = Par_MonedaID;

			SELECT FechaSistema INTO Var_FechaSis FROM PARAMETROSSIS LIMIT 1;

			IF(Var_FechaRegistro <> Var_FechaSis )THEN
				SET	Par_NumErr := 08;
				SET	Par_ErrMen := CONCAT('La última actualización de la divisa fue el día ',CONVERT(Var_FechaRegistro, CHAR(15)));
				SET	Par_Consecutivo := 0;
				SET Var_Control		:='monedaID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		/* si el parametro lo indica se da de alta el encabezado de la poliza */
		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
			CALL MAESTROPOLIZASALT(
				Var_Poliza,				Par_EmpresaID,		Var_FecAplicacion,		Pol_Automatica,		ConContaPagoCre,
				Con_PagoCred,			Par_SalidaNO,		Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
				IF(Par_NumErr!= Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
		END IF;

		SET Var_SaldoPago       := Par_MontoPagar;
		SET Var_CreditoStr      := CONVERT(Par_CreditoFonID, CHAR(15));

		SET Var_PagoPesos := 0;

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
			SET Var_CantidRetener   := Decimal_Cero;
			SET Var_SaldoComFaltaPa := IFNULL(Var_SaldoComFaltaPa, Decimal_Cero);
			SET Var_Retencion := IFNULL(Var_Retencion, Decimal_Cero);


			/* Se convierte el numero de cuenta de institucion a char para utilizarlo en la referencia */

			SET Var_NumCtaInstitStr := CONVERT(Par_NumCtaInstit,CHAR);

			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

			-- Comision por Falta de Pago
			IF(Var_SaldoComFaltaPa >= Mon_MinPago) THEN
				SET Var_IVACantidPagar = ROUND((Var_SaldoComFaltaPa * Var_IVA), 2);

				IF(ROUND(Var_SaldoPago,2) >= (Var_SaldoComFaltaPa + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar := Var_SaldoComFaltaPa;
				ELSE
					SET Var_CantidPagar := ROUND(Var_SaldoPago,2) -
											ROUND(((Var_SaldoPago)/(1+Var_IVA)) * Var_IVA, 2);
					SET	 Var_IVACantidPagar := ROUND(((Var_SaldoPago)/(1+Var_IVA)) * Var_IVA, 2);
				END IF;

				IF(Var_MonedaID != Var_MonedaNaID) THEN
					SET Var_PagoPesos := Var_PagoPesos + ROUND(Var_CantidPagar*Var_TipCamFixCom,2) + ROUND(Var_IVACantidPagar*Var_TipCamFixCom,2);
				ELSE
					SET Var_PagoPesos := Var_PagoPesos + ROUND(Var_CantidPagar,2) + ROUND(Var_IVACantidPagar,2);
				END IF;
				/* Se manda a llamar al sp que hace el pago de la comision por falta de pago, aplica
				** movimientos operativos y contables */
				CALL PAGCREFONCOMFALPRO(
					Var_CreditoFonID,		Var_AmortizacionID,			Var_MonedaID,		Var_InstitutFondID,		Par_InstitucionID,
					Par_NumCtaInstit,		Var_PlazoContable,			Var_TipoInstitID,	Var_NacionalidadIns,	Des_PagoCred,
					Var_TipoFondeo,			Var_Poliza,					Var_CantidPagar,	Var_IVACantidPagar,		Var_FechaSistema,
					Var_FecAplicacion,		Var_NumCtaInstitStr,		Var_NO,				Par_NumErr,				Par_ErrMen,
					Par_Consecutivo,		Par_EmpresaID,				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion  );


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

				SET	Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);

				/* si ya no hay saldo para aplicar se sale del ciclo */
				IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;
			END IF;

			/*  Pago de moratorios */
			IF (Var_SaldoMoratorios >= Mon_MinPago) THEN
				SET	Var_IVACantidPagar := ROUND((Var_SaldoMoratorios *  Var_IVA), 2);

				IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoMoratorios + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar		:=  Var_SaldoMoratorios;
				ELSE
					SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
											   ROUND(((Var_SaldoPago)/(1+Var_IVA)) * Var_IVA, 2);

					SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_IVA)) * Var_IVA, 2);
				END IF;

				IF(Var_MonedaID != Var_MonedaNaID) THEN
					SET Var_PagoPesos := Var_PagoPesos + ROUND(Var_CantidPagar*Var_TipCamFixCom,2) + ROUND(Var_IVACantidPagar*Var_TipCamFixCom,2);
				ELSE
					SET Var_PagoPesos := Var_PagoPesos + ROUND(Var_CantidPagar,2) + ROUND(Var_IVACantidPagar,2);
				END IF;
				/* Se manda a llamar al sp que hace el pago de interes moratorio, aplica
				** movimientos operativos y contables */
				CALL PAGCREFONMORAPRO(
					Var_CreditoFonID,		Var_AmortizacionID,		Var_MonedaID,		Var_InstitutFondID,		Par_InstitucionID,
					Par_NumCtaInstit,		Var_PlazoContable,		Var_TipoInstitID,	Var_NacionalidadIns,	Des_PagoCred,
					Var_TipoFondeo,			Var_Poliza,				Var_CantidPagar,	Var_IVACantidPagar,		Var_FechaSistema,
					Var_FecAplicacion,		Var_NumCtaInstitStr,	Var_NO,				Par_NumErr,				Par_ErrMen,
					Par_Consecutivo,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion );

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

				SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);

				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN/* si ya no hay saldo para aplicar se sale del ciclo */
					LEAVE CICLO;
				END IF;
			END IF; /* fin de if cobro saldo de moratorios */

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
					SET Var_PagoPesos :=Var_PagoPesos + ROUND(Var_CantidPagar*Var_TipCamFixCom,2) + ROUND(Var_IVACantidPagar*Var_TipCamFixCom,2);
				ELSE
					SET Var_PagoPesos := Var_PagoPesos + ROUND(Var_CantidPagar,2) + ROUND(Var_IVACantidPagar,2);
				END IF;
				/* Se manda a llamar al sp que hace el pago de interes provisionado, aplica
				** movimientos operativos y contables */
				CALL PAGCREFONINTPROPRO(
					Var_CreditoFonID,		Var_AmortizacionID,		Var_MonedaID,		Var_InstitutFondID,		Par_InstitucionID,
					Par_NumCtaInstit,		Var_PlazoContable,		Var_TipoInstitID,	Var_NacionalidadIns,	Des_PagoCred,
					Var_TipoFondeo,			Var_Poliza,				Var_CantidPagar,	Var_IVACantidPagar,		Var_FechaSistema,
					Var_FecAplicacion,		Var_NumCtaInstitStr,	Var_NO,				Par_NumErr,				Par_ErrMen,
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
				IF ( Var_Retencion >= Mon_MinPago AND Var_CobraISR = Var_SI) THEN
					SET Var_CantidRetener   := ROUND((Var_CantidPagar/Var_InteresOri) * Var_Retencion, 2);

					SET Var_TotalRetener    := Var_TotalRetener + Var_CantidRetener;

					IF(Var_MonedaID != Var_MonedaNaID) THEN
						SET Var_PagoPesos :=Var_PagoPesos - ROUND(Var_CantidRetener*Var_TipCamFixCom,2) ;
					ELSE
						SET Var_PagoPesos := Var_PagoPesos - ROUND(Var_CantidRetener,2);
					END IF;

					/* Se manda a llamar al sp que hace la Retencion de Interes, Realiza
					** movimientos operativos y contables */
					CALL PAGCREFONINTRETPRO(
						Var_CreditoFonID,		Var_AmortizacionID,		Var_MonedaID,		Var_InstitutFondID,		Par_InstitucionID,
						Par_NumCtaInstit,		Var_PlazoContable,		Var_TipoInstitID,	Var_NacionalidadIns,	Des_PagoCred,
						Var_TipoFondeo,			Var_Poliza,				Var_CantidRetener,	Entero_Cero,			Var_FechaSistema,
						Var_FecAplicacion,		Var_NumCtaInstitStr,	Var_NO,				Par_NumErr,				Par_ErrMen,
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
					SET Var_PagoPesos :=Var_PagoPesos + ROUND((Var_CantidPagar*Var_TipCamFixCom),2) ;
				ELSE
					SET Var_PagoPesos := Var_PagoPesos + ROUND((Var_CantidPagar),2);
				END IF;
				/* Se manda a llamar al sp que hace el pago de capital vigente, aplica
				** movimientos operativos y contables */
				CALL PAGCREFONCAPVIGPRO(
					Var_CreditoFonID,		Var_AmortizacionID,			Var_MonedaID,		Var_InstitutFondID,			Par_InstitucionID,
					Par_NumCtaInstit,		Var_PlazoContable,			Var_TipoInstitID,	Var_NacionalidadIns,		Des_PagoCred,
					Var_TipoFondeo,			Var_Poliza,					Var_CantidPagar,	Var_IVACantidPagar,			Var_FechaSistema,
					Var_FecAplicacion,		Var_NumCtaInstitStr,		Var_NO,				Par_NumErr,					Par_ErrMen,
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
				IF (Var_EsRevolvente = Var_SI AND Var_TipoRevol = RevPagoCuota) THEN
					CALL CREFONAPLICAREVPRO(
						Var_LineaFondeoID,  Var_CantidPagar,    Par_MonedaID,       Var_InstitutFondID,
						Var_FechaSistema,   Var_CreditoFonID,   Var_Poliza,         Par_SalidaNO,
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
			LEAVE ManejoErrores;
		END IF;

		IF(Var_SaldoPago < Entero_Cero) THEN
			SET Var_SaldoPago   := Entero_Cero;
		END IF;

		SET Var_MontoPago	 := Par_MontoPagar - ROUND(Var_SaldoPago,2);

		IF (Var_MontoPago	<= Decimal_Cero) THEN
			SET Par_NumErr		:= 100;
			SET Par_ErrMen		:= 'El Credito no Presenta Adeudos';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		ELSE

			UPDATE AMORTIZAFONDEO Amo, TMPAMORTICRE Tem  SET
				Amo.Estatus			= Est_Pagado,
				Amo.FechaLiquida    = Var_FechaSistema
				WHERE (Amo.SaldoCapVigente + Amo.SaldoCapAtrasad + Amo.SaldoInteresPro + Amo.SaldoInteresAtra +
						 Amo.SaldoMoratorios + Amo.SaldoComFaltaPa + Amo.SaldoOtrasComis) <= Tol_DifPago
					AND Amo.CreditoFondeoID = Par_CreditoFonID
					AND Amo.Estatus 		!= Est_Pagado
				 AND Tem.Transaccion = Aud_NumTransaccion    -- Futuras que no Tienen Capital que son de Solo Interes
				 AND Tem.AmortizacionID = Amo.AmortizacionID  -- Amortizaciones que hayan Sido Afectada con el Pago
				 AND Tem.CreditoID = Amo.CreditoFondeoID;      -- Para evitar Marcar Como Pagadas, aquellas Amortizaciones

			-- Si es un Finiquito Marcamos las cuotas como Pagadas
			IF( Par_Finiquito = Finiquito_SI) THEN
				UPDATE AMORTIZAFONDEO Amo SET
					Amo.Estatus		= Est_Pagado,
					Amo.FechaLiquida	= Var_FechaSistema
					WHERE Amo.CreditoFondeoID 	= Par_CreditoFonID
					  AND Amo.Estatus 	!= Est_Pagado;
			END IF;

			SELECT COUNT(AmortizacionID) INTO Var_NumAmoPag
				FROM AMORTIZAFONDEO
				WHERE CreditoFondeoID = Par_CreditoFonID
					AND Estatus		= Est_Pagado;

			SET Var_NumAmoPag := IFNULL(Var_NumAmoPag, Entero_Cero);

			SELECT COUNT(AmortizacionID) INTO Var_NumAmorti
				FROM AMORTIZAFONDEO
				WHERE CreditoFondeoID = Par_CreditoFonID;

			SET Var_NumAmorti := IFNULL(Var_NumAmorti, Entero_Cero);

			IF (Var_NumAmorti = Var_NumAmoPag) THEN
				UPDATE CREDITOFONDEO SET
					  Estatus			= Est_Pagado,
					  FechaTerminaci	= Var_FechaSistema,

					  Usuario			= Aud_Usuario,
					  FechaActual		= Aud_FechaActual,
					  DireccionIP		= Aud_DireccionIP,
					  ProgramaID		= Aud_ProgramaID,
					  Sucursal			= Aud_Sucursal,
					  NumTransaccion	= Aud_NumTransaccion
					WHERE CreditoFondeoID = Par_CreditoFonID;

				/* Aplicar la Revolvencia, si la Revolvencia es al Terminar de Pagar el Credito */
				IF (Var_EsRevolvente = Var_SI AND Var_TipoRevol = RevLiqCre) THEN
					CALL CREFONAPLICAREVPRO(
						Var_LineaFondeoID,  Var_MontoOtorga,    Par_MonedaID,       Var_InstitutFondID,
						Var_FechaSistema,   Par_CreditoFonID,   Var_Poliza,         Par_SalidaNO,
						Var_Poliza,         Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
						Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			/* Se hace el movimiento operativo y contable de tesoreria */
			/* Se afecta la Cuenta de Bancos por el monto del Pago - La Retencion */
			SET Var_TotalBancos := IFNULL(Var_PagoPesos, Entero_Cero);

			CALL CONTAFONDEOPRO(
				Var_MonedaNaID,         Entero_Cero,        Var_InstitutFondID,     Par_InstitucionID,
				Par_NumCtaInstit,       Par_CreditoFonID,   Var_PlazoContable,      Var_TipoInstitID,
				Var_NacionalidadIns,    Entero_Cero,        Con_PagoCred,           Var_FechaSistema,
				Var_FecAplicacion,      Var_FecAplicacion,  Var_TotalBancos,        Var_CreditoStr,
				Var_CreditoStr,         AltaPoliza_NO,      Entero_Cero,            Cadena_Vacia,
				Nat_Abono,              Cadena_Vacia,       Nat_Cargo,              AltaMovCre_SI,
				MovTesoPago,            Var_NO,             Entero_Cero,            Entero_Cero,
				Var_NO,                 Var_TipoFondeo,     Var_NO,                 Var_Poliza,
				Par_Consecutivo,        Par_NumErr,         Par_ErrMen,             Par_EmpresaID,
				Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
				Aud_Sucursal,           Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
		END IF;


		DELETE FROM TMPAMORTICRE
			WHERE Transaccion = Aud_NumTransaccion;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= CONCAT('Pago Exitoso. Monto del Pago Aplicado: ', FORMAT(Var_MontoPago,2));
		SET Par_Consecutivo	:= 0;
	END ManejoErrores;

	IF (Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Par_Consecutivo 	AS consecutivo;
	END IF;

END TerminaStore$$