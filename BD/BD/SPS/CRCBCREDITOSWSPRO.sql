-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCREDITOSWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCREDITOSWSPRO`;
DELIMITER $$

CREATE PROCEDURE `CRCBCREDITOSWSPRO`(
	-- === SP para realizar alta de creditos mediante el WS de Alta de Creditos de CREDICLUB =====
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

	Par_Salida					CHAR(1), 			-- Indica mensaje de Salida
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Descripcion de Error

	Par_EmpresaID		        INT(11),			-- Parametro de Auditoria
	Aud_Usuario			        INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		  		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
    DECLARE Var_CreditoID			BIGINT(12);		-- Numero de Credito
	DECLARE Var_CuentaAhoID			BIGINT(12);		-- Numero de Cuenta
    DECLARE Par_FechaRegistro		DATE;			-- Fecha de Registro
    DECLARE Par_FechaAutoriza		DATE;			-- Fecha Autorizacion Credito
	DECLARE Par_TasaBase			DECIMAL(8,4);	-- Valor Tasa Base

    DECLARE Par_SobreTasa			DECIMAL(8,4);   -- Valor Sobre Tasa
	DECLARE Par_PisoTasa			DECIMAL(8,4);	-- Valor Piso Tasa
	DECLARE Par_TechoTasa			DECIMAL(8,4);	-- Valor Techo Tasa
	DECLARE Par_MontoAutorizado		DECIMAL(12,2);	-- Monto Autorizado
	DECLARE Par_FrecuenciaCap		CHAR(1);		-- Frecuencia Capitla

    DECLARE Par_PeriodicidadCap		INT(11);		-- Periodicidad Capital
	DECLARE Par_FrecuenciaInt		CHAR(1);		-- Frecuencia Interes
	DECLARE Par_PeriodicidadInt		INT(11);		-- Periodicidad Interes
	DECLARE Par_SucursalID			INT(11);		-- Sucursal en que se realiza la Transaccion
    DECLARE Par_IVAComAper			DECIMAL(12,4);	-- IVA Comision por Apertura

    DECLARE Par_CalcInteresID		INT(11);		-- Calculo de Interes
	DECLARE Par_NumAmortizacion		INT(11);		-- Numero de AMortizacion
	DECLARE Par_DiaPagoProd			CHAR(1);		-- Dia Pago Producto
	DECLARE Par_DiaPagoInteres		CHAR(1);		-- Dia Pago Interes
    DECLARE Par_DiaPagoCapital		CHAR(1);		-- Dia Pago Capital

    DECLARE Par_DiaMesInteres		INT(11);		-- Dia Mes Interes
	DECLARE Par_DiaMesCapital		INT(11);		-- Dia Mes Capital
	DECLARE Par_AjusFecUlVenAmo		CHAR(1);		-- Ajustes Fecha Ultimo Vencimiento
	DECLARE Par_AjusFecExiVen		CHAR(1);		-- Ajustes Fecha
    DECLARE Par_CAT					DECIMAL(12,4);  -- Valor CAT

    DECLARE Par_FechaInhabil		CHAR(1);		-- Fecha Inhabil
	DECLARE Par_AporteCliente		DECIMAL(12,2);	-- Aporte del Cliente
	DECLARE Par_PorcGarLiq			DECIMAL(12,2);  -- Porcentaje Garantia Liquida
	DECLARE Par_FactorMora			DECIMAL(8,4);	-- Factor Mora
    DECLARE Par_TipoCalInteres		INT(11);		-- Tipo de Calculo de Interes

    DECLARE Par_FechaVencimiento	DATE;			-- Fecha de Vencimiento
	DECLARE Par_FechaInicio			DATE;			-- Fecha de Inicio
	DECLARE Par_FechaInicioAmor		DATE;			-- Fecha de Inicio de la Primera Amorizacion
	DECLARE Par_ClasiDestinCred		CHAR(1);		-- Clasificacion Destino de Credito
    DECLARE Par_CicloGrupo			INT(11);		-- Ciclo del Grupo

    DECLARE Par_LineaCreditoID		BIGINT(20);		-- Linea de Credito
	DECLARE Par_ProspectoID         BIGINT(20);     -- Numero de Prospecto
    DECLARE Par_NumCreditos         INT(11);        -- Numero de Creditos
    DECLARE Par_Relacionado         BIGINT(12);     -- Credito Relacionado
    DECLARE Par_NumTransacSim		BIGINT(20);     -- Numero de Transaccion

    DECLARE Par_MontoCuota          DECIMAL(12,2);  -- Monto Cuota
	DECLARE Var_NumCiclos			INT(11);		-- Numero de Ciclos
	DECLARE Var_CicloCliente		INT(10);		-- Ciclo del Cliente
    DECLARE Var_CicloGrupal			INT(10);		-- Ciclo Grupal
    DECLARE Var_TipoCuentaID		INT(11);		-- Ciclo Grupal

    DECLARE Var_IVASucurs       	DECIMAL(12, 4);	-- IVA de la Sucursal
    DECLARE Var_CliPagIVA			CHAR(1);		-- Cliente Paga IVA
    DECLARE Var_SucCliente      	INT(11);		-- Sucursal del Cliente
	DECLARE Var_CalcInteres         INT(11);		-- Calculo de Interes
    DECLARE Var_TipoCalInteres      INT(11);		-- Tipo Calculo de Interes

    DECLARE Var_DiaPagoProd         CHAR(1);		-- Dia Pago Producto de Credito
    DECLARE Var_NumCuotas			DECIMAL(12,2);	-- Numero de Cuotas
    DECLARE	Var_NumDias				INT(11);		-- Numero de Dias del Plazo
	DECLARE Var_FecVencimiento		DATE;			-- Fecha de Vencimiento
    DECLARE Var_CalificaCli			CHAR(1); 		-- Calificacion del Cliente

    DECLARE Var_RequiereGarantia	CHAR(1);		-- Estatus si el producto de credito requiere garantia liquida: N.- NO, S.- SI
	DECLARE Par_CobraSeguroCuota 	CHAR(1);        -- Cobra Seguro por cuota
	DECLARE Par_CobraIVASeguroCuota		CHAR(1);    -- Cobra IVA Seguro por cuota
    DECLARE Par_Cuotas				INT(11);    	-- Numero de Cuotas
    DECLARE Var_SolicitudCreditoID	BIGINT(20);		-- Numero de Solicitud de Credito

    DECLARE Par_TipoPrepago			CHAR(1);		-- Tipo Prepago
    DECLARE	Var_FrecProdCred		VARCHAR(200);	-- Frecuencias por Producto de Credito
	DECLARE	Var_PlazoProdCred		VARCHAR(2000);	-- Plazos por Producto de Credito
    DECLARE Var_TipoDispProdCred	VARCHAR(200);	-- Tipo Dispersion por Producto de Credito

    DECLARE Var_TipPagCapProdCred	VARCHAR(200);	-- Tipo Pago de Capital por Producto de Credito
    DECLARE Par_TipoCuentaID		INT(11);		-- ID del tipo de Cuenta
    DECLARE Par_EsPrincipal			CHAR(1);		-- Indica si la cuenta es principal  S o N
	DECLARE Var_NumCuentasEje		INT(11);		-- Numero de Cuenta Eje por Cliente
	DECLARE Var_EsPrincipal			CHAR(1);		-- La Cuenta es Principal

    DECLARE Var_Tasa                DECIMAL(12,4);	-- Se obtiene el valor de la Tasa
    DECLARE Var_TipoConsultaSIC		CHAR(2);		-- TIPO CONSULTA SIC
    -- Parametros para Solicitud de Credito / Credito
	DECLARE Par_MonedaID				INT(11);		-- Numero de Moneda
	DECLARE Par_InstitucionNominaID		INT(11);		-- Numero de Institucion de Nomina
	DECLARE Par_FolioCtrl				VARCHAR(20);	-- Numero de Empleado de Nomina
	DECLARE Par_Proyecto				VARCHAR(500);	-- Descripcion Proyecto
	DECLARE Par_TipoPagoCapital			CHAR(1);		-- Tipo Pago Capital

    DECLARE Par_CalendIrregular			CHAR(1);		-- Calendario Irregular
	DECLARE Par_TipoCredito				CHAR(1);		-- Tipo de Credito
	DECLARE Par_TipoFondeo				CHAR(1);		-- Tipo de Fondeo
	DECLARE Par_InstitFondeoID			INT(11);		-- Institucion de Fondeo
	DECLARE Par_LineaFondeo				INT(11);		-- Linea de Fondeo

    DECLARE Par_FechaFormalizacion		DATE;			-- Fecha de Formalizacion
	DECLARE Par_MontoFondeado			DECIMAL(14,2);	-- Monto Fondeado
	DECLARE Par_PorcentajeFonde			DECIMAL(14,6);	-- Porcentaje Fondeado
	DECLARE Par_NumeroFondeos			INT(11);		-- Numero Fondeos
	DECLARE Par_ComentarioEjecutivo		VARCHAR(5000);	-- Comentario Ejecutivo

    DECLARE Par_ComentarioMesaControl	VARCHAR(6000);	-- Comentario Mesa de Control
    DECLARE Par_MontoSeguroVida			DECIMAL(12,2);	-- Monto Seguro de Vida
	DECLARE Par_ForCobroSegVida			CHAR(1);		-- Forma Cobro Seguro de Vida
	DECLARE Par_HorarioVeri				VARCHAR(20);	-- Horario Verificacion
	DECLARE Par_DescuentoSeguro			DECIMAL(12,2);	-- Descuento de Seguro

    DECLARE Par_MontoSegOriginal		DECIMAL(12,2);	-- Monto de Seguro Original
	DECLARE Var_EsGrupal				CHAR(1); 		-- Indica si el Producto de Credito es Grupal
    DECLARE	Var_ProrrateoPago			CHAR(1);		-- Prorrateo de Pago
	DECLARE Var_DestinoCre          	INT(11);		-- Destino de Credito por Producto
	DECLARE Var_LongCLABE				INT(11);		-- Longitud CLABE

	DECLARE Var_MontoComXapert			DECIMAL(12,2);	-- Monto Comision por Apertura Producto de Credito
	DECLARE Var_FechaCobroComision		DATE;			-- Fecha de cobro de la comision por apertura
    DECLARE Var_TipoComXapert			CHAR(1);		-- Tipo de cobro de la comision por apertura
    DECLARE Var_TipoBuro				VARCHAR(30);
    DECLARE Var_TipoCirculo				VARCHAR(30);
    DECLARE Var_EjecutaCierre			CHAR(1);			-- indica si se esta realizando el cierre de dia

    -- Declaracion de Constantes
    DECLARE Entero_Cero         INT(11);
    DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Decimal_Cero	    DECIMAL(12,2);
	DECLARE Fecha_Vacia         DATE;
    DECLARE SalidaSI            CHAR(1);
    DECLARE Entero_Treinta      INT(11);

    DECLARE SalidaNO            CHAR(1);
    DECLARE SimbInterrogacion	VARCHAR(1);
    DECLARE Deduccion			CHAR(1);
    DECLARE PagoSemanal			CHAR(1);
	DECLARE PagoDecenal         CHAR(1);

    DECLARE PagoCatorcenal		CHAR(1);
	DECLARE PagoQuincenal		CHAR(1);
	DECLARE PagoMensual			CHAR(1);
	DECLARE PagoPeriodo			CHAR(1);
	DECLARE PagoBimestral		CHAR(1);

    DECLARE PagoTrimestral		CHAR(1);
	DECLARE PagoTetrames		CHAR(1);
	DECLARE PagoSemestral		CHAR(1);
	DECLARE PagoAnual			CHAR(1);
	DECLARE PagoUnico			CHAR(1);

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

    DECLARE TipoPagCapCrec      CHAR(1);
    DECLARE SiPagaIVA      		CHAR(1);
    DECLARE TipoComMonto		CHAR(1);
    DECLARE TipoComPorcentaje   CHAR(1);
    DECLARE Entero_Cien 		INT(11);

    DECLARE Constante_No		CHAR(1);
    DECLARE Constante_Si		CHAR(1);
    DECLARE Act_LiberarSolicitud    INT(11);
    DECLARE Grupal_SI			CHAR(1);
    DECLARE DispSPEI			CHAR(1);

    DECLARE DispCheque			CHAR(1);
    DECLARE DispOrdenPago		CHAR(1);
    DECLARE DispEfectivo		CHAR(1);
    DECLARE Long_CLABE			INT(11);
    DECLARE DescVacio			VARCHAR(20);

    DECLARE Int_Presidente		INT(11);
    DECLARE Int_Tesorero		INT(11);
    DECLARE Int_Secretario		INT(11);
    DECLARE Int_Integrante		INT(11);
    DECLARE DiaPagoUltDiaMes	CHAR(1);

    DECLARE DiaPagoDiaMes		CHAR(1);
    DECLARE DiaPagoDiaAniver	CHAR(1);
    DECLARE DiaPagoIndistinto	CHAR(1);
    DECLARE	Act_AutorizaSolCRCBWS	INT(11);
    DECLARE Estatus_Activa  		CHAR(1);

    DECLARE Act_LibGrupoSolCRCBWS	INT(11);
    DECLARE Entero_Uno				INT(11);
	DECLARE TasaFijaID              INT(11);
	DECLARE	ConSic_TipoBuro			CHAR(2);
	DECLARE ConSic_TipoCirculo		CHAR(2);
    DECLARE Est_Grupo				CHAR(1);
    DECLARE Est_Abierto				CHAR(1);
    DECLARE Act_Inicia      		INT(11);
    DECLARE ValorCierre				VARCHAR(30);
    DECLARE Financiado				CHAR(1);
    DECLARE var_ForCobroComAper		CHAR(1);
    -- Asignacion de Constantes
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Decimal_Cero	    :=  0.00;   			-- DECIMAL Cero
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
    SET SalidaSI           	:= 'S';        			-- El Store SI genera una Salida

    SET	SalidaNO 	   	   	:= 'N';	      			-- El Store NO genera una Salida
    SET SimbInterrogacion	:= '?';					-- Simbolo de interrogacion
    SET Deduccion			:= 'D';					-- Forma Cobro Com. por Apertura: DEDUCCION
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
	SET PagoUnico			:= 'U';  				-- Tipo de Pago unico

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
    SET SiPagaIVA       	:= 'S';             	-- El Cliente si Paga IVA
    SET TipoComMonto		:= 'M';					-- Tipo Comision por Apertura: Monto
    SET TipoComPorcentaje	:= 'P';					-- Tipo Comision Apertura: Porcentaje
	SET Entero_Cien			:= 100;					-- Entero Cien

    SET Constante_No			:= 'N';				-- Constante NO
    SET Constante_Si			:= 'S';				-- Constante Si
    SET Act_LiberarSolicitud    := 11;  			-- Liberar Solicitud de Credito Individual
    SET Grupal_SI				:= 'S';				-- Si es Grupal
	SET DispSPEI				:= 'S';					-- Tipo Dispersion: SPEI

    SET DispCheque			:= 'C';					-- Tipo Dispersion: CHEQUE
    SET DispOrdenPago		:= 'O';					-- Tipo Dispersion: ORDEN DE PAGO
    SET DispEfectivo		:= 'E';					-- Tipo Dispersion: EFECTIVO
	SET Long_CLABE			:= 18;					-- Longitud Cuenta CLABE: 18
	SET DescVacio			:= 'VACIO';				-- Descripcion: VACIO

    SET Int_Presidente		:= 1;					-- Tipo Integrante: Presidente
	SET Int_Tesorero		:= 2;					-- Tipo Integrante: Tesorero
    SET Int_Secretario		:= 3;					-- Tipo Integrante: Secretario
    SET Int_Integrante		:= 4;					-- Tipo Integrante: Integrante
    SET DiaPagoUltDiaMes	:= 'F';					-- Dia Pago Capital: Ultimo Dia Mes

    SET DiaPagoDiaMes		:= 'D';					-- Dia Pago Capital: Dia Mes
    SET DiaPagoDiaAniver	:= 'A';					-- Dia Pago Capital: Aniversario
    SET DiaPagoIndistinto	:= 'I';					-- Dia Pago Capital: Indistinto
	SET	Act_AutorizaSolCRCBWS	:= 9;			    -- Tipo Actualizacion: Autorizacion de Solicitud de Credito	CREDICLUB WS
	SET Estatus_Activa  		:= 'A';             -- Estatus de la Cuenta: Activa

    SET Act_LibGrupoSolCRCBWS   := 10;  			-- Liberar Solicitud de Credito Grupal WS CREDICLUB
    SET Entero_Uno				:= 1;				-- Entero Uno
	SET TasaFijaID         	 	:= 1;               -- ID de la formula para tasa fija (FORMTIPOCALINT)-- Entero Uno
    SET ConSic_TipoBuro			:= 'BC';			-- Consulta SIC buro
	SET ConSic_TipoCirculo		:= 'CC';			-- Consulta SIC Circulo
    SET Est_Abierto				:= 'A';				-- Estatus grupo Abierto
   	SET Act_Inicia				:= 1;              		-- Tipo de Actualizacion: Inicio del Ciclo
    SET Entero_Treinta          :=30;
	SET ValorCierre				:= 'EjecucionCierreDia'; -- INDICA SI SE REALIZA EL CIERRE DE DIA.
    SET Financiado 				:= 'F';

	-- Asignacion de Variables
	SET Par_FechaRegistro   := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);		-- Fecha de Registro
    SET Par_FechaAutoriza	:= Fecha_Vacia;			-- Fecha Autoriza
    SET Par_TasaBase		:= Entero_Cero;			-- Valor Tasa Base
	SET Par_SobreTasa		:= Entero_Cero;			-- Valor Sobre Tasa
	SET Par_PisoTasa		:= Entero_Cero;			-- Valor Piso Tasa

    SET Par_TechoTasa		:= Entero_Cero;			-- Valor Techo Tasa
    SET Par_MontoAutorizado	:= Decimal_Cero;		-- Monto Autorizado
    SET Par_PeriodicidadCap	:= Entero_Cero;			-- Periodicidad de Capital
    SET Par_PeriodicidadInt := Entero_Cero;			-- Periodicidad de Interes
    SET Par_SucursalID		:= Aud_Sucursal;		-- Numero de Sucursal del Usuario

    SET Par_LineaCreditoID	:= Entero_Cero;			-- Numero de Linea de Credito
    SET Par_ProspectoID     := Entero_Cero;			-- Numero de Prospecto
    SET Par_NumCreditos		:= Entero_Cero;			-- Numero de Creditos del Cliente
    SET Par_Relacionado		:= Entero_Cero;			-- Credito Relacionado
    SET Par_NumTransacSim	:= Entero_Cero;			-- Numero de Transaccion

    SET Var_CicloCliente	:= Entero_Cero;			-- Cliclo del Cliente
    SET Var_CicloGrupal		:= Entero_Cero;			-- Ciclo Grupal
    SET Var_CreditoID		:= Entero_Cero;			-- Numero de Credito
    SET Var_CuentaAhoID		:= Entero_Cero;			-- Numero de Cuenta
    SET Par_IVAComAper		:= Decimal_Cero;		-- IVA Comision por Apertura

    SET Par_CAT				:= Decimal_Cero;		-- Valor CAT
	SET Var_LongCLABE		:= (SELECT LENGTH(Par_CuentaClabe));		-- Longitud CLABE

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
 		GET DIAGNOSTICS condition 1
          @Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = '999';
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBCREDITOSWSPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']');
		END;

			SET Var_EjecutaCierre 	:= (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

            -- Validamos que no se este ejecutando el cierre de dia
			IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=SalidaSI)THEN
				SET Par_NumErr  := 800;
				SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
				LEAVE ManejoErrores;
			END IF;

			SET Par_ClienteID			:= REPLACE(Par_ClienteID, SimbInterrogacion, Entero_Cero);
            SET Par_ProductoCreditoID	:= REPLACE(Par_ProductoCreditoID, SimbInterrogacion, Entero_Cero);
            SET Par_Monto				:= REPLACE(Par_Monto, SimbInterrogacion, Decimal_Cero);
            SET Par_TasaFija			:= REPLACE(Par_TasaFija, SimbInterrogacion, Decimal_Cero);
            SET Par_Frecuencia			:= REPLACE(Par_Frecuencia, SimbInterrogacion, Cadena_Vacia);

			SET Par_DiaPago				:= REPLACE(Par_DiaPago, SimbInterrogacion, Cadena_Vacia);
            SET Par_DiaMesPago			:= REPLACE(Par_DiaMesPago, SimbInterrogacion, Entero_Cero);
            SET Par_PlazoID				:= REPLACE(Par_PlazoID, SimbInterrogacion, Entero_Cero);
            SET Par_DestinoCreID		:= REPLACE(Par_DestinoCreID, SimbInterrogacion, Entero_Cero);
            SET Par_TipoIntegrante		:= REPLACE(Par_TipoIntegrante, SimbInterrogacion, Entero_Cero);

			SET Par_GrupoID				:= REPLACE(Par_GrupoID, SimbInterrogacion, Entero_Cero);
			SET Par_TipoDispersion		:= REPLACE(Par_TipoDispersion, SimbInterrogacion, Cadena_Vacia);
			SET Par_MontoPorComAper		:= REPLACE(Par_MontoPorComAper, SimbInterrogacion, Decimal_Cero);
            SET Par_PromotorID			:= REPLACE(Par_PromotorID, SimbInterrogacion, Entero_Cero);
            SET Par_CuentaClabe			:= REPLACE(Par_CuentaClabe, SimbInterrogacion, Cadena_Vacia);

			SET Par_FechaIniPrimAmor	:= REPLACE(Par_FechaIniPrimAmor, SimbInterrogacion, Fecha_Vacia);
            SET Aud_Usuario				:= REPLACE(Aud_Usuario, SimbInterrogacion, Entero_Cero);
            SET Aud_Sucursal			:= REPLACE(Aud_Sucursal, SimbInterrogacion, Entero_Cero);


			SET Par_Frecuencia			:= UPPER(Par_Frecuencia);
            SET Par_DiaPago				:= UPPER(Par_DiaPago);
            SET Par_TipoDispersion		:= UPPER(Par_TipoDispersion);

            SET Par_GrupoID				:= IFNULL(Par_GrupoID,Entero_Cero);
			SET Par_TipoIntegrante		:= IFNULL(Par_TipoIntegrante,Entero_Cero);

			-- Consulta de Valores Parametrizables Solicitud de Credito / Credito
			SELECT ValorParametro INTO Par_MonedaID FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'MonedaID';
			SELECT ValorParametro INTO Par_InstitucionNominaID FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'InstitucionNominaID';
			SELECT ValorParametro INTO Par_FolioCtrl FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'FolioCtrl';
			SELECT ValorParametro INTO Par_Proyecto FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'Proyecto';
			SELECT ValorParametro INTO Par_TipoPagoCapital FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'TipoPagoCapital ';

			SELECT ValorParametro INTO Par_CalendIrregular FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'CalendIrregular';
			SELECT ValorParametro INTO Par_TipoCredito	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'TipoCredito';
			SELECT ValorParametro INTO Par_TipoFondeo FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'TipoFondeo';
			SELECT ValorParametro INTO Par_InstitFondeoID FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'InstitFondeoID';
			SELECT ValorParametro INTO Par_LineaFondeo	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'LineaFondeo';

			SELECT ValorParametro INTO Par_FechaFormalizacion FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'FechaFormalizacion';
			SELECT ValorParametro INTO Par_MontoFondeado FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'MontoFondeado';
			SELECT ValorParametro INTO Par_PorcentajeFonde	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'PorcentajeFonde';
			SELECT ValorParametro INTO Par_NumeroFondeos FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'NumeroFondeos';
			SELECT ValorParametro INTO Par_ComentarioEjecutivo	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'ComentarioEjecutivo';

			SELECT ValorParametro INTO Par_ComentarioMesaControl FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'ComentarioMesaControl';
			SELECT ValorParametro INTO Par_MontoSeguroVida	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'MontoSeguroVida';
			SELECT ValorParametro INTO Par_ForCobroSegVida	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'ForCobroSegVida';
			SELECT ValorParametro INTO Par_HorarioVeri	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'HorarioVeri';
			SELECT ValorParametro INTO Par_DescuentoSeguro	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'DescuentoSeguro';

			SELECT ValorParametro INTO Par_MontoSegOriginal FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'MontoSegOriginal';
            SELECT ValorParametro INTO Par_TipoCuentaID	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'TipoCuentaID';

			IF (Par_Proyecto = Cadena_Vacia) THEN
				SET Par_Proyecto := DescVacio;
            END IF;

            IF (Par_ComentarioEjecutivo = Cadena_Vacia) THEN
				SET Par_ComentarioEjecutivo := DescVacio;
            END IF;

            IF (Par_ComentarioMesaControl = Cadena_Vacia) THEN
				SET Par_ComentarioMesaControl := DescVacio;
            END IF;

            IF(Par_FechaIniPrimAmor = Fecha_Vacia)THEN
				SET Par_FechaIniPrimAmor	:= Par_FechaRegistro;
            END IF;

            -- Se obtiene la Fecha de Inicio de la Amortizacion
			SET Par_FechaInicio		:= Par_FechaIniPrimAmor;	-- Fecha de Inicio
			SET Par_FechaInicioAmor	:= Par_FechaIniPrimAmor;	-- Fecha de Inicio de Amortizacion

			-- Se obtiene el Numero de Empresa
			SET Par_EmpresaID := (SELECT EmpresaDefault FROM PARAMETROSSIS LIMIT 1);

			-- Se obtiene la Cuenta Eje del Cliente en caso de Existir
			SET Var_NumCuentasEje	:= (SELECT COUNT(CuentaAhoID) FROM CUENTASAHO WHERE ClienteID = Par_ClienteID AND TipoCuentaID = Par_TipoCuentaID);
			SET Var_NumCuentasEje	:= IFNULL(Var_NumCuentasEje,Entero_Cero);

			IF(Var_NumCuentasEje = Entero_Uno)THEN
				SELECT	CuentaAhoID INTO Var_CuentaAhoID
				FROM	CUENTASAHO
				WHERE  	ClienteID 	= Par_ClienteID
				  AND   TipoCuentaID = Par_TipoCuentaID
				  AND 	Estatus 	= Estatus_Activa;
			END IF;

			IF(Var_NumCuentasEje > Entero_Uno)THEN
				SELECT	CuentaAhoID INTO Var_CuentaAhoID
				FROM	CUENTASAHO
				WHERE  	ClienteID 	= Par_ClienteID
				  AND   TipoCuentaID = Par_TipoCuentaID
				  AND 	Estatus 	= Estatus_Activa
				  AND 	EsPrincipal	= Constante_Si LIMIT 1;
			END IF;

			IF(Var_NumCuentasEje > Entero_Uno AND IFNULL(Var_CuentaAhoID,Entero_Cero) = Entero_Cero)THEN
				SELECT	CuentaAhoID INTO Var_CuentaAhoID
				FROM	CUENTASAHO
				WHERE  	ClienteID 	= Par_ClienteID
				  AND   TipoCuentaID = Par_TipoCuentaID
				  AND 	Estatus = Estatus_Activa LIMIT 1;
			END IF;

			-- Se verifica si existe una Cuenta Principal Activa del Cliente
			SET Var_EsPrincipal		:= (SELECT EsPrincipal FROM CUENTASAHO WHERE ClienteID = Par_ClienteID AND Estatus = Estatus_Activa AND EsPrincipal = Constante_Si LIMIT 1);
			SET Var_EsPrincipal		:= IFNULL(Var_EsPrincipal,Cadena_Vacia);

			IF(Var_EsPrincipal = Constante_Si)THEN
				SET Par_EsPrincipal = Constante_No;
			ELSE
				SET Par_EsPrincipal = Constante_Si;
			END IF;

			-- Alta y Autorizacion de Cuenta Eje
			IF (IFNULL(Var_CuentaAhoID,Entero_Cero) = Entero_Cero)THEN
				CALL CRCBCUENTASAHOAUTWSPRO (
					Par_SucursalID,			Par_ClienteID,			Par_TipoCuentaID,			Par_EsPrincipal,		Par_FechaRegistro,
                    Decimal_Cero,			Var_CuentaAhoID,		SalidaNO,					Par_NumErr,				Par_ErrMen,
                    Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual, 			Aud_DireccionIP, 		Aud_ProgramaID,
                    Aud_Sucursal,           Aud_NumTransaccion);
			END IF;

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


             -- Se obtienen datos requeridos del Cliente
            SELECT 	SucursalOrigen, 	PagaIVA,		CalificaCredito
            INTO 	Var_SucCliente, 	Var_CliPagIVA,	Var_CalificaCli
            FROM CLIENTES WHERE ClienteID = Par_ClienteID;


            -- Se obtiene el IVA de la Sucursal
			SELECT IVA INTO Var_IVASucurs FROM SUCURSALES WHERE SucursalID	= Var_SucCliente;

			SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);

			-- Se obtienen los datos requeridos del Producto de Credito
			SELECT 	FactorMora,
					CASE TipoComXapert
						WHEN TipoComMonto THEN Par_MontoPorComAper
						WHEN TipoComPorcentaje THEN Par_Monto * (MontoComXapert / 100) END AS ComXAper,
					CalcInteres,	TipoCalInteres,			Garantizado,
                    CobraSeguroCuota, CobraIVASeguroCuota,	TipoPrepago,
                    EsGrupal,		  ProrrateoPago,		MontoComXapert,			TipoComXapert,				ForCobroComAper
            INTO   Par_FactorMora,	Par_MontoPorComAper,	Par_CalcInteresID, 		Par_TipoCalInteres,
				   Var_RequiereGarantia,					Par_CobraSeguroCuota, 	Par_CobraIVASeguroCuota,
                   Par_TipoPrepago,	Var_EsGrupal,			Var_ProrrateoPago,		Var_MontoComXapert,			Var_TipoComXapert, var_ForCobroComAper
            FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCreditoID;

            SET Var_EsGrupal		:= IFNULL(Var_EsGrupal,Constante_No);
            SET Var_ProrrateoPago	:= IFNULL(Var_ProrrateoPago,Constante_No);
            SET Par_CalcInteresID	:= IFNULL(Par_CalcInteresID,Entero_Uno);

			IF (Var_CliPagIVA = SiPagaIVA) THEN
				SET Par_IVAComAper := ROUND((Par_MontoPorComAper * Var_IVASucurs),2);
            END IF;

			SELECT  FecInHabTomar,		AjusFecUlAmoVen,    	AjusFecExigVenc,    	DiaPagoCapital
			INTO    Par_FechaInhabil,	Par_AjusFecUlVenAmo,	Par_AjusFecExiVen,  	Par_DiaPagoProd
			FROM CALENDARIOPROD
			WHERE ProductoCreditoID = Par_ProductoCreditoID;

			IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr 	:= 001;
				SET Par_ErrMen 	:= 'El Cliente esta Vacio.' ;
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaRegistro, Fecha_Vacia) = Fecha_Vacia) THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := 'La Fecha de Registro esta Vacia.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

            IF(IFNULL(Par_Monto, Decimal_Cero) = Decimal_Cero) THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := 'El Monto Solicitado esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

            IF(IFNULL(Par_ProductoCreditoID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := 'El Producto de Credito Solicitado esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TasaFija,Decimal_Cero) = Decimal_Cero) THEN
				SET Par_NumErr := 005;
				SET Par_ErrMen := 'La Tasa Fija Solicitada esta Vacia.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

            IF(IFNULL(Par_PlazoID,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 006;
				SET Par_ErrMen := 'El Plazo esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Frecuencia, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr	:= 007;
				SET Par_ErrMen  := 'La Frecuencia esta Vacia';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Frecuencia NOT IN(PagoSemanal,PagoDecenal,
					PagoCatorcenal,PagoQuincenal,PagoMensual,PagoPeriodo,
					PagoBimestral,PagoTrimestral,PagoTetrames,PagoSemestral,
					PagoAnual,PagoUnico))THEN
                SET Par_NumErr  := 008;
				SET Par_ErrMen  := 'Frecuencia No Valida.' ;
                SET Var_CuentaAhoID	:= Entero_Cero;
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

            IF((Par_PeriodicidadCap OR Par_PeriodicidadInt) = Entero_Cero)THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen  := 'La Periodicidad esta Vacia.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF(Par_PeriodicidadCap NOT IN(FrecSemanal,FrecDecenal,FrecCator,FrecQuin,
							FrecMensual,FrecBimestral,FrecTrimestral,
                            FrecTetrames,FrecSemestral,FrecAnual,1))THEN
				SET Par_NumErr	:= 010;
				SET Par_ErrMen  := 'Periodicidad No Valida.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF NOT EXISTS(SELECT ProducCreditoID FROM PRODUCTOSCREDITO
							WHERE ProducCreditoID = Par_ProductoCreditoID)THEN
				SET Par_NumErr	:= 011;
				SET Par_ErrMen  := 'El Producto de Credito No Existe.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF NOT EXISTS(SELECT ClienteID	FROM CLIENTES
							WHERE ClienteID = Par_ClienteID) THEN
				SET Par_NumErr	:= 012;
				SET Par_ErrMen  := 'El Cliente Indicado No Existe.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

            IF NOT EXISTS(SELECT PlazoID FROM CREDITOSPLAZOS
							WHERE PlazoID = Par_PlazoID) THEN
				SET Par_NumErr	:= 013;
				SET Par_ErrMen  := 'El Plazo No Existe.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

            IF(IFNULL(Par_TipoDispersion,Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:= 014;
				SET Par_ErrMen  := 'El Tipo de Dispersion esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF(Par_TipoDispersion NOT IN(DispSPEI,DispCheque,
					DispOrdenPago,DispEfectivo)) THEN
				SET Par_NumErr	:= 015;
				SET Par_ErrMen  := 'Tipo de Dispersion No Valido.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF(IFNULL(Par_TipoCredito,Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:= 016;
				SET Par_ErrMen  := 'El Tipo de Credito esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF(IFNULL(Par_DestinoCreID,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr	:= 017;
				SET Par_ErrMen  := 'El Destino de Credito esta Vacio';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF NOT EXISTS (SELECT DestinoCreID FROM DESTINOSCREDITO
							WHERE DestinoCreID = Par_DestinoCreID) THEN
				SET Par_NumErr	:= 018;
				SET Par_ErrMen  := 'El Destino de Credito No Existe';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

            -- Destino de Credito por Producto
            SET Var_DestinoCre:=(SELECT ProductoCreditoID
                        FROM DESTINOSCREDPROD
                        WHERE ProductoCreditoID = Par_ProductoCreditoID
                        AND DestinoCreID = Par_DestinoCreID);

			SET Var_DestinoCre	:=	IFNULL(Var_DestinoCre,Entero_Cero);

            IF(Var_DestinoCre = Cadena_Vacia)THEN
				SET Par_NumErr  := 019;
				SET Par_ErrMen  := 'El Destino de Credito Seleccionado no Corresponde con el Producto por su Clasificacion.' ;
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoDispersion = DispSPEI)THEN
				IF(IFNULL(Par_CuentaClabe,Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr  := 020;
					SET Par_ErrMen  := 'La Cuenta CLABE esta Vacia.' ;
                    SET Var_CuentaAhoID	:= Entero_Cero;
					LEAVE ManejoErrores;
                END IF;

                IF (IFNULL(Var_LongCLABE, Entero_Cero) != Long_CLABE )THEN
					SET Par_NumErr := 021;
					SET Par_ErrMen := 'La Cuenta Clable debe de Tener 18 Caracteres.' ;
                    SET Var_CuentaAhoID	:= Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
            END IF;

            SET Var_FrecProdCred	:= (SELECT Frecuencias FROM CALENDARIOPROD WHERE ProductoCreditoID = Par_ProductoCreditoID);
			SET Var_FrecProdCred	:= IFNULL(Var_FrecProdCred,Cadena_Vacia);

            IF(LOCATE(Par_Frecuencia,Var_FrecProdCred) = Cadena_Vacia) THEN
				SET Par_NumErr := 022;
				SET Par_ErrMen := CONCAT('La Frecuencia No es Valida para el Producto de Credito: ',Par_ProductoCreditoID,'.');
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            SET Var_PlazoProdCred	:= (SELECT PlazoID FROM CALENDARIOPROD WHERE ProductoCreditoID = Par_ProductoCreditoID);
            SET Var_PlazoProdCred	:= IFNULL(Var_PlazoProdCred,Cadena_Vacia);

			IF(LOCATE(Par_PlazoID,Var_PlazoProdCred) = Cadena_Vacia) THEN
				SET Par_NumErr := 023;
				SET Par_ErrMen := CONCAT('El Plazo No es Valido para el Producto de Credito: ',Par_ProductoCreditoID,'.');
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

			SET Var_TipoDispProdCred	:= (SELECT TipoDispersion FROM CALENDARIOPROD WHERE ProductoCreditoID = Par_ProductoCreditoID);
            SET Var_TipoDispProdCred	:= IFNULL(Var_TipoDispProdCred,Cadena_Vacia);

            IF(LOCATE(Par_TipoDispersion,Var_TipoDispProdCred) = Cadena_Vacia) THEN
				SET Par_NumErr := 024;
				SET Par_ErrMen := CONCAT('El Tipo de Dispersion No es Valido para el Producto de Credito: ',Par_ProductoCreditoID,'.');
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF(Par_GrupoID > Entero_Cero) THEN
				IF NOT EXISTS (SELECT GrupoID FROM GRUPOSCREDITO
							WHERE GrupoID = Par_GrupoID) THEN
                SET Par_NumErr := 025;
				SET Par_ErrMen := CONCAT('El Grupo Indicado No Existe.');
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
                END IF;
            END IF;

			IF(Var_EsGrupal = Grupal_SI) THEN
				IF(Par_GrupoID = Entero_Cero OR (Par_GrupoID = Entero_Cero
						AND Par_TipoIntegrante > Entero_Cero))THEN
					SET Par_NumErr := 026;
					SET Par_ErrMen := 'El Grupo esta Vacio.';
                    SET Var_CuentaAhoID	:= Entero_Cero;
                    LEAVE ManejoErrores;
				END IF;
            END IF;

            -- Se obtiene el Porcentaje de Garantia Liquida si es que se requiere
			IF(IFNULL(Var_RequiereGarantia,Constante_No) = Constante_Si)THEN
				-- Si si rerquiere, entonces se comprueba la existencia del porcentaje
				IF((EXISTS(SELECT Porcentaje FROM ESQUEMAGARANTIALIQ
								WHERE ProducCreditoID = Par_ProductoCreditoID AND	Clasificacion = Var_CalificaCli AND Par_Monto BETWEEN LimiteInferior AND LimiteSuperior))) THEN
					SELECT Porcentaje INTO Par_PorcGarLiq
						FROM ESQUEMAGARANTIALIQ
							WHERE ProducCreditoID = Par_ProductoCreditoID
								AND	Clasificacion = Var_CalificaCli
								AND Par_Monto BETWEEN LimiteInferior AND LimiteSuperior;
				ELSE
					SET Par_NumErr := 027;
					SET Par_ErrMen := 'No Existe un Esquema de Garantia Liquida para el Producto de Credito.';
                    SET Var_CuentaAhoID	:= Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

            IF(Var_EsGrupal = Grupal_SI) THEN
				IF(Par_GrupoID > Entero_Cero AND Par_TipoIntegrante > Entero_Cero)THEN
					IF(Par_TipoIntegrante NOT IN(Int_Presidente,Int_Tesorero,
												Int_Secretario,Int_Integrante))THEN
					SET Par_NumErr := 028;
					SET Par_ErrMen := 'El Tipo de Integrante No Existe.';
                    SET Var_CuentaAhoID	:= Entero_Cero;
					LEAVE ManejoErrores;
                    END IF;
				END IF;
            END IF;

            IF(Var_EsGrupal = Grupal_SI) THEN
				IF(Par_GrupoID > Entero_Cero AND Par_TipoIntegrante = Entero_Cero)THEN
					SET Par_NumErr := 029;
					SET Par_ErrMen := 'Indique Tipo de Integrante.';
                    SET Var_CuentaAhoID	:= Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

                -- vk
                SELECT EstatusCiclo
					INTO Est_Grupo
					FROM GRUPOSCREDITO
					WHERE GrupoID =  Par_GrupoID;

				IF Est_Grupo <> Est_Abierto THEN

					CALL GRUPOSCREDITOACT (
						Par_GrupoID,		Act_Inicia,			SalidaNO,			Par_NumErr,			Par_ErrMen,
						Par_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
						Aud_Sucursal,   	Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

                END IF;

            END IF;

			IF(Var_TipoComXapert = TipoComMonto) THEN
				IF(Par_MontoPorComAper > Var_MontoComXapert) THEN
					SET Par_NumErr := 031;
					SET Par_ErrMen := CONCAT('El Monto de la Comision por Apertura es Mayor al Monto Parametrizado para el Producto de Credito: ',Par_ProductoCreditoID,'.');
					SET Var_CuentaAhoID	:= Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_PromotorID,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 032;
				SET Par_ErrMen := 'El Promotor esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF NOT EXISTS (SELECT PromotorID FROM PROMOTORES
							WHERE PromotorID = Par_PromotorID)THEN
				SET Par_NumErr := 033;
				SET Par_ErrMen := 'El Promotor No Existe.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

            IF(IFNULL(Par_TipoPagoCapital,Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr := 034;
				SET Par_ErrMen := 'El Tipo de Pago de Capital esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

			SET Var_TipPagCapProdCred	:= (SELECT TipoPagoCapital FROM CALENDARIOPROD WHERE ProductoCreditoID = Par_ProductoCreditoID);
			SET Var_TipPagCapProdCred	:= IFNULL(Var_TipPagCapProdCred,Cadena_Vacia);

			IF(LOCATE(Par_TipoPagoCapital,Var_TipPagCapProdCred) = Cadena_Vacia) THEN
				SET Par_NumErr := 035;
				SET Par_ErrMen := CONCAT('El Tipo Pago Capital No es Valido para el Producto de Credito: ',Par_ProductoCreditoID,'.');
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF(IFNULL(Par_DiaPago,Cadena_Vacia) = Cadena_Vacia AND Par_Frecuencia = PagoMensual) THEN
				SET Par_NumErr := 036;
				SET Par_ErrMen := 'El Dia de Pago esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF(Par_Frecuencia = PagoMensual)THEN
				IF(Par_DiaPago NOT IN(DiaPagoUltDiaMes,DiaPagoDiaAniver))THEN
					SET Par_NumErr := 037;
					SET Par_ErrMen := 'El Valor Dia de Pago No es Valido para Frecuencia: MENSUAL.';
                    SET Var_CuentaAhoID	:= Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
            END IF;

            IF(Par_Frecuencia = PagoMensual AND Par_DiaPago = DiaPagoDiaAniver)THEN
				IF(IFNULL(Par_DiaMesPago,Entero_Cero) =  Entero_Cero) THEN
					SET Par_NumErr := 038;
					SET Par_ErrMen := 'El Dia de Mes del Pago esta Vacio';
                    SET Var_CuentaAhoID	:= Entero_Cero;
					LEAVE ManejoErrores;
                END IF;
            END IF;

            IF(IFNULL(Par_FechaIniPrimAmor,Fecha_Vacia) = Fecha_Vacia) THEN
				SET Par_NumErr := 039;
				SET Par_ErrMen := 'La Fecha de Inicio de las Amortizaciones esta Vacia';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

			IF(IFNULL(Aud_Usuario,Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr	:= 040;
				SET Par_ErrMen  := 'El Usuario esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

			IF NOT EXISTS (SELECT UsuarioID FROM USUARIOS
							WHERE UsuarioID = Aud_Usuario) THEN
				SET Par_NumErr	:= 041;
				SET Par_ErrMen  := 'El Usuario No Existe.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Aud_Sucursal,Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr	:= 042;
				SET Par_ErrMen  := 'La Sucursal esta Vacia.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF NOT EXISTS (SELECT SucursalID FROM SUCURSALES
							WHERE SucursalID = Aud_Sucursal) THEN
				SET Par_NumErr	:= 043;
				SET Par_ErrMen  := 'La Sucursal No Existe.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

            IF((Par_GrupoID > Entero_Cero OR Par_TipoIntegrante > Entero_Cero) AND Var_EsGrupal = Constante_No)THEN
				SET Par_NumErr	:= 044;
				SET Par_ErrMen  := 'El Producto de Credito No es Grupal.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            IF(IFNULL(Var_CuentaAhoID,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr	:= 045;
				SET Par_ErrMen  := 'El Cliente No tiene una Cuenta Activa.';
                SET Var_CuentaAhoID	:= Entero_Cero;
            END IF;

            IF(Par_FechaIniPrimAmor < Par_FechaRegistro) THEN
				SET Par_NumErr := 046;
				SET Par_ErrMen := 'La Fecha de Inicio Primer Amortizacion es Menor a la Fecha del Sistema.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

			IF(Par_Frecuencia != PagoMensual)THEN
				SET Par_DiaPago = Par_DiaPagoProd;
            END IF;

			IF(IFNULL(Par_TipoConsultaSIC, Cadena_Vacia)= Cadena_Vacia) THEN
				SET Par_NumErr := 047;
				SET Par_ErrMen := 'El Tipo de Consulta SIC Esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			ELSE
				IF(Par_TipoConsultaSIC<>ConSic_TipoBuro AND Par_TipoConsultaSIC<>ConSic_TipoCirculo)THEN
					SET Par_NumErr := 048;
					SET Par_ErrMen := 'El Tipo de Consulta SIC es Incorrecto.';
					SET Var_CuentaAhoID	:= Entero_Cero;
					LEAVE ManejoErrores;
                END IF;
			END IF;

            IF(IFNULL(Par_FolioConsultaSIC, Cadena_Vacia)= Cadena_Vacia) THEN
				SET Par_NumErr := 049;
				SET Par_ErrMen := 'El Folio de Consulta SIC Esta Vacio.';
                SET Var_CuentaAhoID	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			-- se obtiene tipo consulta buro
			IF (Par_TipoConsultaSIC = ConSic_TipoBuro)THEN
				SET Var_TipoBuro	:= Par_FolioConsultaSIC;
				SET Var_TipoCirculo := Cadena_Vacia;
			ELSE
				SET Var_TipoBuro	:= Cadena_Vacia;
				SET Var_TipoCirculo := Par_FolioConsultaSIC;
			END IF;


            -- Se obtiene la Frecuendia de Capital e Interes
			SET Par_FrecuenciaCap	:= Par_Frecuencia;		-- Frecuencia de Capital
			SET Par_FrecuenciaInt	:= Par_Frecuencia;		-- Frecuencia de Interes

            -- Se obtiene el Dia de Pago de Interes y Capital
			SET Par_DiaPagoInteres	:= Par_DiaPago;			-- Dia de Pago de Interes
			SET Par_DiaPagoCapital	:= Par_DiaPago;			-- Dia de Pago de Capital

            -- Se obtiene el Dia Mes de Interes y Capital
			SET Par_DiaMesInteres	:= Par_DiaMesPago;		-- Dia Mes Interes
			SET Par_DiaMesCapital	:= Par_DiaMesPago;		-- Dia Mes Capital

            -- Se obtiene la Clasificacion del Destino de Credito
			SET Par_ClasiDestinCred  :=(SELECT Clasificacion FROM DESTINOSCREDITO WHERE DestinoCreID = Par_DestinoCreID);

			-- Se obtiene la Aportacion del Cliente
			SET Par_PorcGarLiq		:= IFNULL(Par_PorcGarLiq,Decimal_Cero);
			SET Par_AporteCliente 	:= Par_Monto * (Par_PorcGarLiq/Entero_Cien);
            SET Par_AporteCliente 	:= IFNULL(Par_AporteCliente,Decimal_Cero);

                        -- Se obtiene el Numero de Dias del Plazo
            SET Var_NumDias := (SELECT Dias FROM CREDITOSPLAZOS WHERE PlazoID = Par_PlazoID);

            -- Se obtiene la Fecha de Vencimiento
			SET Par_FechaVencimiento := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Var_NumDias DAY));

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

           -- Consultamos el Numero de Ciclos(Creditos) que ha tenido el Cliente del mismo Producto de Credito
			CALL CRECALCULOCICLOPRO(
				Par_ClienteID,      	Par_ProspectoID,    	Par_ProductoCreditoID,    	Par_GrupoID,    	Var_CicloCliente,
				Var_CicloGrupal, 		SalidaNO,           	Par_EmpresaID,      		Aud_Usuario,    	Aud_FechaActual,
				Aud_DireccionIP,    	Aud_ProgramaID,     	Aud_Sucursal,       		Aud_NumTransaccion);

			IF(Var_EsGrupal = Grupal_SI) THEN
				SET Par_NumCreditos   := Var_CicloGrupal;
			ELSE
				SET Par_NumCreditos   := Var_CicloCliente;
			END IF;


            SET Var_FechaCobroComision := (SELECT FNSUMADIASFECHA(Par_FechaRegistro,Par_PeriodicidadCap));
			SET Var_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Var_FechaCobroComision, 0, Par_EmpresaID));

            -- Obtenemos el Monto de la Cuota y el valor del CAT
		IF (var_ForCobroComAper=Financiado)THEN
			SET Par_Monto = Par_Monto + Par_MontoPorComAper + Par_IVAComAper;
		END IF;


		IF(Par_Frecuencia <> PagoUnico ) THEN
			CALL CREPAGCRECAMORPRO(
				Entero_Cero,
				Par_Monto,				Par_TasaFija,				Par_PeriodicidadCap,			Par_Frecuencia,				Par_DiaPago,
                Par_DiaMesPago,			Par_FechaInicio,			Par_NumAmortizacion,			Par_ProductoCreditoID,		Par_ClienteID,
                Par_FechaInhabil,		Par_AjusFecUlVenAmo,		Par_AjusFecExiVen,				Par_MontoPorComAper,		Par_AporteCliente,
                Par_CobraSeguroCuota,	Par_CobraIVASeguroCuota,	Decimal_Cero,					0,			SalidaNO,
                Par_NumErr,             Par_ErrMen,					Par_NumTransacSim,				Par_Cuotas,					Par_CAT,
                Par_MontoCuota,			Par_FechaVencimiento,		Par_EmpresaID,					Aud_Usuario,				Aud_FechaActual,
                Aud_DireccionIP,        Aud_ProgramaID,				Aud_Sucursal,      				Aud_NumTransaccion);


		ELSE

			SET Par_PeriodicidadCap := Var_NumDias;
            SET Par_PeriodicidadInt	:= Var_NumDias;

			CALL CREPAGIGUAMORPRO(
                Par_Monto,              Par_TasaFija,               Par_PeriodicidadCap,   		Par_PeriodicidadCap,   		Par_Frecuencia,
                Par_Frecuencia,         Par_DiaPago,      			Par_DiaPago,  				Par_FechaInicio,    		Par_NumAmortizacion,
                Par_NumAmortizacion,    Par_ProductoCreditoID,      Par_ClienteID,      		Par_FechaInhabil,   		Par_AjusFecUlVenAmo,
                Par_AjusFecExiVen,      Par_DiaMesPago,           	Par_DiaMesPago,      		Par_MontoPorComAper,        Par_AporteCliente,
                Par_CobraSeguroCuota,   Par_CobraIVASeguroCuota, 	Decimal_Cero,				Decimal_Cero,    			SalidaNO,
                Par_NumErr,
                Par_ErrMen,             Par_NumTransacSim,          Par_Cuotas,         		Par_Cuotas,         		Par_CAT,
                Par_MontoCuota,			Par_FechaVencimiento,		Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
                Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,           	Aud_NumTransaccion);
			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
            END IF;

        END IF;
            -- LLamada a SOLICITUDCREDITOALT para el Registro de Solicitud de Credito

            CALL SOLICITUDCREDITOALT(
                Par_ProspectoID,        Par_ClienteID,          Par_ProductoCreditoID,		Par_FechaRegistro,          Par_PromotorID,
                Par_TipoCredito,        Par_NumCreditos,        Par_Relacionado,        	Par_AporteCliente,        	Par_MonedaID,
                Par_DestinoCreID,       Par_Proyecto,           Par_SucursalID,         	Par_Monto,         			Par_PlazoID,
                Par_FactorMora,         Par_MontoPorComAper,    Par_IVAComAper,         	Par_TipoDispersion,         Par_CalcInteresID,
                Par_TasaBase,           Par_TasaFija,           Par_SobreTasa,          	Par_PisoTasa,           	Par_TechoTasa,
                Par_FechaInhabil,       Par_AjusFecExiVen,      Par_CalendIrregular,        Par_AjusFecUlVenAmo,        Par_TipoPagoCapital,
                Par_FrecuenciaInt,      Par_FrecuenciaCap,      Par_PeriodicidadInt,        Par_PeriodicidadCap,        Par_DiaPagoInteres,
                Par_DiaPagoCapital,     Par_DiaMesInteres,      Par_DiaMesCapital,          Par_NumAmortizacion,        Par_NumTransacSim,
                Par_CAT,                Par_CuentaClabe,        Par_TipoCalInteres,         Par_TipoFondeo,         	Par_InstitFondeoID,
                Par_LineaFondeo,        Par_NumAmortizacion,    Par_MontoCuota,         	Par_GrupoID,            	Par_TipoIntegrante,
                Par_FechaVencimiento,   Par_FechaInicio,      	Par_MontoSeguroVida,    	Par_ForCobroSegVida,    	Par_ClasiDestinCred,
                Par_InstitucionNominaID,Par_FolioCtrl,          Par_HorarioVeri,        	Par_PorcGarLiq,         	Par_FechaInicioAmor,
                Par_DescuentoSeguro,    Par_MontoSegOriginal,   Cadena_Vacia,           	Entero_Cero,            	Par_TipoConsultaSIC,
                Var_TipoBuro,			Var_TipoCirculo,		Var_FechaCobroComision,		Entero_Cero,				Entero_Cero,
                Decimal_Cero,			Decimal_Cero,			Entero_Cero,	            Entero_Cero,                Cadena_Vacia,
                Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,               Cadena_Vacia,               Cadena_Vacia,
                Entero_Cero,            Entero_Cero,            Cadena_Vacia,               Cadena_Vacia,               Cadena_Vacia,
                Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,               Cadena_Vacia,
                SalidaNO, 				Par_NumErr,             Par_ErrMen,                 Par_EmpresaID,			    Aud_Usuario,
                Aud_FechaActual,       	Aud_DireccionIP,        Aud_ProgramaID,             Aud_Sucursal,               Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
            END IF;

			-- Se obtiene el Numero de la Solicitud de Credito
			SET Var_SolicitudCreditoID   := (SELECT SolicitudCreditoID FROM SOLICITUDCREDITO WHERE NumTransaccion = Aud_NumTransaccion);

            -- Se obtiene el valor de la Tasa Fija Anualizada

            # =============================================================================================================================
			# ----------------- Liberacion y Autorizacion de la Solicitud de Credito Individual -------------------------------------------
            # ------------------------------------ Alta de Credito Individual -------------------------------------------------------------
			# =============================================================================================================================
			IF(Var_EsGrupal = Constante_No AND Par_GrupoID = Entero_Cero)THEN
				-- LLamada a SOLICITUDCREACT para Liberar la Solicitud de Credito
				CALL SOLICITUDCREACT (
					Var_SolicitudCreditoID,		Decimal_Cero,					Fecha_Vacia,				Aud_Usuario,		Decimal_Cero,
					Par_ComentarioEjecutivo,	Par_ComentarioMesaControl,		Cadena_Vacia,               Cadena_Vacia,       Act_LiberarSolicitud,
                    SalidaNO,			        Par_NumErr,                     Par_ErrMen,					Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,        	Aud_DireccionIP,                Aud_ProgramaID,         	Aud_Sucursal,       Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

                -- Se realiza la Autorizacion de la Solicitud de Credito
				CALL SOLICITUDCREACT (
					Var_SolicitudCreditoID,		Par_Monto,						Par_FechaRegistro,				Aud_Usuario,		Par_AporteCliente,
					Cadena_Vacia,				Par_ComentarioMesaControl,		Cadena_Vacia,                   Cadena_Vacia,       Act_AutorizaSolCRCBWS,
					SalidaNO,			        Par_NumErr,                     Par_ErrMen,					    Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	        Aud_DireccionIP,                Aud_ProgramaID,				    Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

                -- LLamada a CREDITOSALT para el Registro de Credito
			    CALL CREDITOSALT (
					Par_ClienteID,				Entero_Cero,				Par_ProductoCreditoID,			Var_CuentaAhoID,		Par_TipoCredito,
					Entero_Cero,				Var_SolicitudCreditoID,		Par_Monto,						Par_MonedaID,			Par_FechaInicio,
					Par_FechaVencimiento,		Par_FactorMora,				Par_CalcInteresID,				Par_TasaBase,			Par_TasaFija,
					Par_SobreTasa,				Par_PisoTasa,				Par_TechoTasa,					Par_FrecuenciaCap,		Par_PeriodicidadCap,
					Par_FrecuenciaInt,			Par_PeriodicidadInt,		Par_TipoPagoCapital,			Par_NumAmortizacion,	Par_FechaInhabil,
					Par_CalendIrregular,		Par_DiaPagoInteres,			Par_DiaPagoCapital,				Par_DiaMesInteres,		Par_DiaMesCapital,
					Par_AjusFecUlVenAmo,		Par_AjusFecExiVen,			Par_NumTransacSim,				Par_TipoFondeo,			Par_MontoPorComAper,
					Par_IVAComAper,				Par_CAT,					Par_PlazoID,					Par_TipoDispersion,		Par_CuentaClabe,
					Par_TipoCalInteres,			Par_DestinoCreID,			Par_InstitFondeoID,				Par_LineaFondeo,		Par_NumAmortizacion,
					Par_MontoCuota,				Par_MontoSeguroVida,		Par_AporteCliente,				Par_ClasiDestinCred,	Par_TipoPrepago,
					Par_FechaInicioAmor,		Par_ForCobroSegVida,		Decimal_Cero,					Decimal_Cero,			Par_TipoConsultaSIC,
					Var_TipoBuro,				Var_TipoCirculo,			Var_FechaCobroComision,			Par_ReferenciaPago,		SalidaNO,
					Var_CreditoID,				Par_NumErr,					Par_ErrMen,						Par_EmpresaID,			Aud_Usuario,
                    Aud_FechaActual, 			Aud_DireccionIP,  			Aud_ProgramaID,					Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
            END IF; -- FIN ALTA DE CREDITO INDIVIDUAL

			# =============================================================================================================================
			# -------------------------------------------- Asignacion de Avales -----------------------------------------------------------
            # ------------------------ Liberacion y Autorizacion de la Solicitud de Credito Grupal ----------------------------------------
			# ---------------------------------------- Alta y Autorizacion de Cuenta Eje --------------------------------------------------
			# ------------------------------------------- Alta Credito Grupal -------------------------------------------------------------
			# =============================================================================================================================

		    IF(Var_EsGrupal = Constante_Si AND Par_GrupoID > Entero_Cero)THEN
                -- Asignacion/Autorizacion de Avales Solicitud de Credito
                CALL CRCBAVALESPORSOLWSALT(
					Var_SolicitudCreditoID,		Par_ClienteID,			Cadena_Vacia,			SalidaNO,			Par_NumErr,
                    Par_ErrMen,					Par_EmpresaID,			Aud_Usuario,   			Aud_FechaActual, 	Aud_DireccionIP,
                    Aud_ProgramaID,         	Aud_Sucursal,           Aud_NumTransaccion);

                IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

                -- LLamada a SOLICITUDCREACT para Liberar la Solicitud de Credito Grupal
				CALL SOLICITUDCREACT (
					Var_SolicitudCreditoID,		Decimal_Cero,					Fecha_Vacia,				Aud_Usuario,		Decimal_Cero,
					Par_ComentarioEjecutivo,	Par_ComentarioMesaControl,		Cadena_Vacia,               Cadena_Vacia,       Act_LibGrupoSolCRCBWS,
					SalidaNO,			        Par_NumErr,                     Par_ErrMen,					Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual, 	        Aud_DireccionIP,                Aud_ProgramaID,         	Aud_Sucursal,       Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

                 -- Se realiza la Autorizacion de la Solicitud de Credito
				CALL SOLICITUDCREACT (
					Var_SolicitudCreditoID,		Par_Monto,						Par_FechaRegistro,				Aud_Usuario,		Par_AporteCliente,
					Cadena_Vacia,				Par_ComentarioMesaControl,		Cadena_Vacia,                   Cadena_Vacia,       Act_AutorizaSolCRCBWS,
					SalidaNO,			        Par_NumErr,                     Par_ErrMen,					    Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	        Aud_DireccionIP,                Aud_ProgramaID,				    Aud_Sucursal,	    Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;



                -- LLamada a CREDITOSALT para el Registro de Credito
			    CALL CREDITOSALT (
					Par_ClienteID,				Entero_Cero,				Par_ProductoCreditoID,			Var_CuentaAhoID,		Par_TipoCredito,
					Entero_Cero,				Var_SolicitudCreditoID,		Par_Monto,						Par_MonedaID,			Par_FechaInicio,
					Par_FechaVencimiento,		Par_FactorMora,				Par_CalcInteresID,				Par_TasaBase,			Par_TasaFija,
					Par_SobreTasa,				Par_PisoTasa,				Par_TechoTasa,					Par_FrecuenciaCap,		Par_PeriodicidadCap,
					Par_FrecuenciaInt,			Par_PeriodicidadInt,		Par_TipoPagoCapital,			Par_NumAmortizacion,	Par_FechaInhabil,
					Par_CalendIrregular,		Par_DiaPagoInteres,			Par_DiaPagoCapital,				Par_DiaMesInteres,		Par_DiaMesCapital,
					Par_AjusFecUlVenAmo,		Par_AjusFecExiVen,			Par_NumTransacSim,				Par_TipoFondeo,			Par_MontoPorComAper,
					Par_IVAComAper,				Par_CAT,					Par_PlazoID,					Par_TipoDispersion,		Par_CuentaClabe,
					Par_TipoCalInteres,			Par_DestinoCreID,			Par_InstitFondeoID,				Par_LineaFondeo,		Par_NumAmortizacion,
					Par_MontoCuota,				Par_MontoSeguroVida,		Par_AporteCliente,				Par_ClasiDestinCred,	Par_TipoPrepago,
					Par_FechaInicioAmor,		Par_ForCobroSegVida,		Decimal_Cero,					Decimal_Cero,           Par_TipoConsultaSIC,
                    Var_TipoBuro,				Var_TipoCirculo,			Var_FechaCobroComision,			Par_ReferenciaPago,		SalidaNO,
                    Var_CreditoID,				Par_NumErr,					Par_ErrMen,						Par_EmpresaID,			Aud_Usuario,
                    Aud_FechaActual, 			Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,			Aud_NumTransaccion);

				DELETE FROM AVALESPORSOLICI WHERE SolicitudCreditoID = Var_SolicitudCreditoID AND ClienteID = Entero_Cero;

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
            END IF; -- FIN ALTA DE CREDITO GRUPAL

		SET Par_NumErr      := Entero_Cero;
		SET Par_ErrMen      := 'Solicitud de Credito Agregado Exitosamente.';

	END ManejoErrores;

     IF(Par_Salida = SalidaSI)THEN
		SELECT 	Par_NumErr		AS codigoRespuesta,
				Par_ErrMen     	AS mensajeRespuesta,
				Var_CreditoID  	AS creditoID,
                Var_CuentaAhoID AS cuentaAhoID;
	END IF;

END TerminaStore$$