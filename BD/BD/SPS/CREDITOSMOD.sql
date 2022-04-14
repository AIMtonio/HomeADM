-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSMOD`;

DELIMITER $$
CREATE PROCEDURE `CREDITOSMOD`(
	# =============================================================================================================================
	# ----------- SP PARA MODIFICAR UN CREDITO NUEVO O UN CREDITO RENOVACION ----------------------------
	# =============================================================================================================================
    Par_CreditoID         BIGINT(12),
    Par_ClienteID         INT(11),
    Par_LinCreditoID      INT(11),
    Par_ProduCredID       INT(11),
    Par_CuentaID          BIGINT(12),

	Par_TipoCredito       CHAR(1),
    Par_Relacionado       BIGINT(12),
    Par_SolicCredID       INT(11),
    Par_MontoCredito      DECIMAL(12,2),
    Par_MonedaID          INT(11),

    Par_FechaInicio       DATE,
	Par_FechaVencim       DATE,
    Par_FactorMora        DECIMAL(12,2),
    Par_CalcInterID       INT(11),
    Par_TasaBase          INT(11),

    Par_TasaFija          DECIMAL(12,4),
    Par_SobreTasa         DECIMAL(12,4),
    Par_PisoTasa          DECIMAL(12,2),
    Par_TechoTasa         DECIMAL(12,2),
    Par_FrecuencCap       CHAR(1),

    Par_PeriodCap         INT(11),
    Par_FrecuencInt       CHAR(1),
    Par_PeriodicInt       INT(11),
    Par_TPagCapital       VARCHAR(10),
    Par_NumAmortiza       INT(11),

    Par_FecInhabil        CHAR(1),
    Par_CalIrregul        CHAR(1),
    Par_DiaPagoInt        CHAR(1),
    Par_DiaPagoCap        CHAR(1),
    Par_DiaMesInt         INT(11),

    Par_DiaMesCap         INT(11),
    Par_AjFUlVenAm        CHAR(1),
    Par_AjuFecExiVe       CHAR(1),
    Par_InstitFondeoID    INT(11),
    Par_LineaFondeo       INT(11),

    Par_FecTraspVen       DATE,
    Par_FechTermina       DATE,
    Par_NumTransacSim     BIGINT,
    Par_TipoFondeo        CHAR(1),
    Par_MonComApe         DECIMAL(12,2),

    Par_IVAComApe         DECIMAL(12,2),
    Par_ValorCAT          DECIMAL(12,4),
    Par_Plazo             VARCHAR(20),
    Par_TipoDisper        VARCHAR(1),
	Par_CuentaCABLE		  CHAR(18), -- Cuenta Clabe para cuando el tipo de Dispersion sea por SPEI

    Par_TipoCalInt        INT(11),
    Par_DestinoCreID      INT(11),
    Par_NumAmortInt       INT(11),
    Par_MontoCuota        DECIMAL(12,2),
    Par_MontoSegVida      DECIMAL(12,2),

	Par_ClasiDestinCred   CHAR(1),
    Par_TipoPrepago       CHAR(1),
	Par_FechaInicioAmor   DATE,
	Par_ForCobroSegVida   CHAR(1),
	Par_DescSeguro        DECIMAL(12,2),

	Par_MontoSegOri    	  DECIMAL(12,2),
	Par_ComentarioAlt	  VARCHAR(500),
	Par_TipoConsultaSIC   CHAR(2),
    Par_FolioConsultaBC   VARCHAR(30),
	Par_FolioConsultaCC   VARCHAR(30),

    Par_FechaCobroComision DATE,
    Par_ReferenciaPago 	  VARCHAR(50),

	Par_Salida            CHAR(1),
	INOUT Par_NumErr      INT(11),
	INOUT Par_ErrMen      VARCHAR(400),

    Aud_EmpresaID         INT(11),
    Aud_Usuario           INT(11),
    Aud_FechaActual       DATETIME,
    Aud_DireccionIP       VARCHAR(15),
    Aud_ProgramaID        VARCHAR(50),
    Aud_Sucursal          INT(11),
    Aud_NumTransaccion    BIGINT(20)

    	)
TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Var_Consecutivo		VARCHAR(50);
	DECLARE Var_ManejaLinea     CHAR(1);
	DECLARE Var_TipPagCapL    	CHAR(1);
	DECLARE FechaTermLin      	DATE;
	DECLARE FechaIniLin       	DATE;
	DECLARE Var_Cliente       	INT;
	DECLARE Var_MonedaCta     	BIGINT;
	DECLARE Var_EstFondeo     	CHAR(1);
	DECLARE Var_SaldoFondo    	DECIMAL(14,2);
	DECLARE VarSumaCapital    	DECIMAL(14,2);
	DECLARE Decimal_Cero      	DECIMAL(14,2);
	DECLARE Var_TipPagoSeg    	CHAR(1);
	DECLARE Var_TipPagComAp   	CHAR(1);
	DECLARE Var_NomControl    	VARCHAR(50);
	DECLARE Var_AporteCliente 	DECIMAL(12,2);
	DECLARE Var_RequiereGL    	CHAR(1);
	DECLARE Var_PorcGarLiq    	DECIMAL(12,2);
	DECLARE Var_CalificaCredito CHAR(1);
	DECLARE Var_FechaSistema  	DATE;
	DECLARE No_Asignada     	CHAR(1);
	DECLARE Var_DiaPagoProd   	CHAR(1);
	DECLARE Var_NumDiasAtraOri  INT(11);
	DECLARE Var_NumRenovacion 	INT(5);
	DECLARE Var_SaldoExigible 	DECIMAL(14,2);
	DECLARE Var_EstatusCrea   	CHAR(1);
	DECLARE Var_NumPagoSostenido INT(5);
	DECLARE Var_EstRelacionado  CHAR(1);
	DECLARE Var_PeriodCap   	INT(11);
	DECLARE Var_DestinoCre    	INT;
	DECLARE Var_SalCredAnt      DECIMAL(12,2);  -- Saldo del Credito Anterior( a Renovar).
	DECLARE Var_TipCobComMorato CHAR(1);
	DECLARE Var_Control         VARCHAR(100);
	#SEGURO CUOTA
	DECLARE Var_MontoSeguroCuota  	DECIMAL(12,2);
	DECLARE Var_CobraSeguroCuota    CHAR(1);                    -- Cobra Seguro por cuota
	DECLARE Var_CobraIVASeguroCuota CHAR(1);                    -- Cobra el producto IVA por seguro por cuota
	DECLARE Var_IVA                 DECIMAL(14,2);              -- IVA de la sucursal
	DECLARE Var_IVASeguroCuota      DECIMAL(12,2);              -- Monto que cobrara por IVA
	#FIN SEGURO CUOTA
	#COMISION ANUAL
	DECLARE Var_CobraComisionComAnual			VARCHAR(1);				-- Cobra Comision S:Si N:No
	DECLARE Var_TipoComisionComAnual			VARCHAR(1);				-- Tipo de Comision P:Porcentaje M:Monto
	DECLARE Var_BaseCalculoComAnual				VARCHAR(1);				-- Base del Calculo M:Monto del credito Original S:Saldo Insoluto
	DECLARE Var_MontoComisionComAnual			DECIMAL(14,2);			-- Monto de la Comision en caso de que el tipo de comision sea M
	DECLARE Var_PorcentajeComisionComAnual		DECIMAL(14,4);			-- Porcentaje de la comision en caso de que el tipo de comision sea P
	DECLARE Var_DiasGraciaComAnual				INT(11);				-- Dias de gracia que se dan antes de cobrar la comision
	#FIN COMISION ANUAL
	DECLARE Var_NombreUsuario					VARCHAR(500);
	DECLARE Var_ClaveUsuario					INT(11);
	# CASTIGO MASIVO
	DECLARE Var_DiasAtrasoMin					INT(11);
	DECLARE Var_CobraAccesorios					CHAR(1);			-- Indica si la solicitud cobra accesorios
    DECLARE Var_PagosXReferencia				CHAR(1);			-- Indica si permite pagos por referencia
    DECLARE Var_PagosXRef						VARCHAR(25); 		-- Descripcion para la LlaveParametro PagosXReferencia
	DECLARE Var_TipoGeneraInteres		CHAR(1);	-- Tipo de Monto Original (Saldos Globales): I.- Iguales  D.- Dias Transcurridos
	DECLARE TipoMontoIguales			CHAR(1);	-- Tipo de Monto Original (Saldos Globales): I.- Iguales
	DECLARE TipoMontoDiasTrans			CHAR(1);	-- Tipo de Monto Original (Saldos Globales): D.- Dias Transcurridos
	DECLARE TipoCalculoMontoOriginal	INT(11);	-- Tipo de Calculo de Interes por el Monto Original (Saldos Globales)

	-- Servicios Adicionales
	DECLARE Var_AplicaDescServicio	CHAR(1);			-- Variable que indica si la solicitud de crédito tiene servicios adicionales
	DECLARE Var_Contador			INT(11);			-- Variable contador
	DECLARE Var_ServicioDesc		VARCHAR(100);		-- Variable para describir el servicio adicional
	DECLARE Var_ValidaDocs			CHAR(1);			-- Variable que indica si es necesario validar el documento para el servicio adicional
	DECLARE Var_DocDesc				VARCHAR(100);		-- Variable para describir el nombre del documento para validar el servicio adicional
	DECLARE Var_Adjuntado			CHAR(1);			-- Variable que indica si el archivo a validar ya se ha adjuntado
	DECLARE Var_EsConsolidacionAgro	CHAR(1);			-- Es Credito Consolidada Agro
	DECLARE Var_SolicitudCreditoID	BIGINT(12);			-- Numero de Solicitud de Credito

	DECLARE Var_EsAgropecuario			CHAR(1);
	DECLARE Var_LineaCreditoID			BIGINT(20);		-- Linea Credito ID
	DECLARE Var_SaldoDisponible			DECIMAL(12,2);	-- Saldo de la Linea, nace con saldo = autorizado
	DECLARE Var_FechaVencimiento		DATE;			-- Fecha de Vencimiento de la Linea de Credito

	DECLARE Var_ManejaComAdmon			CHAR(1);		-- Maneja Comisión Administración \nS.- SI \nN.- NO
	DECLARE Var_ComAdmonLinPrevLiq		CHAR(1);		-- comisión de Admon que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobComAdmon			CHAR(1);		-- Forma Cobro Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición \nC.- Cada Cuota
	DECLARE Var_ForPagComAdmon			CHAR(1);		-- Forma Pago Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición \nC.- Cada Cuota
	DECLARE Var_PorcentajeComAdmon		DECIMAL(6,2);	-- permite un valor de 0% a 100%

	DECLARE Var_ManejaComGarantia		CHAR(1);		-- Maneja Comisión por Garantía \nS.- SI \nN.- NO
	DECLARE Var_ComGarLinPrevLiq		CHAR(1);		-- comisión de Garantia que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobComGarantia		CHAR(1);		-- Forma Cobro Comisión Garantía \n"".- No aplica \nC.- Cada Cuota
	DECLARE Var_ForPagComGarantia		CHAR(1);		-- Forma Pago Comisión Garantía \n"".- No aplica \nC.- Cada Cuota
	DECLARE Var_PorcentajeComGarantia	DECIMAL(6,2);	-- permite un valor de 0% a 100%
	DECLARE Var_PolizaID				BIGINT(20);		-- Poliza de Ajuste
	DECLARE Var_ClienteID               INT(11);         --  Cliente Id
	DECLARE Var_EstatusLinea            CHAR(1);        -- Estatus de linea  de credito
	DECLARE Var_PagaIVA					CHAR(1);		-- Si el cliente Paga IVA
	DECLARE Var_ComisionTotal			DECIMAL(14,2);	-- Monto Total de la Comision por manejo de Linea

	# Declaracion de constantes
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT;
	DECLARE Si_ManejaLinea      CHAR(1);
	DECLARE PagoCreciente       CHAR(1);
	DECLARE TomaFechInha        CHAR(1);
	DECLARE AjuFexiVen          CHAR(1);
	DECLARE Rec_Propios         CHAR(1);
	DECLARE Rec_Fondeo          CHAR(1);
	DECLARE Estatus_Activo      CHAR(1);
	DECLARE Salida_NO           CHAR(1);
	DECLARE Salida_SI           CHAR(1);
	DECLARE TipoValiAltaCre   	INT;
	DECLARE MenorEdad     		CHAR(1);
	DECLARE FrecuencCapLib    	CHAR(1);
	DECLARE FrecuencIntLib    	CHAR(1);
	DECLARE TPagCapitalLib    	CHAR(1);
	DECLARE CreRenovacion   	CHAR(1);
	DECLARE Constante_NO    	CHAR(1);
	DECLARE Constante_SI    	CHAR(1);
	DECLARE Num_PagRegula   	INT(5);
	DECLARE Estatus_Alta    	CHAR(1);
	DECLARE Estatus_Pagado    	CHAR(1);
	DECLARE OrigenRenovacion  	CHAR(1);
	DECLARE Est_Vigente     	CHAR(1);
	DECLARE Est_Vencido     	CHAR(1);
	DECLARE Est_Cancela     	CHAR(1);
	DECLARE Est_Desembolso    	CHAR(1);
	DECLARE PersonaCliente    	CHAR(1);
	DECLARE Entero_Uno      	INT(11);
	#COMISION ANUAL
	DECLARE TipoCalMontoComAnual				VARCHAR(1);				-- Tipo de cobro por monto
	DECLARE TipoCalPorcenComAnual				VARCHAR(1);				-- Tipo de cobro por porcentaje
	#FIN COMISION ANUAL

	DECLARE Var_CuotaCompProyectada CHAR(1);		-- Tipo de Prepago Cuota Completas Proyectadas 'P'
	DECLARE Var_PermitePrepago		CHAR(1);		-- Permite Prepago

	DECLARE Var_FlujoOrigen			CHAR(1);		-- Flujo origen
	DECLARE Var_EsConsolidado		CHAR(1);		-- Es consolidado

	DECLARE Con_Deduccion			CHAR(1);		-- Forma de Pago por Deduccion
	DECLARE Con_Financiado			CHAR(1);		-- Forma de Pago por Financiado
	DECLARE Con_DecimalCien			DECIMAL(12,2);	-- Constante Decimal Cien
	DECLARE Tip_Disposicion			CHAR(1);		-- Constante Tipo Dispocision
	DECLARE Tip_Total				CHAR(1);		-- Constante Total en primera Disposicion
	DECLARE Tip_Cuota				CHAR(1);		-- Constante Cada Cuota
	DECLARE Var_MontoPagComAdmon	DECIMAL(14,2);	-- Monto a Pagar por Comisión por Administracion
	DECLARE Var_MontoPagComGarantia	DECIMAL(14,2);	-- Monto a Pagar por Comisión por Servicio de Garantia
	DECLARE Var_Comisiones			DECIMAL(14,2);	-- Monto de Comisiones
	DECLARE Var_AutorizadoLinea		DECIMAL(14,2);	-- Monto de Autorizado Linea de Credito
	DECLARE Est_Bloqueado	        CHAR(1);		-- Indica si se encuentra bloqueada la linea \nB.- Bloqueada
	DECLARE EstLinea_Vencido 	    CHAR(1);	    -- Indica si se encuentra bloqueada la linea \nE.- Vencido
	DECLARE Var_FechaInicioLinea		DATE;			-- Fecha de Inicio de la Linea

	# Asignacion de constantes
	SET Cadena_Vacia          	:= '';
	SET Var_TipPagCapL          := 'L';
	SET Fecha_Vacia           	:= '1900-01-01';
	SET Entero_Cero           	:= 0;
	SET Decimal_Cero          	:= 0.0;
	SET Si_ManejaLinea        	:= 'S';
	SET PagoCreciente         	:= 'C';
	SET TomaFechInha          	:= 'S';
	SET AjuFexiVen            	:= 'N';
	SET Rec_Propios           	:= 'P';
	SET Rec_Fondeo            	:= 'F';
	SET Estatus_Activo        	:= 'A';
	SET Salida_NO             	:= 'N';
	SET Salida_SI             	:= 'S';
	SET TipoValiAltaCre       	:= 1;
	SET MenorEdad       		:=  'S';
	SET FrecuencCapLib      	:= 'L';       -- Frecuencia de capital: Libre
	SET FrecuencIntLib      	:= 'L';       -- Frecuencia de interes: Libre
	SET TPagCapitalLib      	:= 'L';             -- Tipo Pago Capital: Libre
	SET CreRenovacion     		:= 'O';
	SET Constante_NO      		:= 'N';     -- Constante NO
	SET Constante_SI      		:= 'S';     -- Constante SI
	SET Num_PagRegula     		:= 3;       -- Numero de pagos sostenidos requerido segun CNBV
	SET Estatus_Alta      		:= 'A';     -- Estatus de Alta para la renovacion
	SET Estatus_Pagado      	:= 'P';     -- Estatus pagado
	SET OrigenRenovacion    	:= 'O';     -- Indica que es un credito renovacion en la tabla de reestructuras
	SET Est_Vigente       		:= 'V';     -- Estatus vigente
	SET Est_Vencido       		:= 'B';     -- Estatus vencido
	SET Est_Cancela       		:= 'C';     -- Estatus cancelado
	SET Est_Desembolso     		:= 'D';     -- Estatus desembolsado
	SET PersonaCliente      	:= 'C';     -- Tipo de persona: cliente
	SET Entero_Uno        		:= 1;
	SET No_Asignada       		:= 'N';
	#COMISION ANUAL
	SET TipoCalMontoComAnual	:= 'M';			# Base de Calculo por Monto para comision por anualidad
	SET TipoCalPorcenComAnual	:= 'P';			# Base de Calculo por Porcentaje para comision por anualidad
	#FIN COMISION ANUAL
	SET Var_PagosXRef			:= "PagosXReferencia"; 		-- Descripcion para la LlaveParametro PagosXReferencia
	SET TipoMontoIguales		:= 'I';
	SET TipoMontoDiasTrans		:= 'D';
	SET TipoCalculoMontoOriginal := 2;
	SET Var_CuotaCompProyectada	:= 'P';
	SET Con_Deduccion			:= 'D';
	SET Con_Financiado			:= 'F';
	SET Con_DecimalCien			:= 100.00;
	SET Tip_Disposicion			:= 'D';
	SET Tip_Total				:= 'T';
	SET Tip_Cuota				:= 'C';
	SET Est_Bloqueado           := 'B';
	SET EstLinea_Vencido        := 'E';



	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr 		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOSMOD');
			SET Var_NomControl	:= 'SQLEXCEPTION';
		END;

		SET Var_NomControl    := 'creditoID';
		SET Var_FechaSistema  :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_DestinoCre    :=Entero_Cero;
		SET Var_SalCredAnt      :=0.0;


        # Destino de Credito
        SET Var_DestinoCre:=(SELECT ProductoCreditoID
                            FROM DESTINOSCREDPROD
                            WHERE ProductoCreditoID = Par_ProduCredID
                            AND DestinoCreID = Par_DestinoCreID);

       SET Var_DestinoCre:=IFNULL(Var_DestinoCre,Entero_Cero);


		SELECT DiaPagoCapital  INTO  Var_DiaPagoProd  FROM CALENDARIOPROD WHERE ProductoCreditoID = Par_ProduCredID;

		SELECT
			ManejaLinea,    		TipoPagoSeguro,   			ForCobroComAper, 	TipoGeneraInteres,
			CobraSeguroCuota,		CobraIVASeguroCuota,		DiasAtrasoMin,		CobraAccesorios
		  INTO
			Var_ManejaLinea,  		Var_TipPagoSeg,   			Var_TipPagComAp, 	Var_TipoGeneraInteres,
			Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_DiasAtrasoMin,	Var_CobraAccesorios
			FROM PRODUCTOSCREDITO
				WHERE  ProducCreditoID = Par_ProduCredID;
			# SEGUROS ----------------------------------------------------------------
		SET Var_CobraSeguroCuota 	:= IFNULL(Var_CobraSeguroCuota, Constante_NO);
		SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota,Constante_NO);
        SET Var_CobraAccesorios		:= IFNULL(Var_CobraAccesorios, Constante_NO);

		IF(Par_SolicCredID != Entero_Cero)THEN

		  SELECT Sol.ForCobroComAper, Sol.ForCobroSegVida, Sol.FlujoOrigen, Sol.EsConsolidado
		  INTO Var_TipPagComAp, Var_TipPagoSeg, Var_FlujoOrigen, Var_EsConsolidado
		  FROM SOLICITUDCREDITO Sol
		  WHERE Sol.SolicitudCreditoID = Par_SolicCredID;


		  CALL VALIDAPRODCREDPRO (
			Entero_Cero,        Par_SolicCredID,    TipoValiAltaCre,    Salida_NO,          Par_NumErr,
			Par_ErrMen,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

		  IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		  END IF;
		END IF;


		SELECT MonedaID  INTO Var_MonedaCta
		FROM CUENTASAHO
		WHERE ClienteID       = Par_ClienteID
			AND CuentaAhoID   = Par_CuentaID;

		SET Var_ManejaLinea   = IFNULL(Var_ManejaLinea, Cadena_Vacia);
		SET Var_MonedaCta   = IFNULL(Var_MonedaCta, Entero_Cero);

		IF(NOT EXISTS(SELECT CreditoID
			  FROM CREDITOS
			  WHERE CreditoID = Par_CreditoID)) THEN
		  SET Par_NumErr  := 1;
		  SET Par_ErrMen  := 'El Credito No Existe.';
		  SET Var_NomControl  := 'creditoID';
		  LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_CuentaID, Entero_Cero))= Entero_Cero THEN
		  SET Par_NumErr  := 2;
		  SET Par_ErrMen  := 'El Numero de Cuenta de Ahorro esta Vacio.';
		  SET Var_NomControl  := 'cuentaID';
		  LEAVE ManejoErrores;
		END IF;

		SET Par_LinCreditoID := IFNULL(Par_LinCreditoID, Entero_Cero);

		IF( Par_LinCreditoID <> Entero_Cero ) THEN
			SELECT	LineaCreditoID,		EsAgropecuario,    Estatus
			INTO	Var_LineaCreditoID,	Var_EsAgropecuario,    Var_EstatusLinea
			FROM LINEASCREDITO
			WHERE LineaCreditoID = Par_LinCreditoID;

			IF( IFNULL(Var_LineaCreditoID , Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr		:= 5;
				SET Par_ErrMen		:= 'La Linea de credito no Existe.';
				SET Var_NomControl	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

	    	IF( Var_EstatusLinea IN (Est_Bloqueado, EstLinea_Vencido)) THEN
				SET Par_NumErr	:= 067;
				SET Par_ErrMen	:= 'La Linea de Credito se encuentra Bloqueda/Vencida.';
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_EsAgropecuario := IFNULL(Var_EsAgropecuario, Constante_NO);
		END IF;

		IF(Var_ManejaLinea = Si_ManejaLinea)THEN
			IF( Par_LinCreditoID != Entero_Cero AND Var_EsAgropecuario = Constante_NO ) THEN
				SELECT  IFNULL(FechaVencimiento,Fecha_Vacia), IFNULL(FechaInicio,Fecha_Vacia),
					IFNULL(ClienteID,Entero_Cero),  Estatus   INTO
					FechaTermLin,   FechaIniLin,    Var_Cliente,    Var_EstatusLinea
				FROM LINEASCREDITO
				WHERE LineaCreditoID = Par_LinCreditoID;

				IF(Par_FechaVencim > FechaTermLin)THEN
					SET Par_NumErr  := 3;
					SET Par_ErrMen  := 'El Credito No esta dentro de la Vigencia de la Linea.';
					SET Var_NomControl  := 'lineaCreditoID';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_FechaInicio < FechaIniLin) THEN
					SET Par_NumErr  := 4;
					SET Par_ErrMen  := 'El Credito No esta dentro de la Vigencia de la Linea.';
					SET Var_NomControl  := 'lineaCreditoID';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_Cliente != Par_ClienteID)THEN
					SET Par_NumErr  := 5;
					SET Par_ErrMen  := 'La Linea No Corresponde al safilocale.cliente.';
					SET Var_NomControl  := 'lineaCreditoID';
					LEAVE ManejoErrores;
				END IF;

	        	IF( Var_EstatusLinea IN (Est_Bloqueado, EstLinea_Vencido)) THEN
					SET Par_NumErr	:= 068;
					SET Par_ErrMen	:= 'La Linea de Credito Agro se encuentra Bloqueada/Vencida.';
					SET Var_Control	:= 'lineaCreditoID';
					LEAVE ManejoErrores;
				END IF;

			END IF;
		END IF; -- Fin de la validacion de linea de credito

		IF(Var_MonedaCta <> Par_MonedaID )THEN
		  SET Par_NumErr  := 6;
		  SET Par_ErrMen  := 'La Moneda de la Cuenta es Diferente de la Moneda del Credito.';
		  SET Var_NomControl  := 'monedaID';
		  LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_CuentaID, Entero_Cero))= Entero_Cero THEN
		  SET Par_NumErr  := 7;
		  SET Par_ErrMen  := 'El Numero de Cuenta esta Vacio.';
		  SET Var_NomControl  := 'cuentaID';
		  LEAVE ManejoErrores;
		END IF;

		SET Par_TipoFondeo  := IFNULL(Par_TipoFondeo, Cadena_Vacia);
		IF(Par_TipoFondeo != Rec_Propios AND Par_TipoFondeo != Rec_Fondeo ) THEN
		  SET Par_NumErr  := 8;
		  SET Par_ErrMen  := 'Favor de Especificar el Origen de los Recursos.';
		  SET Var_NomControl  := 'tipoFondeo';
		  LEAVE ManejoErrores;
		END IF;


		IF (Par_TipoFondeo = Rec_Fondeo) THEN
		  SELECT  Ins.Estatus, Lin.SaldoLinea INTO Var_EstFondeo, Var_SaldoFondo
		  FROM INSTITUTFONDEO Ins,
			 LINEAFONDEADOR Lin
		  WHERE   Ins.InstitutFondID  = Lin.InstitutFondID
			  AND   Ins.InstitutFondID  = Par_InstitFondeoID
			  AND   Lin.LineaFondeoID   = Par_LineaFondeo;

		  SET Var_EstFondeo   := IFNULL(Var_EstFondeo, Cadena_Vacia);
		  SET Var_SaldoFondo  := IFNULL(Var_SaldoFondo, Entero_Cero);

		  IF (Var_EstFondeo != Estatus_Activo) THEN
			SET Par_NumErr  := 9;
			SET Par_ErrMen  := 'La Institucion de Fondeo No Existe o No esta Activa.';
			SET Var_NomControl  := 'lineaFondeo';
			LEAVE ManejoErrores;
		  ELSE
			IF (Var_SaldoFondo < Par_MontoCredito) THEN
			  SET Par_NumErr  := 10;
			  SET Par_ErrMen  := 'Saldo de la Linea de Fondeo Insuficiente.';
			  SET Var_NomControl  := 'lineaFondeo';
			  LEAVE ManejoErrores;
			END IF;
		  END IF;
		END IF;

		IF(Par_TPagCapital = Var_TipPagCapL) THEN
		  SET VarSumaCapital := (SELECT SUM(Tmp_Capital)  FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTransacSim);
		  SET VarSumaCapital := IFNULL(VarSumaCapital, Decimal_Cero);
		  IF( VarSumaCapital != Par_MontoCredito )THEN
			SET Par_NumErr  := 11;
			SET Par_ErrMen  := 'Simule o Calcule Amortizaciones Nuevamente.';
			SET Var_NomControl  := 'simular';
			LEAVE ManejoErrores;
		  END IF;
		END IF;


		-- valida que el cliente no sea menor de edad
		IF EXISTS (SELECT ClienteID
		  FROM CLIENTES
		  WHERE ClienteID = Par_ClienteID
		  AND EsMenorEdad = MenorEdad)THEN
			  SET Par_NumErr      := 12;
			  SET Par_ErrMen      :='El safilocale.cliente es Menor, No es Posible Asignar Credito.' ;
			  SET Var_NomControl  := 'clienteID';
			  LEAVE ManejoErrores;
		END IF;

		--  Realiza las validacion para la Garantia Liquida
		SET Var_RequiereGL    := (SELECT IFNULL(Garantizado,No_Asignada) FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProduCredID);

		# si el producto de credito no requiere GL, guardara ceros
		IF(Var_RequiereGL = No_Asignada)THEN
		  SET Var_PorcGarLiq  := Decimal_Cero;
		  SET Var_AporteCliente := Decimal_Cero;
		ELSE
		  SET Var_CalificaCredito  :=(SELECT IFNULL(CalificaCredito,No_Asignada) FROM CLIENTES WHERE ClienteID = Par_ClienteID);

		  SELECT Porcentaje
			FROM ESQUEMAGARANTIALIQ
			WHERE Clasificacion = Var_CalificaCredito
			  AND ProducCreditoID = Par_ProduCredID
			  AND Par_MontoCredito BETWEEN LimiteInferior AND LimiteSuperior
			LIMIT 1
		  INTO Var_PorcGarLiq;

		  SET Var_AporteCliente := ROUND( (Par_MontoCredito * Var_PorcGarLiq) /100,2);
		END IF;


		IF(IFNULL(Par_FechaInicioAmor, Fecha_Vacia) = Fecha_Vacia) THEN
		  SET Par_NumErr      := 13;
		  SET Par_ErrMen      :='Especifique la Fecha de Inicio de Amortizaciones.' ;
		  SET Var_NomControl  := 'fechaInicioAmor';
		  LEAVE TerminaStore;
		END IF;

		IF NOT EXISTS (SELECT CreditoID FROM CREDITOS
			  WHERE SolicitudCreditoID = Par_SolicCredID
				AND CreditoID = Par_CreditoID) THEN
		  SET Par_NumErr      := 14;
		  SET Par_ErrMen      :='No Puede Modificar el Numero de Solicitud de Credito.' ;
		  SET Var_NomControl  := 'solicitudCreditoID';
		  LEAVE TerminaStore;
		END IF;

		IF(IFNULL(Par_TipoCredito, Cadena_Vacia) = Cadena_Vacia) THEN
		  SET Par_NumErr      := 15;
		  SET Par_ErrMen      :='Especifique el Tipo de Credito.' ;
		  SET Var_NomControl  := 'tipoCredito';
		  LEAVE TerminaStore;
		END IF;

		IF(Var_DestinoCre=Cadena_Vacia)THEN
				SET Par_NumErr  = 16;
				SET Par_ErrMen  = 'El Destino de Credito Seleccionado no Corresponde con el Producto por su Clasificacion.';
				SET Var_NomControl  := 'destinoCreID';
				LEAVE ManejoErrores;
			END IF;

		IF(Par_Plazo = Cadena_Vacia )THEN
		  SET Par_NumErr      := 17;
		  SET Par_ErrMen      := CONCAT('Especifique el Plazo del Credito.' );
		  SET Var_NomControl  := 'plazoID';
		  LEAVE ManejoErrores;
		END IF;

        SET Var_PagosXReferencia := (SELECT ValorParametro
									FROM PARAMGENERALES
									WHERE LlaveParametro = Var_PagosXRef);
        IF(IFNULL(Var_PagosXReferencia,Cadena_Vacia)=Constante_SI AND IFNULL(Par_ReferenciaPago,Cadena_Vacia)=Cadena_Vacia )THEN
			SET Par_NumErr      := 18;
			SET Par_ErrMen      := CONCAT('Especifique la Referencia de Pago de Credito.' );
			SET Var_NomControl  := 'referenciaPago';
			LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_MontoSegVida, Decimal_Cero) > Decimal_Cero) THEN
		  SET Par_MontoSegOri := ROUND(Par_MontoSegVida / (1 - (Par_DescSeguro / 100)), 2);
		END IF;

			  /**VALIDACION PARA COBRO POR SEGURO POR CUOTA**/
		IF(Var_CobraSeguroCuota = 'S') THEN
		  SET Var_MontoSeguroCuota :=(SELECT Monto
				FROM ESQUEMASEGUROCUOTA AS Esq INNER JOIN
				  CATFRECUENCIAS AS Cat ON Esq.Frecuencia=Cat.FrecuenciaID
				  WHERE ProducCreditoID = Par_ProduCredID
				  AND Frecuencia IN(Par_FrecuencCap, Par_FrecuencInt) ORDER BY Dias ASC LIMIT 1);

			IF(IFNULL(Var_MontoSeguroCuota,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr  := 040;
				SET Par_ErrMen  := 'El Monto por Seguro por Cuota esta Vacio.' ;
				SET Var_Control := 'frecuenciaCap';
				LEAVE ManejoErrores;
			  ELSE
				IF(IFNULL(Var_CobraIVASeguroCuota,'N') = 'S') THEN
					SET Var_IVA       := (SELECT IFNULL(IVA,Decimal_Cero) FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
					SET Var_IVASeguroCuota :=  ROUND(Var_MontoSeguroCuota * Var_IVA,2);
				ELSE
					SET Var_IVASeguroCuota := Entero_Cero;
				END IF;
			END IF;
		  ELSE
				SET Var_MontoSeguroCuota := Entero_Cero;
				SET Var_IVASeguroCuota := Entero_Cero;
		END IF;
		/**fin VALIDACION PARA COBRO POR SEGURO POR CUOTA**/
			/** VALIDACION PARA COMISION ANUAL **/
			SELECT
				CobraComision,					TipoComision,				BaseCalculo,				MontoComision,				PorcentajeComision,
				DiasGracia
			INTO
				Var_CobraComisionComAnual,		Var_TipoComisionComAnual,	Var_BaseCalculoComAnual,	Var_MontoComisionComAnual,	Var_PorcentajeComisionComAnual,
				Var_DiasGraciaComAnual
			FROM ESQUEMACOMANUAL
					WHERE ProducCreditoID = Par_ProduCredID;

			SET Var_CobraComisionComAnual		:= IFNULL(Var_CobraComisionComAnual, Constante_NO);
			SET Var_TipoComisionComAnual		:= IFNULL(Var_TipoComisionComAnual, Cadena_Vacia);
			SET Var_BaseCalculoComAnual			:= IFNULL(Var_BaseCalculoComAnual, Cadena_Vacia);
			SET Var_MontoComisionComAnual		:= IFNULL(Var_MontoComisionComAnual, Entero_Cero);
			SET Var_PorcentajeComisionComAnual	:= IFNULL(Var_PorcentajeComisionComAnual, Decimal_Cero);
			SET Var_DiasGraciaComAnual			:= IFNULL(Var_DiasGraciaComAnual, Entero_Cero);

			IF(Var_CobraComisionComAnual = Constante_SI) THEN
				IF(Var_TipoComisionComAnual = Cadena_Vacia) THEN
					SET Par_NumErr  := 041;
					SET Par_ErrMen  := 'El Tipo de Comision por Anualidad esta Vacio, Revise la Parametrizacion del Producto.' ;
					SET Var_NomControl := 'agregar';
					SET Var_Consecutivo := '';
					LEAVE ManejoErrores;
				END IF;
				IF(Var_TipoComisionComAnual = TipoCalPorcenComAnual AND Var_BaseCalculoComAnual = Cadena_Vacia) THEN
					SET Par_NumErr  := 042;
					SET Par_ErrMen  := 'La Base de Calculo por Comision por Anualidad esta Vacio, Revise la Parametrizacion del Producto.' ;
					SET Var_NomControl := 'agregar';
					SET Var_Consecutivo := '';
					LEAVE ManejoErrores;
				END IF;
				IF(Var_TipoComisionComAnual = TipoCalMontoComAnual AND Var_MontoComisionComAnual = Entero_Cero) THEN
					SET Par_NumErr  := 043;
					SET Par_ErrMen  := CONCAT('El Monto para la Comision por Anualidad esta Vacio, Revise la Parametrizacion del Producto.') ;
					SET Var_NomControl := 'agregar';
					SET Var_Consecutivo := '';
					LEAVE ManejoErrores;
				END IF;
				IF(Var_TipoComisionComAnual = TipoCalPorcenComAnual AND Var_PorcentajeComisionComAnual = Entero_Cero) THEN
					SET Par_NumErr  := 044;
					SET Par_ErrMen  := 'El Porcentaje para la Comision por Anualidad esta Vacio, Revise la Parametrizacion del Producto.' ;
					SET Var_NomControl := 'agregar';
					SET Var_Consecutivo := '';
					LEAVE ManejoErrores;
				END IF;
			END IF;
			/** FIN VALIDACION PARA COMISION ANUAL **/

			SET Par_TipoCalInt := IFNULL(Par_TipoCalInt, Entero_Cero);

			IF( IFNULL(Par_TipoCalInt, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 045;
				SET Par_ErrMen	:= 'Especifique el Tipo de Calculo de Interes.';
				SET Var_Control	:= 'tipoCalInteres';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_TipoCalInt = TipoCalculoMontoOriginal) THEN

				-- Validacion si el Tipo de Calculo es Monto Original
				IF( Var_TipoGeneraInteres = Cadena_Vacia)THEN
					SET Par_NumErr	:= 046;
					SET Par_ErrMen	:= 'Especifique el Tipo de Generacion de Interes ';
					SET Var_Control	:= 'tipoGeneraInteres';
					LEAVE ManejoErrores;
				END IF;

				-- Validacion para verificar que el tipo de Calculo sea lo parametrizado
				IF( Var_TipoGeneraInteres NOT IN (TipoMontoIguales, TipoMontoDiasTrans) )THEN
					SET Par_NumErr	:= 047;
					SET Par_ErrMen	:= 'Especifique un Tipo de Generacion de Interes valido';
					SET Var_Control	:= 'tipoGeneraInteres';
					LEAVE ManejoErrores;
				END IF;

			END IF;

		-- ===================== Validación si requiere documentos adjuntos de servicios adicionales
		-- Inicio validación servicios adicionales en caso de tenerlos
		SELECT AplicaDescServicio INTO Var_AplicaDescServicio
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolicCredID;

		IF Var_AplicaDescServicio = Constante_SI THEN
		-- Obtener los Documentos que son requeridos y aun no se adjuntan
			SELECT 	sad.Descripcion,
					sad.ValidaDocs,
					tdo.Descripcion,
					CASE WHEN sar.DigSolID IS NULL
							THEN Constante_NO
							ELSE Constante_SI
					END AS Adjuntado
				INTO	Var_ServicioDesc,	Var_ValidaDocs,	Var_DocDesc,	Var_Adjuntado
			FROM SERVICIOSXSOLCRED  ssc
				INNER JOIN SERVICIOSADICIONALES sad on ssc.ServicioID = sad.ServicioID
					INNER JOIN TIPOSDOCUMENTOS as tdo on sad.TipoDocumento = tdo.TipoDocumentoID
						LEFT JOIN SOLICITUDARCHIVOS sar on ssc.SolicitudCreditoID = sar.SolicitudCreditoID
						AND tdo.TipoDocumentoID = sar.TipoDocumentoID
			WHERE sad.ValidaDocs 		= Constante_SI
			  AND sar.DigSolID 			IS NULL  -- Sin adjuntar el documento
			  AND ssc.SolicitudCreditoID = Par_SolicCredID
			  LIMIT 1;

			-- Verificamos que este adjunto
			IF Var_Adjuntado = Constante_NO THEN
				SET Par_NumErr := 112;
				SET Par_ErrMen := CONCAT('No se ha adjuntado el documento ', Var_DocDesc ,' requerido para validar el Servicios Adicional ', Var_ServicioDesc, '.');
				SET Var_Control:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;
		-- Fin validación servicios adicionales en caso de tenerlos

			SET Aud_FechaActual := NOW();
			SET Var_TipCobComMorato := (SELECT TipCobComMorato FROM PRODUCTOSCREDITO WHERE  ProducCreditoID =Par_ProduCredID);
			SET Par_FactorMora := (SELECT FactorMora FROM SOLICITUDCREDITO WHERE  SolicitudCreditoID = Par_SolicCredID);

		-- Validacion con Tipo de Prepago con Cuotas Completas Proyectadas
		IF(IFNULL(Par_TipoPrepago,Cadena_Vacia)) != Cadena_Vacia  THEN
			IF(Par_TipoPrepago = Var_CuotaCompProyectada) THEN
				SET Var_PermitePrepago := (SELECT PermitePrepago FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProduCredID);
				SET Var_PermitePrepago := IFNULL(Var_PermitePrepago, Constante_NO);

				IF(Var_PermitePrepago != Constante_SI  OR Par_TipoCalInt != TipoCalculoMontoOriginal)THEN
						SET Par_NumErr := 113;
						SET Par_ErrMen := 'El valor asignado para Tipo de Prepago es Incorrecto, solo Aplica para Saldos Globales';
						SET Var_NomControl := 'creditoID';
						LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SELECT EsConsolidacionAgro,		SolicitudCreditoID
		INTO Var_EsConsolidacionAgro,	Var_SolicitudCreditoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		-- Creditos Consolidados Agro
		IF( Var_EsConsolidacionAgro = Constante_SI ) THEN
			IF( Var_SolicitudCreditoID <> Par_SolicCredID ) THEN
				SET Par_NumErr := 115;
				SET Par_ErrMen := CONCAT('El Credito: ', Par_CreditoID,' es consolidado Agro por tal motivo no puede realizarse la sustitucion de la Solicitud de Credito.');
				SET Var_NomControl := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Seccion de validacion para lineas de credito agro
		IF( Par_LinCreditoID <> Entero_Cero AND Var_EsAgropecuario = Constante_SI ) THEN

			SELECT	LineaCreditoID,			SaldoDisponible,		FechaVencimiento,		ClienteID,		Autorizado,
			        Estatus
			INTO	Var_LineaCreditoID,		Var_SaldoDisponible,	Var_FechaVencimiento,	Var_ClienteID,	Var_AutorizadoLinea,
			        Var_EstatusLinea
			FROM LINEASCREDITO
			WHERE LineaCreditoID = Par_LinCreditoID
			  AND Estatus = Estatus_Activo
			  AND EsAgropecuario = Constante_SI;

			SELECT	ManejaComAdmon,			ComAdmonLinPrevLiq,			ForCobComAdmon,			ForPagComAdmon,			PorcentajeComAdmon,
					ManejaComGarantia,		ComGarLinPrevLiq,			ForCobComGarantia,		ForPagComGarantia,		PorcentajeComGarantia,
					FechaInicio
			INTO	Var_ManejaComAdmon,		Var_ComAdmonLinPrevLiq,		Var_ForCobComAdmon,		Var_ForPagComAdmon,		Var_PorcentajeComAdmon,
					Var_ManejaComGarantia,	Var_ComGarLinPrevLiq,		Var_ForCobComGarantia,	Var_ForPagComGarantia,	Var_PorcentajeComGarantia,
					Var_FechaInicioLinea
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolicCredID;

			SELECT PagaIVA
			INTO 	Var_PagaIVA
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

			SET Var_LineaCreditoID		:= IFNULL(Var_LineaCreditoID, Entero_Cero);
			SET Var_SaldoDisponible		:= IFNULL(Var_SaldoDisponible, Decimal_Cero);
			SET Var_FechaVencimiento	:= IFNULL(Var_FechaVencimiento, Var_FechaSistema);
			SET Var_PagaIVA				:= IFNULL(Var_PagaIVA, Constante_NO);

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

			IF( Var_LineaCreditoID = Entero_Cero ) THEN
				SET Par_NumErr	:= 047;
				SET Par_ErrMen	:= 'La Linea de Credito Agro no existe.';
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ClienteID != Par_ClienteID)THEN
				SET Par_NumErr	:= 048;
				SET Par_ErrMen	:='La Linea de Credito No Corresponde al Cliente.' ;
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_FechaInicioLinea > Var_FechaSistema)THEN
				SET Par_NumErr	:= 049;
				SET Par_ErrMen	:= CONCAT('La Fecha de Inicio de la Linea de Credito es menor a la fecha del sistema') ;
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_EstatusLinea IN (Est_Bloqueado, EstLinea_Vencido)) THEN
				SET Par_NumErr	:= 069;
				SET Par_ErrMen	:= 'La Linea de Credito Agro se encuentra Bloqueada/Vencida.';
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Segmento de Comision por Administracion
			IF( Var_ManejaComAdmon = Constante_NO ) THEN
				SET Var_ComAdmonLinPrevLiq		:= Cadena_Vacia;
				SET Var_ForPagComAdmon			:= Cadena_Vacia;
				SET Var_ForCobComAdmon			:= Cadena_Vacia;
				SET Var_PorcentajeComAdmon		:= Decimal_Cero;
				SET Var_MontoPagComAdmon		:= Decimal_Cero;
			ELSE
				IF( Var_ComAdmonLinPrevLiq = Cadena_Vacia ) THEN
					SET Par_NumErr	:= 049;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Administracion esta vacia.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_ComAdmonLinPrevLiq NOT IN (Constante_NO, Constante_SI) ) THEN
					SET Par_NumErr	:= 050;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Administracion no es Valida.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_ComAdmonLinPrevLiq = Constante_SI ) THEN
					SET Var_ForPagComAdmon		:= Cadena_Vacia;
					SET Var_ForCobComAdmon		:= Cadena_Vacia;
					SET Var_PorcentajeComAdmon	:= Decimal_Cero;
					SET Var_MontoPagComAdmon		:= Decimal_Cero;
				ELSE

					IF( Var_ForPagComAdmon = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 051;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Administracion esta vacia.';
						SET Var_Control	:= 'forPagComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForPagComAdmon NOT IN (Con_Deduccion, Con_Financiado) ) THEN
						SET Par_NumErr	:= 052;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Administracion no es Valida.';
						SET Var_Control	:= 'forPagComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComAdmon = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 053;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Administracion esta vacio.';
						SET Var_Control	:= 'forCobComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComAdmon NOT IN (Tip_Disposicion, Tip_Total)) THEN
						SET Par_NumErr	:= 054;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Administracion no es valido.';
						SET Var_Control	:= 'forCobComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComAdmon <= Decimal_Cero ) THEN
						SET Par_NumErr	:= 055;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Administracion es menor o igual a cero.';
						SET Var_Control	:= 'porcentajeComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComAdmon > Con_DecimalCien ) THEN
						SET Par_NumErr	:= 056;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Administracion es mayor al 100%.';
						SET Var_Control	:= 'porcentajeComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComAdmon = Tip_Disposicion ) THEN
						SET Var_Comisiones := Par_MontoCredito;
					END IF;

					IF( Var_ForCobComAdmon = Tip_Total ) THEN
						SET Var_Comisiones := Var_AutorizadoLinea;
					END IF;

					SET Var_MontoPagComAdmon := ROUND(((Var_Comisiones * Var_PorcentajeComAdmon) / Con_DecimalCien), 2);
					IF( Var_ForPagComAdmon = Con_Financiado ) THEN

						SET Var_MontoPagComAdmon := Entero_Cero;

						SELECT	MontoPagComAdmon
						INTO	Var_MontoPagComAdmon
						FROM SOLICITUDCREDITO
						WHERE SolicitudCreditoID = Par_SolicCredID;
					END IF;

					SET Var_MontoPagComAdmon := IFNULL(Var_MontoPagComAdmon, Decimal_Cero);

					IF( Var_MontoPagComAdmon = Entero_Cero ) THEN
						SET Par_NumErr	:= 057;
						SET Par_ErrMen	:= 'El Monto de Pago por Comision por Administracion no es valido.';
						SET Var_Control	:= 'montoComAdmon';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			-- Segmento de comision por Garantia
			IF( Var_ManejaComGarantia = Constante_NO ) THEN
				SET Var_ComGarLinPrevLiq		:= Cadena_Vacia;
				SET Var_ForPagComGarantia		:= Cadena_Vacia;
				SET Var_ForCobComGarantia		:= Cadena_Vacia;
				SET Var_PorcentajeComGarantia	:= Decimal_Cero;
				SET Var_MontoPagComGarantia		:= Decimal_Cero;
			ELSE
				IF( Var_ComGarLinPrevLiq = Cadena_Vacia ) THEN
					SET Par_NumErr	:= 057;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Garantia esta vacia.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_ComGarLinPrevLiq NOT IN (Constante_NO, Constante_SI) ) THEN
					SET Par_NumErr	:= 058;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Garantia no es Valida.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_ComGarLinPrevLiq = Constante_SI ) THEN
					SET Var_ForPagComGarantia		:= Cadena_Vacia;
					SET Var_PorcentajeComGarantia	:= Decimal_Cero;
					SET Var_MontoPagComGarantia		:= Decimal_Cero;
				ELSE

					IF( Var_ForPagComGarantia = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 059;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Garantia esta vacia.';
						SET Var_Control	:= 'forPagComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForPagComGarantia NOT IN (Con_Deduccion) ) THEN
						SET Par_NumErr	:= 060;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Garantia no es Valida.';
						SET Var_Control	:= 'forPagComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComGarantia = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 061;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Servicio de Garantia esta vacio.';
						SET Var_Control	:= 'forCobComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComGarantia NOT IN (Tip_Cuota)) THEN
						SET Par_NumErr	:= 062;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Servicio de Garantia no es valido.';
						SET Var_Control	:= 'forCobComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComGarantia <= Decimal_Cero ) THEN
						SET Par_NumErr	:= 063;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Garantia es menor o igual a cero.';
						SET Var_Control	:= 'porcentajeComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComGarantia > Con_DecimalCien ) THEN
						SET Par_NumErr	:= 064;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Garantia es mayor al 100%.';
						SET Var_Control	:= 'porcentajeComGarantia';
						LEAVE ManejoErrores;
					END IF;

					CALL CRESIMPAGCOMSERGARPRO (
						Entero_Cero,				Par_SolicCredID,	Par_CreditoID,		Entero_Cero,	Par_NumTransacSim,
						Var_MontoPagComGarantia,	Var_PolizaID,		Par_MontoCredito,	Fecha_Vacia,
						Salida_NO,					Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Par_NumTransacSim);

					SET Var_MontoPagComGarantia := IFNULL(Var_MontoPagComGarantia, Entero_Cero);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					IF( Var_MontoPagComGarantia = Entero_Cero ) THEN
						SET Par_NumErr	:= 065;
						SET Par_ErrMen	:= 'El Monto de Pago por Comision por Servicio de Garantia no es valido.';
						SET Var_Control	:= 'montoGarantia';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			-- Validacion para evitar que el cobro de la comisión no supere al monto del crédito
			SET Var_ComisionTotal := Var_MontoPagComAdmon + Var_MontoPagComGarantia;

			IF( Var_PagaIVA = Constante_SI ) THEN

				SET Var_IVA := (SELECT IFNULL(IVA,Decimal_Cero) FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
				SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
				SET Var_ComisionTotal := Var_MontoPagComAdmon + ROUND(Var_MontoPagComAdmon * Var_IVA, 2) +
										 Var_MontoPagComGarantia +  ROUND(Var_MontoPagComGarantia * Var_IVA, 2);
			END IF;

			-- Segmento de Validacion de General
			IF( Par_MontoCredito > Var_SaldoDisponible ) THEN
				SET Par_NumErr	:= 065;
				SET Par_ErrMen	:= 'El Monto solicitado es mayor al saldo disponible actual de la Linea de Credito seleccionada.';
				SET Var_Control	:= 'montoSolic';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_FechaVencim > Var_FechaVencimiento ) THEN
				SET Par_NumErr	:= 066;
				SET Par_ErrMen	:= 'La fecha de vencimiento de la Solicitud de Crédito excede a la fecha de vencimiento de la línea de Crédito.';
				SET Var_Control	:= 'fechaVencim';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_ComisionTotal > Par_MontoCredito ) tHEN
				SET Par_NumErr	:= 067;
				SET Par_ErrMen	:= 'Las Comisiones por manejo de Linea de Credito Agro superan el monto Solicitado del Credito';
				SET Var_Control	:= 'montoSolic';
				LEAVE ManejoErrores;
			END IF;

			-- Actualizo el monto de Pago de Comision por Administracion(Si el monto que se autorizo es diferente del Solicitado)
			UPDATE SOLICITUDCREDITO SET
				MontoPagComAdmon = Var_MontoPagComAdmon
			WHERE SolicitudCreditoID = Par_SolicCredID;
		ELSE

			-- Comsion por Administracion
			SET Var_ManejaComAdmon			:= Constante_NO;
			SET Var_ComAdmonLinPrevLiq		:= Cadena_Vacia;
			SET Var_ForCobComAdmon			:= Cadena_Vacia;
			SET Var_ForPagComAdmon			:= Cadena_Vacia;
			SET Var_PorcentajeComAdmon		:= Decimal_Cero;

			-- Comsion por Garantia
			SET Var_ManejaComGarantia		:= Constante_NO;
			SET Var_ComGarLinPrevLiq		:= Cadena_Vacia;
			SET Var_ForCobComGarantia		:= Cadena_Vacia;
			SET Var_ForPagComGarantia		:= Cadena_Vacia;
			SET Var_PorcentajeComGarantia	:= Decimal_Cero;
			SET Var_MontoPagComAdmon		:= Decimal_Cero;
			SET Var_MontoPagComGarantia		:= Decimal_Cero;
		END IF;

		UPDATE CREDITOS SET
			CreditoID         	= Par_CreditoID,
			ClienteID         	= Par_ClienteID,
			LineaCreditoID   	= Par_LinCreditoID,
			ProductoCreditoID   = Par_ProduCredID,
			CuentaID          	= Par_CuentaID,
			TipoCredito     	= Par_TipoCredito,
			Relacionado      	= Par_Relacionado,
			SolicitudCreditoID  = Par_SolicCredID,
			MontoCredito      	= Par_MontoCredito,
			MonedaID          	= Par_MonedaID,
			FechaInicio       	= Par_FechaInicio,
			FechaVencimien    	= Par_FechaVencim,
			TipCobComMorato   	= Var_TipCobComMorato,
			FactorMora        	= Par_FactorMora,
			CalcInteresID     	= Par_CalcInterID,
			TasaBase          	= Par_TasaBase,
			TasaFija          	= Par_TasaFija,
			SobreTasa         	= Par_SobreTasa,
			PisoTasa          	= Par_PisoTasa,
			TechoTasa        	= Par_TechoTasa,
			FrecuenciaCap     	= Par_FrecuencCap,
			PeriodicidadCap   	= Par_PeriodCap,
			FrecuenciaInt     	= Par_FrecuencInt,
			PeriodicidadInt   	= Par_PeriodicInt,
			TipoPagoCapital   	= Par_TPagCapital,
			NumAmortizacion   	= Par_NumAmortiza,
			FechaInhabil      	= Par_FecInhabil,
			CalendIrregular   	= Par_CalIrregul,
			DiaPagoInteres    	= Par_DiaPagoInt,
			DiaPagoCapital    	= Par_DiaPagoCap,
			DiaMesInteres     	= Par_DiaMesInt,
			DiaMesCapital     	= Par_DiaMesCap,
			AjusFecUlVenAmo   	= Par_AjFUlVenAm,
			AjusFecExiVen     	= Par_AjuFecExiVe,
			InstitFondeoID    	= Par_InstitFondeoID,
			LineaFondeo       	= Par_LineaFondeo,
			FechTraspasVenc   	= Par_FecTraspVen,
			FechTerminacion   	= Par_FechTermina,
			NumTransacSim     	= Par_NumTransacSim,
			TipoFondeo        	= Par_TipoFondeo,
			MontoComApert     	= Par_MonComApe,
			IVAComApertura    	= Par_IVAComApe,
			ValorCAT          	= Par_ValorCAT,
			PlazoID           	= Par_Plazo,
			TipoDispersion    	= Par_TipoDisper,
			CuentaCLABE     	= Par_CuentaCABLE,
			TipoCalInteres    	= Par_TipoCalInt,
			TipoGeneraInteres	= Var_TipoGeneraInteres,
			DestinoCreID      	= Par_DestinoCreID,
			NumAmortInteres   	= Par_NumAmortInt,
			AporteCliente   	= Var_AporteCliente,
			PorcGarLiq      	= Var_PorcGarLiq,
			MontoCuota       	= Par_MontoCuota,
			MontoSeguroVida   	= Par_MontoSegVida,
			ForCobroSegVida   	= Par_ForCobroSegVida,
			ForCobroComAper   	= Var_TipPagComAp,
			ClasiDestinCred   	=  Par_ClasiDestinCred,
			TipoPrepago       	= Par_TipoPrepago,
			FechaInicioAmor   	= Par_FechaInicioAmor,
			DescuentoSeguro   	= Par_DescSeguro,
			MontoSegOriginal  	= Par_MontoSegOri,
			DiaPagoProd     	= Var_DiaPagoProd,
			CobraSeguroCuota 	= Var_CobraSeguroCuota,
			CobraIVASeguroCuota = Var_CobraIVASeguroCuota,
			MontoSeguroCuota 	= Var_MontoSeguroCuota,
			IVASeguroCuota 		= Var_IVASeguroCuota,
			CobraComAnual 		= Var_CobraComisionComAnual,
			TipoComAnual 		= Var_TipoComisionComAnual,
			BaseCalculoComAnual = Var_BaseCalculoComAnual,
			MontoComAnual 		= Var_MontoComisionComAnual,
			PorcentajeComAnual 	= Var_PorcentajeComisionComAnual,
			DiasGraciaComAnual 	= Var_DiasGraciaComAnual,
			TipoConsultaSIC		= Par_TipoConsultaSIC,
			FolioConsultaBC		= Par_FolioConsultaBC,
			FolioConsultaCC     = Par_FolioConsultaCC,
			FechaCobroComision	= Par_FechaCobroComision,
			DiasAtrasoMin		= Var_DiasAtrasoMin,
			CobraAccesorios		= Var_CobraAccesorios,
			ReferenciaPago		= Par_ReferenciaPago,
			FlujoOrigen			= IFNULL(Var_FlujoOrigen,Cadena_Vacia),
			EsConsolidado		= IFNULL(Var_EsConsolidado,Cadena_Vacia),

			ManejaComAdmon			= Var_ManejaComAdmon,
			ComAdmonLinPrevLiq		= Var_ComAdmonLinPrevLiq,
			ForCobComAdmon			= Var_ForCobComAdmon,
			ForPagComAdmon			= Var_ForPagComAdmon,
			PorcentajeComAdmon		= Var_PorcentajeComAdmon,
			MontoPagComAdmon		= Var_MontoPagComAdmon,

			ManejaComGarantia		= Var_ManejaComGarantia,
			ComGarLinPrevLiq		= Var_ComGarLinPrevLiq,
			ForCobComGarantia		= Var_ForCobComGarantia,
			ForPagComGarantia		= Var_ForPagComGarantia,
			PorcentajeComGarantia	= Var_PorcentajeComGarantia,
			MontoPagComGarantia 	= Var_MontoPagComGarantia,
			MontoPagComGarantiaSim	= Var_MontoPagComGarantia,

			EmpresaID       		= Aud_EmpresaID,
			Usuario         		= Aud_Usuario,
			FechaActual     		= Aud_FechaActual,
			DireccionIP     		= Aud_DireccionIP,
			ProgramaID      		= Aud_ProgramaID,
			Sucursal        		= Aud_Sucursal,
			NumTransaccion  		= Aud_NumTransaccion

		WHERE   CreditoID   = Par_CreditoID;

		-- INICIO  ACTUALIZACION DE COMENTARIO PARA LA MESA DE CONTROL Y EL MONITOR DE SOLICITUDES
		 -- Datos del Usuario
			SELECT	Usu.NombreCompleto,	Usu.UsuarioID
			INTO 	Var_NombreUsuario, 	Var_ClaveUsuario
			FROM USUARIOS Usu
				LEFT JOIN PUESTOS Pue ON Pue.ClavePuestoID = Usu.ClavePuestoID
			WHERE Usu.UsuarioID = Aud_Usuario;

		UPDATE  SOLICITUDCREDITO    SET
				ComentarioMesaControl 	= CONCAT(CASE WHEN IFNULL(ComentarioMesaControl, Cadena_Vacia) = Cadena_Vacia
														THEN Cadena_Vacia
														ELSE " " END,"--> ", CAST(NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",  LTRIM(RTRIM(Par_ComentarioAlt)),
																" ", LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia)))  )

				WHERE SolicitudCreditoID    = Par_SolicCredID
					AND CreditoID   = Par_CreditoID;

			 UPDATE COMENTARIOSSOL SET
						Comentario		= CASE WHEN Par_ComentarioAlt = Cadena_Vacia THEN Comentario ELSE Par_ComentarioAlt END,
						Fecha			= IFNULL(CONCAT(DATE(Var_FechaSistema)," ",CURRENT_TIME), Fecha_Vacia),
						Usuario			= Var_ClaveUsuario
					WHERE SolicitudCreditoID = Par_SolicCredID
						AND Estatus = 'CI';

		-- FIN  ACTUALIZACION DE COMENTARIO PARA LA MESA DE CONTROL Y L MONITOR DE SOLICITUDES

		# ======================================= VALIDACIONES PARA UN CREDITO RENOVACION ===========================================
		IF(Par_TipoCredito = CreRenovacion) THEN
			SELECT Estatus,       PeriodicidadCap
			INTO Var_EstRelacionado,  Var_PeriodCap
			FROM CREDITOS WHERE CreditoID = Par_Relacionado;

			-- Revision de Estatus de Nacimiento
			SELECT  FUNCIONEXIGIBLE(Par_Relacionado) INTO Var_SaldoExigible;
			SET Var_SaldoExigible  := IFNULL(Var_SaldoExigible, Entero_Cero);

			IF (Var_SaldoExigible <= Entero_Cero) THEN
			  SET Var_EstatusCrea := Est_Vigente;
			ELSE
			  SET Var_EstatusCrea := Est_Vencido;
			END IF;

			-- Revision del Numero de Pagos Sostenidos para ser Regularizado.
			IF (Var_EstatusCrea = Est_Vencido) THEN
			  SET Var_NumPagoSostenido  = Num_PagRegula;
			END IF;


			-- Calculo de los Dias de Atraso
			SELECT  (DATEDIFF(Var_FechaSistema, IFNULL(MIN(FechaExigible), Var_FechaSistema)))
			INTO Var_NumDiasAtraOri
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Par_Relacionado
			  AND Amo.Estatus != Estatus_Pagado
			  AND Amo.FechaExigible <= Var_FechaSistema;

			-- Revision del Numero de Renovaciones sobre el Credito Original
			SELECT  NumeroReest
			INTO Var_NumRenovacion
			FROM REESTRUCCREDITO
			WHERE CreditoOrigenID = Par_Relacionado
			  AND EstatusReest = Est_Desembolso;
			SET Var_NumRenovacion := IFNULL(Var_NumRenovacion, Entero_Cero) + 1;

					SET Var_SalCredAnt :=FUNCIONTOTDEUDACRE(Par_Relacionado);



			CALL REESTRUCCREDITOMOD (
			  Var_FechaSistema,   Aud_Usuario,        Par_Relacionado,      Par_CreditoID,      Var_SalCredAnt,
			  Var_EstRelacionado, Var_EstatusCrea,    Var_NumDiasAtraOri,   Var_NumPagoSostenido,   Entero_Cero,
			  Constante_NO,       Fecha_Vacia,        Var_NumRenovacion,      Entero_Cero,      Entero_Cero,
			  Entero_Cero,    Entero_Cero,    OrigenRenovacion,   Constante_NO,         Par_NumErr,
			  Par_ErrMen,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			  Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion );

			IF (Par_NumErr != Entero_Cero) THEN
			  LEAVE ManejoErrores;
			END IF;
		END IF; -- Termina IF(Par_TipoCredito = CreRenovacion) THEN



		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := CONCAT('Credito  Modificado Exitosamente: ',Par_CreditoID,'.');
		SET Var_NomControl  := 'creditoID';

	END ManejoErrores;

	IF( Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
		Par_ErrMen    AS ErrMen,
		Var_NomControl  AS control;

	END IF;

END TerminaStore$$