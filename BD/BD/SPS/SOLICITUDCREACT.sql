-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREACT`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDCREACT`(
/* ========================================================================================================================
 * SP PARA LIBERAR, AUTORIZAR, RECHAZAR, CAMBIAR MONTO AUTORIZADO, RERESARA A EJECUTIVO, O AGREGAR COMENTARIO A LA SOLICTUD
 * ======================================================================================================================== */
	Par_SolicCredID         BIGINT(20),			-- Numero de Solicitud
	Par_MontoAutor          DECIMAL(18,2),		-- Monto autorizado
	Par_FechAutoriz         DATETIME,			-- Fecha de autorizacion
	Par_UsuarioAut          INT(11),			-- Usuario que autoriza
	Par_AporteCli           DECIMAL(18,2),		-- Aporte del cliente

	Par_ComentEjecutivo     VARCHAR(1500), 		-- Comentario del ejecutivo
	Par_ComentMesaControl   VARCHAR(800),		-- Comentario de la mesa de control
	Par_CadenaMotivo        VARCHAR(50),		-- Cadena motivoID Cancelacion/Devolucion
	Par_ComentMotivo        VARCHAR(1500),		-- Comentario del motivo Cancelacion/DEvolucion

	Par_NumAct              TINYINT UNSIGNED,	-- Numero de actualizacion
	Par_Salida              CHAR(1),
	INOUT Par_NumErr        INT(11),

	INOUT Par_ErrMen        VARCHAR(4000),
	/* Parametros de Auditoria */
	Par_EmpresaID           INT(11),			-- Auditoria
	Aud_Usuario             INT(11),			-- Auditoria
	Aud_FechaActual         DATETIME,			-- Auditoria
	Aud_DireccionIP         VARCHAR(15),		-- Auditoria

	Aud_ProgramaID          VARCHAR(50),  		-- Auditoria
	Aud_Sucursal            INT(11),			-- Auditoria
	Aud_NumTransaccion      BIGINT(20)			-- Auditoria
	)

TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Par_ComisAp             DECIMAL(18,2);
	DECLARE Par_IVAComisAp          DECIMAL(18,2);
	DECLARE Par_TasaFija            DECIMAL(18,4);
	DECLARE Par_MontoAuto           DECIMAL(18,4);
	DECLARE Var_MontoSolic          DECIMAL(18,4);
	DECLARE Var_MontoAut            DECIMAL(18,4);
	DECLARE Var_NumTrSim            BIGINT(20);
	DECLARE Var_FechaVenc           DATE;
	DECLARE Var_ProductoCreID       INT(11);
	DECLARE Par_NumTran				BIGINT(20);
	DECLARE Var_Cliente             INT(11);
	DECLARE Var_CheckComple         CHAR(1);
	DECLARE Var_EstatusSolicitud    CHAR(1);
	DECLARE Var_NumGrupo            INT(11);
	DECLARE Var_SucursalUsuario     INT(11);
	DECLARE Var_EstatusUsuario      CHAR(1);
	DECLARE Var_PuestoUsuario       VARCHAR(10);
	DECLARE Var_EstatusPuesto       CHAR(1);
	DECLARE Var_AtiendeSucursales   CHAR(1);
	DECLARE Var_CurSolicitud        BIGINT(20);
	DECLARE Var_CurSolEstatus       CHAR(1);
	DECLARE Var_ListaSolicitudes    VARCHAR(500);
	DECLARE Var_NombreUSuario       VARCHAR(500);
	DECLARE Var_MensajesError       VARCHAR(6000);
	DECLARE Var_SucursalSolici      BIGINT(20);
	DECLARE Var_MontoSeguro         DECIMAL(12,2);
	DECLARE Var_MontoGarLiq         DECIMAL(12,2);
	DECLARE Var_clienteID			INT(11);
	DECLARE	Var_ProspectoID			INT(11);
	DECLARE	Var_DatosCompletos		CHAR(1);
	DECLARE	Var_FechaInicio			DATE;
	DECLARE Var_FechaInicia			DATE; 			# Fecha de inicio utilizada para simulacion de amortizaciones
	DECLARE	Var_TipoPagCap			CHAR(1);
	DECLARE	Var_FrecCap				CHAR(1);
	DECLARE	Var_FrecInt				CHAR(1);
	DECLARE Var_PeriodCap			INT(11);
	DECLARE Var_PeriodInt			INT(11);
	DECLARE Var_DiaPagoInt			CHAR(1);
	DECLARE Var_DiaPagoCap			CHAR(1);
	DECLARE Var_DiaMesCap			INT(11);
	DECLARE Var_DiaMesInt			INT(11);
	DECLARE Var_NumCuotasCap		INT(11);
	DECLARE Var_NumCuotasInt		INT(11);
	DECLARE Var_FechaInhabil		CHAR(1);
	DECLARE Var_AjusFecUlVenAmo		CHAR(1);
	DECLARE Var_AjusFecExiVen		CHAR(1);
	DECLARE Var_CAT					DECIMAL(12,4);
	DECLARE Var_MontoCuota			DECIMAL(12,4);
	DECLARE Var_ReqSegVida      	CHAR(1);
	DECLARE NumDias           		INT(11);
	DECLARE Var_FactRiesSeg     	DECIMAL(14,6);
	DECLARE Var_PorcGarLiq			DECIMAL(14,2);
	DECLARE Var_FuncionHuella 		CHAR(1);
	DECLARE Var_ReqHuellaProductos	CHAR(1);
	DECLARE Var_EstadoCivil			CHAR(2);
	DECLARE Var_SolClienteID		INT(11);
	DECLARE Var_SolProspectoID		INT(11);
	DECLARE Var_FechaVencimiento	DATE;
	DECLARE Var_EstatusCli			CHAR(1);
	DECLARE Var_FechaInicioAmor		DATE;
	DECLARE Hora_Actual				TIME;
	DECLARE Var_Control         	VARCHAR(100);
    DECLARE Var_FechaLiberada		DATETIME;
    DECLARE Var_FechaActualizada	DATETIME;
    DECLARE ClaveUsuario			INT(11);
	DECLARE Var_ComentarioID		INT(11);
	DECLARE Var_NumRegistros		INT(11);
	DECLARE Var_RequiereCheckList	CHAR(1);
    DECLARE Var_EvaluaRiesgoComun	CHAR(1);
    DECLARE Var_CapitalContableNeto	DECIMAL(14,2);
    DECLARE Var_MontoCreditosRiesgo	DECIMAL(14,2);
    DECLARE Var_NumSolNoEvaluaron	INT(11);
    DECLARE Var_MsjRiesgo			VARCHAR(200);
    DECLARE Var_DiasReqPrimerAmor	INT(11);
    DECLARE Var_FecFinPrimerAmor	DATE;
	DECLARE Var_NumDiasVenPrimAmor  INT(11);
	DECLARE Var_Capital				DECIMAL(14,2);
	DECLARE Var_ValorReqPrimerAmor	CHAR(1);
    DECLARE Var_DetecNoDeseada		CHAR(1);		-- Valida la activacion del proceso de personas no deseadas S:Si N:No
    DECLARE Var_RFCOficial			CHAR(13);		-- RFC de la persona
    DECLARE Var_TipoPersona			CHAR(1);		-- Tipo de Persona Fisica, Fisica Act. Empresarial y Moral
	DECLARE Var_RequiereAnalisiCre  CHAR(1);        -- Valida si la solicitud requiere analisis de credito
	DECLARE Var_ProducCreditoID     INT(11);
	DECLARE Var_estatusDev          CHAR(1);        -- Estatus devolucion cancelada/rechazada
	DECLARE Var_LineaCredito        BIGINT(20);     -- Linea de Credito
	DECLARE Var_SaldoDisponible     DECIMAL(12,2);  -- Monto Disponible de la linea
	DECLARE Var_EstatusLinea        CHAR(1);
	DECLARE Var_PlazoID				INT(11);
	DECLARE Var_CobraAccesorios		CHAR(1);
	DECLARE Var_ValidaGrupo			CHAR(1);		-- Variable para almacenar si se valida el ciclo del grupo
	DECLARE Var_CiclosDistinto		INT(11);		-- Variable para almacenar si los integrantes del grupo tienen ciclos distintos
    DECLARE Var_datosConyuge		CHAR(1);		-- Variable para almacenar si son obligatirios los datos del conyuge
    DECLARE Var_obligaDatoConyuge	CHAR(1);

	#SEGUROS -------------------------------------------------------------------------------
	DECLARE Var_CobraSeguroCuota CHAR(1);			-- Cobra Seguro por cuota
	DECLARE Var_CobraIVASeguroCuota CHAR(1);		-- Cobra IVA seguro por cuota
	DECLARE Var_MontoSeguroCuota DECIMAL(12,2);		-- Cobra seguro por cuota el credito

	-- Servicios Adicionales
	DECLARE Var_AplicaDescServicio	CHAR(1);		-- Variable que indica si la solicitud de crédito tiene servicios adicionales
	DECLARE Var_Contador			INT(11);		-- Variable contador
	DECLARE Var_ServicioDesc		VARCHAR(100);	-- Variable para describir el servicio adicional
	DECLARE Var_ValidaDocs			CHAR(1);		-- Variable que indica si es necesario validar el documento para el servicio adicional
	DECLARE Var_DocDesc				VARCHAR(100);	-- Variable para describir el nombre del documento para validar el servicio adicional
	DECLARE Var_Adjuntado			CHAR(1);		-- Variable que indica si el archivo a validar ya se ha adjuntado


	# Declaracion de Constantes
	DECLARE Entero_Cero             INT(11);
	DECLARE Decimal_Cero            DECIMAL(12,2);
	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Fecha_Vacia             DATE;
	DECLARE EstatusAut              CHAR(1);
	DECLARE Sol_EstatusInactiva     CHAR(1);
	DECLARE Sol_EstatusLiberada     CHAR(1);
	DECLARE Sol_EstatusCancelada    CHAR(1);
	DECLARE Sol_EstatusRechazada	CHAR(1);
	DECLARE Sol_EstatusDevuelta 	CHAR(1);
	DECLARE Int_EstatusActivo       CHAR(1);
	DECLARE SalidaNO                CHAR(1);
	DECLARE SalidaSI                CHAR(1);
	DECLARE Str_SI                  CHAR(1);
	DECLARE Str_NO                  CHAR(1);
    DECLARE Cons_Si					CHAR(1);		-- Constante Si
	DECLARE Cons_No					CHAR(1);		-- Constante No
    DECLARE Per_Moral				CHAR(1);		-- Persona Moral
    DECLARE Per_Fisica				CHAR(1);		-- Persona Fisica
    DECLARE Per_Empre				CHAR(1);		-- Persona Fisica Act. Empresarial
	DECLARE RequiereAnalisis_SI     CHAR(1);        -- Requiere analisis S

	DECLARE Fecha_Sist              DATE;
	DECLARE TipoValiAltaCre         INT(11);
	DECLARE Var_Monto               DECIMAL(14,2);
	DECLARE TasFija                 INT(11);
	DECLARE PagCrecientes           CHAR(1);
	DECLARE PagIguales              CHAR(1);
	DECLARE TipValSoliciInd         INT(11);
	DECLARE TipValSoliciGru         INT(11);
	DECLARE Baj_PorSolicitud        INT(11);
	DECLARE Usu_StaActivo           CHAR(1);
	DECLARE Usu_PuestoVigente       CHAR(1);
	DECLARE Tip_RechazarInteg       INT(11);
	DECLARE TipoValiLiberaSol       INT(11);
	DECLARE ValiDatosSESolInd 		INT(11);
	DECLARE Act_Autoriza            INT(11);
	DECLARE Act_MontoAut            INT(11);
	DECLARE Act_RegresaEjecutivo    INT(11);
	DECLARE Act_RechazarSolicitud   INT(11);
	DECLARE Act_LiberarSolicitud    INT(11);
	DECLARE Act_LiberarGrupoSoli    INT(11);
	DECLARE Act_GuardaComentario    INT(11);
	DECLARE PagosCrecientes    		CHAR(1);
	DECLARE PagosIguales	   		CHAR(1);
	DECLARE PagosLibres	    		CHAR(1);
	DECLARE ReqSegVida_SI  			CHAR(1);
	DECLARE	EstCivCM				CHAR(2);
	DECLARE EstCivCC				CHAR(2);
	DECLARE EstCiVU					CHAR(2);
	DECLARE EstCivCS				CHAR(2);
	DECLARE Inactivo				CHAR(1);
	DECLARE Huella_SI				CHAR(1);
	DECLARE EstatusGuardado			CHAR(1);
	DECLARE EstatusProcesada		CHAR(1);
	DECLARE CreditoNuevo			CHAR(1);
	DECLARE	Var_Proyecto			VARCHAR(500);
	DECLARE	Var_Beneficiario		VARCHAR(200);
	DECLARE	Var_DireccionBe			VARCHAR(300);
	DECLARE	Var_TipoRelacion		INT;
	DECLARE Var_SeguroVida			CHAR(1);
	DECLARE Var_TipoCredito			CHAR(1);
	DECLARE PersonaCliente			CHAR(1);
	DECLARE Act_AutSolCreReest		INT(11);
    DECLARE EstLiberado				CHAR(2);
    DECLARE EstActualizado			CHAR(2);
    DECLARE EstAutorizado			CHAR(2);
    DECLARE EstRechazado			CHAR(2);
    DECLARE EstInactivo				CHAR(2);
    DECLARE Var_ProgramaRatios		VARCHAR(50);
    DECLARE Act_AutorizaSolCRCBWS	INT(11);
	DECLARE Act_LibGrupoSolCRCBWS   INT(11);
	DECLARE Act_LiberarSolCRCBWS	INT(11);
	DECLARE Var_CicloGrupo			INT(11);
	DECLARE Act_EstatusGarAsig		TINYINT;
	DECLARE DescValidaReqPrimerAmor	VARCHAR(50);
	DECLARE Por_Cliente             CHAR(1);
	DECLARE Por_Financiera          CHAR(1);
	DECLARE Var_ConvenioNomina		BIGINT UNSIGNED;	-- Convenio de nomina
	DECLARE Var_EsConsolidacionAgro CHAR(1);		-- Es consolidacion Agro
	DECLARE Var_FechaDesembolsoConAgro DATE;		-- Fecha de Desembolso de un credito consolidacion Agro
	DECLARE EstatusPagado       	CHAR(1);			-- Estatus para tabla real
	DECLARE Var_CreditoID       	BIGINT(12);		 	-- Variables para tabla real
	DECLARE Var_FechaIniAmor		DATE;
	DECLARE Var_ManejaCalendario	CHAR(1);
	DECLARE Var_MontoConsolida		DECIMAL(14,2);		-- Total monto consolidación
	DECLARE Est_Bloqueado	        CHAR(1);		    -- Indica si se encuentra bloqueada la linea \nB.- Bloqueada
	DECLARE EstLinea_Vencido 	    CHAR(1);		    -- Indica si se encuentra bloqueada la linea \nE.- Vencido
	DECLARE Entero_Uno				INT(11);			-- Constante: Entero uno



	# Declaracion de cursores
	DECLARE  CURLIBERASOL  CURSOR FOR
	SELECT  Inte.SolicitudCreditoID, Sol.Estatus AS SolEstatus,Sol.ClienteID,Sol.ProspectoID
	FROM INTEGRAGRUPOSCRE  Inte
	INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
	WHERE Inte.GrupoID = Var_NumGrupo
		AND Inte.Estatus = Int_EstatusActivo;


	# Asignacion de Constantes
	SET Entero_Cero             := 0;
	SET Decimal_Cero            := 0.0;
	SET Fecha_Vacia             := '1900-01-01';
	SET Cadena_Vacia            := '';
	SET EstatusAut              := 'A';
	SET Sol_EstatusInactiva     := 'I';
	SET Sol_EstatusLiberada     := 'L';
	SET Sol_EstatusCancelada    := 'C';
	SET Sol_EstatusRechazada    := 'R';
	SET Sol_EstatusDevuelta     := 'B';
	SET Int_EstatusActivo       := 'A';
	SET SalidaSI                := 'S';
	SET SalidaNO                := 'N';
	SET Str_SI                  := 'S';
	SET Str_NO                  := 'N';
    SET Cons_No					:= 'N';
    SET Cons_Si					:= 'S';
	SET Per_Moral				:= 'M';
	SET Per_Fisica				:= 'F';
	SET Per_Empre				:= 'A';
	SET TipoValiAltaCre         := 1;
	SET TasFija                 := 1;
	SET PagCrecientes           := 'C';
	SET PagIguales              := 'I';
	SET TipValSoliciInd         := 1;
	SET TipValSoliciGru         := 2;
	SET Baj_PorSolicitud        := 1;
	SET Usu_StaActivo           := 'A';
	SET Usu_PuestoVigente       := 'V';
	SET Tip_RechazarInteg       := 1;
	SET TipoValiLiberaSol       := 4;
	SET ValiDatosSESolInd		:= 1;
	SET Act_Autoriza            := 1;
	SET Act_MontoAut            := 2;
	SET Act_RegresaEjecutivo    := 3;
	SET Act_RechazarSolicitud   := 4;
	SET Act_LiberarSolicitud    := 5;
	SET Act_LiberarGrupoSoli    := 6;
	SET Act_GuardaComentario    := 7;
	SET Act_AutSolCreReest		:= 8;
	SET PagosCrecientes    		:= 'C';
	SET PagosIguales	   		:= 'I';
	SET PagosLibres		   		:= 'L';
	SET ReqSegVida_SI  			:= 'S';
	SET EstCivCM				:= 'CM';
	SET EstCivCC				:= 'CC';
	SET EstCiVU					:= 'U';
	SET EstCivCS				:= 'CS';
	SET Fecha_Sist				:=  (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Hora_Actual				:=  CURTIME();
	SET Inactivo				:='I';
	SET Huella_SI				:="S";
	SET EstatusGuardado			:='G';
	SET EstatusProcesada		:='P';
	SET CreditoNuevo			:= 'N'; -- La solicitud de credito es para un credito nuevo
	SET PersonaCliente			:= 'C';
    SET EstInactivo				:= 'SI';
    SET EstLiberado				:= 'SL';
    SET EstActualizado			:= 'SM';
    SET EstAutorizado			:= 'SA';
    SET EstRechazado			:= 'SR';
    SET Var_ProgramaRatios		:= '/microfin/generacionRatios.htm';
	SET	Act_AutorizaSolCRCBWS	:= 9;			    -- Tipo Actualizacion: Autorizacion de Solicitud de Credito	CREDICLUB WS
	SET Act_LibGrupoSolCRCBWS   := 10;  		-- Liberar Solicitud de Credito Grupal WS CREDICLUB
    SET Act_LiberarSolCRCBWS	:= 11;			-- LIBERA SOLICITUD DE CREDITOS IND WS CRCB
    SET Act_EstatusGarAsig		:= 1;			-- Actualiza el estatus de la garantia asignada
    SET DescValidaReqPrimerAmor	:= 'ValidaReqPrimerAmor';
	SET RequiereAnalisis_SI		:= 'S';
	SET Por_Cliente             := 'C';
	SET Por_Financiera          := 'F';
	SET EstatusPagado       	:= 'P';		    -- Estatus de Pagado
	SET Est_Bloqueado           := 'B';
	SET EstLinea_Vencido        := 'E';
	SET Entero_Uno				:= 1;
    SET Var_obligaDatoConyuge	:= 'S';



	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREACT');
				SET Var_Control:= 'SQLEXCEPTION';
			END;
		# Inicializacion de Variables
		SET Var_Proyecto		:=	(SELECT Proyecto FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicCredID);

		SET	Var_Beneficiario	:=	(SELECT Beneficiario FROM SOLICITUDCREDITO sol
										INNER JOIN SEGUROVIDA seg
										ON sol.SolicitudCreditoID = seg.SolicitudCreditoID
										WHERE sol.SolicitudCreditoID = Par_SolicCredID);

		SET	Var_DireccionBe		:=	(SELECT DireccionBen FROM SOLICITUDCREDITO sol
										INNER JOIN SEGUROVIDA seg
										ON sol.SolicitudCreditoID = seg.SolicitudCreditoID
										WHERE sol.SolicitudCreditoID = Par_SolicCredID);

		SET	Var_TipoRelacion	:=	(SELECT TipoRelacionID FROM SOLICITUDCREDITO sol
										INNER JOIN SEGUROVIDA seg
										ON sol.SolicitudCreditoID = seg.SolicitudCreditoID
										WHERE sol.SolicitudCreditoID = Par_SolicCredID);

		SET	Var_SeguroVida		:=	(SELECT ReqSeguroVida FROM PRODUCTOSCREDITO
										INNER JOIN SOLICITUDCREDITO
										ON ProducCreditoID = ProductoCreditoID
										WHERE SolicitudCreditoID = Par_SolicCredID);

		SET Var_TipoCredito		:= (SELECT TipoCredito FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicCredID);
        
        SET Var_datosConyuge	:= (SELECT pc.ValidaConyuge FROM PRODUCTOSCREDITO pc INNER JOIN SOLICITUDCREDITO sol ON sol.ProductoCreditoID = pc.ProducCreditoID WHERE sol.SolicitudCreditoID = Par_SolicCredID);

		SELECT 	Sol.MontoSolici,     	Sol.Estatus, 			Sol.MontoAutorizado, 	Gru.GrupoID,	 		Sol.SucursalID,
				Sol.NumTransacSim,   	Sol.FechaInicio,		Sol.TipoPagoCapital,	Sol.FrecuenciaCap,      Sol.FrecuenciaInt,
				Sol.PeriodicidadCap,	Sol.PeriodicidadInt,	Sol.DiaPagoInteres,		Sol.DiaPagoCapital, 	Sol.DiaMesCapital,
				Sol.DiaMesInteres,		Sol.NumAmortizacion,	Sol.NumAmortInteres,	Sol.ProductoCreditoID,  Sol.ClienteID,
				Sol.FechaInhabil, 		Sol.AjusFecUlVenAmo,	Sol.AjusFecExiVen,		Sol.MontoPorComAper,    Sol.TasaFija,
				Pro.ReqSeguroVida,		Pro.FactorRiesgoSeguro,	Sol.FechaVencimiento,	Sol.FechaInicioAmor	,	Sol.CobraSeguroCuota,
				Sol.CobraIVASeguroCuota,	Sol.MontoSeguroCuota,	Sol.FechaLiberada,	Sol.FechaActualizada,	Sol.ValorCAT,
                Sol.MontoCuota,				Sol.ConvenioNominaID,	Sol.EsConsolidacionAgro,	Sol.PlazoID,	Sol.CobraAccesorios
		INTO	Var_MontoSolic, 			Var_EstatusSolicitud, 	Var_MontoAut,			Var_NumGrupo, 			Var_SucursalSolici,
				Var_NumTrSim,   			Var_FechaInicio,		Var_TipoPagCap,			Var_FrecCap,            Var_FrecInt,
				Var_PeriodCap,				Var_PeriodInt,			Var_DiaPagoInt, 		Var_DiaPagoCap,         Var_DiaMesCap,
				Var_DiaMesInt,				Var_NumCuotasCap,		Var_NumCuotasInt,		Var_ProductoCreID,      Var_clienteID,
				Var_FechaInhabil,			Var_AjusFecUlVenAmo,	Var_AjusFecExiVen,		Par_ComisAp,            Par_TasaFija,
				Var_ReqSegVida,				Var_FactRiesSeg,		Var_FechaVencimiento,	Var_FechaInicioAmor,	Var_CobraSeguroCuota,
				Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Var_FechaLiberada,		Var_FechaActualizada,	Var_CAT,
                Var_MontoCuota,				Var_ConvenioNomina,		Var_EsConsolidacionAgro, Var_PlazoID,		Var_CobraAccesorios
		FROM 	SOLICITUDCREDITO Sol
			LEFT JOIN INTEGRAGRUPOSCRE Gru ON Sol.SolicitudCreditoID = Gru.SolicitudCreditoID
			INNER JOIN PRODUCTOSCREDITO Pro ON Pro.ProducCreditoID = Sol.ProductoCreditoID
		WHERE Sol.SolicitudCreditoID = Par_SolicCredID;

		SELECT	Usu.NombreCompleto,	Usu.SucursalUSuario, Usu.Estatus,    		Pue.ClavePuestoID,		Pue.Estatus,
				Pue.AtiendeSuc, Usu.UsuarioID
		INTO 	Var_NombreUSuario, 	Var_SucursalUsuario, Var_EstatusUsuario, 	Var_PuestoUsuario, 		Var_EstatusPuesto,
				Var_AtiendeSucursales, ClaveUsuario
		FROM USUARIOS Usu
			LEFT JOIN PUESTOS Pue ON Pue.ClavePuestoID = Usu.ClavePuestoID
		WHERE Usu.UsuarioID = Aud_Usuario;

		SELECT 	FuncionHuella,		ReqHuellaProductos,		EvaluaRiesgoComun, CapitalContableNeto
		INTO 	Var_FuncionHuella,	Var_ReqHuellaProductos,	Var_EvaluaRiesgoComun, Var_CapitalContableNeto
		FROM PARAMETROSSIS;

		SET Var_MontoSolic          := IFNULL(Var_MontoSolic, Decimal_Cero);
		SET Var_MontoAut            := IFNULL(Var_MontoAut, Decimal_Cero);
		SET Var_EstatusSolicitud    := IFNULL(Var_EstatusSolicitud, Cadena_Vacia);
		SET Var_NumGrupo            := IFNULL(Var_NumGrupo, Entero_Cero);
		SET Par_ComentMesaControl   := IFNULL(Par_ComentMesaControl, Cadena_Vacia);
		SET Par_ComentEjecutivo     := IFNULL(Par_ComentEjecutivo, Cadena_Vacia);
		SET Var_NombreUSuario     	:= IFNULL(Var_NombreUSuario, Cadena_Vacia);
		SET Var_MensajesError       := IFNULL(Var_MensajesError, Cadena_Vacia);
		SET Var_NumTrSim            := IFNULL(Var_NumTrSim, Entero_Cero);
		SET Par_ComisAp             := Entero_Cero;
		SET Par_IVAComisAp          := Entero_Cero;
		SET Par_TasaFija            := IFNULL(Par_TasaFija, Entero_Cero);
		SET Par_MontoAuto           := Entero_Cero;
		SET Var_MontoSeguro         := Entero_Cero;
		SET Var_MontoGarLiq         := Entero_Cero;
		SET Aud_FechaActual			:= NOW();
		SET Var_CobraSeguroCuota 	:= IFNULL(Var_CobraSeguroCuota, 'N');
		SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota, 'N');
		SET Var_MontoSeguroCuota 	:= IFNULL(Var_MontoSeguroCuota, Entero_Cero);
        SET Var_FechaLiberada       := IFNULL(Fecha_Sist, Fecha_Vacia);
        SET Var_FechaActualizada    := IFNULL(Fecha_Sist, Fecha_Vacia);
        SET Var_ConvenioNomina    := IFNULL(Var_ConvenioNomina, Entero_Cero);
        SET Var_FechaDesembolsoConAgro := Var_FechaInicio;
        SET Var_EsConsolidacionAgro	:= IFNULL(Var_EsConsolidacionAgro, 'N');

		IF(Var_FuncionHuella = Huella_SI AND Var_ReqHuellaProductos=Huella_SI) THEN
			IF NOT EXISTS ( SELECT * FROM HUELLADIGITAL Hue WHERE Hue.TipoPersona = PersonaCliente AND Hue.PersonaID=Var_clienteID ) THEN
				SET Par_NumErr := 100;
				SET Par_ErrMen := CONCAT('El Cliente no tiene Huella Registrada.');
				SET Var_Control:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		# ===========================================================================================================================
		# 1.- ==================================== AUTORIZACION DE SOLICITUD DE CREDITO =============================================
		IF(Par_NumAct = Act_Autoriza) THEN
        SET Var_DetecNoDeseada := IFNULL((SELECT  PersonNoDeseadas FROM PARAMETROSSIS LIMIT 1),Cons_No);
        IF(Var_DetecNoDeseada = Cons_Si) THEN
        -- INICIO VALIDACIÓN DE PERSONAS NO DESEADAS
        	SELECT	Cli.TipoPersona
			INTO	Var_TipoPersona
			FROM	CLIENTES Cli,
					SUCURSALES Suc
			WHERE 	Cli.ClienteID 	= Var_ClienteID
            AND		Suc.SucursalID 	= Cli.SucursalOrigen;

			IF(Var_TipoPersona = Per_Moral) THEN
				SELECT 	Cli.RFCpm
				INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
				WHERE 	Cli.ClienteID 	= Var_ClienteID
				AND		Suc.SucursalID 	= Cli.SucursalOrigen;
			END IF;

			IF(Var_TipoPersona = Per_Fisica OR Var_TipoPersona = Per_Empre ) THEN
				SELECT 	Cli.RFC
				INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
				WHERE 	Cli.ClienteID 	= Var_ClienteID
				AND		Suc.SucursalID 	= Cli.SucursalOrigen;
			END IF;

			CALL PLDDETECPERSNODESEADASPRO(
				Var_ClienteID,	Var_RFCOficial,	Var_TipoPersona,	SalidaNO,	Par_NumErr,
                Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,	Aud_FechaActual,
                Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr			:= 050;
				SET Par_ErrMen			:= Par_ErrMen;
				LEAVE ManejoErrores;
			END IF;
		END IF;

        -- FIN VALIDACIÓN DE PERSONAS NO DESEADAS

			CALL VALIDAPRODCREDPRO (
				Entero_Cero,    Par_SolicCredID,    TipoValiAltaCre,    SalidaNO,           Par_NumErr,
				Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

             -- Se obtiene el valor Requiere CheckList del Producto de la Solicitud de Credito
			SELECT 	Pro.RequiereCheckList
			INTO 	Var_RequiereCheckList
			FROM PRODUCTOSCREDITO Pro,
				 SOLICITUDCREDITO Sol
			WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
			AND Sol.solicitudCreditoID = Par_SolicCredID;

             -- Se valida SI Requiere CheckList la Solicitud de Credito
			IF (Var_RequiereCheckList = Str_SI)THEN
				CALL SOLICIDOCENTVAL(
					Par_SolicCredID,   Entero_Cero,    	TipValSoliciInd,    Var_CheckComple,    SalidaNO,
					Par_NumErr,        Par_ErrMen,     	Par_EmpresaID,      Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,   Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero ) THEN
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;

				IF (Var_CheckComple = Str_NO) THEN
					SET Par_NumErr := 101;
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_MontoAutor, Decimal_Cero)= Decimal_Cero) THEN
				SET Par_NumErr := 102;
				SET Par_ErrMen := CONCAT('El Monto de la Solicitud de Credito esta Vacio.');
				SET Var_Control:= 'montoSolici';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_MontoSolic < Par_MontoAutor) THEN
				SET Par_NumErr := 103;
				SET Par_ErrMen := CONCAT('El Monto a Autorizar No Debe ser Mayor al Monto Solicitado.');
				SET Var_Control:= 'montoAutorizado';
				LEAVE ManejoErrores;
			END IF;

            -- Se obtiene el valor si requiere validar los dias requeridos para la primera amortizacion en Tipo Pago Capital LIBRES
            SELECT ValorParametro
            INTO Var_ValorReqPrimerAmor
            FROM PARAMGENERALES
            WHERE LlaveParametro = DescValidaReqPrimerAmor;

            -- SE VALIDA SI SE ENCUENTRA REGISTRADO LOS DIAS REQUERIDOS DE SOLICITUDES DE PAGOS DE CAPITAL LIBRES
			IF(Var_TipoPagCap = PagosLibres AND Var_ValorReqPrimerAmor = Str_SI)THEN
				-- SE OBTIENE LOS DIAS REQUERIDO EN LA PRIMERA AMORTIZACION
				SELECT 	DiasReqPrimerAmor
				INTO 	Var_DiasReqPrimerAmor
				FROM CALENDARIOPROD
				WHERE ProductoCreditoID = Var_ProductoCreID;

				SET Var_DiasReqPrimerAmor   := IFNULL(Var_DiasReqPrimerAmor, Entero_Cero);

				-- SE OBTIENE LA FECHA DE VENCIMIENTO DE LA PRIMERA AMORTIZACION
				SET Var_FecFinPrimerAmor := (SELECT MIN(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE NumTransaccion = Var_NumTrSim);

				-- SE OBTIENE LA DIFERENCIA ENTRE LA FECHA DE VENCIMIENTO DE LA PRIMERA AMORTIZACION Y LA FECHA DEL SISTEMA
				SET Var_NumDiasVenPrimAmor := (SELECT DATEDIFF(Var_FecFinPrimerAmor,Fecha_Sist));
				SET Var_NumDiasVenPrimAmor  := IFNULL(Var_NumDiasVenPrimAmor, Entero_Cero);

				IF(Var_DiasReqPrimerAmor = Entero_Cero)THEN
					SET Par_NumErr := 104;
					SET Par_ErrMen := CONCAT('La Solicitud Tiene Pagos de Capital Libre, <br>los Dias Requeridos para la Primera Amortizacion No se encuentra Registrada.');
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

						-- Se valida si existe linea de credito y evalua el monto disponible del mismo para solicitudes agropecuarias
			SELECT 	IFNULL(Sol.LineaCreditoID,Entero_Cero),Lin.SaldoDisponible, Lin.Estatus
			INTO Var_LineaCredito , Var_SaldoDisponible, Var_EstatusLinea
			FROM SOLICITUDCREDITO Sol  INNER JOIN
					LINEASCREDITO Lin  ON Sol.LineaCreditoID = Lin.LineaCreditoID
			WHERE Sol.EsAgropecuario = 'S'
			AND   Sol.SolicitudCreditoID = Par_SolicCredID;

	    	IF( Var_EstatusLinea IN (Est_Bloqueado, EstLinea_Vencido)) THEN
				SET Par_NumErr	:= 114;
				SET Par_ErrMen	:= 'La Linea de Credito Agro se encuentra Bloqueada/Vencida.';
				SET Var_Control	:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_LineaCredito<>Entero_Cero) THEN
				IF(Var_SaldoDisponible<=Decimal_Cero) THEN
					SET Par_NumErr := 108;
					SET Par_ErrMen := CONCAT('Saldo Insuficiente de la Linea de Credito');
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;
				IF(Var_SaldoDisponible<Par_MontoAutor) THEN
					SET Par_NumErr := 108;
					SET Par_ErrMen := CONCAT('El Monto Autorizado Excede el Monto Disponible de la Linea de Credito');
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF( (Var_FechaInicio <> Fecha_Sist) || (Var_MontoSolic != Par_MontoAutor)) THEN
					IF(Var_FechaInicioAmor < Fecha_Sist)THEN
						SET Var_FechaInicia	:= Fecha_Sist;
					ELSE
						SET Var_FechaInicia	:= Var_FechaInicioAmor;
					END IF;

					 CALL RECALAUTOSOLCREPRO(
						Par_SolicCredID,    Par_MontoAutor,     Var_SucursalSolici,	SalidaNO,           Par_NumErr,
						Par_ErrMen,         Par_ComisAp,        Par_IVAComisAp,     Par_TasaFija,       Var_MontoSeguro,
						Var_MontoGarLiq,	Par_MontoAuto,      Var_PorcGarLiq,		Par_EmpresaID,      Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero ) THEN
						SET Var_Control:= 'solicitudCreditoID';
						LEAVE ManejoErrores;
					END IF;



					IF IFNULL(Var_CobraAccesorios,'N') = 'S' THEN
						CALL DETALLEACCESORIOSALT(
							Entero_Cero,			Par_SolicCredID,		Var_ProductoCreID,		Var_ClienteID,
	   						Aud_NumTransaccion,		Var_PlazoID,			1,						Par_MontoAutor,
	   						Var_ConvenioNomina,		SalidaNO,				Par_NumErr,				Par_ErrMen,
	   						Par_EmpresaID,      	Aud_Usuario,     		Aud_FechaActual,		Aud_DireccionIP,
	   						Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero ) THEN
							SET Var_Control:= 'solicitudCreditoID';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					CASE Var_TipoPagCap
						WHEN PagosCrecientes THEN
								CALL CREPAGCRECAMORPRO(
									Var_ConvenioNomina,
									Par_MontoAutor,			Par_TasaFija,				Var_PeriodCap,			Var_FrecCap,		Var_DiaPagoCap,
									Var_DiaMesCap,			Var_FechaInicia,			Var_NumCuotasCap,		Var_ProductoCreID,	Var_clienteID,
									Var_FechaInhabil,		Var_AjusFecUlVenAmo,		Var_AjusFecExiVen,		Par_ComisAp,		Par_AporteCli,
									Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Entero_Cero,		SalidaNO,
                                    Par_NumErr,				Par_ErrMen,					Par_NumTran,			Var_NumCuotasCap,	Var_CAT,
                                    Var_MontoCuota,			Var_FechaVenc,				Par_EmpresaID,      	Aud_Usuario,     	Aud_FechaActual,
                                    Aud_DireccionIP,    	Aud_ProgramaID,     		Aud_Sucursal,       	Aud_NumTransaccion);
								SET Var_NumCuotasInt := Var_NumCuotasCap;

						WHEN PagosIguales	THEN
								CALL PRINCIPALSIMPAGIGUAPRO(
									Var_ConvenioNomina,
									Par_MontoAutor,			Par_TasaFija,				Var_PeriodCap,			Var_PeriodInt,		Var_FrecCap,
									Var_FrecInt,			Var_DiaPagoCap,				Var_DiaPagoInt, 		Var_FechaInicia,	Var_NumCuotasCap,
									Var_NumCuotasInt,		Var_ProductoCreID,			Var_clienteID,			Var_FechaInhabil,	Var_AjusFecUlVenAmo,
									Var_AjusFecExiVen,		Var_DiaMesInt,				Var_DiaMesCap,			Par_ComisAp,		Par_AporteCli,
									Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Entero_Cero,		SalidaNO,
                                    Par_NumErr,				Par_ErrMen,					Par_NumTran,			Var_NumCuotasCap,	Var_NumCuotasInt,
                                    Var_CAT,				Var_MontoCuota,				Var_FechaVenc,			Par_EmpresaID,		Aud_Usuario,
                                    Aud_FechaActual,    	Aud_DireccionIP,			Aud_ProgramaID,     	Aud_Sucursal, 		Aud_NumTransaccion);

						WHEN PagosLibres THEN
                            -- SE REALIZAN VALIDACIONES DE SOLICITUDES DE PAGOS DE CAPITAL LIBRES
							IF (Var_MontoSolic != Par_MontoAutor) THEN
								SET Par_NumErr 	:= 105;
								SET Par_ErrMen 	:= CONCAT('La Solicitud Tiene Pagos de Capital Libre, <br>el Monto a Autorizar No puede ser Diferente del Solicitado: ',
												 CONVERT(Par_SolicCredID, CHAR(20)));
								SET Var_Control	:= 'solicitudCreditoID';
								LEAVE ManejoErrores;
							END IF;

                            IF(Var_ValorReqPrimerAmor = Str_NO)THEN
                            	SET Par_NumErr 	:= 106;
								SET Par_ErrMen 	:= CONCAT('La Solicitud tiene Pagos de Capital Libre, <br>La Fecha de Inicio no puede ser Diferente a la de Actual: ',
												 CONVERT(Par_SolicCredID, CHAR(20)));
								SET Var_Control	:= 'solicitudCreditoID';
								LEAVE ManejoErrores;
							END IF;

                            -- VALIDACIONES CUANDO SE REQUIERE VALIDAR LOS DIAS REQUERIDOS PARA LA PRIMERA AMORTIZACION EN TIPO DE PAGO DE CAPITAL LIBRES
                            IF(Var_ValorReqPrimerAmor = Str_SI)THEN

								IF(Fecha_Sist > Var_FecFinPrimerAmor)THEN
									SET Par_NumErr := 107;
									SET Par_ErrMen := 'La Solicitud Tiene Pagos de Capital Libre, <br>No es posible Autorizar la Solicitud de Credito, la Fecha del Sistema es mayor a la Fecha de Vencimiento de la Primera Amortizacion.';
									SET Var_Control:= 'solicitudCreditoID';
									LEAVE ManejoErrores;
								END IF;

                                IF(Var_DiasReqPrimerAmor > Entero_Cero)THEN
									IF(Var_NumDiasVenPrimAmor < Var_DiasReqPrimerAmor)THEN
										SET Par_NumErr := 107;
										SET Par_ErrMen := CONCAT('La Solicitud Tiene Pagos de Capital Libre, <br>los Dias Minimos Requeridos para la Primera Amortizacion son ',Var_DiasReqPrimerAmor, ' dias.');
										SET Var_Control:= 'solicitudCreditoID';
										LEAVE ManejoErrores;
									END IF;
								END IF;

								IF(Var_NumDiasVenPrimAmor >= Var_DiasReqPrimerAmor)THEN
									-- SE OBTIENE LA FECHA DE INICIO DE LA PRIMERA AMORTIZACION A LA FECHA DEL SISTEMA
									SET Var_FechaInicia	:= Fecha_Sist;

									-- SE OBTIENE LA FECHA DE VENCIMIENTO DE LA ULTIMA AMORTIZACION
									SET Var_FechaVenc := (SELECT MAX(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE NumTransaccion = Var_NumTrSim);

									-- SE ACTUALIZA LA FECHA DE INICIO DE LA PRIMERA AMORTIZACION A LA FECHA DEL SISTEMA
									UPDATE TMPPAGAMORSIM
									SET Tmp_FecIni = Fecha_Sist
									WHERE NumTransaccion = Var_NumTrSim
									AND Tmp_Consecutivo = 1;

									-- SE ACTUALIZA LOS NUMEROS DE DIAS DE LA PRIMERA AMORTIZACION
									UPDATE TMPPAGAMORSIM
									SET Tmp_Dias = DATEDIFF(Tmp_FecFin,Tmp_FecIni)
									WHERE NumTransaccion = Var_NumTrSim
									AND Tmp_Consecutivo = 1;

									-- SE OBTIENE LA SUMA DEL CAPITAL
									SELECT SUM(Tmp_Capital) INTO Var_Capital
									FROM TMPPAGAMORSIM
									WHERE NumTransaccion = Var_NumTrSim;

									-- SP PARA RECAULCULAR LAS AMORTIZACIONES EN PAGOS LIBRES
									CALL CRERECPAGLIBPRO(
										Var_Capital,			Par_TasaFija,				Var_ProductoCreID,		Var_clienteID,		Par_ComisAp,
										Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Decimal_Cero,		SalidaNO,
										Par_NumErr,				Par_ErrMen,					Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
										Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Var_NumTrSim);

									-- SE OBTIENE EL VALOR DEL CAT
									SELECT Tmp_Cat INTO Var_CAT
									FROM TMPPAGAMORSIM
									WHERE NumTransaccion = Var_NumTrSim
									AND Tmp_Consecutivo = 1;

									IF(Par_NumErr != Entero_Cero)THEN
										SET Var_Control	:= 'solicitudCreditoID';
										LEAVE ManejoErrores;
									END IF;
								END IF;
							END IF;

					END CASE ;

					SELECT		MIN(Tmp_FecIni)
						INTO	Var_FechaIniAmor
						FROM	TMPPAGAMORSIM
						WHERE	NumTransaccion = IF (Var_NumTrSim <> Entero_Cero, Var_NumTrSim, Par_NumTran);

					IF(Var_TipoPagCap != PagosLibres)THEN
						DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Var_NumTrSim;
						DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTran;
					END IF;

					 IF(IFNULL(Var_FechaVencimiento,Fecha_Vacia)  = Fecha_Vacia ) THEN
						SET Par_NumErr := 049;
						SET Par_ErrMen := 'La Fecha de Vencimiento esta Vacia.';
						SET Var_Control := 'fechaVencimien';
						LEAVE ManejoErrores;
					END IF;

					UPDATE SOLICITUDCREDITO SET
							FechaAutoriza       = CASE WHEN ( Var_EsConsolidacionAgro = Cons_Si ) THEN Var_FechaDesembolsoConAgro
													   ELSE Fecha_Sist END,
							FechaInicio         = CASE WHEN ( Var_EsConsolidacionAgro = Cons_Si ) THEN Var_FechaDesembolsoConAgro
													   ELSE Fecha_Sist END,
							FechaInicioAmor		= CASE WHEN ( Var_EsConsolidacionAgro = Cons_Si ) THEN Var_FechaDesembolsoConAgro
													   ELSE Var_FechaInicia END,
							NumAmortInteres		= Var_NumCuotasInt,
							NumAmortizacion 	= Var_NumCuotasCap,
							ValorCAT			= Var_CAT,
							MontoCuota			= Var_MontoCuota,
							MontoAutorizado     = Par_MontoAutor,
							UsuarioAutoriza     = Par_UsuarioAut,
							Estatus             = EstatusAut,
							ComentarioEjecutivo = CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
															THEN Cadena_Vacia
															ELSE
																  " "
															END,
											   "--> ", CAST( NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",  LTRIM(RTRIM(Par_ComentMesaControl)),
												" ", LTRIM(RTRIM(IFNULL(ComentarioEjecutivo, Cadena_Vacia)))  ),
							ComentarioMesaControl =  CASE WHEN Par_ComentMesaControl!=Cadena_Vacia
															THEN
																 CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Var_NombreUSuario," ----- ",
																 LTRIM(RTRIM(Par_ComentMesaControl)), " ",
																 LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
															ELSE
																 Cadena_Vacia
													END ,
							MontoPorComAper     = Par_ComisAp,
							IVAComAper          = Par_IVAComisAp,
							TasaFija            = Par_TasaFija,
							MontoSeguroVida     = Var_MontoSeguro,
							MontoSegOriginal    = ROUND(Var_MontoSeguro / (1 - (DescuentoSeguro / 100)), 2),
							AporteCliente       = Var_MontoGarLiq,
							PorcGarLiq			= Var_PorcGarLiq,

							EmpresaID           = Par_EmpresaID,
							Usuario             = Aud_Usuario,
							FechaActual         = Aud_FechaActual,
							DireccionIP         = Aud_DireccionIP,
							ProgramaID          = Aud_ProgramaID,
							Sucursal            = Aud_Sucursal,
							NumTransaccion      = Aud_NumTransaccion

					WHERE SolicitudCreditoID = Par_SolicCredID;

					-- Si esta ligada a un convenio de nomina y maneja calendario, se respeta la fecha pacta
					IF (Var_ConvenioNomina <> Entero_Cero) THEN

						SELECT		ManejaCalendario
							INTO	Var_ManejaCalendario
							FROM	CONVENIOSNOMINA
							WHERE	ConvenioNominaID = Var_ConvenioNomina;

						SET Var_ManejaCalendario	:= IFNULL(Var_ManejaCalendario, Str_NO);

						IF (Var_ManejaCalendario = Str_SI AND Var_FechaIniAmor <> Fecha_Vacia) THEN

							UPDATE SOLICITUDCREDITO SET
								FechaInicio		= Var_FechaIniAmor,
								FechaInicioAmor	= Var_FechaIniAmor
							WHERE SolicitudCreditoID = Par_SolicCredID;

						END IF;

					END IF;


			ELSE
					-- SE VALIDA SI EL TIPO DE PAGO DE CAPITAL ES LIBRE Y CUANDO SE REQUIERE VALIDAR LOS DIAS REQUERIDOS PARA LA PRIMERA AMORTIZACION
                    IF(Var_TipoPagCap = PagosLibres AND Var_ValorReqPrimerAmor = Str_SI)THEN
						-- SE VALIDA CUANDO LA FECHA DEL SISTEMA ES IGUAL A LA FECHA DE VENCIMIENTO DE LA PRIMERA AMORTIZACION
						IF(Fecha_Sist = Var_FecFinPrimerAmor)THEN
							SET Par_NumErr := 108;
							SET Par_ErrMen := 'La Solicitud Tiene Pagos de Capital Libre, <br>No es posible Autorizar la Solicitud de Credito, la Fecha de Vencimiento de la Primera Amortizacion es igual a la Fecha del Sistema.';
							SET Var_Control:= 'solicitudCreditoID';
							LEAVE ManejoErrores;
						END IF;
                    END IF;

					UPDATE SOLICITUDCREDITO SET
						FechaAutoriza       = CASE WHEN ( Var_EsConsolidacionAgro = Cons_Si ) THEN Var_FechaDesembolsoConAgro
												   ELSE Fecha_Sist END,
						FechaInicio         = CASE WHEN ( Var_EsConsolidacionAgro = Cons_Si ) THEN Var_FechaDesembolsoConAgro
												   ELSE Fecha_Sist END,
						MontoAutorizado     = Par_MontoAutor,
						UsuarioAutoriza     = Par_UsuarioAut,
						Estatus             = EstatusAut,
						ComentarioEjecutivo = CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
															THEN Cadena_Vacia
															ELSE
																  " "
															END,
											   "--> ", CAST( NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",  LTRIM(RTRIM(Par_ComentMesaControl)),
												" ", LTRIM(RTRIM(IFNULL(ComentarioEjecutivo, Cadena_Vacia)))  ),
						ComentarioMesaControl = CASE WHEN Par_ComentMesaControl!=Cadena_Vacia
															THEN
																 CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Var_NombreUSuario," ----- ",
																 LTRIM(RTRIM(Par_ComentMesaControl)), " ",
																 LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
															ELSE
																 Cadena_Vacia
													END ,

						EmpresaID           = Par_EmpresaID,
						Usuario             = Aud_Usuario,
						FechaActual         = Aud_FechaActual,
						DireccionIP         = Aud_DireccionIP,
						ProgramaID          = Aud_ProgramaID,
						Sucursal            = Aud_Sucursal,
						NumTransaccion      = Aud_NumTransaccion

					WHERE SolicitudCreditoID = Par_SolicCredID;

					-- Si esta ligada a un convenio de nomina y maneja calendario, se respeta la fecha pacta
					IF (Var_ConvenioNomina <> Entero_Cero) THEN

						SELECT		ManejaCalendario
							INTO	Var_ManejaCalendario
							FROM	CONVENIOSNOMINA
							WHERE	ConvenioNominaID = Var_ConvenioNomina;

						SET Var_ManejaCalendario	:= IFNULL(Var_ManejaCalendario, Str_NO);

						IF (Var_ManejaCalendario = Str_SI AND Var_FechaInicio <> Fecha_Vacia) THEN


							UPDATE SOLICITUDCREDITO SET
								FechaInicio		= Var_FechaInicio,
								FechaInicioAmor	= Var_FechaInicio
							WHERE SolicitudCreditoID = Par_SolicCredID;

						END IF;

					END IF;

			END IF; -- FIN IF( (Var_FechaInicio <> Fecha_Sist) || (Var_MontoSolic != Par_MontoAutor)) THEN

			# Actualizar estatus de la solicitud de credito

				CALL ESTATUSSOLCREDITOSALT(
				Par_SolicCredID,           Entero_Cero,          EstatusAut,       Cadena_Vacia,        Cadena_Vacia,
				SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,           Aud_Usuario,
				Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;


				CALL HISSOLICITUDESASIGNACIONESALT(
				Par_SolicCredID,           SalidaNO,             Par_NumErr,                Par_ErrMen,               Par_EmpresaID,
				Aud_Usuario,               Aud_FechaActual,      Aud_DireccionIP,           Aud_ProgramaID,           Aud_Sucursal,
				Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;


			SET Var_Monto:= (SELECT IFNULL(MontoAutorizado,Entero_Cero) FROM SOLICITUDCREDITO
								WHERE SOlicitudCreditoID = Par_SolicCredID);

			IF(Var_Monto != Entero_Cero) THEN

				CALL COMENTARIOSALT (
					Par_SolicCredID,	EstAutorizado,	Par_FechAutoriz,	Par_ComentMesaControl,	ClaveUsuario,
					SalidaNO,			Par_NumErr,		Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,   		Aud_NumTransaccion  );

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


				SET Par_NumErr := Entero_Cero;
				SET Par_ErrMen := CONCAT('La Solicitud de Credito: ',
											 CONVERT(Par_SolicCredID, CHAR(20)),' Fue Autorizada.');
			ELSE
				SET Par_NumErr := 105;
				SET Par_ErrMen := CONCAT('La Solicitud de Credito: ',
											 CONVERT(Par_SolicCredID, CHAR(20)),' NO Fue Autorizada.');
			END IF;

            SET Var_Control	:= 'solicitudCreditoID';
			LEAVE ManejoErrores;

		END IF;
		# ======================================== TERMINA AUTORIZACION DE SOLICITUD DE CREDITO =====================================
		# ===========================================================================================================================

		# ===========================================================================================================================
		# 2.- ==================================== AUTORIZACION DE MONTO DE SOLICITUD DE CREDITO ====================================
		IF (Par_NumAct = Act_MontoAut) THEN

			SET Par_NumErr := 100;
			SET Par_ErrMen := Cadena_Vacia;

			IF (Var_EstatusSolicitud <> Sol_EstatusLiberada) THEN
				SET Par_NumErr := 101;
				SET Par_ErrMen := CONCAT('La Solicitud No se Encuentra Liberada.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF (Var_MontoAut <> Entero_Cero AND Par_MontoAutor > Var_MontoAut) THEN
				SET Par_NumErr := 102;
				SET Par_ErrMen := CONCAT('No puede Incrementar el Monto Autorizado.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE SOLICITUDCREDITO
			SET MontoAutorizado = Par_MontoAutor,
				AporteCliente = Par_AporteCli,
				ComentarioMesaControl = CONCAT("--> ", CAST( NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",
				LTRIM(RTRIM(Par_ComentMesaControl))," ", LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia)))  )
			WHERE SolicitudCreditoID = Par_SolicCredID;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('Monto Autorizado Actualizado con Exito.');
			SET Var_Control:= 'solicitudCreditoID';
			LEAVE ManejoErrores;

		END IF;
		# ======================================== TERMINA AUTORIZACION DE MONTO SOLICITUD DE CREDITO ===============================
		# ===========================================================================================================================

		# ===========================================================================================================================
		# 3.- ==================================== REGRESAR SOLICITUD DE CREDITO A EJECUTIVO ========================================
		IF (Par_NumAct = Act_RegresaEjecutivo) THEN
			SET Par_NumErr  := 100;
			SET Par_ErrMen	:= Cadena_Vacia;

			IF (Var_EstatusSolicitud <> Sol_EstatusLiberada AND Aud_ProgramaID != Var_ProgramaRatios) THEN
				SET Par_NumErr := 101;
				SET Par_ErrMen := CONCAT('La Solicitud No se Encuentra Liberada.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Par_ComentEjecutivo := IFNULL(Par_ComentEjecutivo, Cadena_Vacia);
			IF (CHAR_LENGTH(Par_ComentEjecutivo) <= Entero_Cero) THEN
				SET Par_NumErr := 102;
				SET Par_ErrMen := CONCAT('Los Comentarios estan Vacios.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;


			UPDATE SOLICITUDCREDITO
					SET Estatus             = Sol_EstatusInactiva,
						MontoAutorizado     = Decimal_Cero,
						AporteCliente   	= Par_AporteCli,
                        FechaActualizada	= Var_FechaActualizada,
                        FechaLiberada		= Fecha_Vacia,
						MotivoRechazoID     = Par_CadenaMotivo,
						ComentarioRechazo   = Par_ComentMotivo,
						ComentarioEjecutivo = CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
															THEN Cadena_Vacia
															ELSE
																  " "
															END,
											   "--> ", CAST( NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",  LTRIM(RTRIM(Par_ComentEjecutivo)),
												" ", LTRIM(RTRIM(IFNULL(ComentarioEjecutivo, Cadena_Vacia)))  )
			WHERE SolicitudCreditoID = Par_SolicCredID;

				# Actualizar estatus de la solicitud de credito
				CALL ESTATUSSOLCREDITOSALT(
				Par_SolicCredID,           Entero_Cero,          Sol_EstatusDevuelta,       Par_CadenaMotivo,        Par_ComentMotivo,
				SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,           Aud_Usuario,
				Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);


				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;

				CALL HISSOLICITUDESASIGNACIONESALT(
				Par_SolicCredID,           SalidaNO,             Par_NumErr,                Par_ErrMen,               Par_EmpresaID,
				Aud_Usuario,               Aud_FechaActual,      Aud_DireccionIP,           Aud_ProgramaID,           Aud_Sucursal,
				Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;

			CALL ESQUEMAAUTFIRMABAJ(Par_SolicCredID,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Baj_PorSolicitud,
									SalidaNO,               Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,
									Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				CALL COMENTARIOSALT (
					Par_SolicCredID,	EstActualizado,			Var_FechaActualizada, 	Par_ComentEjecutivo,	ClaveUsuario,
	                SalidaNO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
	                Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,   		Aud_NumTransaccion  );


				CALL ASIGNAGARANTIASACT(
					Par_SolicCredID, 	Entero_Cero, 			Act_EstatusGarAsig, 	SalidaNO,				Par_NumErr,
					Par_ErrMen, 		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual, 		Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion );

                IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			IF (Par_NumErr > Entero_Cero) THEN
				SET Par_NumErr := 103;
				SET Var_Control:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('La Solicitud Fue Enviada de Regreso al Ejecutivo con Exito.');
			SET Var_Control:= 'solicitudCreditoID';
			LEAVE ManejoErrores;

		END IF;
		# ======================================== TERMINA REGRESAR SOLICITUD DE CREDITO AL EJECUTIVO ===============================
		# ===========================================================================================================================

		# ===========================================================================================================================
		# 4.- ==================================== RECHAZAR SOLICITUD DE CREDITO  ===================================================
		IF (Par_NumAct = Act_RechazarSolicitud) THEN
			SET Par_NumErr  := 100;
			SET Par_ErrMen := Cadena_Vacia;

			IF Var_EstatusSolicitud NOT IN (Sol_EstatusLiberada, Sol_EstatusInactiva) THEN
				SET Par_NumErr := 101;
				SET Par_ErrMen := CONCAT('Solo Puede Rechazar Solicitudes Inactivas o Liberadas.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF (CHAR_LENGTH(Par_ComentEjecutivo) <= Entero_Cero) THEN
				SET Par_NumErr := 102;
				SET Par_ErrMen := CONCAT('Los Comentarios estan Vacios.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_EstatusUsuario, Cadena_Vacia) <> Usu_StaActivo) THEN
				SET Par_NumErr := 103;
				SET Par_ErrMen := CONCAT('El Usuario se Encuentra Inactivo.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_SucursalUsuario, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 104;
				SET Par_ErrMen := CONCAT('El Usuario No tiene una Sucursal Asignada.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_SucursalUsuario, Entero_Cero) <> Var_SucursalSolici AND Var_AtiendeSucursales = Str_SI) THEN
				SET Par_NumErr := 105;
				SET Par_ErrMen := CONCAT('No puede Rechazar Solicitudes de Otras Sucursales.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_PuestoUsuario, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr := 106;
				SET Par_ErrMen := CONCAT('El Usuario No tiene un Puesto Asignado.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_EstatusPuesto, Cadena_Vacia) <> Usu_PuestoVigente) THEN
				SET Par_NumErr := 107;
				SET Par_ErrMen := CONCAT('El Puesto del Usuario No se Encuentra Vigente.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Aud_FechaActual := NOW();
			UPDATE SOLICITUDCREDITO
			SET Estatus             = Sol_EstatusRechazada,
				MontoAutorizado     = Decimal_Cero,
				AporteCliente   	= Decimal_Cero,
				FechaRechazo		= CONCAT(Fecha_Sist,' ',Hora_Actual),
				UsuarioRechazo		= Aud_Usuario,
				ComentarioRech		= Par_ComentEjecutivo,
				MotivoRechazoID     = Par_CadenaMotivo,
				ComentarioRechazo   = Par_ComentMotivo,
				ComentarioEjecutivo = CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
													THEN Cadena_Vacia
												  ELSE " "
											  END,
										"---- RECHAZO DE LA SOLICITUD ----","--> ",CAST(FechaRechazo AS CHAR)," -- ",Var_NombreUSuario," ----- \n",
										LTRIM(RTRIM(Par_ComentEjecutivo)),"\n\n", LTRIM(RTRIM(IFNULL(ComentarioEjecutivo, Cadena_Vacia)))  ),
					FechaActual			= Aud_FechaActual
			WHERE SolicitudCreditoID = Par_SolicCredID;

				CALL COMENTARIOSALT (
				Par_SolicCredID,   	EstRechazado,		Fecha_Sist, 		Par_ComentEjecutivo,ClaveUsuario,
                SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion  );

                IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				# verifica si el tipo de CANCELACION es por parte de la financiera o del usuario
               SET Var_estatusDev:=(SELECT TipoPeticion from CATALOGOMOTRECHAZO where MotivoRechazoID=Par_CadenaMotivo limit 1);
			   SET Var_estatusDev:=(IFNULL(Var_estatusDev,Sol_EstatusRechazada));

			   IF(Var_estatusDev=Por_Financiera)THEN
			     SET  Var_estatusDev:=Sol_EstatusRechazada;
			   END IF;

			   IF(Var_estatusDev=Por_Cliente)THEN
			    SET Var_estatusDev:=Sol_EstatusCancelada;
			   END IF;

				# Actualizar estatus de la solicitud de credito
				CALL ESTATUSSOLCREDITOSALT(
				Par_SolicCredID,           Entero_Cero,          Var_estatusDev,            Par_CadenaMotivo,        Par_ComentMotivo,
				SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,           Aud_Usuario,
				Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;

				CALL HISSOLICITUDESASIGNACIONESALT(
				Par_SolicCredID,           SalidaNO,             Par_NumErr,                Par_ErrMen,               Par_EmpresaID,
				Aud_Usuario,               Aud_FechaActual,      Aud_DireccionIP,           Aud_ProgramaID,           Aud_Sucursal,
				Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;

			IF (Var_NumGrupo > Entero_Cero) THEN
				CALL INTEGRAGRUPOSACT ( Var_NumGrupo,    Par_SolicCredID,    Entero_Cero,    Entero_Cero,       Cadena_Vacia,
										Fecha_Vacia,     Entero_Cero,        Entero_Cero,    Tip_RechazarInteg, SalidaNO,
										Par_NumErr,      Par_ErrMen,         Par_EmpresaID,  Aud_Usuario,       Aud_FechaActual,
										Aud_DireccionIP, Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

				IF (Par_NumErr > Entero_Cero) THEN
					SET Par_NumErr := 108;
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('Solicitud Rechazada con Exito.');
			SET Var_Control:= 'solicitudCreditoID';
			LEAVE ManejoErrores;

		END IF;
		# ======================================== TERMINA RECHAZAR DE SOLICITUD DE CREDITO =========================================
		# ===========================================================================================================================

		# ===========================================================================================================================
		# 5.- ==================================== LIBERAR SOLICITUD DE CREDITO INDIV. ==============================================
		IF (Par_NumAct = Act_LiberarSolicitud) THEN
			SET Par_NumErr := 100;
			SET Par_ErrMen := Cadena_Vacia;
			SELECT IFNULL(Cli.Estatus,Cadena_Vacia) INTO Var_EstatusCli
				FROM CLIENTES Cli
					INNER JOIN SOLICITUDCREDITO Sol ON Sol.ClienteID = Cli.ClienteID
				WHERE solicitudCreditoID = Par_SolicCredID;
			IF(Var_EstatusCli = Inactivo) THEN
				SET Par_NumErr := 101;
				SET Par_ErrMen := CONCAT('El Cliente se Encuentra Inactivo.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_Proyecto, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr := 102;
				SET Par_ErrMen := CONCAT('El Proyecto esta Vacio.');
				SET Var_Control:= 'proyecto';
				LEAVE ManejoErrores;
			END IF;

			-- -------- VALIDA LOS CAMPOS DEL SEGURO DE VIDA  No aplica para solicitudes para creditos renovados o reestructurados -------
			IF(Var_SeguroVida = Str_SI AND Var_TipoCredito = CreditoNuevo) THEN
				IF (IFNULL(Var_Beneficiario, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr := 103;
					SET Par_ErrMen := CONCAT('El Beneficiario esta Vacio.');
					SET Var_Control:= 'beneficiario';
					LEAVE ManejoErrores;
				END IF;

				IF (IFNULL(Var_DireccionBe, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr := 104;
					SET Par_ErrMen := CONCAT('La Direccion del Beneficiario esta Vacia.');
					SET Var_Control:= 'direccionBe';
					LEAVE ManejoErrores;
				END IF;

				IF (IFNULL(Var_TipoRelacion, Entero_Cero) = Entero_Cero) THEN
					SET Par_NumErr := 105;
					SET Par_ErrMen := CONCAT('El Parentesco del Beneficiario esta Vacio.');
					SET Var_Control:= 'tipoRelacion';
					LEAVE ManejoErrores;
				END IF;

			END IF; -- Termina IF(Var_SeguroVida = Str_SI AND Var_TipoCredito = CreditoNuevo) THEN


			IF (Var_EstatusSolicitud <> Sol_EstatusInactiva) THEN
				SET Par_NumErr := 106;
				SET Par_ErrMen := CONCAT('La Solicitud Debe estar Inactiva para poder Liberarla.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;


			-- Otras validaciones sobre la solicitud de credito para poder ser liberada
            -- Se obtiene el valor Requiere CheckList del Producto de la Solicitud de Credito
            SELECT 	Pro.RequiereCheckList
            INTO 	Var_RequiereCheckList
            FROM PRODUCTOSCREDITO Pro,
				 SOLICITUDCREDITO Sol
			WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
			AND Sol.solicitudCreditoID = Par_SolicCredID;

            -- Se valida SI Requiere CheckList la Solicitud de Credito
            IF (Var_RequiereCheckList = Str_SI)THEN
				CALL SOLICIDOCENTVAL(
					Par_SolicCredID,   Entero_Cero,    	TipValSoliciInd,    Var_CheckComple,    SalidaNO,
					Par_NumErr,        Par_ErrMen,     	Par_EmpresaID,      Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,   Aud_ProgramaID, 	Aud_Sucursal,	   	Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero ) THEN
					SET Par_NumErr := 107;
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;

				IF (Var_CheckComple = Str_NO) THEN
					SET Par_NumErr := 108;
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (IFNULL(Par_ComentEjecutivo, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_ComentEjecutivo := 'SIN COMENTARIOS';
			END IF;

			-- Otras validaciones de acuerdo al producto de credito (avales, garantias)
			CALL VALIDAPRODCREDPRO (
				Entero_Cero,    Par_SolicCredID,    TipoValiLiberaSol,  SalidaNO,           Par_NumErr,
				Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero ) THEN
				SET Par_NumErr := 109;
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;


			SELECT ClienteID, ProspectoID  INTO Var_clienteID, Var_ProspectoID
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolicCredID;
			SET Var_clienteID		:= CASE WHEN IFNULL(Var_clienteID,Entero_Cero) = Entero_Cero THEN -1 ELSE Var_clienteID END;
			SET Var_ProspectoID		:= CASE WHEN Var_clienteID > Entero_Cero THEN -1 ELSE  IFNULL(Var_ProspectoID,Entero_Cero) END ;

			IF (Var_clienteID > Entero_Cero) THEN
						SET	Var_EstadoCivil	:= (SELECT EstadoCivil FROM CLIENTES WHERE  ClienteID = Var_clienteID );
					ELSE
						SET	Var_EstadoCivil	:= (SELECT EstadoCivil FROM PROSPECTOS WHERE  ProspectoID = Var_ProspectoID);
			END IF;
			SET Var_EstadoCivil:=IFNULL(Var_EstadoCivil,Cadena_Vacia);
			SET Var_EstadoCivil:=IFNULL(Var_EstadoCivil,Cadena_Vacia);


			IF(Var_EstadoCivil = EstCivCC OR Var_EstadoCivil = EstCivCM OR Var_EstadoCivil = EstCivU OR Var_EstadoCivil = EstCivCS) THEN
				IF (Var_datosConyuge = Var_obligaDatoConyuge) THEN
				   IF NOT EXISTS ( SELECT ClienteID
									FROM SOCIODEMOCONYUG WHERE  Var_clienteID = ClienteID  OR ProspectoID = Var_ProspectoID  ) THEN
						SET Par_NumErr := 110;
						SET Par_ErrMen := CONCAT('El ',
													CASE WHEN Var_clienteID > Entero_Cero
															THEN  CONCAT('Cliente ', CAST(Var_clienteID AS CHAR))
															ELSE  CONCAT('Prospecto ', CAST(Var_ProspectoID AS CHAR))
													END,' No Tiene Capturados Datos del C&oacute;nyuge.');
						SET Var_Control:= 'solicitudCreditoID';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF EXISTS(SELECT ProducCreditoID
					  FROM SOLICITUDCREDITO Sol
						INNER JOIN PRODUCTOSCREDITO Pro	ON Pro.ProducCreditoID = Sol.ProductoCreditoID
							AND CalculoRatios = Str_SI
							AND Sol.SolicitudCreditoID = Par_SolicCredID) THEN
					IF NOT EXISTS(SELECT SolicitudCreditoID
									FROM RATIOS WHERE SolicitudCreditoID = Par_SolicCredID AND Estatus = EstatusProcesada) THEN
						SET Par_NumErr := 111;
						SET Par_ErrMen := CONCAT('Es Necesario Realizar el Calculo de Ratios para la Solicitud: ',CONVERT(Par_SolicCredID, CHAR), '.');
						SET Var_Control:= 'solicitudCreditoID';
						LEAVE ManejoErrores;
					END IF;
			END IF;

	-- ===================== Validación si requiere documentos adjuntos de servicios adicionales
			SELECT AplicaDescServicio INTO Var_AplicaDescServicio
				FROM SOLICITUDCREDITO
				WHERE SolicitudCreditoID = Par_SolicCredID;

			IF Var_AplicaDescServicio = Str_SI THEN
				-- Obtener los Documentos que son requeridos y aun no se adjuntan
				SELECT 	sad.Descripcion,
						sad.ValidaDocs,
						tdo.Descripcion,
						CASE WHEN sar.DigSolID IS NULL
								THEN Str_NO
								ELSE Str_SI
						END AS Adjuntado
					INTO	Var_ServicioDesc,	Var_ValidaDocs,	Var_DocDesc,	Var_Adjuntado
				FROM SERVICIOSXSOLCRED  ssc
					INNER JOIN SERVICIOSADICIONALES sad on ssc.ServicioID = sad.ServicioID
						INNER JOIN TIPOSDOCUMENTOS as tdo on sad.TipoDocumento = tdo.TipoDocumentoID
							LEFT JOIN SOLICITUDARCHIVOS sar on ssc.SolicitudCreditoID = sar.SolicitudCreditoID
							AND tdo.TipoDocumentoID = sar.TipoDocumentoID
				WHERE sad.ValidaDocs 		= Str_SI
				  AND sar.DigSolID 			IS NULL  -- Sin adjuntar el documento
				  AND ssc.SolicitudCreditoID = Par_SolicCredID
				  LIMIT 1;

				-- Verificamos que este adjunto
				IF Var_Adjuntado = Str_NO THEN
					SET Par_NumErr := 112;
					SET Par_ErrMen := CONCAT('No se ha adjuntado el documento ', Var_DocDesc ,' requerido para validar el Servicios Adicional ', Var_ServicioDesc, '.');
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- validamos que el monto de la solicitud no sea menor al de la consolidación
			SELECT MontoConsolida INTO Var_MontoConsolida
			FROM CONSOLIDACIONCARTALIQ WHERE SolicitudCreditoID = Par_SolicCredID;

			IF(IFNULL(Var_MontoConsolida, Entero_Cero) > Var_MontoSolic) THEN
				SET Par_NumErr := 113;
				SET Par_ErrMen := 'El Monto de la Solicitud de Crédito no Puede ser Menor al Monto de las Cartas de Liquidación.';
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE SOLICITUDCREDITO
			SET Estatus             = Sol_EstatusLiberada,
				FechaLiberada		= Fecha_Sist,
				ComentarioEjecutivo = CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
													THEN Cadena_Vacia
													ELSE " " END,"--> ", CAST(NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",  LTRIM(RTRIM(Par_ComentEjecutivo)),
															" ", LTRIM(RTRIM(IFNULL(ComentarioEjecutivo, Cadena_Vacia)))  )
			WHERE SolicitudCreditoID = Par_SolicCredID;

				CALL COMENTARIOSALT (
				Par_SolicCredID,   	EstLiberado,	Fecha_Sist, 	Par_ComentEjecutivo,	ClaveUsuario,
                SalidaNO,			Par_NumErr,		Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,   		Aud_NumTransaccion  );

                IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


				# Actualizar estatus de la solicitud de credito
				CALL ESTATUSSOLCREDITOSALT(
				Par_SolicCredID,           Entero_Cero,          Sol_EstatusLiberada,       Cadena_Vacia,             Cadena_Vacia,
				SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,
				Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;

	-- =====================VALIDA SI SE REQUIERE ANALISIS DE CREDITO=======================

			SELECT 	Pro.RequiereAnalisiCre, Sol.TipoCredito
			INTO 	Var_RequiereAnalisiCre,Var_TipoCredito
			FROM PRODUCTOSCREDITO Pro,
				SOLICITUDCREDITO Sol
			WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
			AND Sol.solicitudCreditoID = Par_SolicCredID;

			IF(Var_RequiereAnalisiCre=RequiereAnalisis_SI) THEN
				CALL ASIGNACIONSOLICITUDESPRO (
										Par_SolicCredID,    Entero_Cero,            SalidaNO,			Par_NumErr,		    Par_ErrMen,			    Par_EmpresaID,	    Aud_Usuario,   	 Aud_FechaActual,
									    Aud_DireccionIP,    Aud_ProgramaID,		    Aud_Sucursal,   	Aud_NumTransaccion);
				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;
			END IF;

	-- =====================FIN DE VALIDAR SI SE REQUIERE ANALISIS DE CREDITO=======================

            -- INICIO VALIDACION ANALISIS RIESGO COMUN INDIVIDUAL

            IF(IFNULL(Var_EvaluaRiesgoComun,Cadena_Vacia) = Str_SI)THEN

				IF EXISTS(SELECT SolicitudCreditoID
							FROM RIESGOCOMUNCLICRE
							WHERE Procesado = Str_NO
								AND SolicitudCreditoID = Par_SolicCredID)THEN
					-- SOLO SE CONCATENA AL MENSAJE DE EXITO QUE NO NO SE REALIO EL PROCESO
					SET Par_NumErr := Entero_Cero;
					SET Par_ErrMen := CONCAT('Solicitud Liberada Exitosamente: ', CONVERT(Par_SolicCredID, CHAR), '. ',
												'No se realiz&oacute; el proceso de an&aacute;lisis de riesgo com&uacute;n para el solicitante.');
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;

				END IF;

            END IF;

            -- FIN VALIDACION ANALISIS RIESGO COMUN


			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('Solicitud Liberada Exitosamente: ', CONVERT(Par_SolicCredID, CHAR), '.');
			SET Var_Control:= 'solicitudCreditoID';
			LEAVE ManejoErrores;

		END IF;
		# ======================================== TERMINA LIBERAR DE SOLICITUD DE CREDITO INDIV ====================================
		# ===========================================================================================================================

		# ===========================================================================================================================
		# 6.- ==================================== LIBERAR SOLICITUD DE CREDITO GRUPAL===============================================
		IF Par_NumAct = Act_LiberarGrupoSoli THEN
			IF Var_NumGrupo = Entero_Cero THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := CONCAT("La Solicitud ",Par_SolicCredID," esta ligada a un grupo ",Var_NumGrupo," que no Existe");
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_ListaSolicitudes    := Cadena_Vacia;

			-- Obtenemos la bandera si valida el ciclo del grupo
			SET Var_ValidaGrupo		:= (SELECT ValidaCicloGrupo FROM PARAMETROSSIS);
			SET Var_ValidaGrupo		:= IFNULL(Var_ValidaGrupo, Cadena_Vacia);

			-- Si la bandera se encuentra encendida
			IF(Var_ValidaGrupo = Str_SI)THEN
				-- Obtenemos si los integrantes del grupo tienen ciclos distintos
				SELECT	COUNT(DISTINCT(Ciclo))
				INTO	Var_CiclosDistinto
				FROM INTEGRAGRUPOSCRE
				WHERE GrupoID = Var_NumGrupo;

				-- Validamos datos nulos
				SET Var_CiclosDistinto := IFNULL(Var_CiclosDistinto, Entero_Cero);

				-- Cuando la variable es mayor a uno quiere decir que dos o mas integrantes tienen ciclos distintos
				IF(Var_CiclosDistinto > Entero_Uno)THEN
					SET Par_NumErr := 002;
					SET Par_ErrMen := CONCAT("No es posible liberar las solicitudes, los integrantes del grupo no est&aacute;n en el mismo ciclo.");
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			OPEN CURLIBERASOL;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOCUR_SOLICI: LOOP
						FETCH CURLIBERASOL  INTO 	Var_CurSolicitud, Var_CurSolEstatus, Var_SolClienteID, Var_SolProspectoID;

                         -- Se obtiene el valor Requiere CheckList del Producto de la Solicitud de Credito
						SELECT 	Pro.RequiereCheckList
						INTO 	Var_RequiereCheckList
						FROM PRODUCTOSCREDITO Pro,
							 SOLICITUDCREDITO Sol
						WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
						AND Sol.solicitudCreditoID = Var_CurSolicitud;

                         -- Se valida SI Requiere CheckList la Solicitud de Credito
                         IF (Var_RequiereCheckList = Str_SI)THEN
							CALL SOLICIDOCENTVAL(
								Var_CurSolicitud,      Entero_Cero,        TipValSoliciInd,    	Var_CheckComple,    	SalidaNO,
								Par_NumErr,            Par_ErrMen,         Par_EmpresaID,      	Aud_Usuario,		    Aud_FechaActual,
								Aud_DireccionIP,       Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr <> Entero_Cero ) THEN
								SET Par_NumErr := 0;
								SET Var_MensajesError := CONCAT(Var_MensajesError,"<br>", Par_ErrMen);
								 ITERATE CICLOCUR_SOLICI;
							 END IF;

							IF Var_CheckComple = Str_NO THEN
								SET Par_NumErr := 0;
								SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);
								 ITERATE CICLOCUR_SOLICI;
							END IF;
						END IF;

						IF (Var_CurSolEstatus <> Sol_EstatusInactiva) THEN
							SET Par_NumErr := 0;
							SET Par_ErrMen := CONCAT("La Solicitud ",Var_CurSolicitud," no se encuentra Inactiva");
							SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);

							 ITERATE CICLOCUR_SOLICI;
						END IF;


						-- =====================VALIDA EL PROYECTO=======================
						 IF IFNULL(Var_Proyecto, Cadena_Vacia) = Cadena_Vacia THEN

						   SET Par_NumErr := 0;
						   SET Par_ErrMen := CONCAT("El Proyecto de la Solicitud ",Var_CurSolicitud," esta Vaci­o.");
						   SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);

							ITERATE CICLOCUR_SOLICI;
						END IF;


						-- ========= VALIDA LOS CAMPOS DEL SEGURO DE VIDA
						IF(Var_SeguroVida = 'S')THEN

							IF IFNULL(Var_Beneficiario, Cadena_Vacia) = Cadena_Vacia THEN

								SET Par_NumErr := 0;
								SET Par_ErrMen := CONCAT("El Beneficiario de la Solicitud ",Var_CurSolicitud," esta Vacio.");
								SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);

								ITERATE CICLOCUR_SOLICI;
							END IF;


							IF IFNULL(Var_DireccionBe, Cadena_Vacia) = Cadena_Vacia THEN

								SET Par_NumErr := 0;
								SET Par_ErrMen := CONCAT("La Direccion del Beneficiario de la Solicitud ",Var_CurSolicitud," esta Vacia.");
								SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);

								ITERATE CICLOCUR_SOLICI;
							END IF;


							IF IFNULL(Var_TipoRelacion, Entero_Cero) = Entero_Cero THEN

								SET Par_NumErr := 0;
								SET Par_ErrMen := CONCAT("El Parentesco de la Solicitud ",Var_CurSolicitud," esta Vacio.");
								SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);

								ITERATE CICLOCUR_SOLICI;
							END IF;
						END IF;
						-- ========================TERMINA VALIDACION DE SEGURO DE VIDA



						SET Var_SolClienteID		:= CASE WHEN IFNULL(Var_SolClienteID,Entero_Cero) = Entero_Cero THEN -1 ELSE Var_SolClienteID END;
						SET Var_SolProspectoID		:= CASE WHEN Var_SolClienteID > Entero_Cero THEN -1 ELSE  IFNULL(Var_SolProspectoID,Entero_Cero) END ;


						IF Var_SolClienteID > Entero_Cero THEN
							SET	Var_EstadoCivil	:= (SELECT EstadoCivil FROM CLIENTES WHERE  ClienteID = Var_SolClienteID );
						ELSE
							SET	Var_EstadoCivil	:= (SELECT EstadoCivil FROM PROSPECTOS WHERE  ProspectoID = Var_SolProspectoID);
						END IF;
						SET Var_EstadoCivil:=IFNULL(Var_EstadoCivil,Cadena_Vacia);


						IF(Var_EstadoCivil = EstCivCC OR Var_EstadoCivil = EstCivCM
							OR Var_EstadoCivil=EstCivU OR Var_EstadoCivil=EstCivCS) THEN
							IF NOT EXISTS ( SELECT 1
											FROM SOCIODEMOCONYUG
											WHERE  Var_SolClienteID = ClienteID  OR ProspectoID = Var_SolProspectoID  ) THEN
								SET Par_NumErr := 0;
								SET Par_ErrMen := CONCAT('El ',CASE WHEN Var_SolClienteID > 0 THEN
																	CONCAT("Cliente ",CAST(Var_SolClienteID AS CHAR))
																ELSE CONCAT("Prospecto ", CAST(Var_SolProspectoID AS CHAR))
																END,' no tiene capturados datos del C&oacute;nyuge');

								SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);
								ITERATE CICLOCUR_SOLICI;
							END IF;
						END IF;

						CALL VALIDAPRODCREDPRO (
							Entero_Cero,    Var_CurSolicitud,   TipoValiLiberaSol,  SalidaNO,           Par_NumErr,
							Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
							Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
						IF(Par_NumErr <> Entero_Cero ) THEN
							SET Par_NumErr := 1;
							SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);

							 ITERATE CICLOCUR_SOLICI;
						 END IF;

						IF EXISTS(SELECT ProducCreditoID
									FROM SOLICITUDCREDITO Sol
										INNER JOIN PRODUCTOSCREDITO Pro  	ON Pro.ProducCreditoID = Sol.ProductoCreditoID
										AND CalculoRatios = Str_SI
										AND Sol.SolicitudCreditoID = Var_CurSolicitud)THEN
									IF NOT EXISTS(SELECT SolicitudCreditoID
														FROM RATIOS WHERE SolicitudCreditoID = Var_CurSolicitud
															 AND Estatus = EstatusGuardado)THEN
												SET Par_NumErr := 0;
												SET Par_ErrMen := CONCAT('La Solicitud ',CONVERT(Var_CurSolicitud, CHAR),' no tiene Calculo de Ratios');

												SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);
												ITERATE CICLOCUR_SOLICI;
									END IF;
						END IF;

                        -- INICIO VALIDACION ANALISIS RIESGO COMUN   GRUPAL

						IF(IFNULL(Var_EvaluaRiesgoComun,Cadena_Vacia) = Str_SI)THEN

							IF EXISTS(SELECT SolicitudCreditoID
										FROM RIESGOCOMUNCLICRE
										WHERE Procesado = 'N'
											AND SolicitudCreditoID = Var_CurSolicitud)THEN

								SET Var_NumSolNoEvaluaron := IFNULL(Var_NumSolNoEvaluaron,Entero_Cero)+ 1;

							END IF;

						END IF;
						-- FIN VALIDACION ANALISIS RIESGO COMUN

						UPDATE SOLICITUDCREDITO
						SET Estatus             = Sol_EstatusLiberada
						WHERE SolicitudCreditoID = Var_CurSolicitud;

							# Actualizar estatus de la solicitud de credito
						CALL ESTATUSSOLCREDITOSALT(
						Var_CurSolicitud,          Entero_Cero,          Sol_EstatusLiberada,       Cadena_Vacia,             Cadena_Vacia,
						SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,
						Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

						IF(Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
						END IF;

	                -- =====================VALIDA SI SE REQUIERE ANALISIS DE CREDITO=======================

						SELECT 	Pro.RequiereAnalisiCre, Sol.TipoCredito
						INTO 	Var_RequiereAnalisiCre,Var_TipoCredito
						FROM PRODUCTOSCREDITO Pro,
							SOLICITUDCREDITO Sol
						WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
						AND Sol.solicitudCreditoID = Var_CurSolicitud;

						IF(Var_RequiereAnalisiCre=RequiereAnalisis_SI) THEN
									CALL ASIGNACIONSOLICITUDESPRO (
													Var_CurSolicitud,    Entero_Cero,           SalidaNO,			Par_NumErr,		    Par_ErrMen,			    Par_EmpresaID,	    Aud_Usuario,   	 Aud_FechaActual,
													Aud_DireccionIP,     Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion  );
									IF(Par_NumErr <> Entero_Cero)THEN
									LEAVE ManejoErrores;
									END IF;
						END IF;

	                -- =====================FIN DE VALIDAR SI SE REQUIERE ANALISIS DE CREDITO=======================


						IF IFNULL(Var_ListaSolicitudes, Cadena_Vacia) = Cadena_Vacia THEN
							SET Var_ListaSolicitudes    := CONVERT(Var_CurSolicitud , CHAR);
						ELSE
							SET Var_ListaSolicitudes    := CONCAT(Var_ListaSolicitudes,",",CONVERT(Var_CurSolicitud , CHAR));
						END IF;

					END LOOP CICLOCUR_SOLICI;
				END;
			CLOSE CURLIBERASOL;

            -- VALIAMOS SI EXISTEN SOLICITUDES DONDE NO SE REALIZO EL ANALISIS DE RIESGO COMUN
			IF(Var_NumSolNoEvaluaron > Entero_Cero)THEN
				SET Var_MsjRiesgo := CONCAT(" En ",Var_NumSolNoEvaluaron, " Solicitud(es) no se realizo el proceso de analisis de riesgo comun.");
			ELSE
				SET Var_MsjRiesgo := Cadena_Vacia;
            END IF;

			IF IFNULL(Var_ListaSolicitudes, Cadena_Vacia) = Cadena_Vacia THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := CONCAT("Ninguna Solicitud se pudo Liberar.","<br>",Var_MensajesError);
			ELSE
				SET Par_NumErr  := 0;
				SET Par_ErrMen  := CONCAT("La(s) Siguiente(s) Solicitud(es) ",Var_ListaSolicitudes," se ha(n) Liberado con Exito.",Var_MsjRiesgo);
			END IF;

			SET Var_Control:= 'solicitudCreditoID';
			SET Par_SolicCredID :=  Var_NumGrupo;
			LEAVE ManejoErrores;
		END IF;
		# ======================================== TERMINA LIBERAR DE SOLICITUD DE CREDITO GRUPAL ===================================
		# ===========================================================================================================================

		# ===========================================================================================================================
		# 7.- ==================================== GUARDAR COMENTARIO EN SOLICITUD DE CREDITO =======================================
		IF (Par_NumAct = Act_GuardaComentario) THEN
			IF (Var_EstatusSolicitud <> Sol_EstatusInactiva) THEN
				SET Par_NumErr := 101;
				SET Par_ErrMen := CONCAT('La solicitud debe estar Inactiva para Poder Agregar Comentarios.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;


           SET Var_NumRegistros := (SELECT COUNT(ComentarioID)
									   FROM COMENTARIOSSOL
									   WHERE SolicitudCreditoID = Par_SolicCredID
                                       AND Estatus = EstInactivo);

			IF (Var_NumRegistros > Entero_Cero) THEN
				UPDATE SOLICITUDCREDITO
						SET ComentarioEjecutivo = CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia THEN Cadena_Vacia
															  ELSE " " END,"--> ", CAST(NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",  LTRIM(RTRIM(Par_ComentEjecutivo)),
								" ", LTRIM(RTRIM(IFNULL(ComentarioEjecutivo, Cadena_Vacia)))  )
						WHERE SolicitudCreditoID = Par_SolicCredID;

				UPDATE COMENTARIOSSOL
				SET Comentario = CONCAT(CASE WHEN IFNULL(Comentario, Cadena_Vacia) = Cadena_Vacia THEN Cadena_Vacia
													  ELSE " --" END,"--> ", CAST(NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",  LTRIM(RTRIM(Par_ComentEjecutivo)),
						" -- ", LTRIM(RTRIM(IFNULL(Comentario, Cadena_Vacia)))  )
				WHERE SolicitudCreditoID = Par_SolicCredID
				AND Estatus = EstInactivo;
            ELSE
				CALL COMENTARIOSALT (
				Par_SolicCredID,   	EstInactivo,		Fecha_Sist, 	Par_ComentEjecutivo,	ClaveUsuario,
                SalidaNO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,			Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,   		Aud_NumTransaccion  );

                IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
            END IF;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('Comentario Agregado con Exito.');
			SET Var_Control:= 'solicitudCreditoID';
			LEAVE ManejoErrores;

		END IF;
		# ======================================== TERMINA GUARDAR COMENTARIO EN SOLICITUD DE CREDITO ===============================
		# ===========================================================================================================================

		# ===========================================================================================================================
		# 8.- ==================================== AUTORIZACION DE SOLICITUD DE CREDITO REESTRUCTURA ================================
		IF(Par_NumAct = Act_AutSolCreReest) THEN
			-- Validaciones de avales y garantias prendarias
			CALL VALIDAPRODCREDPRO (
				Entero_Cero,    Par_SolicCredID,    TipoValiAltaCre,    SalidaNO,           Par_NumErr,
				Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			  -- Se obtiene el valor Requiere CheckList del Producto de la Solicitud de Credito
			SELECT 	Pro.RequiereCheckList
			INTO 	Var_RequiereCheckList
			FROM PRODUCTOSCREDITO Pro,
				 SOLICITUDCREDITO Sol
			WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
			AND Sol.solicitudCreditoID = Var_CurSolicitud;

             -- Se valida SI Requiere CheckList la Solicitud de Credito
			IF (Var_RequiereCheckList = Str_SI)THEN
				-- Validaciones del checklist
			CALL SOLICIDOCENTVAL(Par_SolicCredID,   Entero_Cero,    TipValSoliciInd,    Var_CheckComple,    SalidaNO,
								 Par_NumErr,        Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,		    Aud_FechaActual,
								 Aud_DireccionIP,   Aud_ProgramaID, Aud_Sucursal,
								 Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero ) THEN
				SET Par_NumErr := 100;
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			 END IF;
			END IF;
			IF (Var_CheckComple = Str_NO) THEN
				SET Par_NumErr := 101;
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_MontoAutor, Decimal_Cero)= Decimal_Cero) THEN
				SET Par_NumErr := 102;
				SET Par_ErrMen := 'El Monto de la Solicitud de Credito esta Vacio.';
				SET Var_Control:= 'montoSolici';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_MontoSolic != Par_MontoAutor) THEN
				SET Par_NumErr := 103;
				SET Par_ErrMen := 'La Solicitud Tiene Pagos de Capital Libre, <br>El Monto a Autorizar No puede ser Diferente del Solicitado.';
				SET Var_Control:= 'montoAutorizado';
				LEAVE ManejoErrores;
			END IF;



			UPDATE SOLICITUDCREDITO SET
				FechaAutoriza       = Fecha_Sist,
				MontoAutorizado     = Par_MontoAutor,
				UsuarioAutoriza     = Par_UsuarioAut,
				Estatus             = EstatusAut,
				ComentarioMesaControl = CASE WHEN Par_ComentMesaControl != Cadena_Vacia
													THEN
														 CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Var_NombreUSuario," ----- ",
														 LTRIM(RTRIM(Par_ComentMesaControl)), " ",
														 LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
													ELSE
														 Cadena_Vacia
											END ,

				EmpresaID           = Par_EmpresaID,
				Usuario             = Aud_Usuario,
				FechaActual         = Aud_FechaActual,
				DireccionIP         = Aud_DireccionIP,
				ProgramaID          = Aud_ProgramaID,
				Sucursal            = Aud_Sucursal,
				NumTransaccion      = Aud_NumTransaccion

			WHERE SolicitudCreditoID = Par_SolicCredID;

			# Actualizar estatus de la solicitud de credito
			CALL ESTATUSSOLCREDITOSALT(
			Par_SolicCredID,           Entero_Cero,          EstatusAut,                Cadena_Vacia,             Cadena_Vacia,
			SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,
			Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
			END IF;

			CALL HISSOLICITUDESASIGNACIONESALT(
			Par_SolicCredID,           SalidaNO,             Par_NumErr,                Par_ErrMen,               Par_EmpresaID,
			Aud_Usuario,               Aud_FechaActual,      Aud_DireccionIP,           Aud_ProgramaID,           Aud_Sucursal,
			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
			END IF;

			SET Var_CreditoID := (SELECT Relacionado
			 							FROM SOLICITUDCREDITO
			 							WHERE SolicitudCreditoID = Par_SolicCredID);
			SET Var_CreditoID := IFNULL(Var_CreditoID,Entero_Cero);
			IF EXISTS (SELECT * FROM AMORTCRENOMINAREAL WHERE CreditoID = Var_CreditoID)THEN
	            UPDATE AMORTCRENOMINAREAL
	                SET Estatus = EstatusPagado,
	                    NumTransaccion  = Aud_NumTransaccion
	            WHERE CreditoID = Var_CreditoID
	            AND Estatus <> EstatusPagado;
	        END IF;
			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('La Solicitud de Cr&eacute;dito: ',
											 CONVERT(Par_SolicCredID, CHAR(20)),' Fue Autorizada.');
			SET Var_Control:= 'solicitudCreditoID';
			LEAVE ManejoErrores;

		END IF;
		# ======================================== TERMINA AUTORIZACION DE SOLICITUD DE CREDITO REESTRUCTURA ========================
		# ===========================================================================================================================

        # ===========================================================================================================================
		# 9.- ================================ AUTORIZACION DE SOLICITUD DE CREDITO POR WS CREDICLUB ================================
		IF(Par_NumAct = Act_AutorizaSolCRCBWS) THEN

             -- Se obtiene el valor Requiere CheckList del Producto de la Solicitud de Credito
			SELECT 	Pro.RequiereCheckList
			INTO 	Var_RequiereCheckList
			FROM PRODUCTOSCREDITO Pro,
				 SOLICITUDCREDITO Sol
			WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
			AND Sol.solicitudCreditoID = Par_SolicCredID;

             -- Se valida SI Requiere CheckList la Solicitud de Credito
			IF (Var_RequiereCheckList = Str_SI)THEN
				CALL SOLICIDOCENTVAL(
					Par_SolicCredID,   Entero_Cero,    	TipValSoliciInd,    Var_CheckComple,    SalidaNO,
					Par_NumErr,        Par_ErrMen,     	Par_EmpresaID,      Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,   Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				IF (Var_CheckComple = Str_NO) THEN
					SET Par_NumErr := 101;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_MontoAutor, Decimal_Cero)= Decimal_Cero) THEN
				SET Par_NumErr := 102;
				SET Par_ErrMen := CONCAT('El Monto de la Solicitud de Credito esta Vacio.');
				LEAVE ManejoErrores;
			END IF;

			IF(Var_MontoSolic < Par_MontoAutor) THEN
				SET Par_NumErr := 103;
				SET Par_ErrMen := CONCAT('El Monto a Autorizar No Debe ser Mayor al Monto Solicitado.');
				LEAVE ManejoErrores;
			END IF;

			-- Se actualiza los campos de la tabla SOLICITUDCREDITO para la Autorizacion de la Solicitud
			UPDATE SOLICITUDCREDITO SET
				FechaAutoriza       = Fecha_Sist,
				MontoAutorizado     = Par_MontoAutor,
				UsuarioAutoriza     = Par_UsuarioAut,
				Estatus             = EstatusAut,
				ComentarioEjecutivo = CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
													THEN Cadena_Vacia
													ELSE
														  " "
													END,
									   "--> ", CAST( NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",  LTRIM(RTRIM(Par_ComentMesaControl)),
										" ", LTRIM(RTRIM(IFNULL(ComentarioEjecutivo, Cadena_Vacia)))  ),
				ComentarioMesaControl = CASE WHEN Par_ComentMesaControl!=Cadena_Vacia
													THEN
														 CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Var_NombreUSuario," ----- ",
														 LTRIM(RTRIM(Par_ComentMesaControl)), " ",
														 LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
													ELSE
														 Cadena_Vacia
											END ,

				EmpresaID           = Par_EmpresaID,
				Usuario             = Aud_Usuario,
				FechaActual         = Aud_FechaActual,
				DireccionIP         = Aud_DireccionIP,
				ProgramaID          = Aud_ProgramaID,
				Sucursal            = Aud_Sucursal,
				NumTransaccion      = Aud_NumTransaccion

			WHERE SolicitudCreditoID = Par_SolicCredID;

			SET Var_Monto:= (SELECT IFNULL(MontoAutorizado,Entero_Cero) FROM SOLICITUDCREDITO
								WHERE SOlicitudCreditoID = Par_SolicCredID);

			IF(Var_Monto != Entero_Cero) THEN

				CALL COMENTARIOSALT (
					Par_SolicCredID,	EstAutorizado,	Par_FechAutoriz,	Par_ComentMesaControl,	ClaveUsuario,
					SalidaNO,			Par_NumErr,		Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,   		Aud_NumTransaccion  );

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


				SET Par_NumErr := Entero_Cero;
				SET Par_ErrMen := CONCAT('La Solicitud de Credito: ',
											 CONVERT(Par_SolicCredID, CHAR(20)),' Fue Autorizada.');
			ELSE
				SET Par_NumErr := 105;
				SET Par_ErrMen := CONCAT('La Solicitud de Credito: ',
											 CONVERT(Par_SolicCredID, CHAR(20)),' NO Fue Autorizada.');
			END IF;

			LEAVE ManejoErrores;

		END IF;
		# ============================== TERMINA AUTORIZACION DE SOLICITUD DE CREDITO POR WS CREDICLUB ==============================
		# ===========================================================================================================================

        # ===========================================================================================================================
		# 10.- ==================================== LIBERAR SOLICITUD DE CREDITO GRUPAL WS CREDICLUB =================================
		IF Par_NumAct = Act_LibGrupoSolCRCBWS THEN



			IF Var_NumGrupo = Entero_Cero THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := CONCAT("La Solicitud ",Par_SolicCredID," esta ligada a un grupo ",Var_NumGrupo," que no Existe");
				LEAVE ManejoErrores;
			END IF;

			SET Var_ListaSolicitudes    := Cadena_Vacia;



			OPEN CURLIBERASOL;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOCUR_SOLICI: LOOP
						FETCH CURLIBERASOL  INTO 	Var_CurSolicitud, Var_CurSolEstatus, Var_SolClienteID, Var_SolProspectoID;

                         -- Se obtiene el valor Requiere CheckList del Producto de la Solicitud de Credito
						SELECT 	Pro.RequiereCheckList
						INTO 	Var_RequiereCheckList
						FROM PRODUCTOSCREDITO Pro,
							 SOLICITUDCREDITO Sol
						WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
						AND Sol.solicitudCreditoID = Var_CurSolicitud;

                         -- Se valida SI Requiere CheckList la Solicitud de Credito
                         IF (Var_RequiereCheckList = Str_SI)THEN
							CALL SOLICIDOCENTVAL(
								Var_CurSolicitud,      Entero_Cero,        TipValSoliciInd,    	Var_CheckComple,    	SalidaNO,
								Par_NumErr,            Par_ErrMen,         Par_EmpresaID,      	Aud_Usuario,		    Aud_FechaActual,
								Aud_DireccionIP,       Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr <> Entero_Cero ) THEN
									SET Par_NumErr := 0;
									 SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);

								 ITERATE CICLOCUR_SOLICI;
							 END IF;

							IF Var_CheckComple = Str_NO THEN
								SET Par_NumErr := 0;
								 SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);

								 ITERATE CICLOCUR_SOLICI;
							END IF;
						END IF;

						IF (Var_CurSolEstatus <> Sol_EstatusInactiva) THEN
							SET Par_NumErr := 0;
							SET Par_ErrMen := CONCAT("La Solicitud ",Var_CurSolicitud," no se encuentra Inactiva");
							 SET Var_MensajesError = CONCAT(Var_MensajesError,"<br>", Par_ErrMen);

							 ITERATE CICLOCUR_SOLICI;
						END IF;


						SET Var_SolClienteID		:= CASE WHEN IFNULL(Var_SolClienteID,Entero_Cero) = Entero_Cero THEN -1 ELSE Var_SolClienteID END;
						SET Var_SolProspectoID		:= CASE WHEN Var_SolClienteID > Entero_Cero THEN -1 ELSE  IFNULL(Var_SolProspectoID,Entero_Cero) END ;


						IF Var_SolClienteID > Entero_Cero THEN
							SET	Var_EstadoCivil	:= (SELECT EstadoCivil FROM CLIENTES WHERE  ClienteID = Var_SolClienteID );
						ELSE
							SET	Var_EstadoCivil	:= (SELECT EstadoCivil FROM PROSPECTOS WHERE  ProspectoID = Var_SolProspectoID);
						END IF;
						SET Var_EstadoCivil:=IFNULL(Var_EstadoCivil,Cadena_Vacia);

						UPDATE SOLICITUDCREDITO
						SET Estatus             = Sol_EstatusLiberada
						WHERE SolicitudCreditoID = Var_CurSolicitud;

						IF IFNULL(Var_ListaSolicitudes, Cadena_Vacia) = Cadena_Vacia THEN
							SET Var_ListaSolicitudes    := CONVERT(Var_CurSolicitud , CHAR);
						ELSE
							SET Var_ListaSolicitudes    := CONCAT(Var_ListaSolicitudes,",",CONVERT(Var_CurSolicitud , CHAR));
						END IF;

					END LOOP CICLOCUR_SOLICI;
				END;
			CLOSE CURLIBERASOL;

			IF IFNULL(Var_ListaSolicitudes, Cadena_Vacia) = Cadena_Vacia THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := CONCAT("Ninguna Solicitud se pudo Liberar.","<br>",Var_MensajesError);
			ELSE
				SET Par_NumErr  := 0;
				SET Par_ErrMen  := CONCAT("La(s) Siguiente(s) Solicitud(es) ",Var_ListaSolicitudes," se ha(n) Liberado con Exito.");
			END IF;

			LEAVE ManejoErrores;

		END IF;
		# ======================================== TERMINA LIBERAR DE SOLICITUD DE CREDITO GRUPAL WS CREDICLUB ======================
		# ===========================================================================================================================

        IF (Par_NumAct = Act_LiberarSolCRCBWS) THEN


			SET Par_NumErr := 100;
			SET Par_ErrMen := Cadena_Vacia;
			SELECT IFNULL(Cli.Estatus,Cadena_Vacia) INTO Var_EstatusCli
				FROM CLIENTES Cli
					INNER JOIN SOLICITUDCREDITO Sol ON Sol.ClienteID = Cli.ClienteID
				WHERE solicitudCreditoID = Par_SolicCredID;
			IF(Var_EstatusCli = Inactivo) THEN
				SET Par_NumErr := 101;
				SET Par_ErrMen := CONCAT('El Cliente se Encuentra Inactivo.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_Proyecto, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr := 102;
				SET Par_ErrMen := CONCAT('El Proyecto esta Vacio.');
				SET Var_Control:= 'proyecto';
				LEAVE ManejoErrores;
			END IF;

			-- -------- VALIDA LOS CAMPOS DEL SEGURO DE VIDA  No aplica para solicitudes para creditos renovados o reestructurados -------
			IF(Var_SeguroVida = Str_SI AND Var_TipoCredito = CreditoNuevo) THEN
				IF (IFNULL(Var_Beneficiario, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr := 103;
					SET Par_ErrMen := CONCAT('El Beneficiario esta Vacio.');
					SET Var_Control:= 'beneficiario';
					LEAVE ManejoErrores;
				END IF;

				IF (IFNULL(Var_DireccionBe, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr := 104;
					SET Par_ErrMen := CONCAT('La Direccion del Beneficiario esta Vacia.');
					SET Var_Control:= 'direccionBe';
					LEAVE ManejoErrores;
				END IF;

				IF (IFNULL(Var_TipoRelacion, Entero_Cero) = Entero_Cero) THEN
					SET Par_NumErr := 105;
					SET Par_ErrMen := CONCAT('El Parentesco del Beneficiario esta Vacio.');
					SET Var_Control:= 'tipoRelacion';
					LEAVE ManejoErrores;
				END IF;

			END IF; -- Termina IF(Var_SeguroVida = Str_SI AND Var_TipoCredito = CreditoNuevo) THEN


			IF (Var_EstatusSolicitud <> Sol_EstatusInactiva) THEN
				SET Par_NumErr := 106;
				SET Par_ErrMen := CONCAT('La Solicitud Debe estar Inactiva para poder Liberarla.');
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;




			-- Otras validaciones sobre la solicitud de credito para poder ser liberada
            -- Se obtiene el valor Requiere CheckList del Producto de la Solicitud de Credito
            SELECT 	Pro.RequiereCheckList
            INTO 	Var_RequiereCheckList
            FROM PRODUCTOSCREDITO Pro,
				 SOLICITUDCREDITO Sol
			WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
			AND Sol.solicitudCreditoID = Par_SolicCredID;

            -- Se valida SI Requiere CheckList la Solicitud de Credito
            IF (Var_RequiereCheckList = Str_SI)THEN
				CALL SOLICIDOCENTVAL(
					Par_SolicCredID,   Entero_Cero,    	TipValSoliciInd,    Var_CheckComple,    SalidaNO,
					Par_NumErr,        Par_ErrMen,     	Par_EmpresaID,      Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,   Aud_ProgramaID, 	Aud_Sucursal,	   	Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero ) THEN
					SET Par_NumErr := 107;
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;

				IF (Var_CheckComple = Str_NO) THEN
					SET Par_NumErr := 108;
					SET Var_Control:= 'solicitudCreditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (IFNULL(Par_ComentEjecutivo, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_ComentEjecutivo := 'SIN COMENTARIOS';
			END IF;

			-- Otras validaciones de acuerdo al producto de credito (avales, garantias)
			CALL VALIDAPRODCREDPRO (
				Entero_Cero,    Par_SolicCredID,    TipoValiLiberaSol,  SalidaNO,           Par_NumErr,
				Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero ) THEN
				SET Par_NumErr := 109;
				SET Var_Control:= 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;


			SELECT ClienteID, ProspectoID  INTO Var_clienteID, Var_ProspectoID
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolicCredID;
			SET Var_clienteID		:= CASE WHEN IFNULL(Var_clienteID,Entero_Cero) = Entero_Cero THEN -1 ELSE Var_clienteID END;
			SET Var_ProspectoID		:= CASE WHEN Var_clienteID > Entero_Cero THEN -1 ELSE  IFNULL(Var_ProspectoID,Entero_Cero) END ;

			IF (Var_clienteID > Entero_Cero) THEN
						SET	Var_EstadoCivil	:= (SELECT EstadoCivil FROM CLIENTES WHERE  ClienteID = Var_clienteID );
					ELSE
						SET	Var_EstadoCivil	:= (SELECT EstadoCivil FROM PROSPECTOS WHERE  ProspectoID = Var_ProspectoID);
			END IF;
			SET Var_EstadoCivil:=IFNULL(Var_EstadoCivil,Cadena_Vacia);
			SET Var_EstadoCivil:=IFNULL(Var_EstadoCivil,Cadena_Vacia);

			IF EXISTS(SELECT ProducCreditoID
					  FROM SOLICITUDCREDITO Sol
						INNER JOIN PRODUCTOSCREDITO Pro	ON Pro.ProducCreditoID = Sol.ProductoCreditoID
							AND CalculoRatios = Str_SI
							AND Sol.SolicitudCreditoID = Par_SolicCredID) THEN
					IF NOT EXISTS(SELECT SolicitudCreditoID
									FROM RATIOS WHERE SolicitudCreditoID = Par_SolicCredID AND Estatus = EstatusProcesada) THEN
						SET Par_NumErr := 111;
						SET Par_ErrMen := CONCAT('Es Necesario Realizar el Calculo de Ratios para la Solicitud: ',CONVERT(Par_SolicCredID, CHAR), '.');
						SET Var_Control:= 'solicitudCreditoID';
						LEAVE ManejoErrores;
					END IF;
			END IF;


			UPDATE SOLICITUDCREDITO
			SET Estatus             = Sol_EstatusLiberada,
				FechaLiberada		= Fecha_Sist,
				ComentarioEjecutivo = CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
													THEN Cadena_Vacia
													ELSE " " END,"--> ", CAST(NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",  LTRIM(RTRIM(Par_ComentEjecutivo)),
															" ", LTRIM(RTRIM(IFNULL(ComentarioEjecutivo, Cadena_Vacia)))  )
			WHERE SolicitudCreditoID = Par_SolicCredID;

				CALL COMENTARIOSALT (
				Par_SolicCredID,   	EstLiberado,	Fecha_Sist, 	Par_ComentEjecutivo,	ClaveUsuario,
                SalidaNO,			Par_NumErr,		Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,   		Aud_NumTransaccion  );

                IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('Solicitud Liberada Exitosamente: ', CONVERT(Par_SolicCredID, CHAR), '.');
			SET Var_Control:= 'solicitudCreditoID';
			LEAVE ManejoErrores;

		END IF;
		# ======================================== TERMINA LIBERAR DE SOLICITUD DE CREDITO INDIV WS CRCB====================================
		# ===========================================================================================================================


		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('La Solicitud de Cr&eacute;dito: ',
										 CONVERT(Par_SolicCredID, CHAR(20)),' Fue Autorizada.');
		SET Var_Control:= 'solicitudCreditoID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS Control,
				Par_SolicCredID AS Consecutivo;
	END IF;

END TerminaStore$$
