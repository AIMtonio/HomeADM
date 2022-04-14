-- CRCBREESTRUCTURACREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBREESTRUCTURACREDPRO`;
DELIMITER $$

CREATE PROCEDURE `CRCBREESTRUCTURACREDPRO`(
	-- ===========================================================================================
	-- === SP para realizar alta de reestructuras de creditos de CREDICLUB =====
	-- ===========================================================================================
	Par_CreditoOrigen			BIGINT(20),			-- Credito origen SAFI
    Par_ClienteID				INT(11),			-- Numero de Cliente
    Par_ProductoCreditoID		INT(11),			-- Numero de Producto de Credito
    Par_Monto					DECIMAL(14,2),		-- Monto del Credito
    Par_TasaFija				DECIMAL(12,4),		-- Tasa Fija

    Par_Frecuencia				CHAR(1),    		-- Frecuencia de Pagos: Semanal, Catorcenal, Quincenal, Mensual ...... Anual
    Par_DiaPago					CHAR(1),   			-- Dia de Pago: Aniversario, Fin de Mes
    Par_DiaMesPago				INT(11),			-- Dia del mes en que se realizaran los Pagos
	Par_PlazoID         		INT(11),			-- Numero de Plazo
    Par_DestinoCreID			INT(11),			-- Destino de Credito

	Par_TipoIntegrante			INT(11),			-- Tipo Integrante: 1.- Presidente 2.- Tesorero 3.- Secretario 4.- Integrante
    Par_GrupoID         		INT(11),			-- Numero de Grupo
	Par_TipoDispersion      	CHAR(1),			-- Tipo de Dispersion
    Par_MontoPorComAper			DECIMAL(14,2),		-- Monto de Comision por Apertura de Credito
    Par_PromotorID				INT(11),			-- Numero de Promotor

    Par_CuentaClabe     		CHAR(18),			-- Numero de Cuenta CLABE
    Par_FechaIniPrimAmor		DATE,				-- Fecha de Inicio de la Primera Amortizacion
    Par_TipoConsultaSIC 		CHAR(2),			-- consulta fue Buro de Credito o Circulo de credito
	Par_FolioConsultaSIC 		VARCHAR(30),		-- campo correspondiente segun el tipo de Consulta SIC ( BC o CC).
	Par_ReferenciaPago			VARCHAR(20),		-- Referencia de Pago

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo			VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         	VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema		DATE;
    DECLARE Var_CreditoID			BIGINT(12);			-- Numero de Credito
	DECLARE Var_MontoComision   	DECIMAL(12,4);

	DECLARE Var_MontoInteres		DECIMAL(12,4);
	DECLARE Var_SolicitudCreditoID 	BIGINT(20);
	DECLARE Var_Estatus				CHAR(1);
	DECLARE Var_EstatusCredito		CHAR(1);
    DECLARE Var_EjecutaCierre		CHAR(1);			-- indica si se esta realizando el cierre de dia

	-- variables solicitud
    DECLARE Var_ProspectoID     	BIGINT(20);			-- ID Prospecto
	DECLARE Var_ClienteID       	INT(11);			-- ID Cliente
	DECLARE Var_ProduCredID     	INT(11);			-- ID Producto de Credito
	DECLARE Var_FechaReg        	DATE;				-- Fecha Registro
	DECLARE Var_Promotor        	INT(11);			-- ID Promotor

	DECLARE Var_TipoCredito     	CHAR(1);			-- Tipo de Credito
	DECLARE Var_NumCreditos     	INT(11);			-- Numero de Creditos
	DECLARE Var_Relacionado     	BIGINT(20);			-- Relacionado
	DECLARE Var_AporCliente     	DECIMAL(12,2);		-- Aportacion del Cliente
	DECLARE Var_Moneda          	INT(11);			-- ID Moneda

	DECLARE Var_DestinoCre      	INT(11);			-- Destino de Credito
	DECLARE Var_Proyecto        	VARCHAR(500);		-- Descripcionb Proyecto
	DECLARE Var_SucursalID      	INT(11);			-- ID Sucursal
	DECLARE Var_MontoSolic      	DECIMAL(12,2);		-- Monto Solicitado
	DECLARE Var_PlazoID         	INT(11);			-- ID Plazo

	DECLARE Var_FactorMora			DECIMAL(8,4);		-- Factor Mora
	DECLARE Var_ComApertura     	DECIMAL(12,4);		-- Comision por Apertura
	DECLARE Var_IVAComAper      	DECIMAL(12,4);		-- IVA Comision por APertura
	DECLARE Var_TipoDisper      	CHAR(1);			-- Tipo de Dispersion
	DECLARE Var_CalcInteres     	INT(11);			-- Calculo de Interes

	DECLARE Var_TasaBase        	DECIMAL(12,4);		-- Valor Tasa Base
	DECLARE Var_TasaFija        	DECIMAL(12,4);		-- Valor Tasa Fija
	DECLARE Var_SobreTasa       	DECIMAL(12,4);		-- Valor Sobre Tasa
	DECLARE Var_PisoTasa       	 	DECIMAL(12,4);		-- Valor Tipo Tasa
	DECLARE Var_TechoTasa       	DECIMAL(12,4);		-- Valor Techo Tasa

	DECLARE Var_FechInhabil     	CHAR(1);			-- Fecha Inhabil
	DECLARE Var_AjuFecExiVe     	CHAR(1);			-- Ajuste Fecha Exigible al Vencimiento
	DECLARE Var_CalIrreg        	CHAR(1);			-- Calendario Irregular
	DECLARE Var_AjFUlVenAm      	CHAR(1);			-- Ajuste Fecha Ultimo Vencimiento
	DECLARE Var_TipoPagCap      	CHAR(1);			-- Tipo de Pago de Capital

	DECLARE Var_FrecInter       	CHAR(1);			-- Frecuencia de Interes
	DECLARE Var_FrecCapital     	CHAR(1);			-- Frecuencia de Capital
	DECLARE Var_PeriodInt       	INT(11);			-- Periodicidad de Interes
	DECLARE Var_PeriodCap       	INT(11);			-- Periodicidad de Capital
	DECLARE Var_DiaPagInt       	CHAR(1);

	DECLARE Var_DiaPagCap       	CHAR(1);			-- Dia de Pago de Capital
	DECLARE Var_DiaMesInter     	INT(11);			-- Dia Mes Interes
	DECLARE Var_DiaMesCap       	INT(11);			-- Dia Mes Capital
	DECLARE Var_NumAmorti       	INT(11);			-- Numero de Amortizacion
	DECLARE Var_NumTransacSim   	BIGINT(20);			-- Numero de Transaccion

	DECLARE Var_CAT             	DECIMAL(12,4);		-- Valor del CAT
	DECLARE Var_CuentaClabe     	CHAR(18);			-- Cuenta CLABE
	DECLARE Var_TipoCalInt      	INT(11);			-- Tipo de Calculo de Interes
	DECLARE Var_TipoFondeo      	CHAR(1);			-- Tipo Fondeo
	DECLARE Var_InstitFondeoID  	INT(11);			-- ID Institucion de Fondeo

	DECLARE Var_LineaFondeo     	INT(11);			-- Linea de Fondeo
	DECLARE Var_NumAmortInt     	INT(11);			-- Numero de Amortizacion de Interes
	DECLARE Var_MontoCuota      	DECIMAL(12,2);		-- Monto de la Cuota
	DECLARE Var_GrupoID         	INT(11);			-- ID Grupo
	DECLARE Var_TipoIntegr      	INT(11);			-- Tipo Integrante

	DECLARE Var_FechaVencim     	DATE;				-- Fecha Vencimiento
	DECLARE Var_FechaInicio     	DATE;				-- Fecha de Inicio
	DECLARE Var_MontoSeguroVida 	DECIMAL(12,2);			-- Monto Seguro Vida
	DECLARE Var_ForCobroSegVida 	CHAR(1);			-- Forma de Cobro de Seguro de Vida
	DECLARE Var_ClasiDestinCred 	CHAR(1);			-- Clasificacion de Destino de Credito

	DECLARE Var_InstitNominaID  	INT(11);			-- ID Institucion Nomina
	DECLARE Var_FolioCtrl       	VARCHAR(20);		-- Numero de Folio
	DECLARE Var_HorarioVeri     	VARCHAR(20);		-- Horario de Verificacion
	DECLARE Var_PorcGarLiq      	DECIMAL(12,2);		-- Porcentaje de Garantia Liquida
	DECLARE Var_FechaInicioAmor 	DATE;				-- Fecha de Inicio de la primera Amoritizacion

	DECLARE Var_DescuentoSeguro 	DECIMAL(12,2);		-- Descuento de Seguro
	DECLARE Var_MontoSegOriginal  	DECIMAL(12,2);		-- Monto Seguro Original
	DECLARE Var_TipoLiquidacion 	CHAR(1);			-- Tipo Liquidacion
	DECLARE Var_CantidadPagar   	DECIMAL(12,2);		-- Cantidad Pagar
	DECLARE Var_TipoConsultaSIC 	CHAR(2);			-- Tipo Consulta SIC

	DECLARE Var_FolioConsultaBC 	VARCHAR(30);		-- Folio Consulta Buro de Credito
	DECLARE Var_FolioConsultaCC 	VARCHAR(30);		-- Folio Consulta Circulo de Credito
	DECLARE Var_FechaCobroComision 	DATE;				-- Fecha de Cobro de Comision
	DECLARE Var_InvCredAut			INT(11);
	DECLARE Var_CtaCredAut			BIGINT(12);


	DECLARE Var_Cobertura			DECIMAL(14,2);		-- Monto que corresponde al seguro de vida.
	DECLARE Var_Prima				DECIMAL(14,2);		-- Monto que el cliente paga/cubre respecto al seguro de vida
	DECLARE Var_Vigencia			INT(11);			-- Meses en que es valido el seguro de vida a partir de su contratacion
	DECLARE Var_ConvenioNominaID	BIGINT(20);		 	-- Identificador del convenio
	DECLARE Var_FolioSolici			VARCHAR(20);		-- Folio de solicitud convenio de nomina
	DECLARE Var_QuinquenioID		INT(11);			-- Quinquenio que hace referencia al catalogo de "CATQUINQUENIOS"
	DECLARE Var_ClabeDomiciliacion	VARCHAR(20);		-- Cuenta clabe de domiciliacion


	DECLARE Var_ReestCalVenc 		CHAR(1); 			-- Indica si se permite realizar una Reestructura a un Credito con el Calendario de Pagos Vencido\nS: SI N: NO',
	DECLARE Var_EstValReest 		CHAR(1);		 	-- Indica si se permite realizar una Reestructura a un Credito con estatus Vigente\nS: SI N: NO
	DECLARE Var_CicloCliente		INT(10);			-- Ciclo del Cliente
    DECLARE Var_CicloGrupal			INT(10);			-- Ciclo
    DECLARE Var_IVASucurs       	DECIMAL(12, 4);	-- IVA de la Sucursal
    DECLARE Var_SucCliente      	INT(11);		-- Sucursal del Cliente
    DECLARE Var_CliPagIVA			CHAR(1);		-- Cliente Paga IVA
    DECLARE Var_CalificaCli			CHAR(1); 		-- Calificacion del Cliente
    DECLARE Var_DiaPagoProd         CHAR(1);		-- Dia Pago Producto de Credito
    DECLARE	Var_NumDias				INT(11);		-- Numero de Dias del Plazo
	DECLARE Var_CobraSeguroCuota 	CHAR(1);        -- Cobra Seguro por cuota
	DECLARE Var_CobraIVASeguroCuota	CHAR(1);    	-- Cobra IVA Seguro por cuota
    DECLARE Var_Cuotas				INT(11);    	-- Numero de Cuotas
	DECLARE Var_NumReestructura		INT(11);
	DECLARE Var_NumDiasAtraOri		INT(11);
    DECLARE Var_SaldoExigible   	DECIMAL(14,2);  # Almacena el Saldo Exigible del Credito
	DECLARE Var_EstatusCrea     	CHAR(1);    # Almacena el Estatus de Creacion del Credito
	DECLARE Var_NumPagoSostenido  	INT(5);     # Almacena el Numero de Pagos Sostenidos
    DECLARE Var_NumRenovacion   	INT(5);     # Almacena el Numero de Renovacion sobre el Credito Original
	DECLARE Var_EstRelacionado    	CHAR(1);    # Almacena el Estatus del Credito Relacionado

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_NO   	    	CHAR(1);      		-- Constante NO
	DECLARE Cons_SI   	    	CHAR(1);      		-- Constante SI
    DECLARE ValorCierre			VARCHAR(30);
	DECLARE OrigenReestructura	CHAR(1);
	DECLARE Estatus_Inactivo	CHAR(1);
	DECLARE Estatus_Liberado	CHAR(1);
	DECLARE Estatus_Autorizado	CHAR(1);
    DECLARE SiPagaIVA      		CHAR(1);
	DECLARE PagoUnico			CHAR(1);
    DECLARE Act_LiberarSolicitud    INT(11);
    DECLARE	Act_AutorizaSolCRCBWS	INT(11);
	DECLARE Num_PagRegula     		INT(11);

    DECLARE Var_SaldoMoratorios		DECIMAL(14,2);
    DECLARE Var_TotalCapital		DECIMAL(14,2);
    DECLARE Var_TotalInteres		DECIMAL(14,2);
    DECLARE Var_TotalComisi			DECIMAL(14,2);
    DECLARE Var_TotalCondo			DECIMAL(14,2);
    DECLARE Var_UsuarioID			INT(11);
    DECLARE	Var_ClavePuestoID		CHAR(10);
    DECLARE Var_Porc100				DECIMAL(14,4);
    DECLARE Var_Poliza				BIGINT(20);
	DECLARE Var_AltaPoliza			CHAR(1);

	DECLARE Par_PeriodicidadCap		INT(11);		-- Periodicidad Capital
	DECLARE PagoSemanal				CHAR(1);
	DECLARE PagoDecenal         	CHAR(1);
    DECLARE PagoCatorcenal			CHAR(1);
	DECLARE PagoQuincenal			CHAR(1);
	DECLARE PagoMensual				CHAR(1);
	DECLARE PagoPeriodo				CHAR(1);
	DECLARE PagoBimestral			CHAR(1);
    DECLARE PagoTrimestral			CHAR(1);
	DECLARE PagoTetrames			CHAR(1);
	DECLARE PagoSemestral			CHAR(1);
	DECLARE PagoAnual				CHAR(1);
    DECLARE Par_NumAmortizacion		INT(11);		-- Numero de AMortizacion

	DECLARE FrecSemanal			INT(11);
    DECLARE FrecDecenal         INT(11);
    DECLARE FrecCator			INT(11);
    DECLARE FrecQuin			INT(11);
	DECLARE FrecMensual			INT(11);

    DECLARE FrecBimestral		INT(11);
	DECLARE FrecTrimestral		INT(11);
	DECLARE FrecTetrames		INT(11);
    DECLARE FrecSemestral		INT(11);
	DECLARE FrecAnual			INT(11);
    DECLARE Par_TipoPagoCapital			CHAR(1);		-- Tipo Pago Capital
    DECLARE TipoPagCapCrec      CHAR(1);
    DECLARE Par_PeriodicidadInt		INT(11);		-- Periodicidad Interes

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_NO		          	:= 'N';
	SET Cons_SI	          		:= 'S';
	SET ValorCierre				:= 'EjecucionCierreDia'; -- INDICA SI SE REALIZA EL CIERRE DE DIA.
	SET OrigenReestructura  	:= 'R';
	SET Estatus_Inactivo		:= 'I';
	SET Estatus_Liberado		:= 'L';
	SET Estatus_Autorizado		:= 'A';
    SET SiPagaIVA				:= 'S';             	-- El Cliente si Paga IVA
	SET PagoUnico				:= 'U';  				-- Tipo de Pago unico
    SET Act_LiberarSolicitud    := 11;  			-- Liberar Solicitud de Credito Individual
	SET	Act_AutorizaSolCRCBWS	:= 9;			    -- Tipo Actualizacion: Autorizacion de Solicitud de Credito	CREDICLUB WS
	SET Num_PagRegula       	:= 3;           # Numero de pagos sostenidos requerido segun CNBV
    SET Var_Porc100				:= 100.0000;
    SET Var_AltaPoliza			:= 'S';
	SET Par_PeriodicidadCap	:= Entero_Cero;			-- Periodicidad de Capital
    SET PagoSemanal			:= 'S'; 				-- Tipo de Pago Semanal
    SET PagoDecenal         := 'D'; 				-- Tipo de Pago Decenal

    SET PagoCatorcenal		:= 'C';  				-- Tipo de Pago Catorcenal
	SET PagoQuincenal		:= 'Q';  				-- Tipo de Pago Quincenal
	SET PagoMensual			:= 'M';  				-- Tipo de Pago Mensual
	SET PagoPeriodo			:= 'P';  				-- Tipo de Pago periodo
	SET PagoBimestral		:= 'B';  				-- Tipo de Pago bimestral

    SET PagoTrimestral		:= 'T';  				-- Tipo de Pago trimestral
	SET PagoTetrames		:= 'R';	 				-- Tipo de Pago tetramestral
	SET PagoSemestral		:= 'E';  				-- Tipo de Pago semestral
	SET PagoAnual			:= 'A';  				-- Tipo de Pago anual

	SET FrecSemanal			:= 7;	 				-- Tipo de Frecuencia 7 dias
    SET FrecDecenal         := 10; 					-- Tipo de Frecuencia 10 dias
	SET FrecCator			:= 14;		 			-- Tipo de Frecuencia 14 dias
	SET FrecQuin			:= 15;		 			-- Tipo de Frecuencia 15 dias
	SET FrecMensual			:= 30;		 			-- Tipo de Frecuencia 30 dias

    SET FrecBimestral		:= 60;		 			-- Tipo de Frecuencia 60 dias
	SET FrecTrimestral		:= 90;		 			-- Tipo de Frecuencia 90 dias
	SET FrecTetrames		:= 120;		 			-- Tipo de Frecuencia 120 dias
	SET FrecSemestral		:= 180;		 			-- Tipo de Frecuencia 180 dias
	SET FrecAnual			:= 360;	 				-- Tipo de Frecuencia 360 dias
    SET TipoPagCapCrec      := 'C';             	-- Tipo de Pago: Creciente
    SET Par_PeriodicidadInt := Entero_Cero;			-- Periodicidad de Interes

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = '999';
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBREESTRUCTURACREDPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']');
			SET Var_Control := 'sqlException' ;
		END;

        SET Var_EjecutaCierre 	:= (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

        SELECT ValorParametro INTO Par_TipoPagoCapital FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'TipoPagoCapital';

		-- Validamos que no se este ejecutando el cierre de dia
		IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=Cons_SI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			LEAVE ManejoErrores;
		END IF;

        SELECT CreditoID, Estatus
			INTO Var_CreditoID, Var_EstatusCredito
        FROM CREDITOS
        WHERE CreditoID = Par_CreditoOrigen;

        IF(IFNULL(Var_CreditoID,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Credito No Existe.';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Var_EstatusCredito,Cadena_Vacia) <> 'V' )THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Credito a Reestructurar debe estar Vigente.';
			LEAVE ManejoErrores;
		END IF;

		-- PARAMETROS DEL SISTEMA
        SELECT FechaSistema,	ReestCalVenc, 	EstValReest
			INTO Var_FechaSistema, Var_ReestCalVenc, 	Var_EstValReest
        FROM PARAMETROSSIS
        LIMIT 1;

		SET Var_MontoComision :=(SELECT FUNCIONCONCOMFALPAGCRE(Par_CreditoOrigen));
		SET Var_MontoInteres  :=(SELECT FNTOTALINTERESCREDITO(Par_CreditoOrigen));

		-- VALIDA SI EXISTE UNA SOLICITUD PARA REESTRUCTURA
		SELECT SolicitudCreditoID,		Estatus
			INTO Var_SolicitudCreditoID,	Var_Estatus
		FROM SOLICITUDCREDITO
		WHERE Relacionado = Par_CreditoOrigen
			AND TipoCredito = OrigenReestructura
			AND Estatus IN (Estatus_Inactivo, Estatus_Liberado, Estatus_Autorizado);

		SET Var_SolicitudCreditoID	:= IFNULL(Var_SolicitudCreditoID, Entero_Cero);
		SET Var_Estatus	:= IFNULL(Var_Estatus, Cadena_Vacia);

        IF(IFNULL(Var_SolicitudCreditoID,Entero_Cero) > Entero_Cero)THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'Ya Existe una Solicitud de Reestructura para este Credito.';
			LEAVE ManejoErrores;
		END IF;



        -- GHERNANDEZ
        CALL CREDITOSCONDONACRCB (
						Var_CreditoID,		Var_SaldoMoratorios, 	Var_TotalCapital,	Var_TotalInteres,	Var_TotalComisi,
                        Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
                        Aud_Sucursal,      	Aud_NumTransaccion);

	   SET Var_TotalCondo := Var_SaldoMoratorios + Var_TotalInteres + Var_TotalComisi;

       IF (IFNULL(Var_TotalCondo, Decimal_Cero) > Decimal_Cero) THEN
		-- OBTENGO USUARIO
        SELECT 			UsuarioID, 		ClavePuestoID
				INTO 	Var_UsuarioID, 	Var_ClavePuestoID
                FROM USUARIOS WHERE Estatus='A' LIMIT 1;
       -- CONDONO COMISIONES, INTERES Y MORATORIOS
			CALL CREQUITASPRO(
						Var_CreditoID,			Var_UsuarioID,			Var_ClavePuestoID,		Var_FechaSistema,		Var_TotalComisi,
                        Var_Porc100,
                        Var_SaldoMoratorios,	Var_Porc100,			Var_TotalInteres,		Var_Porc100,			Decimal_Cero,
                        Decimal_Cero,			Var_Poliza,				Var_AltaPoliza,			Salida_NO, 				Par_NumErr,
                        Par_ErrMen,
                        Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,       	Aud_DireccionIP,    	Aud_ProgramaID,
                        Aud_Sucursal,           Aud_NumTransaccion);

                IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
				END IF;
       END IF;

        -- FIN GHERNANDEZ


		-- DATOS CREDITO ORIGEN
		SELECT  Cre.CreditoID,			Cre.ClienteID,			Cre.ProductoCreditoID, 			Cre.Relacionado,			Cre.FechaInhabil,
				Cre.MonedaID,	 		Cre.Estatus,			Cre.DestinoCreID,				Cre.ClasiDestinCred,    	Cre.GrupoID,
				Cre.TipoCredito,		Cre.MontoCredito,		Sol.HorarioVeri,				Sol.InstitucionNominaID,	Cre.FechaInicio,
				Cre.FechaInicioAmor,	Cre.FechaVencimien,		Cre.PlazoID,					Cre.AporteCliente,			Cre.PorcGarLiq,
				Cre.TipoCalInteres,		Cre.CalcInteresID,		Cre.TasaBase,					Sol.FolioCtrl,				Cre.SobreTasa,
                Cre.TasaFija,			Cre.PisoTasa,			Cre.TechoTasa,					Cre.FactorMora,				Sol.Proyecto,
				Cre.TipoConsultaSIC,	Cre.FolioConsultaBC, 	Cre.FolioConsultaCC,			Sol.ConvenioNominaID,		Sol.PromotorID,
                Sol.SucursalID,			Sol.TipoDispersion,		Sol.CalendIrregular,			Sol.AjusFecExiVen,			Sol.AjusFecUlVenAmo,
                Sol.TipoPagoCapital,	Sol.FrecuenciaInt,		Sol.FrecuenciaCap,				Sol.PeriodicidadInt,		Sol.PeriodicidadCap,
                Sol.DiaPagoInteres,		Sol.DiaPagoCapital,		Sol.DiaMesInteres,				Sol.DiaMesCapital,			Sol.CuentaCLABE,
                Sol.TipoFondeo,			Sol.InstitFondeoID,		Sol.QuinquenioID,				Sol.ClabeCtaDomici,			Sol.MontoPorComAper,
                Sol.LineaFondeo,		Sol.MontoCuota,			Sol.MontoSeguroVida,			Sol.ForCobroSegVida,		Sol.DescuentoSeguro,
                Sol.MontoSegOriginal, 	Sol.TipoLiquidacion,	Sol.CantidadPagar,				Sol.FechaCobroComision,		Sol.InvCredAut,
                Sol.CtaCredAut,			Sol.Cobertura,			Sol.Prima,	 					Sol.Vigencia,				Sol.FolioSolici
		INTO
				Var_CreditoID,			Var_ClienteID,			Var_ProduCredID,				Var_Relacionado,			Var_FechInhabil,
                Var_Moneda,				Var_EstatusCredito,		Var_DestinoCre,					Var_ClasiDestinCred,		Var_GrupoID,
                Var_TipoCredito,		Var_MontoSolic,			Var_HorarioVeri,				Var_InstitNominaID,			Var_FechaInicio,
                Var_FechaInicioAmor,	Var_FechaVencim,		Var_PlazoID,					Var_AporCliente,			Var_PorcGarLiq,
                Var_TipoCalInt,			Var_CalcInteres,		Var_TasaBase,					Var_FolioCtrl,				Var_SobreTasa,
                Var_TasaFija,			Var_PisoTasa,			Var_TechoTasa,					Var_FactorMora,				Var_Proyecto,
                Var_TipoConsultaSIC,	Var_FolioConsultaBC,	Var_FolioConsultaCC,            Var_ConvenioNominaID,		Var_Promotor,
                Var_SucursalID,			Var_TipoDisper,			Var_CalIrreg,					Var_AjuFecExiVe,			Var_AjFUlVenAm,
                Var_TipoPagCap,			Var_FrecInter,			Var_FrecCapital,				Var_PeriodInt,				Var_PeriodCap,
                Var_DiaPagInt,			Var_DiaPagCap,			Var_DiaMesInter,				Var_DiaMesCap,				Var_CuentaClabe,
                Var_TipoFondeo,			Var_InstitFondeoID,		Var_QuinquenioID,				Var_ClabeDomiciliacion,		Var_ComApertura,
                Var_LineaFondeo,		Var_MontoCuota,			Var_MontoSeguroVida,			Var_ForCobroSegVida,		Var_DescuentoSeguro,
                Var_MontoSegOriginal,	Var_TipoLiquidacion,	Var_CantidadPagar,				Var_FechaCobroComision,		Var_InvCredAut,
                Var_CtaCredAut,			Var_Cobertura,			Var_Prima,						Var_Vigencia,				Var_FolioSolici
		FROM CREDITOS Cre
			LEFT JOIN SOLICITUDCREDITO Sol
				ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
		WHERE Cre. CreditoID = Par_CreditoOrigen;

		-- valida si permite realizar una Reestructura a un Credito con el Calendario de Pagos Vencido
        IF(Var_ReestCalVenc = 'N' AND Var_FechaVencim < Var_FechaSistema)THEN
			SET Par_NumErr  := 004;
			SET Par_ErrMen  := 'La Fecha de Vencimiento debe ser Mayor a la Fecha de Inicio.';
			LEAVE ManejoErrores;
        END IF;


		--  Se asigna un valor para la periodicidad de Capital
			CASE Par_Frecuencia
				WHEN PagoSemanal	THEN SET Par_PeriodicidadCap	:=  FrecSemanal;
                WHEN PagoDecenal	THEN SET Par_PeriodicidadCap	:=  FrecDecenal;
				WHEN PagoCatorcenal	THEN SET Par_PeriodicidadCap	:=  FrecCator;
				WHEN PagoQuincenal	THEN SET Par_PeriodicidadCap	:=  FrecQuin;
				WHEN PagoMensual	THEN SET Par_PeriodicidadCap	:=  FrecMensual;
				WHEN PagoPeriodo	THEN SET Par_PeriodicidadCap 	:=  Entero_Treinta;
				WHEN PagoBimestral	THEN SET Par_PeriodicidadCap	:=  FrecBimestral;
				WHEN PagoTrimestral	THEN SET Par_PeriodicidadCap	:=  FrecTrimestral;
				WHEN PagoTetrames	THEN SET Par_PeriodicidadCap	:=  FrecTetrames;
				WHEN PagoSemestral	THEN SET Par_PeriodicidadCap	:=  FrecSemestral;
				WHEN PagoAnual		THEN SET Par_PeriodicidadCap	:=  FrecAnual;
                WHEN PagoUnico 		THEN SET Par_PeriodicidadCap	:=  1;
		   END CASE;

                      -- Se obtiene la periodicidad de interes
            IF(Par_TipoPagoCapital = TipoPagCapCrec) THEN
				SET Par_PeriodicidadInt   := Par_PeriodicidadCap;
			END IF;

			IF(Par_Frecuencia =  PagoUnico) THEN
                SET Par_TipoPagoCapital   := 'I';
            END IF;

            IF(Par_PeriodicidadInt = Entero_Cero) THEN
				SET Par_PeriodicidadInt   := Par_PeriodicidadCap;
			END IF;

		SET Var_GrupoID := 0;

		SET Var_ProspectoID	:= Entero_Cero;
		SET Var_FechaReg := Var_FechaSistema;
        SET Var_TipoCredito := 'R';
        SET Var_FechaInicio := Var_FechaSistema;
        SET Var_FechaInicioAmor:= Var_FechaSistema;
        SET Var_NumAmorti := Var_PeriodCap;
        SET Var_NumAmortInt := Var_PeriodInt;
        SET Var_TipoIntegr := Entero_Cero;
        SET Var_Relacionado := Par_CreditoOrigen;

        SET Var_MontoSolic :=FNADEUDOTOTALCRED(Var_Relacionado);

		-- Se obtienen los datos requeridos del Producto de Credito
		SELECT CobraSeguroCuota, CobraIVASeguroCuota
			INTO   Var_CobraSeguroCuota, 	Var_CobraIVASeguroCuota
		FROM PRODUCTOSCREDITO
        WHERE ProducCreditoID = Var_ProduCredID;

        -- extendiendo el plazo por default 6 meses
        SET Var_PlazoID := (SELECT PlazoID FROM CREDITOSPLAZOS WHERE Dias=180 AND Frecuencia='M'); -- BUSCO EL PLAZO DE 6 MESES
		-- Se obtiene el Numero de Dias del Plazo
		SET Var_NumDias := (SELECT Dias FROM CREDITOSPLAZOS WHERE PlazoID = Var_PlazoID);
		-- Se obtiene la Fecha de Vencimiento
		SET Var_FechaVencim := (SELECT DATE_ADD(Var_FechaInicio, INTERVAL Var_NumDias DAY));

		-- Se obtiene el Numero de Cuotas
            IF(Par_Frecuencia = PagoUnico) THEN
				SET Par_NumAmortizacion := Entero_Uno;
			ELSE
				IF(Par_Frecuencia = PagoPeriodo)THEN
					SET Par_PeriodicidadCap := Var_NumDias;
				END IF;
				SET Par_NumAmortizacion := (Var_NumDias / Par_PeriodicidadCap);
			END IF;

               SET Par_NumAmortizacion := IFNULL(ROUND(Par_NumAmortizacion),Entero_Cero);

		SELECT  DiaPagoCapital
			INTO    Var_DiaPagoProd
		FROM CALENDARIOPROD
		WHERE ProductoCreditoID = Var_ProduCredID;

         -- Se obtienen datos requeridos del Cliente
		SELECT 	SucursalOrigen, 	PagaIVA,		CalificaCredito
			INTO 	Var_SucCliente, 	Var_CliPagIVA,	Var_CalificaCli
		FROM CLIENTES
        WHERE ClienteID = Var_ClienteID;
		SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);

         -- Consultamos el Numero de Ciclos(Creditos) que ha tenido el Cliente del mismo Producto de Credito
		CALL CRECALCULOCICLOPRO(
			Var_ClienteID,      	Var_ProspectoID,    	Var_ProduCredID,    		Var_GrupoID,    	Var_CicloCliente,
			Var_CicloGrupal, 		Salida_NO,           	Par_EmpresaID,      		Aud_Usuario,    	Aud_FechaActual,
			Aud_DireccionIP,    	Aud_ProgramaID,     	Aud_Sucursal,       		Aud_NumTransaccion);

		IF(Var_GrupoID > Entero_Cero) THEN
			SET Var_NumCreditos   := Var_CicloGrupal;
		ELSE
			SET Var_NumCreditos   := Var_CicloCliente;
		END IF;

		-- Se obtiene el IVA de la Sucursal
		SELECT IVA
			INTO Var_IVASucurs
		FROM SUCURSALES
        WHERE SucursalID = Var_SucCliente;

		IF (Var_CliPagIVA = SiPagaIVA) THEN
			SET Var_IVAComAper := ROUND((Var_ComApertura * Var_IVASucurs),2);
		END IF;

		SET Var_NumReestructura :=  IFNULL((SELECT NumeroReest
											FROM REESTRUCCREDITO
											WHERE CreditoDestinoID = Par_CreditoOrigen
												AND Origen = OrigenReestructura
												AND EstatusReest = 'D'
											LIMIT 1), Entero_Cero);


		SET Var_NumDiasAtraOri	:=	(SELECT  DATEDIFF(Var_FechaSistema, IFNULL(MIN(FechaExigible), Var_FechaSistema))
												FROM AMORTICREDITO Amo
												WHERE Amo.CreditoID = Par_CreditoOrigen
													AND Amo.Estatus != 'P'
													AND Amo.FechaExigible <= Var_FechaSistema);

        IF(Var_FrecCapital <> PagoUnico ) THEN

			CALL CREPAGCRECAMORPRO(
				Entero_Cero,
				Var_MontoSolic,			Var_TasaFija,				Par_PeriodicidadCap,			Par_Frecuencia,				Var_DiaPagoProd,
                Var_DiaMesCap,			Var_FechaInicio,			Par_NumAmortizacion,			Var_ProduCredID,			Var_ClienteID,
                Var_FechInhabil,		Var_AjFUlVenAm,				Var_AjuFecExiVe,				Var_ComApertura,			Var_AporCliente,
                Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Decimal_Cero,					0,							Salida_NO,
                Par_NumErr,             Par_ErrMen,					Var_NumTransacSim,				Var_Cuotas,					Var_CAT,
                Var_MontoCuota,			Var_FechaVencim,			Par_EmpresaID,					Aud_Usuario,				Aud_FechaActual,
                Aud_DireccionIP,        Aud_ProgramaID,				Aud_Sucursal,      				Aud_NumTransaccion
			);
            IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		ELSE

			SET Par_PeriodicidadCap := Var_NumDias;
            SET Par_PeriodicidadInt	:= Var_NumDias;

			CALL CREPAGIGUAMORPRO(
                Var_MontoSolic,         Var_TasaFija,               Par_PeriodicidadCap,   			Par_PeriodicidadCap,   		Par_Frecuencia,
                Par_Frecuencia,         Var_DiaPagCap,     			Var_DiaPagCap,  				Var_FechaInicio,    		Par_NumAmortizacion,
                Par_NumAmortizacion,    Var_ProduCredID,      		Var_ClienteID,      			Var_FechInhabil,   			Var_AjFUlVenAm,
                Var_AjuFecExiVe,      	Var_DiaPagCap,           	Var_DiaPagCap,      			Var_ComApertura,        	Var_AporCliente,
                Var_CobraSeguroCuota,   Var_CobraIVASeguroCuota, 	Decimal_Cero,					Decimal_Cero,    			Salida_NO,
                Par_NumErr,
                Par_ErrMen,             Var_NumTransacSim,          Var_Cuotas,         		Var_Cuotas,         		Var_CAT,
                Var_MontoCuota,			Var_FechaVencim,			Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
                Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,           	Aud_NumTransaccion
			);

            IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
            END IF;

        END IF;

		-- ALTA DE SOLICITUD DE REESTRUCTURA
		CALL SOLICITUDCREDITOALT(
			Var_ProspectoID,			Var_ClienteID,			Var_ProduCredID,			Var_FechaReg,				Var_Promotor,
			Var_TipoCredito,			Var_NumCreditos,		Var_Relacionado,			Var_AporCliente,			Var_Moneda,
			Var_DestinoCre,				Var_Proyecto,			Var_SucursalID,				Var_MontoSolic,				Var_PlazoID,
			Var_FactorMora,				Var_ComApertura,		Var_IVAComAper,				Var_TipoDisper,				Var_CalcInteres,
			Var_TasaBase,				Var_TasaFija,			Var_SobreTasa,				Var_PisoTasa,				Var_TechoTasa,

			Var_FechInhabil,			Var_AjuFecExiVe,		Var_CalIrreg,				Var_AjFUlVenAm,				Var_TipoPagCap,
			Par_Frecuencia,      		Par_Frecuencia,      	Par_PeriodicidadInt,        Par_PeriodicidadCap,		Var_DiaPagInt,
			Var_DiaPagCap,				Var_DiaMesInter,		Var_DiaMesCap,				Par_NumAmortizacion,		Var_NumTransacSim,
			Var_CAT,					Var_CuentaClabe,		Var_TipoCalInt,				Var_TipoFondeo,				Var_InstitFondeoID,
			Var_LineaFondeo,			Par_NumAmortizacion,		Var_MontoCuota,				Var_GrupoID,				Var_TipoIntegr,

			Var_FechaVencim,			Var_FechaInicio,		Var_MontoSeguroVida,		Var_ForCobroSegVida,		Var_ClasiDestinCred,
			Var_InstitNominaID,			Var_FolioCtrl,			Var_HorarioVeri,			Var_PorcGarLiq,				Var_FechaInicioAmor,
			Var_DescuentoSeguro,		Var_MontoSegOriginal,	Var_TipoLiquidacion,		Var_CantidadPagar,			Var_TipoConsultaSIC,
			Var_FolioConsultaBC,		Var_FolioConsultaCC,	Var_FechaCobroComision,		Var_InvCredAut,				Var_CtaCredAut,
			Var_Cobertura,				Var_Prima,				Var_Vigencia,				Var_ConvenioNominaID,		Var_FolioSolici,

			Var_QuinquenioID,			Var_ClabeDomiciliacion, Cadena_Vacia,				Cadena_Vacia,				Cadena_Vacia,
			Entero_Cero,				Entero_Cero,			Cadena_Vacia,				Cadena_Vacia,				Cadena_Vacia,
			Entero_Cero,				Cadena_Vacia,			Cadena_Vacia,				Cadena_Vacia,
			Salida_NO, 					Par_NumErr,             Par_ErrMen,                 Par_EmpresaID,				Aud_Usuario,
			Aud_FechaActual,       		Aud_DireccionIP,        Aud_ProgramaID,             Aud_Sucursal,           	Aud_NumTransaccion
		);

        IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se obtiene el Numero de la Solicitud de Credito
		SET Var_SolicitudCreditoID   := (SELECT SolicitudCreditoID FROM SOLICITUDCREDITO WHERE NumTransaccion = Aud_NumTransaccion);

        -- autoriza avales
        UPDATE AVALESPORSOLICI SET
			Estatus = 'U'
		WHERE SolicitudCreditoID = Var_SolicitudCreditoID;

        -- autoriza garantias
        UPDATE ASIGNAGARANTIAS SET
			Estatus = 'U'
		WHERE SolicitudCreditoID = Var_SolicitudCreditoID;

		# =============================================================================================================================
		# ----------------- Liberacion y Autorizacion de la Solicitud de REESTRUCTURA Credito Individual -------------------------------------------
		# ------------------------------------  -------------------------------------------------------------
		# =============================================================================================================================

		-- LLamada a SOLICITUDCREACT para Liberar la Solicitud de Credito
		CALL SOLICITUDCREACT (
			Var_SolicitudCreditoID,		Decimal_Cero,					Fecha_Vacia,				Aud_Usuario,		Decimal_Cero,
			'Reestructura',				'Reestructura',					Cadena_Vacia,               Cadena_Vacia,       Act_LiberarSolicitud,
			Salida_NO,			        Par_NumErr,                     Par_ErrMen,					Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,        	Aud_DireccionIP,                Aud_ProgramaID,         	Aud_Sucursal,       Aud_NumTransaccion
		);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se realiza la Autorizacion de la Solicitud de Credito
		CALL SOLICITUDCREACT (
			Var_SolicitudCreditoID,		Var_MontoSolic,					Var_FechaSistema,				Aud_Usuario,		Var_AporCliente,
			Cadena_Vacia,				'Reestructura mc',				Cadena_Vacia,                   Cadena_Vacia,       Act_AutorizaSolCRCBWS,
			Salida_NO,			        Par_NumErr,                     Par_ErrMen,					    Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	        Aud_DireccionIP,                Aud_ProgramaID,				    Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SELECT Estatus,				PeriodicidadCap,		TipoFondeo
			INTO Var_EstRelacionado,	Var_PeriodCap,			Var_TipoFondeo
		FROM CREDITOS
        WHERE CreditoID = Var_Relacionado;

		/***** VALIDACION PARA ASIGNAR EL ESTATUS AL CREDITO REESTRUCTURADO *****/
		CALL ESTATUSCREDITOACT(
			Var_Relacionado,	Var_EstRelacionado,	Var_EstatusCrea,	Cons_NO,			Par_NumErr,
			Par_ErrMen,     	Par_EmpresaID,    	Aud_Usuario,    	Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,   	Aud_Sucursal,   	Aud_NumTransaccion
		);

		# Revision del Numero de Pagos Sostenidos para ser Regularizado.

		# Se valida si el Tipo Frecuencia es diferente de Unica y Libre
		IF(Var_FrecCapital != PagoUnico) THEN
			# Si la periodicidad del Capital es mayor a 60 dias el numero de pagos sostenidos sera 1
			IF(Var_PeriodCap > 60) THEN
				SET Var_NumPagoSostenido  = 1;
			ELSE
				-- Var_PeriodCap: Periodicidad de Capital del Credito Anterior
				-- Var_PeriodCap: Periodicidad de Capital del Credito Nuevo
				IF(Var_FrecCapital != 'L') THEN
					IF(Var_PeriodCap > Entero_Cero)THEN
						SET Var_NumPagoSostenido := CEILING((Var_PeriodCap/Var_PeriodCap) * Num_PagRegula);
					ELSE
						SET Var_NumPagoSostenido := Entero_Cero;
					END IF;
				ELSE
					SET Var_NumPagoSostenido  = Num_PagRegula;
				END IF;
			END IF;
		ELSE

			IF(Var_FrecCapital = PagoUnico AND  Var_FrecInter = PagoUnico) THEN
				SET Var_NumPagoSostenido  = 1;
			ELSE
				IF(Var_FrecInter != 'P') THEN
					IF(Var_PeriodInt > Entero_Cero)THEN
						SET Var_NumPagoSostenido := CEILING((90/Var_PeriodInt));
					ELSE
						SET Var_NumPagoSostenido := Entero_Cero;
					END IF;
				ELSE
					SET Var_NumPagoSostenido  = 1;
				END IF;
			END IF;
		END IF;

		# Calculo de los Dias de Atraso
		SELECT  (DATEDIFF(Var_FechaSistema, IFNULL(MIN(FechaExigible), Var_FechaSistema)))
			INTO Var_NumDiasAtraOri
		FROM AMORTICREDITO Amo
		WHERE Amo.CreditoID = Var_Relacionado
			AND Amo.Estatus != 'P'
			AND Amo.FechaExigible <= Var_FechaSistema;

		# Revision del Numero de Renovaciones sobre el Credito Original
		SELECT  NumeroReest
			INTO Var_NumRenovacion
		FROM REESTRUCCREDITO
		WHERE CreditoOrigenID = Var_Relacionado
			AND EstatusReest = 'D';

		SET Var_NumRenovacion := IFNULL(Var_NumRenovacion, Entero_Cero) + 1;

		CALL REESTRUCCREDITOALT (
			Var_FechaSistema,   Aud_Usuario,        Var_Relacionado,      	Var_Relacionado,      	Var_MontoSolic,
			Var_EstRelacionado, Var_EstatusCrea,    Var_NumDiasAtraOri,   	Var_NumPagoSostenido,   Entero_Cero,
			Cons_NO,         	Fecha_Vacia,        Var_NumRenovacion,      Entero_Cero,      		Entero_Cero,
			Entero_Cero,    	Entero_Cero,    	OrigenReestructura,		Cons_NO,           		Par_NumErr,
			Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,
			'CRCBREESTRUCTURACREDPRO',      Aud_Sucursal,     	Aud_NumTransaccion
		);

		IF(Par_NumErr > Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Reestructura Realizada Exitosamente.');
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$