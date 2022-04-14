-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDWSALT`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDCREDWSALT`(
/* =====================================================================================
   ------- STORE PARA DAR ALTA SOLICITUDES DE CREDITO WS PARA SANA TUS FINANZAS---------
   =====================================================================================*/
	Par_ProspectoID     BIGINT(20),
	Par_ClienteID       INT(11),
	Par_ProduCredID     INT(11),
	Par_MontoSolic      DECIMAL(12,2),
    Par_Periodicidad    CHAR(1),

	Par_PlazoID         VARCHAR(20),
	Par_DestinoCredID   INT(11),
	Par_Proyecto        VARCHAR(500),
    Par_TipoDispersion	CHAR(1),
    Par_CuentaCLABE		CHAR(18),

    Par_TipoPagoCapital	CHAR(1),
    Par_TipoCredito		CHAR(1),
	Par_NumCreditos     INT(11),
    Par_GrupoID 		INT(11),		# Solo cuando sea grupal
    Par_TipoIntegrante	INT(11),		# Solo cuando sea grupal

    Par_Folio_Pda		VARCHAR(20),    # Folio generado por el PDA
    Par_ClaveUsuario    VARCHAR(100),   # ID del usuario
	Par_Dispositivo		VARCHAR(40),	# Dispositivo del que se genera el movimiento
    /* Parametros de Auditoria */
	Par_EmpresaID       INT(11),		# Desde dao
	Aud_Usuario         INT(11),		# Usuario logeado

	Aud_FechaActual     DATETIME,		# Del sistema
	Aud_DireccionIP     VARCHAR(15),	# Desde dao
	Aud_ProgramaID      VARCHAR(50),  	# Formado por el folio pda y el dispositivo
	Aud_Sucursal        INT(11), 		# Del usuario logeado
	Aud_NumTransaccion  BIGINT(20)		# Num de transaccion desde dao
		)

TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Entero_Cero     	INT;
    DECLARE Entero_Uno			INT;
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Par_NumErr      	INT;
	DECLARE Par_ErrMen      	VARCHAR(400);
	DECLARE SalidaNO        	CHAR(1);
	DECLARE SalidaSI        	CHAR(1);
    DECLARE TipoCreditoRenova	CHAR(1);
    DECLARE Constante_No		CHAR(1);
    DECLARE Constante_Si		CHAR(1);
    DECLARE DiaDelMes			CHAR(1);
    DECLARE TipoFondeoRecPropios	CHAR(1);
	DECLARE PagoSemanal			CHAR(1);
	DECLARE PagoCatorcenal		CHAR(1);
	DECLARE PagoQuincenal		CHAR(1);
	DECLARE PagoMensual			CHAR(1);
	DECLARE PagoPeriodo			CHAR(1);
	DECLARE PagoBimestral		CHAR(1);
	DECLARE PagoTrimestral		CHAR(1);
	DECLARE PagoTetrames		CHAR(1);
	DECLARE PagoSemestral		CHAR(1);
	DECLARE PagoAnual			CHAR(1);
	DECLARE PagoFinMes			CHAR(1);
	DECLARE PagoAniver			CHAR(1);
	DECLARE PagoUnico			CHAR(1);
	DECLARE FrecSemanal			INT;
	DECLARE FrecCator			INT;
	DECLARE FrecQuin			INT;
	DECLARE FrecMensual			INT;
	DECLARE FrecBimestral		INT;
	DECLARE FrecTrimestral		INT;
	DECLARE FrecTetrames		INT;
	DECLARE FrecSemestral		INT;
	DECLARE FrecAnual			INT;
    DECLARE DispersionSPEI		CHAR(1);
    DECLARE Entero_Cien 		INT;
    DECLARE Espacio_Blanco		CHAR(1);
    DECLARE Dos_Puntos			CHAR(1);
	DECLARE Grupal_SI			CHAR(1);
	DECLARE PonderaTasa_SI		CHAR(1);
	DECLARE Estatus_Activo	    CHAR(1);
    DECLARE Par_FechaReg		DATE;
    DECLARE TiposCreditos		VARCHAR(10);
    DECLARE TiposFrecuencia		VARCHAR(200);
    DECLARE LetraEnie			CHAR(1);
	DECLARE TasaFijaID			INT(11);
	DECLARE	ConSic_TipoBuro		CHAR(2);		-- Consulta tipo buro
	DECLARE ConSic_TipoCirculo	CHAR(2);		-- Consulta tipo circulo
    DECLARE Con_TipoBuro		CHAR(1);
	DECLARE Var_NivelID			INT(11);		-- Nivel del crédito (NIVELCREDITO).

-- Declaracion de variables
	DECLARE Var_ProspectoID     INT;
    DECLARE Var_ProductoCredID	INT(11);
    DECLARE Var_Dispersiones	VARCHAR(8);
	DECLARE Var_CodigoResp		INT(1);
	DECLARE Var_CodigoDesc		VARCHAR(400);
	DECLARE Var_Estatus     	CHAR(1);
	DECLARE Var_ClasifiCli		CHAR(1);
    DECLARE Var_DestinoCredID	INT(11);
	DECLARE Var_SolicitudCre	BIGINT(20);
    DECLARE Var_SolicitudID		VARCHAR(400);
    DECLARE Var_TasaFija		DECIMAL(12,4);
    DECLARE Var_FactorMora		DECIMAL(12,4);
	DECLARE Var_Control			CHAR(15);
	DECLARE Var_ClienteID       INT;
	DECLARE	Fre_Dias			INT;
	DECLARE	NumDias				INT;
	DECLARE Var_FecVencimiento	DATE;
	DECLARE Var_NumCuotas		DECIMAL(12,2);
	DECLARE Var_CalificaCli		CHAR(1);
	DECLARE Var_PorcGarLiq      DECIMAL(12,4);
    DECLARE Var_ValorCAT		DECIMAL(12,4);
    DECLARE Var_AporteCliente 	DECIMAL(12,2);
    DECLARE Var_Posicion		INT;
	DECLARE Var_EsGrupal		CHAR(1); 		 		-- Indica si el producto es grupal
	DECLARE Var_GrupoID			INT(11);
	DECLARE Var_NumCiclos		INT(11);
	DECLARE Var_CicloCliente	INT(10);		 		-- Ciclo del cliente para un producto de credito
	DECLARE Var_CicloGrupal		INT(10);
	DECLARE Var_TasaPonderaGru	CHAR(1);
	DECLARE Var_PeriodoCapInt	INT(11);
	DECLARE Var_NumErr		    INT(11);
	DECLARE Var_MenErr		    VARCHAR(100);
    DECLARE Var_DiaPagoMes		INT;
	DECLARE Var_SucursalOriCli  INT;
    DECLARE Var_DireccionIP		VARCHAR(15);
	DECLARE Var_Renovado		CHAR(1);
	DECLARE Var_Nuevo			CHAR(1);
	DECLARE Var_Reestructura	CHAR(1);
    DECLARE Var_FrecuenciasTipoProd	VARCHAR(200);		-- Frecuencias dependiendo del tipo de producto de credito
    DECLARE Var_PlazosIDTipoProd	TEXT;				-- Plazos ID dependiendo del tipo de producto de credito
    DECLARE Var_DispersionTipoProd	VARCHAR(100);		-- Tipos de Dispersion dependiendo del tipo de producto de credito
    DECLARE Var_RequiereGarantia	CHAR(1);			-- Estatus si el producto de credito requiere garantia liquida: N.- NO, S.- SI
    DECLARE Var_ClasifDestinoCred	CHAR(1);
    DECLARE Var_CalcInteres			INT(11);
    DECLARE Var_MontoSeguroCuota	DECIMAL(12,2);		-- Monto por seguro por cuota, temporalmente ira en 0 ya que ZAFY no esa esto
    DECLARE Var_TipoConsultaSIC		CHAR(2);			-- TIPO CONSULTA SIC
	DECLARE Var_FechaCobroComision	DATE;				-- Fecha de cobro de la comision por apertura

-- Asignacion de Constantes
	SET Entero_Cero     		:= 0; 					-- Constante Entero Cero
    SET Entero_Uno				:= 1;					-- Constante Entero Uno
	SET Decimal_Cero    		:= 0.0;             	-- Constante DECIMAL cero
	SET Fecha_Vacia     		:= '1900-01-01';    	-- Fecha vacia
	SET Cadena_Vacia    		:= '';              	-- Cadena vacia
	SET SalidaSI        		:= 'S';             	-- SI salida
	SET SalidaNO        		:= 'N'; 				-- No salida
	SET Var_Dispersiones        := 'S,C,E,O';			-- Tipos de Dispersiones existentes: S.- SPEI	C.- Cheque	O.- Orden de Pago E.- Efectivo
    SET TipoCreditoRenova		:= 'O';					-- Tipo de Creditos: O.- Renovacion
    SET Constante_No			:= 'N';					-- Constante NO
    SET Constante_Si			:= 'S';					-- Constante Si
    SET DiaDelMes				:= 'D';					-- D.- Dia del Mes
    SET TipoFondeoRecPropios	:= 'P';					-- Tipo de Fondeo: P.- Recursos Propios
	SET PagoSemanal				:= 'S'; 				-- Tipo de Pago Semanal
	SET PagoCatorcenal			:= 'C';  				-- Tipo de Pago Catorcenal
	SET PagoQuincenal			:= 'Q';  				-- Tipo de Pago Quincenal
	SET PagoMensual				:= 'M';  				-- Tipo de Pago Mensual
	SET PagoPeriodo				:= 'P';  				-- Tipo de Pago periodo
	SET PagoBimestral			:= 'B';  				-- Tipo de Pago bimestral
	SET PagoTrimestral			:= 'T';  				-- Tipo de Pago trimestral
	SET PagoTetrames			:= 'R';	 				-- Tipo de Pago tetramestral
	SET PagoSemestral			:= 'E';  				-- Tipo de Pago semestral
	SET PagoAnual				:= 'A';  				-- Tipo de Pago anual
	SET PagoUnico				:= 'U';  				-- Tipo de Pago unico
	SET FrecSemanal				:= 7;	 				-- Tipo de Frecuencia 7 dias
	SET FrecCator				:= 14;		 			-- Tipo de Frecuencia 14 dias
	SET FrecQuin				:= 15;		 			-- Tipo de Frecuencia 15 dias
	SET FrecMensual				:= 30;		 			-- Tipo de Frecuencia 30 dias
	SET FrecBimestral			:= 60;		 			-- Tipo de Frecuencia 60 dias
	SET FrecTrimestral			:= 90;		 			-- Tipo de Frecuencia 90 dias
	SET FrecTetrames			:= 120;		 			-- Tipo de Frecuencia 120 dias
	SET FrecSemestral			:= 180;		 			-- Tipo de Frecuencia 180 dias
	SET FrecAnual				:= 360;	 				-- Tipo de Frecuencia 360 dias
	SET DispersionSPEI			:= 'S';		 			-- Tipo de Dispersion para SPEI
    SET Entero_Cien				:= 100;					-- Constante cien
	SET Espacio_Blanco			:= ' ';	 				-- Constante espacio en blanco
    SET Dos_Puntos				:= ':';					-- Constante simbolo dos puntos
    SET Grupal_SI				:= 'S';					-- Si es Grupal
	SET PonderaTasa_SI			:= 'S';					-- Si el producto de credito pondera la tasa en un grupo de creditos S = si
	SET Estatus_Activo	  		:= 'A';        			-- Estatus Activo del Usuario
    SET TiposCreditos			:= 'N,R,O';				-- Tipos de Dispersiones disponibles : N.- Nuevo R.- Reestructura O.- Renovacion
    SET TiposFrecuencia			:= 'S,C,Q,M,P,B,T,R,E,A,L';-- Tipos de Frecuencia: Semanal, catorcenal, quincenal, mensual, periodo, bimestral, trimestral, tetrmestral, semanal, anual, libre
    SET LetraEnie				:= 'N';					-- Letra ene
	SET TasaFijaID				:= 1; 					-- ID de la formula para tasa fija (FORMTIPOCALINT)
	SET Var_Renovado			:= 'O';					-- Tipo de Credito Renovado
	SET Var_Nuevo				:= 'N';					-- Tipo de Credito Nuevo
	SET Var_Reestructura		:= 'R';					-- Tipo de Credito Reestructura
	SET ConSic_TipoBuro			:= 'BC';				-- Consulta SIC buro
	SET ConSic_TipoCirculo		:= 'CC';				-- Consulta SIC Circulo
    SET Con_TipoBuro			:= 'B';					-- Tipo buro
	-- Asignacion de Variables
	SET	Var_CodigoResp	    	:= 0;
	SET	Var_CodigoDesc	   		:= 'Transaccion Rechazada';
    SET Var_ValorCAT			:= Decimal_Cero;
    SET Var_Posicion			:= 0;
	SET Var_CicloCliente		:= Entero_Cero;
    SET Var_CicloGrupal			:= Entero_Cero;
    SET Var_DireccionIP			:= '127.0.0.1';
    SET Var_MontoSeguroCuota	:= Entero_Cero;

    SET Aud_ProgramaID			:= UPPER(CONCAT(Par_Folio_Pda, ' ', Par_Dispositivo));
    SET Aud_DireccionIP			:= Var_DireccionIP;
    SET Var_ClienteID 			:= IFNULL(Par_ClienteID,Entero_Cero);
    SET Var_SucursalOriCli  	:= (SELECT SucursalOrigen
										FROM CLIENTES
											WHERE ClienteID = Var_ClienteID);

	SELECT 	UsuarioID,		EmpresaID,		SucursalUsuario INTO
			Aud_Usuario,	Par_EmpresaID,	Aud_Sucursal
		FROM USUARIOS
			WHERE Clave = Par_ClaveUsuario
				AND Estatus = Estatus_Activo;

    SELECT FechaSistema INTO Aud_FechaActual
		FROM PARAMETROSSIS;

    SET Par_FechaReg 			:= Aud_FechaActual;
    SET Var_DiaPagoMes 			:= DAY(Par_FechaReg);
    SET Par_TipoCredito			:= UPPER(Par_TipoCredito);

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr 		:= 999;
				SET Par_ErrMen 		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDWSALT');
				SET Var_CodigoDesc  := 	Par_ErrMen;
				SET Var_Control 	:= 'SQLEXCEPTION' ;
			END;

	SET Var_TipoConsultaSIC	:= (SELECT ConBuroCreDefaut FROM PARAMETROSSIS LIMIT 1);

    IF(IFNULL(Var_TipoConsultaSIC, Cadena_Vacia)= Cadena_Vacia) THEN
		SET Var_TipoConsultaSIC	:= Cadena_Vacia;
    ELSE
		IF (Var_TipoConsultaSIC = Con_TipoBuro)THEN
			SET Var_TipoConsultaSIC := ConSic_TipoBuro;
		ELSE
			SET Var_TipoConsultaSIC := ConSic_TipoCirculo;
        END IF;
    END IF;

	IF(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero AND IFNULL(Par_ProspectoID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 001;
        SET Par_ErrMen := 'El Prospecto o Cliente esta vacio.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaReg,Fecha_Vacia) = Fecha_Vacia) THEN
		SET Par_NumErr := 002;
        SET Par_ErrMen := 'La Fecha de Registro esta vacia.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoSolic,Decimal_Cero) = Decimal_Cero) THEN
		SET Par_NumErr := 003;
        SET Par_ErrMen := 'El Monto Solicitado esta vacio.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ProduCredID,Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 004;
        SET Par_ErrMen := 'El Producto de Credito Solicitado esta vacio.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

	SELECT		ProducCreditoID, 	FactorMora, 	EsGrupal,		TasaPonderaGru, 	Garantizado,
				CalcInteres
		INTO 	Var_ProductoCredID, Var_FactorMora, Var_EsGrupal, 	Var_TasaPonderaGru,	Var_RequiereGarantia,
				Var_CalcInteres
		FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID = Par_ProduCredID;

	IF(IFNULL(Var_ProductoCredID,Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'El Producto de Credito Solicitado No Existe.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    SELECT 		Frecuencias,				PlazoID,				TipoDispersion
		INTO 	Var_FrecuenciasTipoProd, 	Var_PlazosIDTipoProd,	Var_DispersionTipoProd
		FROM CALENDARIOPROD
			WHERE ProductoCreditoID = Var_ProductoCredID;

    IF(IFNULL(Par_PlazoID,Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr := 006;
        SET Par_ErrMen := 'El Plazo esta vacio.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_Periodicidad,Cadena_Vacia) = Cadena_Vacia OR (LOCATE(Par_Periodicidad,TiposFrecuencia)=0)) THEN
		SET Par_NumErr := 007;
        SET Par_ErrMen := 'La Periodicidad esta vacia o no es valida.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_TipoDispersion,Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr := 008;
        SET Par_ErrMen := 'El Tipo de Dispersion esta vacio.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    IF LOCATE(Par_TipoDispersion, Var_Dispersiones) = 0 THEN
		SET Par_NumErr := 009;
        SET Par_ErrMen := 'El Tipo de Dispersion no es valido.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

	SELECT ProspectoID,	CalificaProspecto, 	ClienteID
    INTO Var_ProspectoID, Var_ClasifiCli, 	Var_ClienteID
		FROM PROSPECTOS
			WHERE ProspectoID = Par_ProspectoID;

	IF((IFNULL(Var_ProspectoID, Entero_Cero)= Entero_Cero)AND(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero)) THEN
		SET Par_NumErr := 010;
		SET Par_ErrMen := 'El Prospecto Indicado No Existe.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

	SET Var_ClienteID := IFNULL((SELECT ClienteID
									FROM CLIENTES
										WHERE ClienteID = Par_ClienteID),Entero_Cero);

	IF(IFNULL(Var_ClienteID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 011;
		SET Par_ErrMen := 'El Cliente Indicado No Existe.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

	SELECT ClienteID, 		Estatus,		CalificaCredito
	INTO   Var_ClienteID, 	Var_Estatus,	Var_ClasifiCli
		FROM CLIENTES
			WHERE ClienteID = Var_ClienteID;

    IF(IFNULL(Par_TipoCredito,Cadena_Vacia) = Cadena_Vacia) OR (LOCATE(Par_TipoCredito,TiposCreditos)=0)THEN
		SET Par_NumErr := 012;
        SET Par_ErrMen := 'El Tipo de Credito esta vacio o no es valido.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	ELSE
		IF(Par_TipoCredito=TipoCreditoRenova) THEN
			IF(IFNULL(Par_NumCreditos,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 013;
				SET Par_ErrMen := 'El Numero de Creditos a Renovar esta vacio.';
				SET Var_CodigoResp     :=	Par_NumErr;
				SET Var_CodigoDesc     :=  	Par_ErrMen;
				LEAVE ManejoErrores;
			END IF;
        END IF;
	END IF;

    IF(IFNULL(Par_ClaveUsuario,Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr := 014;
        SET Par_ErrMen := 'El Usuario esta vacio.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_DestinoCredID,Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 015;
        SET Par_ErrMen := 'El Destino de Credito esta vacio.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

	SELECT	DestinoCreID, 		Clasificacion
    INTO 	Var_DestinoCredID,	Var_ClasifDestinoCred
		FROM DESTINOSCREDITO
			WHERE DestinoCreID = Par_DestinoCredID;

	IF(IFNULL(Var_DestinoCredID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 016;
		SET Par_ErrMen := 'El Destino de Credito No Existe.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    IF(Par_FechaReg > Aud_FechaActual) THEN
		SET Par_NumErr := 017;
        SET Par_ErrMen := 'La Fecha de Registro No debe ser Mayor a la Fecha del Sistema.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    IF(Par_TipoDispersion=DispersionSPEI) THEN
		IF(IFNULL(Par_CuentaCLABE,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 018;
			SET Par_ErrMen := 'La Cuenta CLABE esta vacia.';
			SET Var_CodigoResp     :=	Par_NumErr;
			SET Var_CodigoDesc     :=  	Par_ErrMen;
			LEAVE ManejoErrores;
		END IF;

	END IF;

    IF NOT EXISTS(SELECT U.RolID
						FROM USUARIOS U,
							 PARAMETROSCAJA P
						WHERE U.Clave = Par_ClaveUsuario
							AND U.RolID = P.EjecutivoFR
							AND U.Estatus = Estatus_Activo
						LIMIT 1)THEN
		SET Par_NumErr := 019;
		SET Par_ErrMen := 'El Usuario Indicado no puede realizar operaciones. Rol Invalido.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    IF((LOCATE(Par_Periodicidad, Var_FrecuenciasTipoProd)=0)) THEN
		SET Par_NumErr := 020;
        SET Par_ErrMen := 'La Periodicidad no es valida para el Tipo de Producto de Credito.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    IF LOCATE(Par_PlazoID, Var_PlazosIDTipoProd) = 0 THEN
		SET Par_NumErr := 021;
        SET Par_ErrMen := 'El PlazoID no es valido para el Tipo de Producto de Credito.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    IF LOCATE(Par_TipoDispersion, Var_DispersionTipoProd) = 0 THEN
		SET Par_NumErr := 022;
        SET Par_ErrMen := 'El Tipo de Dispersion no es valido para el Tipo de Producto de Credito.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

    IF(Var_EsGrupal = Grupal_SI)THEN
		IF(IFNULL(Par_GrupoID, Entero_Cero) != Entero_Cero)THEN
			IF NOT EXISTS(SELECT GrupoID FROM GRUPOSCREDITO WHERE GrupoID = Par_GrupoID)THEN
				SET Par_NumErr := 023;
				SET Par_ErrMen := 'El Grupo Indicado no existe.';
				SET Var_CodigoResp     :=	Par_NumErr;
				SET Var_CodigoDesc     :=  	Par_ErrMen;
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Par_NumErr := 025;
			SET Par_ErrMen := 'El Grupo esta vacio.';
			SET Var_CodigoResp     :=	Par_NumErr;
			SET Var_CodigoDesc     :=  	Par_ErrMen;
			LEAVE ManejoErrores;
		END IF;
	END IF;

    IF(IFNULL(Par_Proyecto,Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr := 024;
        SET Par_ErrMen := 'El Proyecto esta vacio.';
		SET Var_CodigoResp     :=	Par_NumErr;
		SET Var_CodigoDesc     :=  	Par_ErrMen;
		LEAVE ManejoErrores;
	END IF;

	-- CALCULO DE LA TASA FIJA
    IF(Var_EsGrupal = Grupal_SI) THEN
		SET Var_GrupoID  := IFNULL(Par_GrupoID, Entero_Cero);
	END IF;

	-- Consultamos el Numero de Ciclos(Creditos) que ha tenido del mismo producto que sera unos de los inputs para el Esquema de Tasas
	CALL CRECALCULOCICLOPRO(
		Var_ClienteID,      	Par_ProspectoID,    Par_ProduCredID,    	Var_GrupoID,    	Var_CicloCliente,
		Var_CicloGrupal, 		SalidaNO,           Par_EmpresaID,      	Aud_Usuario,    	Aud_FechaActual,
		Aud_DireccionIP,    	Aud_ProgramaID,     Aud_Sucursal,       	Aud_NumTransaccion  );


	IF(Var_EsGrupal = Grupal_SI AND Var_TasaPonderaGru = PonderaTasa_SI) THEN
		SET Var_NumCiclos   := Var_CicloGrupal;
	ELSE
		SET Var_NumCiclos   := Var_CicloCliente;
	END IF;
    -- Fin Consulta Numero de Ciclos (Creditos)

	CALL ESQUEMATASACALPRO(
			Aud_Sucursal,		Par_ProduCredID,	Var_NumCiclos,		Par_MontoSolic,		Var_ClasifiCli,
            Var_TasaFija,		Par_PlazoID,		Entero_Cero,		Entero_Cero,		Var_NivelID,
            SalidaNO,			Par_NumErr,			Par_ErrMen,	        Par_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,    	Aud_Sucursal,       Aud_NumTransaccion);

	IF(IFNULL(Var_TasaFija,Entero_Cero)=Entero_Cero)THEN
		-- Si el calculo de los intereses es por tasa fija
		IF(Var_CalcInteres=TasaFijaID)THEN
			SET Par_ErrMen := 'No Existe un Esquema de Tasas para las Condiciones de la Solicitud.';
		ELSE -- Si es por tasa Variable
			SET Par_ErrMen := 'No Existe una Tasa Base Registrada para el Mes Anterior.';
		END IF;
		SET Par_NumErr 		:= 027;
		SET Var_CodigoResp  := Par_NumErr;
		SET Var_CodigoDesc  := Par_ErrMen;
		LEAVE ManejoErrores;
    END IF;
	-- FIN CALCULO DE LA TASA FIJA

	-- CALCULO DE NUMERO DE AMORTIZACION
	CASE (Par_Periodicidad)
		WHEN PagoQuincenal	THEN SET Fre_Dias	:=  FrecQuin;
		WHEN PagoCatorcenal THEN SET Fre_Dias	:=  FrecCator;
		WHEN PagoSemanal 	THEN SET Fre_Dias	:=  FrecSemanal;
		WHEN PagoMensual 	THEN SET Fre_Dias	:=  FrecMensual;
		WHEN PagoBimestral 	THEN SET Fre_Dias	:=  FrecBimestral;
		WHEN PagoTrimestral THEN SET Fre_Dias	:=  FrecTrimestral;
		WHEN PagoTetrames 	THEN SET Fre_Dias	:=  FrecTetrames;
		WHEN PagoSemestral 	THEN SET Fre_Dias	:=  FrecSemestral;
		WHEN PagoAnual 		THEN SET Fre_Dias	:=  FrecAnual;
		WHEN PagoPeriodo 	THEN SET Fre_Dias	:=  Entero_Cero;
		WHEN PagoUnico 		THEN SET Fre_Dias	:=  Entero_Cero;
		ELSE SET Fre_Dias	:=  Entero_Cero;
	END CASE;

	SET NumDias := (SELECT Dias
					FROM CREDITOSPLAZOS
					WHERE PlazoID = Par_PlazoID);

	SET Var_FecVencimiento := (SELECT DATE_ADD(Par_FechaReg, INTERVAL NumDias DAY));

	IF(Par_Periodicidad = PagoUnico) THEN
		SET Var_NumCuotas := 1;
	ELSE
		IF(Par_Periodicidad = PagoPeriodo)THEN
			SET Fre_Dias := NumDias;
		END IF;
		SET Var_NumCuotas := (NumDias / Fre_Dias);
	END IF;

	SET Var_NumCuotas := IFNULL(ROUND(Var_NumCuotas),0);
	-- FIN CALCULO DE NUMERO DE AMORTIZACION

	/* Se asigna un valor para la periodicidad de Capital y de Interes -----------*/
	CASE Par_Periodicidad
		WHEN PagoSemanal	THEN SET Var_PeriodoCapInt	:=  FrecSemanal;
		WHEN PagoCatorcenal	THEN SET Var_PeriodoCapInt	:=  FrecCator;
		WHEN PagoQuincenal	THEN SET Var_PeriodoCapInt	:=  FrecQuin;
		WHEN PagoMensual	THEN SET Var_PeriodoCapInt	:=  FrecMensual;
		WHEN PagoPeriodo	THEN SET Var_PeriodoCapInt  :=  Entero_Cero;
		WHEN PagoBimestral	THEN SET Var_PeriodoCapInt	:=  FrecBimestral;
		WHEN PagoTrimestral	THEN SET Var_PeriodoCapInt	:=  FrecTrimestral;
		WHEN PagoTetrames	THEN SET Var_PeriodoCapInt	:=  FrecTetrames;
		WHEN PagoSemestral	THEN SET Var_PeriodoCapInt	:=  FrecSemestral;
		WHEN PagoAnual		THEN SET Var_PeriodoCapInt	:=  FrecAnual;
	END CASE;

	SET Var_CalificaCli	:= (SELECT CalificaCredito
								FROM CLIENTES
									WHERE ClienteID = Var_ClienteID);
    /* Obtiene el porcentaje de garantia liquida si es que se requiere */
    IF(IFNULL(Var_RequiereGarantia,Constante_No)=Constante_Si)THEN
		/* Si si rerquiere, entonces se comprueba la existencia del porcentaje*/
		IF((EXISTS(SELECT Porcentaje FROM ESQUEMAGARANTIALIQ
						WHERE ProducCreditoID = Par_ProduCredID AND	Clasificacion = Var_CalificaCli AND Par_MontoSolic BETWEEN LimiteInferior AND LimiteSuperior))) THEN
			SELECT Porcentaje INTO Var_PorcGarLiq
				FROM ESQUEMAGARANTIALIQ
					WHERE ProducCreditoID = Par_ProduCredID
						AND	Clasificacion = Var_CalificaCli
						AND Par_MontoSolic BETWEEN LimiteInferior AND LimiteSuperior;
		ELSE
			SET Par_NumErr := 026;
			SET Par_ErrMen := 'No existe un Esquema de Garantia Liquida para el Producto de Credito.';
			SET Var_CodigoResp     :=	Par_NumErr;
			SET Var_CodigoDesc     :=  	Par_ErrMen;
			LEAVE ManejoErrores;
		END IF;
    END IF;

	-- CALCULO DE LA APORTACION DEL CLIENTE
    SET Var_AporteCliente := Par_MontoSolic * (Var_PorcGarLiq/Entero_Cien);

	-- CALCULO VALOR CAT
    CALL CALCULARCATPRO(
		Par_MontoSolic,		Var_NumCuotas,		Var_PeriodoCapInt,		SalidaNO, 		Par_ProduCredID,
       		Var_ClienteID, 		Entero_Cero,		Entero_Cero,			Var_ValorCAT,		Aud_NumTransaccion);

	# Se suman los dias correspondientes a la frecuencia,
	SET Var_FechaCobroComision := (SELECT FNSUMADIASFECHA(Aud_FechaActual,Var_PeriodoCapInt));
    SET Var_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Var_FechaCobroComision, 0, Par_EmpresaID));


	CALL SOLICITUDCREDITOALT (
		IFNULL(Par_ProspectoID,Entero_Cero), Var_ClienteID,	Par_ProduCredID,    	Par_FechaReg,				Entero_Uno,
		UPPER(Par_TipoCredito),	Par_NumCreditos,			Entero_Cero,        	Var_AporteCliente,			Entero_Uno,
		Par_DestinoCredID, 	 	UPPER(Par_Proyecto),		Aud_Sucursal,    		Par_MontoSolic,				Par_PlazoID,
		Var_FactorMora,	     	Decimal_Cero, 	    		Decimal_Cero,       	UPPER(Par_TipoDispersion),	Entero_Uno,
		Decimal_Cero,    	 	Var_TasaFija,    			Decimal_Cero,       	Decimal_Cero,				Decimal_Cero,

		Constante_Si, 	 	 	Constante_No, 				Constante_No,			Constante_No,				UPPER(Par_TipoPagoCapital),
		UPPER(Par_Periodicidad),UPPER(Par_Periodicidad),	Var_PeriodoCapInt,		Var_PeriodoCapInt,			DiaDelMes,
		DiaDelMes,    	 	 	Var_DiaPagoMes, 			Var_DiaPagoMes,      	Var_NumCuotas,				Entero_Cero,
		Var_ValorCAT,        	Par_CuentaCLABE,   			Entero_Uno,     		TipoFondeoRecPropios,		Entero_Cero,
		Entero_Cero,  	 	 	Var_NumCuotas,   			Decimal_Cero,       	Par_GrupoID,				Par_TipoIntegrante,

		Fecha_Vacia,     	 	Aud_FechaActual,			Decimal_Cero,		    Cadena_Vacia,				Var_ClasifDestinoCred,
		Entero_Cero,	     	Cadena_Vacia,				Cadena_Vacia,			Var_PorcGarLiq,				Aud_FechaActual,
		Decimal_Cero,	 	 	Decimal_Cero,				Cadena_Vacia,			Decimal_Cero,				Var_TipoConsultaSIC,
        Cadena_Vacia,			Cadena_Vacia,				Var_FechaCobroComision,	Entero_Cero,				Entero_Cero,
        Decimal_Cero,			Decimal_Cero,				Entero_Cero,        	Entero_Cero,				Cadena_Vacia,
        Entero_Cero,			Cadena_Vacia,				Cadena_Vacia,			Cadena_Vacia,				Cadena_Vacia,
        Entero_Cero,			Entero_Cero,				Cadena_Vacia,			Cadena_Vacia,				Cadena_Vacia,
        Entero_Cero,			Cadena_Vacia,				Cadena_Vacia,			Cadena_Vacia,
        SalidaNO,			 	Par_NumErr,					Par_ErrMen,				Par_EmpresaID,		 		Aud_Usuario,
        Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,        		Aud_NumTransaccion);

SET Entero_Cero  := 0;
IF(IFNULL(Par_NumErr,Entero_Cero) != Entero_Cero) THEN
	SET Var_CodigoDesc	:= Par_ErrMen;
	SET Var_CodigoResp	:= Par_NumErr;
	LEAVE ManejoErrores;
ELSE
	SET Var_CodigoResp		:= Par_NumErr;
	SET Var_CodigoDesc		:= 'La Solicitud de Credito fue Agregada Exitosamente.';
    SET Var_SolicitudID		:= '';
    SET Var_Posicion		:= LOCATE(Dos_Puntos, Par_ErrMen);
    SET Var_SolicitudID		:= SUBSTRING(Par_ErrMen, Var_Posicion);
    SET Var_Posicion		:= LOCATE(Espacio_Blanco, Var_SolicitudID);
    SET Var_SolicitudID		:= TRIM(SUBSTRING(Var_SolicitudID, Var_Posicion));
    IF (IFNULL(Var_SolicitudID, Cadena_Vacia)= Cadena_Vacia) THEN
		SET Var_SolicitudCre	:= Entero_Cero;
	ELSE
		SET Var_SolicitudCre	:= CAST(REPLACE(Var_SolicitudID, Dos_Puntos, Cadena_Vacia) AS SIGNED);
    END IF;
END IF;

END ManejoErrores;

IF (Var_CodigoResp != Entero_Cero)THEN 	-- SI HAY ERROR EN VALIDACIONES y en el alta
	SELECT Par_NumErr	 	  	    AS codigoRespuesta,
		 Var_CodigoDesc         	AS mensajeRespuesta,
		 Entero_Cero				AS solicitudCreditoID,
         Var_ClienteID				AS clienteID;
ELSE 									-- SI ES EXITO
	SELECT Var_CodigoResp 	  	    AS codigoRespuesta,
		 Var_CodigoDesc         	AS mensajeRespuesta,
		 Var_SolicitudCre	 	 	AS solicitudCreditoID,
         Var_ClienteID				AS clienteID;
END IF;

END TerminaStore$$