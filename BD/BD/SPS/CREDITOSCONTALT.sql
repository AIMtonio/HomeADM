-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSCONTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSCONTALT`;

DELIMITER $$
CREATE PROCEDURE `CREDITOSCONTALT`(
	# ===============================================================
	# ------ SP PARA DAR DE ALTA UN CREDITO NUEVO CONTINGENTE -------
	# ===============================================================
    Par_ClienteID       	INT(11),
    Par_LinCreditoID    	INT(11),
    Par_ProduCredID     	INT(11),
    Par_CuentaID        	BIGINT(12),
	Par_TipoCredito     	CHAR(1),

    Par_Relacionado     	BIGINT(12),
    Par_SolicCredID     	INT(11),
    Par_MontoCredito    	DECIMAL(14,2),
    Par_MonedaID        	INT(11),
    Par_FechaInicio     	DATE,

    Par_FechaVencim     	DATE,
    Par_FactorMora      	DECIMAL(12,2),
    Par_CalcInterID     	INT(11),
    Par_TasaBase        	INT(11),
    Par_TasaFija        	DECIMAL(12,4),

    Par_SobreTasa       	DECIMAL(12,4),
    Par_PisoTasa        	DECIMAL(12,2),
    Par_TechoTasa       	DECIMAL(12,2),
    Par_FrecuencCap     	CHAR(1),
    Par_PeriodCap       	INT(11),

    Par_FrecuencInt     	CHAR(1),
    Par_PeriodicInt     	INT(11),
    Par_TPagCapital     	VARCHAR(10),
    Par_NumAmortiza     	INT(11),
    Par_FecInhabil      	CHAR(1),

    Par_CalIrregul      	CHAR(1),
    Par_AjFUlVenAm      	CHAR(1),
    Par_AjuFecExiVe     	CHAR(1),
    Par_NumTransacSim   	BIGINT(20),
    Par_TipoFondeo      	CHAR(1),

    Par_MonComApe       	DECIMAL(12,2),
    Par_IVAComApe       	DECIMAL(12,2),
    Par_ValorCAT        	DECIMAL(12,4),
    Par_Plazo           	VARCHAR(20),
    Par_TipoDisper      	CHAR(1),

    Par_TipoCalInt      	INT(11),
    Par_DestinoCreID    	INT(11),
    Par_InstitFondeoID  	INT(11),
    Par_LineaFondeo     	INT(11),
    Par_NumAmortInt     	INT(11),

    Par_MontoCuota      	DECIMAL(12,2),
    Par_ClasiDestinCred 	CHAR(1),
	Par_TipoPrepago     	CHAR(1),
	Par_FechaInicioAmor		DATE,
    Par_FechaCobroComision 	DATE,

    Par_Salida          	CHAR(1),
    Par_CreditoID  			BIGINT(12),
    INOUT Par_NumErr    	INT(11),
    INOUT Par_ErrMen    	VARCHAR(400),

    Par_EmpresaID 			INT(11) ,
    Par_Usuario 			INT(11) ,
    Par_FechaActual 		DATETIME,
    Par_DireccionIP 		VARCHAR(15),
    Par_ProgramaID 			VARCHAR(50),
    Par_SucursalID 			INT(11) ,
    Par_NumTransaccion 		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Consecutivo					VARCHAR(50);
	DECLARE Var_TipPagComAp 				CHAR(1);
	DECLARE Decimal_Cero  					DECIMAL(12,2);
	DECLARE Var_MonedaCta   				BIGINT;
	DECLARE Var_EstFondeo   				CHAR(1);
	DECLARE Var_SaldoFondo  				DECIMAL(14,2);
	DECLARE Var_NomControl  				VARCHAR(50);
	DECLARE Var_SalCapConta     			DECIMAL(14,2);
	DECLARE Var_ValidaCapConta  			CHAR(1);
	DECLARE Var_PorcMaxCapConta 			DECIMAL(12,4);
	DECLARE Var_MonMaxPer       			DECIMAL(12,2);
	DECLARE Var_EstatusCta					CHAR(1);
	DECLARE Var_EstatusCliente				CHAR(1);
	DECLARE Var_FechaSistema				DATE;
	DECLARE Var_DestinoCre					INT;
	DECLARE Var_TipCobComMorato				CHAR(1);
	DECLARE Var_Control             		VARCHAR(100);
	DECLARE Var_CobraComisionComAnual		VARCHAR(1);				-- Cobra Comision S:Si N:No
	DECLARE Var_TipoComisionComAnual		VARCHAR(1);				-- Tipo de Comision P:Porcentaje M:Monto
	DECLARE Var_BaseCalculoComAnual			VARCHAR(1);				-- Base del Calculo M:Monto del credito Original S:Saldo Insoluto
	DECLARE Var_MontoComisionComAnual		DECIMAL(14,2);			-- Monto de la Comision en caso de que el tipo de comision sea M
	DECLARE Var_PorcentajeComisionComAnual	DECIMAL(14,4);			-- Porcentaje de la comision en caso de que el tipo de comision sea P
	DECLARE Var_DiasGraciaComAnual			INT(11);				-- Dias de gracia que se dan antes de cobrar la comision
    DECLARE Var_FiraInstitucionID			INT(11);				-- ID de institucion asignada a FIRA
    DECLARE	Var_FiraLineaID					INT(11);				-- ID de institucion asignada a FIRA
	DECLARE	Var_ClasifRegID					INT(11);
    DECLARE Var_IVAInteres					DECIMAL(12,2);
    DECLARE Var_IVAComisiones				DECIMAL(12,2);
    DECLARE Var_CalendIrregular				CHAR(1);

	DECLARE Var_ManejaComAdmon				CHAR(1);		-- Maneja Comisión Administración \nS.- SI \nN.- NO
	DECLARE Var_ComAdmonLinPrevLiq			CHAR(1);		-- comisión de Admon que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobComAdmon				CHAR(1);		-- Forma Cobro Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición \nC.- Cada Cuota
	DECLARE Var_ForPagComAdmon				CHAR(1);		-- Forma Pago Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición \nC.- Cada Cuota
	DECLARE Var_PorcentajeComAdmon			DECIMAL(6,2);	-- permite un valor de 0% a 100%

	DECLARE Var_ManejaComGarantia			CHAR(1);		-- Maneja Comisión por Garantía \nS.- SI \nN.- NO
	DECLARE Var_ComGarLinPrevLiq			CHAR(1);		-- comisión de Garantia que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobComGarantia			CHAR(1);		-- Forma Cobro Comisión Garantía \n"".- No aplica \nC.- Cada Cuota
	DECLARE Var_ForPagComGarantia			CHAR(1);		-- Forma Pago Comisión Garantía \n"".- No aplica \nC.- Cada Cuota
	DECLARE Var_PorcentajeComGarantia		DECIMAL(6,2);	-- permite un valor de 0% a 100%

	DECLARE Var_MontoPagComAdmon			DECIMAL(14,2);	-- Monto a Pagar por Comisión por Administración
	DECLARE Var_MontoCobComAdmon			DECIMAL(14,2);	-- Monto Cobrado por Comisión por Administración
	DECLARE Var_MontoPagComGarantia			DECIMAL(14,2);	-- Monto a Pagar por Comisión por Servicio de Garantia
	DECLARE Var_MontoCobComGarantia			DECIMAL(14,2);	-- Monto Cobrado por Comisión por Servicio de Garantía
	DECLARE Var_MontoPagComGarantiaSim		DECIMAL(14,2);	-- Monto Simulado por Comisión por Servicio de Garantía
	DECLARE Var_SaldoComServGar				DECIMAL(14,2);	-- Saldo Comision por Servicio de Garantia Agro
	DECLARE Var_SaldoIVAComSerGar			DECIMAL(14,2);	-- Saldo Iva Comision por Servicio de Garantia Agro

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Entero_Cero         INT;
	DECLARE Fecha_Vacia         DATE;
	DECLARE consecutivo         BIGINT(12);
	DECLARE Estatus_Activo      CHAR(1);
	DECLARE Estatus_Cancelado	CHAR(1);
	DECLARE Estatus_Inactivo    CHAR(1);
	DECLARE Rec_Propios         CHAR(1);
	DECLARE Rec_Fondeo          CHAR(1);
	DECLARE SalidaSI            CHAR(1);
	DECLARE SalidaNO            CHAR(1);
	DECLARE PagoCreciente   	CHAR(1);
	DECLARE Var_TipPagCapL   	CHAR(1);
	DECLARE Si_ValidaCapConta   CHAR(1);
	DECLARE MenorEdad			CHAR(1);
	DECLARE Constante_NO		CHAR(1);
	DECLARE Constante_SI		CHAR(1);
	DECLARE Est_Vencido			CHAR(1);
    DECLARE Estatus_Vigente		CHAR(1);
	DECLARE Entero_Uno			INT(11);
    DECLARE Fira_InstitucionID	VARCHAR(20);
    DECLARE Fira_LineaID		VARCHAR(20);

	--  Asignacion de Constantes
	SET Estatus_Activo      := 'A';             -- Estatus Activo
	SET Estatus_Cancelado	:= 'C';
	SET Cadena_Vacia        := '';              -- Cadena Vacia
	SET Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero         := 0;               -- Entero en Cero
	SET Decimal_Cero        := 0.0;             -- DECIMAL Cero
	SET Estatus_Inactivo    := 'I';             -- Estatus del Credito: Iactivo
	SET PagoCreciente       := 'C';             -- Tipo de Pago de Capital: Crecientes
	SET Var_TipPagCapL      := 'L';             -- Tipo de Pago de Capital: Crecientes
	SET Rec_Propios         := 'P';             -- Tipo de Recursos: Propios
	SET Rec_Fondeo          := 'F';             -- Tipo de Recursos: Con Institucion de Fondeo
	SET SalidaSI            := 'S';             -- El store si Regresa una Salida
	SET SalidaNO            := 'N';             -- El store no Regresa una Salida
	SET Si_ValidaCapConta   := 'S';             -- SI Valida el Capital Contable
	SET Constante_NO		:= 'N';				-- Constante NO
	SET Constante_SI		:= 'S';				-- Constante SI
    SET Estatus_Vigente		:= 'V';
	SET Entero_Uno			:= 1;
    SET Fira_InstitucionID	:='FiraInstitucionID';
    SET Fira_LineaID		:= 'FiraLineaID';

    SET Var_ClasifRegID		:= 0;
    SET Var_IVAInteres		:= 0.0;
    SET Var_IVAComisiones	:= 0.0;
    SET Var_CalendIrregular	:= 'N';


	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOSCONTALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;
		SELECT 	SaldoCapContable,	FechaSistema	INTO Var_SalCapConta,	Var_FechaSistema
			FROM PARAMETROSSIS;

		SELECT Estatus INTO Var_EstatusCliente
			FROM CLIENTES WHERE ClienteID=Par_ClienteID;

		SET Var_SalCapConta 		:= IFNULL(Var_SalCapConta, Entero_Cero);
		SET Var_FiraInstitucionID 	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro =Fira_InstitucionID );
		SET Var_FiraLineaID 		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro=Fira_LineaID);



		IF(Var_EstatusCliente= Estatus_Inactivo) THEN
			SET Par_NumErr      := 1;
			SET Par_ErrMen      := 'El safilocale.cliente Indicado se Encuentra Inactivo.';
			SET Var_NomControl  := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SELECT  ForCobroComAper, 	ValidaCapConta, 		PorcMaxCapConta
			INTO    Var_TipPagComAp, 	Var_ValidaCapConta, 	Var_PorcMaxCapConta
				FROM PRODUCTOSCREDITO
					WHERE	 ProducCreditoID = Par_ProduCredID;

		SET Var_ValidaCapConta  := IFNULL(Var_ValidaCapConta, Cadena_Vacia);
		SET Var_PorcMaxCapConta := IFNULL(Var_PorcMaxCapConta, Entero_Cero);

		SELECT MonedaID,	Estatus INTO Var_MonedaCta,		Var_EstatusCta
			FROM CUENTASAHO
		WHERE   ClienteID   = Par_ClienteID
		  AND   CuentaAhoID = Par_CuentaID;

		SET Var_EstatusCta := IFNULL(Var_EstatusCta,Cadena_Vacia);

        SET Var_DestinoCre:=(SELECT ProductoCreditoID FROM DESTINOSCREDPROD
								WHERE ProductoCreditoID = Par_ProduCredID
                            AND DestinoCreID = Par_DestinoCreID);

        SET Var_DestinoCre		:=IFNULL(Var_DestinoCre,Entero_Cero);

		IF(IFNULL(Par_SucursalID, Entero_Cero)= Entero_Cero) THEN
			SET Par_NumErr      := 3;
			SET Par_ErrMen      := 'El Numero de Sucursal esta Vacio.' ;
			SET Var_NomControl  := 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ClienteID, Entero_Cero)= Entero_Cero ) THEN
			SET Par_NumErr      := 4;
			SET Par_ErrMen      := 'El Numero de safilocale.cliente esta Vacio.';
			SET Var_NomControl  := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_MonedaCta <> Par_MonedaID )THEN
			SET Par_NumErr      := 8;
			SET Par_ErrMen      :='La Moneda de la Cuenta es Diferente de la Moneda del Credito.'  ;
			SET Var_NomControl  := 'monedaID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaID, Entero_Cero)= Entero_Cero) THEN
			SET Par_NumErr      := 9;
			SET Par_ErrMen      :='El Numero de Cuenta esta Vacio.';
			SET Var_NomControl  := 'cuentaID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_TipoFondeo  := IFNULL(Par_TipoFondeo, Cadena_Vacia);

        IF(IFNULL(Par_InstitFondeoID, Entero_Cero)<> Var_FiraInstitucionID)THEN
			SET Par_InstitFondeoID      := Var_FiraInstitucionID;
			SET Par_LineaFondeo      	:= Var_FiraLineaID;
        END IF;

		SELECT  Ins.Estatus, Lin.SaldoLinea INTO Var_EstFondeo, Var_SaldoFondo
		FROM INSTITUTFONDEO Ins, LINEAFONDEADOR Lin
		WHERE   Ins.InstitutFondID  = Lin.InstitutFondID
		  AND   Ins.InstitutFondID  = Par_InstitFondeoID
		  AND   Lin.LineaFondeoID   = Par_LineaFondeo;

		SET Var_EstFondeo   := IFNULL(Var_EstFondeo, Cadena_Vacia);
		SET Var_SaldoFondo  := IFNULL(Var_SaldoFondo, Entero_Cero);

		IF (Var_EstFondeo != Estatus_Activo) THEN
			SET Par_NumErr := 10;
			SET	Par_ErrMen :='La Institucion de Fondeo No Existe o No esta Activa.' ;
			SET Var_NomControl  := 'institFondeoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_SaldoFondo < Par_MontoCredito) THEN
			SET Par_NumErr      := 11;
			SET Par_ErrMen      :='Saldo de la Linea de Fondeo Insuficiente.' ;
			SET Var_NomControl  := 'institFondeoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusCta != Estatus_Activo )THEN
			SET Par_NumErr      := 14;
			SET Par_ErrMen      := CONCAT('La Cuenta ',CONVERT(Par_CuentaID, CHAR),' No se Encuentra Vigente.' );
			SET Var_NomControl  := 'cuentaID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TPagCapital = PagoCreciente) THEN
			SET Par_NumAmortInt :=  Par_NumAmortiza;
		END IF;

		-- valida que el cliente no sea menor de edad
		IF EXISTS (SELECT ClienteID	FROM CLIENTES WHERE ClienteID = Par_ClienteID AND EsMenorEdad = MenorEdad)THEN
			SET Par_NumErr      := 16;
			SET Par_ErrMen      :='El safilocale.cliente es Menor, No es Posible Asignar Credito.' ;
			SET Var_NomControl  := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaInicioAmor, Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr      := 19;
			SET Par_ErrMen      := 'Especifique la Fecha de Inicio de Amortizaciones.';
			SET Var_NomControl  := 'fechaInicioAmor';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoCredito, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr      := 21;
			SET Par_ErrMen      := 'Especifique el Tipo de Credito.';
			SET Var_NomControl  := 'tipoCredito';
			LEAVE ManejoErrores;
		END IF;

        IF(Var_DestinoCre=Cadena_Vacia)THEN
            SET Par_NumErr	:= 22;
            SET	Par_ErrMen	:= 'El Destino de Credito Seleccionado no Corresponde con el Producto por su Clasificacion.';
            SET Var_NomControl  := 'destinoCreID';
            LEAVE ManejoErrores;
        END IF;

	  IF(Par_Plazo = Cadena_Vacia )THEN
			SET Par_NumErr      := 23;
			SET Par_ErrMen      := CONCAT('Especifique el Plazo del Credito.' );
			SET Var_NomControl  := 'plazoID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumAmortiza := IFNULL(Par_NumAmortiza,Entero_Cero); -- mh
		SET Par_FechaActual := CURRENT_TIMESTAMP();

		SELECT
			CobraComision,					TipoComision,				BaseCalculo,				MontoComision,				PorcentajeComision,
			DiasGracia
		INTO
			Var_CobraComisionComAnual,		Var_TipoComisionComAnual,	Var_BaseCalculoComAnual,	Var_MontoComisionComAnual,	Var_PorcentajeComisionComAnual,
			Var_DiasGraciaComAnual
		FROM ESQUEMACOMANUAL
				WHERE ProducCreditoID = Par_ProduCredID;

		SELECT IVAInteres,IVAComisiones,CalendIrregular,ClasifRegID
			INTO Var_IVAInteres,Var_IVAComisiones,Var_CalendIrregular,Var_ClasifRegID
        FROM CREDITOS
        WHERE CreditoID=Par_CreditoID;

        SET Var_IVAInteres		:= IFNULL(Var_IVAInteres,Decimal_Cero);
        SET Var_IVAComisiones	:= IFNULL(Var_IVAComisiones,Decimal_Cero);
        SET Var_CalendIrregular	:= IFNULL(Var_CalendIrregular, Constante_NO);
        SET Var_ClasifRegID		:= IFNULL(Var_ClasifRegID,Entero_Cero);
		SET Var_CobraComisionComAnual		:= IFNULL(Var_CobraComisionComAnual, Constante_NO);
		SET Var_TipoComisionComAnual		:= IFNULL(Var_TipoComisionComAnual, Cadena_Vacia);
		SET Var_BaseCalculoComAnual			:= IFNULL(Var_BaseCalculoComAnual, Cadena_Vacia);
		SET Var_MontoComisionComAnual		:= IFNULL(Var_MontoComisionComAnual, Entero_Cero);
		SET Var_PorcentajeComisionComAnual	:= IFNULL(Var_PorcentajeComisionComAnual, Decimal_Cero);
		SET Var_DiasGraciaComAnual			:= IFNULL(Var_DiasGraciaComAnual, Entero_Cero);

        SET Par_LinCreditoID = IFNULL(Par_LinCreditoID,Entero_Cero);

		SET Var_TipCobComMorato := (SELECT TipCobComMorato FROM PRODUCTOSCREDITO WHERE  ProducCreditoID =Par_ProduCredID);

		SELECT	ManejaComAdmon,			ComAdmonLinPrevLiq,			ForCobComAdmon,				ForPagComAdmon,				PorcentajeComAdmon,
				ManejaComGarantia,		ComGarLinPrevLiq,			ForCobComGarantia,			ForPagComGarantia,			PorcentajeComGarantia,
				MontoPagComAdmon,		MontoCobComAdmon,			MontoPagComGarantia,		MontoCobComGarantia,		MontoPagComGarantiaSim,
				SaldoComServGar,		SaldoIVAComSerGar
		INTO	Var_ManejaComAdmon,		Var_ComAdmonLinPrevLiq,		Var_ForCobComAdmon,			Var_ForPagComAdmon,			Var_PorcentajeComAdmon,
				Var_ManejaComGarantia,	Var_ComGarLinPrevLiq,		Var_ForCobComGarantia,		Var_ForPagComGarantia,		Var_PorcentajeComGarantia,
				Var_MontoPagComAdmon,	Var_MontoCobComAdmon,		Var_MontoPagComGarantia,	Var_MontoCobComGarantia,	Var_MontoPagComGarantiaSim,
				Var_SaldoComServGar,	Var_SaldoIVAComSerGar
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_ManejaComAdmon		:= IFNULL(Var_ManejaComAdmon, Constante_NO);
		SET Var_ComAdmonLinPrevLiq	:= IFNULL(Var_ComAdmonLinPrevLiq, Constante_NO);
		SET Var_ForCobComAdmon		:= IFNULL(Var_ForCobComAdmon, Cadena_Vacia);
		SET Var_ForPagComAdmon		:= IFNULL(Var_ForPagComAdmon, Cadena_Vacia);
		SET Var_PorcentajeComAdmon	:= IFNULL(Var_PorcentajeComAdmon, Decimal_Cero);

		SET Var_ManejaComGarantia		:= IFNULL(Var_ManejaComGarantia, Constante_NO);
		SET Var_ComGarLinPrevLiq		:= IFNULL(Var_ComGarLinPrevLiq, Constante_NO);
		SET Var_ForCobComGarantia		:= IFNULL(Var_ForCobComGarantia, Cadena_Vacia);
		SET Var_ForPagComGarantia		:= IFNULL(Var_ForPagComGarantia, Cadena_Vacia);
		SET Var_PorcentajeComGarantia	:= IFNULL(Var_PorcentajeComGarantia, Decimal_Cero);

		SET Var_MontoPagComAdmon		:= IFNULL(Var_MontoPagComAdmon, Decimal_Cero);
		SET Var_MontoCobComAdmon		:= IFNULL(Var_MontoCobComAdmon, Decimal_Cero);
		SET Var_MontoPagComGarantia		:= IFNULL(Var_MontoPagComGarantia, Decimal_Cero);
		SET Var_MontoCobComGarantia		:= IFNULL(Var_MontoCobComGarantia, Decimal_Cero);
		SET Var_MontoPagComGarantiaSim	:= IFNULL(Var_MontoPagComGarantiaSim, Decimal_Cero);
		SET Var_SaldoComServGar			:= IFNULL(Var_SaldoComServGar, Decimal_Cero);
		SET Var_SaldoIVAComSerGar		:= IFNULL(Var_SaldoIVAComSerGar, Decimal_Cero);

		INSERT INTO CREDITOSCONT(
			CreditoID,					ClienteID,					LineaCreditoID,				ProductoCreditoID,			CuentaID,
			Relacionado,				SolicitudCreditoID,			MontoCredito,				MonedaID,					FechaInicio,
			FechaVencimien,				TipCobComMorato,			FactorMora,					CalcInteresID,				TasaBase,
			TasaFija,					SobreTasa,					PisoTasa,					TechoTasa,					FrecuenciaCap,
			PeriodicidadCap,			FrecuenciaInt,				PeriodicidadInt,			TipoPagoCapital,			NumAmortizacion,
			InstitFondeoID, 			LineaFondeo,				Estatus,					FechTraspasVenc,			FechTerminacion,
			SaldoCapVigent,				SaldoCapAtrasad,			SaldoCapVencido,			SaldCapVenNoExi,			SaldoInterOrdin,
			SaldoInterAtras,			SaldoInterVenc,				SaldoInterProvi,			SaldoIntNoConta,			SaldoIVAInteres,
			SaldoMoratorios,			SaldoIVAMorator,			SaldComFaltPago,			SalIVAComFalPag,			SaldoOtrasComis,
			SaldoIVAComisi,				ProvisionAcum,				FechaInhabil,				CalendIrregular,			AjusFecUlVenAmo,
			AjusFecExiVen,				NumTransacSim,				FechaMinistrado,			TipoFondeo,					SucursalID,
			ValorCAT,					MontoComApert,				IVAComApertura,				PlazoID,					TipoDispersion,
			TipoCalInteres,				DestinoCreID,				MontoPorDesemb,				NumAmortInteres,			MontoCuota,
			ComAperPagado,				ForCobroComAper,			ClasiDestinCred,			CicloGrupo,					GrupoID,
			TipoPrepago,				SaldoMoraVencido,			SaldoMoraCarVen,			FechaInicioAmor,			TipoCredito,
			CobraComAnual,				TipoComAnual,				BaseCalculoComAnual,		MontoComAnual,				PorcentajeComAnual,
			DiasGraciaComAnual,			ComAperCont,				IVAComAperCont,				FechaCobroComision,			FechaAutoriza,
			UsuarioAutoriza,			ClasifRegID,				IVAInteres,					IVAComisiones,
			ManejaComAdmon,				ComAdmonLinPrevLiq,			ForCobComAdmon,				ForPagComAdmon,				PorcentajeComAdmon,
			ManejaComGarantia,			ComGarLinPrevLiq,			ForCobComGarantia,			ForPagComGarantia,			PorcentajeComGarantia,
			SalCapitalOriginal,			SalInteresOriginal,			SalMoraOriginal,			SalComOriginal,				MontoPagComAdmon,
			MontoCobComAdmon,			MontoPagComGarantia,		MontoCobComGarantia,		MontoPagComGarantiaSim,		SaldoComServGar,
			SaldoIVAComSerGar,
			EmpresaID,					Usuario,					FechaActual,				DireccionIP,				ProgramaID,
			Sucursal,					NumTransaccion)
		VALUES(
			Par_CreditoID,				Par_ClienteID,				Par_LinCreditoID,			Par_ProduCredID,			Par_CuentaID,
			Entero_Cero,				Entero_Cero,				Par_MontoCredito,			Par_MonedaID,				Par_FechaInicio,
			Par_FechaVencim,			Var_TipCobComMorato,		Par_FactorMora,				Par_CalcInterID,			Par_TasaBase,
			Par_TasaFija,				Par_SobreTasa,				Par_PisoTasa,				Par_TechoTasa,				Par_FrecuencCap,
			Par_PeriodCap,				Par_FrecuencInt,			Par_PeriodicInt,			Par_TPagCapital,			Par_NumAmortiza,
			Par_InstitFondeoID,			Par_LineaFondeo,			Estatus_Vigente,			Fecha_Vacia,				Fecha_Vacia,
			Par_MontoCredito,			Decimal_Cero,				Decimal_Cero,				Decimal_Cero,				Decimal_Cero,
			Decimal_Cero,				Decimal_Cero,				Decimal_Cero,				Decimal_Cero,				Decimal_Cero,
			Decimal_Cero,				Decimal_Cero,				Decimal_Cero,				Decimal_Cero,				Decimal_Cero,
			Decimal_Cero,				Entero_Cero,				Par_FecInhabil,				Par_CalIrregul,				Par_AjFUlVenAm,
			Par_AjuFecExiVe,			Par_NumTransaccion,			Fecha_Vacia,				Par_TipoFondeo,				Par_SucursalID,
			Par_ValorCAT,				Par_MonComApe,				Par_IVAComApe,				Par_Plazo,					Par_TipoDisper,
			Par_TipoCalInt,				Par_DestinoCreID,			Entero_Cero,				Par_NumAmortInt,			Par_MontoCuota,
			Entero_Cero,				Var_TipPagComAp,			Par_ClasiDestinCred,		Entero_Cero,				Entero_Cero,
			Par_TipoPrepago,			Entero_Cero,				Entero_Cero,				Par_FechaInicioAmor,		Par_TipoCredito,
			Var_CobraComisionComAnual,	Var_TipoComisionComAnual,	Var_BaseCalculoComAnual,	Var_MontoComisionComAnual,	Var_PorcentajeComisionComAnual,
			Var_DiasGraciaComAnual,		Par_MonComApe,				Par_IVAComApe,				Fecha_Vacia,				Var_FechaSistema,
			Par_Usuario,				Var_ClasifRegID,			Var_IVAInteres,				Var_IVAComisiones,
			Var_ManejaComAdmon,			Var_ComAdmonLinPrevLiq,		Var_ForCobComAdmon,			Var_ForPagComAdmon,			Var_PorcentajeComAdmon,
			Var_ManejaComGarantia,		Var_ComGarLinPrevLiq,		Var_ForCobComGarantia,		Var_ForPagComGarantia,		Var_PorcentajeComGarantia,
			Decimal_Cero,				Decimal_Cero,				Decimal_Cero,				Decimal_Cero,				Var_MontoPagComAdmon,
			Var_MontoCobComAdmon,		Var_MontoPagComGarantia,	Var_MontoCobComGarantia,	Var_MontoPagComGarantiaSim,	Var_SaldoComServGar,
			Var_SaldoIVAComSerGar,
			Par_EmpresaID,				Par_Usuario,				Par_FechaActual,			Par_DireccionIP,			Par_ProgramaID,
			Par_SucursalID,				Par_NumTransaccion);


		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Credito Contingente Agregado Exitosamente: ', CONVERT(Par_CreditoID, CHAR), '.');
		SET Var_Consecutivo := Par_CreditoID;

	END ManejoErrores;

	 IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_NomControl 	AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$