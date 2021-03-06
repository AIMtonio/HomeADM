-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDEOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDEOALT`;
DELIMITER $$


CREATE PROCEDURE `CREDITOFONDEOALT`(
	/*Sp para alta de credito pasivo */
	Par_LineaFondeoID   	INT(11),		/* Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR */
	Par_InstitutFondID		INT(11),		/* id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO*/
	Par_Folio		   		VARCHAR(150),	/* Folio del Fondeo corresponde con lo que da la inst de fondeo. */
	Par_TipoCalInteres		INT(11),		/* 1 .- Saldos Insolutos\n2 .- Monto Original (Saldos Globales) */
	Par_CalcInteresID		INT(11),		/* Formula para el calculo de Interes */

	Par_TasaBase			INT(11),		/* Tasa Base, necesario dependiendo de la Formula */
	Par_SobreTasa			DECIMAL(12,4),	/* Si es formula dos (Tasa base mas puntos), aqui se definen\n Los puntos */
	Par_TasaFija			DECIMAL(12,4),	/* Si es formula uno (Tasa Fija), aqui se especifica el valor de dicha\ntasa fija */
	Par_PisoTasa			DECIMAL(12,4),	/* Piso, Si es formula tres */
	Par_TechoTasa			DECIMAL(12,4),	/* Techo, Si es formula tres */

	Par_FactorMora			DECIMAL(12,4),	/* Factor de Moratorio */
	Par_Monto				DECIMAL(14,2),	/* Monto del Credito de Fondeo */
	Par_MonedaID			INT(11),		/* moneda */
	Par_FechaInicio			DATE,			/* Fecha de Inicio */
	Par_FechaVencim			DATE,			/* Fecha de Vencimiento */

	Par_TipoPagoCap			CHAR(1),		/* Tipo de Pago de Capital\nC .-Crecientes\nI .- Iguales\nL .-Libres */
	Par_FrecuenciaCap		CHAR(1),		/* Frecuencia de Pago de las Amortizaciones de Capital\nS .- Semanal,\nC .- Catorcenal\nQ .- Quincenal\nM .- Mensual\nP .- Periodo\nB.-Bimestral \nT.-Trimestral \nR.-TetraMestral\nE.-Semestral \nA.-Anual */
	Par_PeriodicidadCap		INT(11),		/* Periodicidad de Capital en dias	 */
	Par_NumAmortizacion		INT(11),		/* Numero de Amortizaciones o Cuotas (de Capital) */
	Par_FrecuenciaInt		CHAR(1),		/* Frecuencia de Interes\nS .- Semanal,\nC .- Catorcenal\nQ .- Quincenal\nM .- Mensual\nP .- Periodo\nB.-Bimestral \nT.-Trimestral \nR.-TetraMestral\nE.-Semestral \nA.-Anual */

	Par_PeriodicidadInt		INT(11),		/* Periodicidad de Interes en dias	 */
	Par_NumAmortInteres		INT(11),		/* Numero de Amortizaciones (cuotas) de Interes */
	Par_MontoCuota			DECIMAL(12,2),	/* Monto de la Cuota */
	Par_FechaInhabil		CHAR(1),		/* Fecha Inhabil: S.-Siguiente  A.-Anterior */
	Par_CalendIrregular		CHAR(1),		/* Calendario Irregular S.- Si N.-No */

	Par_DiaPagoCapital		CHAR(1),		/* D????????????a de pago Capital F-Pago Final de mes\\nA-Por aniversario */
	Par_DiaPagoInteres 		CHAR(1), 		/* Dia de pago Interes F.-Pago final del mes A.-Por aniversario */
	Par_DiaMesInteres   	INT,			/* D????????????a del mes inter????????????s */
	Par_DiaMesCapital   	INT,			/* D????????????a del mes Capital */
	Par_AjusFecUlVenAmo 	CHAR(1), 		/* Ajustar la fecha de vencimiento de la ultima amortizacion a fecha de vencimiento\nde credito S.-Si  N.-No */

	Par_AjusFecExiVen   	CHAR(1),		/* Ajustar Fecha de exigibilidad a fecha de vencimiento\nS.-Si  N.-No */
	Par_NumTransacSim   	BIGINT(20),		/* Numero de transacci????????????n en el simulador de Amortizaciones */
	Par_PlazoID				VARCHAR(20),	/* Plazo del credito\nCorresponde con la tabla CREDITOSPLAZOS */
	Par_PagaIVA				CHAR(1),		/* indica si paga IVA valores :  Si = "S" / No = "N") */
	Par_IVA					DECIMAL(12,4),	/* indica el valor del iva si es que Paga IVA = si */

	Par_MargenPag			DECIMAL(12,2),	/* Margen para Pagos Iguales. */
	Par_InstitucionID		INT(11),		/* Numero de Institucion (INSTITUCIONES) */
	Par_CuentaClabe			VARCHAR(18),	/* Cuenta Clabe de la institucion */
	Par_NumCtaInstit		VARCHAR(20),	/* Numero de Cuenta Bancaria. */
	Par_PlazoContable		CHAR(1),		/* plazo contable C.- Corto plazo L.- Largo Plazo*/

	Par_TipoInstitID		INT(11),		/* Corresponde con el campo TipoInstitID de la tabla TIPOSINSTITUCION */
	Par_NacionalidadIns		CHAR(1),		/* Especifica la nacionalidad de la institucion, corresponde con la tabla SUBCTANACINSFON*/
	Par_FechaContable		DATE,			/* Indica la fecha contable */
	Par_ComDispos			DECIMAL(12,2),	/* Comision por disposicion. */
	Par_IvaComDispos		DECIMAL(12,2),	/* IVA Comision por disposicion. */

	Par_CobraISR			CHAR(1),		/* Indica si cobra o no ISR Si = S No = N */
	Par_TasaISR				DECIMAL(12,2),	/* Tasa del ISR*/
	Par_MargenPriCuota		INT(11),		/* Margen para calcular la primer cuota */
	Par_CapitalizaInteres	CHAR(1),
    Par_PagosParciales		CHAR(1),
	Par_TipoFondeador		CHAR(1),
	Par_Salida		      	CHAR(1),
	INOUT Par_NumErr		INT(11),

	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,
	Par_EmpresaID			INT(11),
	Aud_Usuario			   	INT,
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)

TerminaStore: BEGIN

	/* DECLARACION DE CONSTANTES*/
	DECLARE	Cadena_Vacia		CHAR(1);		/* Cadena Vacia*/
	DECLARE	Entero_Cero			INT;			/* Entero en Cero*/
	DECLARE	Decimal_Cero		DECIMAL(12,2);	/* Decimal en Cero*/
	DECLARE Var_SI				CHAR(1);		/* valor si */
	DECLARE Var_NO				CHAR(1);		/* valor no */
	DECLARE	Fecha_Vacia			DATE;			/* Fecha Vacia*/
	DECLARE	Salida_SI			CHAR(1);		/* Valor para devolver una Salida */
	DECLARE	Salida_NO			CHAR(1);		/* Valor para no devolver una Salida */
	DECLARE	Est_Vigente			CHAR(1);		/* Estatus Vigente corresponde con tabla CREDITOFONDEO */
	DECLARE	Nat_Cargo			CHAR(1);		/* Naturaleza de Cargo  */
	DECLARE	Nat_Abono			CHAR(1);		/* Naturaleza de Abono  */
	DECLARE Mov_CapVigente		INT(4);			/* Tipo del Movimiento de Credito Pasivo: Capital Vigente (TIPOSMOVSFONDEO) */
	DECLARE Var_Descripcion     VARCHAR(100);	/* descripcion para los movimientos de credito pasivo*/
	DECLARE Var_SaldosInso		INT(11);		/* Tipo de calculo de interes Saldos Insolutos*/
	DECLARE Var_TasaFija		INT(11);		/* Indica el valor para la formula de tasa fija*/
	DECLARE Var_Crecientes		CHAR(1);		/* Indica el tipo de pago de capital Creciente */
	DECLARE Var_Iguales			CHAR(1);		/* Indica el tipo de pago de capital Igual */
	DECLARE Var_Libres			CHAR(1);		/* Indica el tipo de pago de capital Libre*/
	DECLARE OtorgaCrePasID		CHAR(4); 		/* ID del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO*/
	DECLARE Var_ConcepFonCap	INT(11);		/* concepto de capital que corresponde con la tabla CONCEPTOSFONDEO*/
	DECLARE Var_ConcepConDes	INT(11);		/* concepto de contable  de DESEMBOLSO DE CREDITO CREDITO PASIVO tabla CONCEPTOSCONTA*/
	DECLARE Var_CtaOrdCar		INT(11);		/* Cta. Orden Contingente (Cargo) con la tabla CONCEPTOSFONDEO*/
	DECLARE Var_CtaOrdAbo		INT(11);		/* Cta. Orden Correlativa (Abono) con la tabla CONCEPTOSFONDEO*/
	DECLARE Var_ComDis			INT(11);		/* Cta. comisi????n por disposici????n  con la tabla CONCEPTOSFONDEO*/
	DECLARE Var_IvaComDis		INT(11);		/* Cta. iva comisi????n por disposici????n  con la tabla CONCEPTOSFONDEO*/
	DECLARE Constante_NO		CHAR(1);
	DECLARE EstatusAbierto		CHAR(1);
	DECLARE Var_Monto 			DECIMAL(12,2);	-- Se utiliza para guardar el valor del monto
	DECLARE Var_ComDispos 		DECIMAL(12,2); 	-- Monto de Comision por disposicion en pesos
	DECLARE Var_IvaComDispos 	DECIMAL(12,2); 	-- IVA de Comision por disposicion en pesos
	DECLARE Var_ConcepCompCap 	INT(11);		/* concepto de complemento capital que corresponde con la tabla CONCEPTOSFONDEO*/

	/* DECLARACION DE VARIABLES */
	DECLARE Var_CreFondeo    	INT; 		/* Guarda en consecutivo del id de Credito FONDEO */
	DECLARE Var_FechaApl        DATE;		/* Si la fecha de operacion no es un dia habil, se guarda en esta variable el valor de dia habil*/
	DECLARE Var_EsHabil         CHAR(1);
	DECLARE Var_CuotasCap		INT(11);	/* numero de cuotas de capital que devuelve el simulador*/
	DECLARE Var_CuotasInt		INT(11);	/* numero de cuotas de Interes que devuelve el simulador*/
	DECLARE Var_PolizaID		    BIGINT;
	DECLARE Var_NumTranSim		BIGINT(20);
	DECLARE Var_FechInicLinea	DATE; 		/* Fecha de inicio de la linea de  fondeo */
	DECLARE Var_FechaFinLinea	DATE; 		/* Fecha de fin de la linea de  fondeo */
	DECLARE Var_FechaMaxVenci	DATE; 		/* Fecha de vencimiento maximo de la linea de  fondeo */
	DECLARE Var_MontoComDis		DECIMAL(12,2); 		/* monto de credito mas comision mas iva */
	DECLARE Var_TasaISR			DECIMAL(12,2); 		/* tasa de ISR */
	DECLARE Var_AcfectacioConta CHAR(1); /* VARIA DE AFECTACION CONTABLE SI='S',NO='N' */
	DECLARE Var_Control			VARCHAR(100);
	DECLARE Var_PrimerDiaMes	DATE; -- Almacena el primer dia del mes --
	DECLARE Var_EstatusPeriodo	CHAR(1); -- Almecena el Estatus del Periodo Contable --
	DECLARE Var_FechaRegistro	DATE;
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_MontoComDisMN	DECIMAL(12,2);
	DECLARE Var_MonedaID 		INT(11);
    DECLARE Var_TipoCamDof		DECIMAL(14,6);	-- Se ocupa para guardar el valor del tipo cambio en DOF
    DECLARE Var_TipCamFixVen	DECIMAL(14,6);	-- Tipo de cambio venta Fix
    DECLARE Cons_MonedaNID		INT(11);			-- Identificador de moneda nacional

	/* ASIGNACION DE CONSTANTES */
	SET	Cadena_Vacia		:= '';				/* Cadena Vacia	 */
	SET	Entero_Cero			:= 0;				/* Entero en Cero */
	SET	Salida_SI			:= 'S';				/* Valor para devolver una Salida */
	SET	Salida_NO			:= 'N';				/* Valor para no devolver una Salida */
	SET	Decimal_Cero		:= 0.00;			/* Valor para devolver una Salida */
	SET Var_SI				:= 'S';				/* Valor SI */
	SET Var_NO				:= 'N';				/* Valor SI */
	SET	Fecha_Vacia			:= '1900-01-01';	/* Fecha Vacia */
	SET	Est_Vigente			:= 'N';				/* Estatus Vigente corresponde con tabla CREDITOFONDEO/AMORTIZAFONDEO */
	SET	Nat_Cargo			:= 'C';				/* Naturaleza de Cargo 			 */
	SET	Nat_Abono			:= 'A';				/* Naturaleza de Abono */
	SET Mov_CapVigente      := 1;				/* Tipo del Movimiento de Credito Pasivo: Capital Vigente (TIPOSMOVSFONDEO) */
	SET Var_Descripcion     := 'OTORGAMIENTO DE CREDITO PASIVO';  /* descripcion para los movimientos de credito pasivo*/
	SET Var_SaldosInso		:= 1;				/* Tipo de calculo de interes Saldos Insolutos*/
	SET Var_TasaFija		:= 1; 				/* Indica el valor para la formula de tasa fija*/
	SET Var_Crecientes		:= 'C'; 			/* Indica el tipo de pago de capital Creciente */
	SET Var_Iguales			:= 'I'; 			/* Indica el tipo de pago de capital Igual */
	SET Var_Libres 			:= 'L';				/* Indica el tipo de pago de capital Libre*/
	SET Var_ConcepFonCap	:= 1; 				/* concepto de capital que corresponde con la tabla CONCEPTOSFONDEO*/
	SET Var_ConcepConDes	:= 23; 				/* concepto de contable  de DESEMBOLSO DE CREDITO CREDITO PASIVO tabla CONCEPTOSCONTA*/
	SET OtorgaCrePasID		:= 30; 				/* ID del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO*/
	SET Var_CtaOrdCar		:= 11;				/* Cta. Orden Contingente (Cargo) con la tabla CONCEPTOSFONDEO*/
	SET Var_CtaOrdAbo		:= 12;				/* Cta. Orden Correlativa (Abono) con la tabla CONCEPTOSFONDEO*/
	SET Var_ComDis			:= 17;				/* Cta. comisi????n por disposici????n  con la tabla CONCEPTOSFONDEO*/
	SET Var_IvaComDis		:= 18;				/* Cta. Iva comisi????n por disposici????n  con la tabla CONCEPTOSFONDEO*/
	SET EstatusAbierto		:= 'N';				-- Estatus Abierto del periodo contable, N significa No cerrado --
	SET Var_ConcepCompCap	:= 28; 				/* concepto de complemento capital que corresponde con la tabla CONCEPTOSFONDEO*/

	/* ASIGNACION DE VARIABLES */
	SET Var_CreFondeo		:= 0;
	SET Constante_NO		:='N';

    SET Cons_MonedaNID		:= 1;				-- Asignaci??n de moneda nacional

	SET Aud_FechaActual		:=NOW();			-- Toma fecha actual --



	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operaci??n. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOFONDEOALT');
			SET Var_Control := 'sqlException';
		END;

		SELECT FechaSistema
		INTO Var_FechaSistema
		FROM PARAMETROSSIS LIMIT 1;

		SET Par_FechaInicio := IFNULL(Par_FechaInicio, Fecha_Vacia);

		IF( Par_FechaInicio = Fecha_Vacia ) THEN
			SET	Par_NumErr := 1;
			SET	Par_ErrMen := 'La Fecha de Inicio esta Vacia.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control		:='fechaInicio';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FechaInicio > Var_FechaSistema ) THEN
			SET	Par_NumErr := 1;
			SET	Par_ErrMen := 'La Fecha de Inicio es mayor a la Fecha del Sistema.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control		:='fechaInicio';
			LEAVE ManejoErrores;
		END IF;

		-- Inicializacion de Valores por default
		SET Par_FechaContable 	:= Par_FechaInicio;
		SET Par_AjusFecUlVenAmo	:= Constante_NO;
		SET Par_AjusFecExiVen	:= Constante_NO;

		-- Validacion de Campos Requeridos
		IF(IFNULL(Par_InstitutFondID, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr := 1;
			SET	Par_ErrMen := 'La Institucion de Fondeo esta Vacia.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control		:='institutFondID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_LineaFondeoID, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr := 2;
			SET	Par_ErrMen := 'La Linea de Fondeo esta Vacia.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control	:= 'lineaFondeoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaInicio, Fecha_Vacia))= Fecha_Vacia THEN
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'Especificar Fecha de Inicio de Credito.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control	:= 'fechaInicio';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaVencim, Fecha_Vacia))= Fecha_Vacia THEN
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'Especificar Fecha de Vencimiento de Credito.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control	:= 'fechaVencim';
			LEAVE ManejoErrores;
		END IF;

		SELECT	FechInicLinea,		FechaFinLinea,		FechaMaxVenci,		CobraISR	,AfectacionConta
			INTO 	Var_FechInicLinea,	Var_FechaFinLinea,	Var_FechaMaxVenci,	Par_CobraISR, Var_AcfectacioConta
			FROM LINEAFONDEADOR lin,
				INSTITUTFONDEO ins
				WHERE LineaFondeoID 	= Par_LineaFondeoID
					AND ins.InstitutFondID = lin.InstitutFondID;

		SET Var_FechInicLinea	:= IFNULL(Var_FechInicLinea,Fecha_Vacia);
		SET Var_FechaFinLinea	:= IFNULL(Var_FechaFinLinea,Fecha_Vacia);
		SET Var_FechaMaxVenci	:= IFNULL(Var_FechaMaxVenci,Fecha_Vacia);

		IF(IFNULL(Par_FechaInicio, Fecha_Vacia)< Var_FechInicLinea ) THEN
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'La Fecha de Inicio del Credito no puede ser Inferior a la Fecha de Inicio de la Ventana de Disposicion.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control	:= 'fechaInicio';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_FechaInicio, Fecha_Vacia) > Var_FechaFinLinea ) THEN
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'La Fecha de Inicio del Credito no puede ser Superior a la Fecha de Fin de la Ventana de Disposicion.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control	:= 'fechaInicio';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_FechaVencim, Fecha_Vacia) > Var_FechaMaxVenci ) THEN
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'La Fecha de Vencimiento del Credito no puede ser Superior a la Fecha Maxima de Vencimiento de la Ventana de Disposicion.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control	:= 'fechaInicio';
			LEAVE ManejoErrores;
		END IF;

		-- valida folio
		IF(IFNULL(Par_Folio, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'El Folio Esta Vacio.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control	:= 'folio';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoCalInteres, Entero_Cero) = Entero_Cero ) THEN
			SET	Par_NumErr := 4;
			SET	Par_ErrMen := 'El Tipo Cal. Interes esta Vacio.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control	:= 'tipoCalInteres';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto, Decimal_Cero) <= Decimal_Cero ) THEN
			SET	Par_NumErr := 5;
			SET	Par_ErrMen := 'El Monto esta Vacio.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control	:= 'monto';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_MonedaID, Entero_Cero) = Entero_Cero ) THEN
			SET	Par_NumErr := 6;
			SET	Par_ErrMen := 'El Monto esta Vacio.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control	:= 'monedaID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_PrimerDiaMes:= CONVERT(DATE_ADD(Par_FechaContable, INTERVAL -1*(DAY(Par_FechaContable))+1 DAY),DATE);
		SET Var_EstatusPeriodo :=IFNULL((SELECT Estatus
											FROM PERIODOCONTABLE
												WHERE Inicio = Var_PrimerDiaMes),Cadena_Vacia);

		IF(Var_EstatusPeriodo = Cadena_Vacia)THEN
			SET	Par_NumErr := 7;
			SET	Par_ErrMen := 'No Existe el Periodo Contable.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control		:='institutFondID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusPeriodo != EstatusAbierto)THEN
			SET	Par_NumErr := 8;
			SET	Par_ErrMen := 'El Periodo Contable se Encuentra Cerrado.';
			SET	Par_Consecutivo := Var_CreFondeo;
			SET Var_Control		:='institutFondID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MonedaID, Entero_Cero) <> Cons_MonedaNID) THEN
			SELECT FechaRegistro INTO Var_FechaRegistro
				FROM MONEDAS WHERE MonedaId = Par_MonedaID;

			IF(Var_FechaRegistro <> Var_FechaSistema )THEN
				SET	Par_NumErr := 9;
				SET	Par_ErrMen := CONCAT('La ??ltima actualizaci??n de la divisa fue el d??a ',CONVERT(Var_FechaRegistro, CHAR(15)));
				SET	Par_Consecutivo := Var_CreFondeo;
				SET Var_Control		:='monedaID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

        SELECT TipCamDof,TipCamFixVen
			INTO Var_TipoCamDof,Var_TipCamFixVen
		FROM MONEDAS
			WHERE FechaRegistro = Var_FechaSistema
				AND MonedaId = Par_MonedaID;

		CALL DIASFESTIVOSCAL(
			Par_FechaInicio,	Entero_Cero,		Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		-- se verifica si se paga o no ISR
		IF( IFNULL(Par_CobraISR,Cadena_Vacia) = Var_SI) THEN
			SET Var_TasaISR:= Par_TasaISR;
		ELSE
			SET Var_TasaISR:= Entero_Cero;
		END IF;

		IF(IFNULL(Par_TipoPagoCap, Cadena_Vacia) = Var_Libres)THEN
			SET Var_NumTranSim := Par_NumTransacSim;
		END IF;

		-- Se obtiene el numero del folio que le toca
		CALL FOLIOSAPLICAACT('CREDITOFONDEO', Var_CreFondeo);


		-- Se insertan los valores en la tabla de CREDITOFONDEO
		INSERT INTO CREDITOFONDEO (
			CreditoFondeoID,		LineaFondeoID,			InstitutFondID, 		Folio, 					TipoCalInteres,
			CalcInteresID, 			TasaBase, 				SobreTasa,				TasaFija,  				PisoTasa,
			TechoTasa,				FactorMora, 			Monto, 					MonedaID, 				FechaInicio,
			FechaVencimien, 		FechaTerminaci, 		Estatus,				SaldoCapVigente, 		SaldoCapAtrasad,
			SaldoInteresAtra,		SaldoInteresPro,		SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMora,
			SaldoComFaltaPa,		SaldoIVAComFalP,		SaldoOtrasComis,		SaldoIVAComisi,			ProvisionAcum,
			TipoPagoCapital,		FrecuenciaCap,			PeriodicidadCap,		NumAmortizacion,		FrecuenciaInt,
			PeriodicidadInt,		NumAmortInteres,		MontoCuota,				FechaInhabil,			CalendIrregular,
			DiaPagoInteres,			DiaPagoCapital,			DiaMesInteres,			DiaMesCapital,			AjusFecUlVenAmo,
			AjusFecExiVen,			NumTransacSim,			PlazoID,				PlazoContable,			FechaContable,
			PagaIva,				PorcentanjeIVA,			MargenPagIgual,			InstitucionID,			CuentaClabe,
			NumCtaInstit,			TipoInstitID,			NacionalidadIns,		EmpresaID,				Usuario,
			FechaActual,			DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion,
			ComDispos,				IvaComDispos,			CobraISR,				TasaISR,				MargenPriCuota,
			SaldoRetencion,			CapitalizaInteres,		TipoFondeador,    		PagosParciales,			EsContingente,
			TipoGarantiaFIRAID)
			VALUES(
			Var_CreFondeo,			Par_LineaFondeoID,		Par_InstitutFondID,		Par_Folio,				Par_TipoCalInteres,
			Par_CalcInteresID,		Par_TasaBase,			Par_SobreTasa,			Par_TasaFija,			Par_PisoTasa,
			Par_TechoTasa,			Par_FactorMora,			Par_Monto,				Par_MonedaID,			Par_FechaInicio,
			Par_FechaVencim,		Fecha_Vacia,			Est_Vigente,			Par_Monto,				Decimal_Cero,
			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
			Par_TipoPagoCap,		Par_FrecuenciaCap,		Par_PeriodicidadCap,	Par_NumAmortizacion,	Par_FrecuenciaInt,
			Par_PeriodicidadInt,	Par_NumAmortInteres,	Par_MontoCuota,			Par_FechaInhabil,		Par_CalendIrregular,
			Par_DiaPagoInteres,		Par_DiaPagoCapital,		Par_DiaMesInteres,		Par_DiaMesCapital,		Par_AjusFecUlVenAmo,
			Par_AjusFecExiVen,		Par_NumTransacSim,		Par_PlazoID,			Par_PlazoContable,		Par_FechaContable,
			Par_PagaIVA,			Par_IVA,				Par_MargenPag,			Par_InstitucionID,		Par_CuentaClabe,
			Par_NumCtaInstit,		Par_TipoInstitID,		Par_NacionalidadIns,	Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion,
			Par_ComDispos,			Par_IvaComDispos,		Par_CobraISR,			Var_TasaISR,			Par_MargenPriCuota,
			Decimal_Cero,			Par_CapitalizaInteres,  Par_TipoFondeador,   	Par_PagosParciales,		Var_NO,
			Entero_Cero);

		-- SP para generar las amortizaciones del credito
		CALL FONGENAMORTIZAPRO(
			Var_CreFondeo,		Salida_NO,			Var_NumTranSim,			Par_NumErr, 		Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;



		-- Se insertar Los movimientos del Credito de fondeo
		INSERT INTO CREDITOFONDMOVS (
			CreditoFondeoID,	AmortizacionID,		Transaccion,		FechaOperacion,		FechaAplicacion,
			TipoMovFonID,		NatMovimiento,		MonedaID,			Cantidad,			Descripcion,
			Referencia,			EmpresaID,			Usuario,			FechaActual,		DireccionIP,
			ProgramaID,			Sucursal,			NumTransaccion)
			SELECT
				Var_CreFondeo,		Tmp_Consecutivo,	Aud_NumTransaccion,	Var_FechaApl,		Var_FechaApl,
				Mov_CapVigente,		Nat_Cargo,			Par_MonedaID,		CASE WHEN Par_CapitalizaInteres =	Var_SI  THEN -- Si capitaliza interes
				Par_Monto ELSE Tmp_Capital END ,		Var_Descripcion,
				Par_NumCtaInstit,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM TMPPAGAMORSIM
					WHERE NumTransaccion = Var_NumTranSim
						AND Tmp_Capital > Decimal_Cero
						AND Tmp_Consecutivo >0;

		-- se borran las amortizaciones temporales
		DELETE FROM TMPPAGAMORSIM
			WHERE NumTransaccion = Aud_NumTransaccion;

		-- se actualiza el saldo de la linea de fondeo.
		CALL SALDOSLINEAFONACT(
			Par_LineaFondeoID,	Nat_Cargo,			Par_Monto,			Salida_NO,				Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
			LEAVE ManejoErrores;
		END IF;

		-- Se manda a llamar sp para hacer la parte contable
		CALL CONTAFONDEOPRO(
			Par_MonedaID,					Par_LineaFondeoID,				Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
			Var_CreFondeo,					Par_PlazoContable,				Par_TipoInstitID,		Par_NacionalidadIns,	Var_ConcepFonCap,
			Var_Descripcion,				Par_FechaInicio,				Par_FechaInicio,		Par_FechaInicio,		Par_Monto,
			CONVERT(Var_CreFondeo,CHAR),	CONVERT(Var_CreFondeo,CHAR),	Var_SI,					Var_ConcepConDes,		Nat_Abono,
			Nat_Cargo,						Nat_Cargo,						Nat_Abono,				Var_NO,					OtorgaCrePasID,
			Var_NO,							Entero_Cero,					Mov_CapVigente,			Var_SI,					Par_TipoFondeador,
			Salida_NO,						Var_PolizaID,					Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
			Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,					Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
			LEAVE ManejoErrores;
		END IF;


        IF(Par_MonedaID <> Cons_MonedaNID) THEN
			SET Var_Monto := Par_Monto * Var_TipCamFixVen;
			-- Se manda a llamar sp para hacer la parte contable
			CALL CONTAFONDEOPRO(
				Cons_MonedaNID,					Par_LineaFondeoID,				Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
				Var_CreFondeo,					Par_PlazoContable,				Par_TipoInstitID,		Par_NacionalidadIns,	Var_ConcepFonCap,
				Var_Descripcion,				Par_FechaInicio,				Par_FechaInicio,		Par_FechaInicio,		Var_Monto,
				CONVERT(Var_CreFondeo,CHAR),	CONVERT(Var_CreFondeo,CHAR),	Var_NO,					Var_ConcepConDes,		Nat_Abono,
				Nat_Cargo,						Nat_Cargo,						Nat_Abono,				Var_NO,					OtorgaCrePasID,
				Var_NO,							Entero_Cero,					Mov_CapVigente,			Var_SI,					Par_TipoFondeador,
				Salida_NO,						Var_PolizaID,					Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
				Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,					Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
				LEAVE ManejoErrores;
			END IF;

			-- Falta Definir concepto contable
			-- Se manda a llamar sp para hacer la parte contable
			CALL CONTAFONDEOPRO(
				Par_MonedaID,					Par_LineaFondeoID,				Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
				Var_CreFondeo,					Par_PlazoContable,				Par_TipoInstitID,		Par_NacionalidadIns,	Var_ConcepCompCap,
				Var_Descripcion,				Par_FechaInicio,				Par_FechaInicio,		Par_FechaInicio,		Par_Monto,
				CONVERT(Var_CreFondeo,CHAR),	CONVERT(Var_CreFondeo,CHAR),	Var_NO,					Var_ConcepConDes,		Nat_Cargo,
				Nat_Cargo,						Nat_Cargo,						Nat_Abono,				Var_NO,					OtorgaCrePasID,
				Var_NO,							Entero_Cero,					Mov_CapVigente,			Var_SI,					Par_TipoFondeador,
				Salida_NO,						Var_PolizaID,					Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
				Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,					Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- CUENTA ORDEN LINEA DE FONDEO --
		IF(Var_AcfectacioConta = Var_SI)THEN
			-- --------------------------------------------------------------------------------------
			-- Se manda a llamar sp para hacer la parte contable que corresponde con la cuenta de orden
			-- contingente (Cargo)
			-- --------------------------------------------------------------------------------------
			CALL CONTAFONDEOPRO(
				Par_MonedaID,					Par_LineaFondeoID,				Par_InstitutFondID,	Par_InstitucionID,		Par_NumCtaInstit,
				Var_CreFondeo,					Par_PlazoContable,				Par_TipoInstitID,	Par_NacionalidadIns,	Var_CtaOrdCar,
				Var_Descripcion,				Par_FechaInicio,				Par_FechaInicio,	Par_FechaInicio,		Par_Monto,
				CONVERT(Var_CreFondeo,CHAR),	CONVERT(Var_CreFondeo,CHAR),	Var_NO,				Var_ConcepConDes,		Nat_Abono,
				Nat_Abono,						Nat_Abono,						Nat_Abono,			Var_NO,					OtorgaCrePasID,
				Var_NO,							Entero_Cero,					Mov_CapVigente,		Var_SI,					Par_TipoFondeador,
				Salida_NO,						Var_PolizaID,					Par_Consecutivo,	Par_NumErr,				Par_ErrMen,
				Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,					Aud_NumTransaccion  );

			IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
				LEAVE ManejoErrores;
			END IF;

			-- --------------------------------------------------------------------------------------
			-- Se manda a llamar sp para hacer la parte contable que corresponde con la cuenta de orden
			-- contingente (Abono)
			-- --------------------------------------------------------------------------------------
			CALL CONTAFONDEOPRO(
				Par_MonedaID,					Par_LineaFondeoID,				Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
				Var_CreFondeo,					Par_PlazoContable,				Par_TipoInstitID,		Par_NacionalidadIns,	Var_CtaOrdAbo,
				Var_Descripcion,				Par_FechaInicio,				Par_FechaInicio,		Par_FechaInicio,		Par_Monto,
				CONVERT(Var_CreFondeo,CHAR),	CONVERT(Var_CreFondeo,CHAR),	Var_NO,					Var_ConcepConDes,		Nat_Cargo,
				Nat_Cargo,						Nat_Cargo,						Nat_Cargo,				Var_NO,					OtorgaCrePasID,
				Var_NO,							Entero_Cero,					Mov_CapVigente,			Var_SI,					Par_TipoFondeador,
				Salida_NO,						Var_PolizaID,					Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
				Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,					Aud_NumTransaccion  );

			IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
				LEAVE ManejoErrores;
			END IF;
		END IF; -- Afectacion contable Linea

		-- FIN CUENTA ORDEN LINEA DE FONDEO
		IF(IFNULL(Par_ComDispos, Decimal_Cero)) >Decimal_Cero THEN -- si hay una comision por disposicion
			-- Se manda a llamar sp para hacer la parte contable
			CALL CONTAFONDEOPRO(
			Par_MonedaID,					Par_LineaFondeoID,				Par_InstitutFondID,			Par_InstitucionID,				Par_NumCtaInstit,
			Var_CreFondeo,					Par_PlazoContable,				Par_TipoInstitID,			Par_NacionalidadIns,			Var_ComDis,
			Var_Descripcion,				Par_FechaInicio,				Par_FechaInicio,			Par_FechaInicio,				Par_ComDispos,
			CONVERT(Var_CreFondeo,CHAR),	CONVERT(Var_CreFondeo,CHAR),	Var_NO,						Var_ConcepConDes,				Nat_Cargo,
			Nat_Cargo,						Nat_Cargo,						Nat_Abono,					Var_NO,							OtorgaCrePasID,
			Var_NO,							Entero_Cero,					Mov_CapVigente,				Var_SI,							Par_TipoFondeador,
			Salida_NO,						Var_PolizaID,					Par_Consecutivo,			Par_NumErr,						Par_ErrMen,
			Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,			Aud_DireccionIP,				Aud_ProgramaID,
			Aud_Sucursal,					Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
				LEAVE ManejoErrores;
			END IF;

			IF(Par_MonedaID <> Cons_MonedaNID) THEN
				SET Var_ComDispos := Par_ComDispos * Var_TipCamFixVen;

				CALL CONTAFONDEOPRO(
					Par_MonedaID,					Par_LineaFondeoID,				Par_InstitutFondID,			Par_InstitucionID,				Par_NumCtaInstit,
					Var_CreFondeo,					Par_PlazoContable,				Par_TipoInstitID,			Par_NacionalidadIns,			Var_ComDis,
					Var_Descripcion,				Par_FechaInicio,				Par_FechaInicio,			Par_FechaInicio,				Par_ComDispos,
					CONVERT(Var_CreFondeo,CHAR),	CONVERT(Var_CreFondeo,CHAR),	Var_NO,						Var_ConcepConDes,				Nat_Abono,
					Nat_Cargo,						Nat_Cargo,						Nat_Abono,					Var_NO,							OtorgaCrePasID,
					Var_NO,							Entero_Cero,					Mov_CapVigente,				Var_SI,							Par_TipoFondeador,
					Salida_NO,						Var_PolizaID,					Par_Consecutivo,			Par_NumErr,						Par_ErrMen,
					Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,			Aud_DireccionIP,				Aud_ProgramaID,
					Aud_Sucursal,					Aud_NumTransaccion
				);

				IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
					LEAVE ManejoErrores;
				END IF;

				CALL CONTAFONDEOPRO(
					Cons_MonedaNID,					Par_LineaFondeoID,				Par_InstitutFondID,			Par_InstitucionID,				Par_NumCtaInstit,
					Var_CreFondeo,					Par_PlazoContable,				Par_TipoInstitID,			Par_NacionalidadIns,			Var_ComDis,
					Var_Descripcion,				Par_FechaInicio,				Par_FechaInicio,			Par_FechaInicio,				Var_ComDispos,
					CONVERT(Var_CreFondeo,CHAR),	CONVERT(Var_CreFondeo,CHAR),	Var_NO,						Var_ConcepConDes,				Nat_Cargo,
					Nat_Cargo,						Nat_Cargo,						Nat_Abono,					Var_NO,							OtorgaCrePasID,
					Var_NO,							Entero_Cero,					Mov_CapVigente,				Var_SI,							Par_TipoFondeador,
					Salida_NO,						Var_PolizaID,					Par_Consecutivo,			Par_NumErr,						Par_ErrMen,
					Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,			Aud_DireccionIP,				Aud_ProgramaID,
					Aud_Sucursal,					Aud_NumTransaccion
				);

				IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_IvaComDispos, Decimal_Cero)) >Decimal_Cero THEN -- si hay un iva de comision por disposicion
				-- Se manda a llamar sp para hacer la parte contable
				CALL CONTAFONDEOPRO(
					Par_MonedaID,						Par_LineaFondeoID,					Par_InstitutFondID,		Par_InstitucionID,			Par_NumCtaInstit,
					Var_CreFondeo,						Par_PlazoContable,					Par_TipoInstitID,		Par_NacionalidadIns,		Var_IvaComDis,
					Var_Descripcion,					Par_FechaInicio,					Par_FechaInicio,		Par_FechaInicio,			Par_IvaComDispos,
					CONVERT(Var_CreFondeo,CHAR),		CONVERT(Var_CreFondeo,CHAR),		Var_NO,					Var_ConcepConDes,			Nat_Cargo,
					Nat_Cargo,							Nat_Cargo,							Nat_Abono,				Var_NO,						OtorgaCrePasID,
					Var_NO,								Entero_Cero,						Mov_CapVigente,			Var_SI,						Par_TipoFondeador,
					Salida_NO,							Var_PolizaID,						Par_Consecutivo,		Par_NumErr,					Par_ErrMen,
					Par_EmpresaID,						Aud_Usuario,						Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,						Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
					LEAVE ManejoErrores;
				END IF;

				IF(Par_MonedaID <> Cons_MonedaNID) THEN
					SET Var_IvaComDispos := Par_IvaComDispos * Var_TipCamFixVen;

					CALL CONTAFONDEOPRO(
						Par_MonedaID,						Par_LineaFondeoID,					Par_InstitutFondID,		Par_InstitucionID,			Par_NumCtaInstit,
						Var_CreFondeo,						Par_PlazoContable,					Par_TipoInstitID,		Par_NacionalidadIns,		Var_IvaComDis,
						Var_Descripcion,					Par_FechaInicio,					Par_FechaInicio,		Par_FechaInicio,			Par_IvaComDispos,
						CONVERT(Var_CreFondeo,CHAR),		CONVERT(Var_CreFondeo,CHAR),		Var_NO,					Var_ConcepConDes,			Nat_Abono,
						Nat_Cargo,							Nat_Cargo,							Nat_Abono,				Var_NO,						OtorgaCrePasID,
						Var_NO,								Entero_Cero,						Mov_CapVigente,			Var_SI,						Par_TipoFondeador,
						Salida_NO,							Var_PolizaID,						Par_Consecutivo,		Par_NumErr,					Par_ErrMen,
						Par_EmpresaID,						Aud_Usuario,						Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
						Aud_Sucursal,						Aud_NumTransaccion);

					IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
						LEAVE ManejoErrores;
					END IF;

					CALL CONTAFONDEOPRO(
						Cons_MonedaNID,						Par_LineaFondeoID,					Par_InstitutFondID,		Par_InstitucionID,			Par_NumCtaInstit,
						Var_CreFondeo,						Par_PlazoContable,					Par_TipoInstitID,		Par_NacionalidadIns,		Var_IvaComDis,
						Var_Descripcion,					Par_FechaInicio,					Par_FechaInicio,		Par_FechaInicio,			Var_IvaComDispos,
						CONVERT(Var_CreFondeo,CHAR),		CONVERT(Var_CreFondeo,CHAR),		Var_NO,					Var_ConcepConDes,			Nat_Cargo,
						Nat_Cargo,							Nat_Cargo,							Nat_Abono,				Var_NO,						OtorgaCrePasID,
						Var_NO,								Entero_Cero,						Mov_CapVigente,			Var_SI,						Par_TipoFondeador,
						Salida_NO,							Var_PolizaID,						Par_Consecutivo,		Par_NumErr,					Par_ErrMen,
						Par_EmpresaID,						Aud_Usuario,						Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
						Aud_Sucursal,						Aud_NumTransaccion);

					IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF; -- iva comision por disposicion
		END IF; -- Comision por disposicion

		-- Se insertan los movimientos de tesoreria

		SET Var_MontoComDis := Par_Monto -IFNULL(Par_IvaComDispos, Decimal_Cero)-IFNULL(Par_ComDispos, Decimal_Cero);
		-- Se manda a llamar sp para hacer la parte contable

		SET Var_MonedaID := Par_MonedaID;
		SET Var_MontoComDisMN := Var_MontoComDis;
		if(Par_MonedaID <> Cons_MonedaNID) THEN
			SET Var_MontoComDisMN := Var_MontoComDis * Var_TipCamFixVen;
			SET Var_MonedaID := Cons_MonedaNID;
		END IF;

		CALL CONTAFONDEOPRO(
			Var_MonedaID,					Par_LineaFondeoID,				Par_InstitutFondID,		Par_InstitucionID,			Par_NumCtaInstit,
			Var_CreFondeo,					Par_PlazoContable,				Par_TipoInstitID,		Par_NacionalidadIns,		Var_ConcepFonCap,
			Var_Descripcion,				Par_FechaInicio,				Par_FechaInicio,		Par_FechaInicio,			Var_MontoComDisMN,
			CONVERT(Var_CreFondeo,CHAR),	CONVERT(Var_CreFondeo,CHAR),	Var_NO,					Var_ConcepConDes,			Nat_Abono,
			Nat_Cargo,						Nat_Cargo,						Nat_Abono,				Var_SI,						OtorgaCrePasID,
			Var_NO,							Entero_Cero,					Mov_CapVigente,			Var_NO,						Par_TipoFondeador,
			Salida_NO,						Var_PolizaID,					Par_Consecutivo,		Par_NumErr,					Par_ErrMen,
			Par_EmpresaID,					Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,					Aud_NumTransaccion
		);

		IF(Par_NumErr <> Entero_Cero) THEN
			SET Var_CreFondeo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		-- Se genera el interes a la fecha del sistema --
		CALL GENINTERESFONDEOPRO(
		Var_CreFondeo,	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= CONCAT('Credito Pasivo Agregado Exitosamente: ',CONVERT(Var_CreFondeo,CHAR));
		SET	Par_Consecutivo := Var_CreFondeo;

	END ManejoErrores;  -- End del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr 	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS control,
			Var_CreFondeo AS consecutivo,
			Var_PolizaID AS CampoGenerico;
	END IF;
END TerminaStore$$