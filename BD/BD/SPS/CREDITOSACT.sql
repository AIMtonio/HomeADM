-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSACT`;
DELIMITER $$


CREATE PROCEDURE `CREDITOSACT`(
# ======================================================
# ------- STORE PARA ACTUALIZACION DE CREDITOS----------
# ======================================================
	Par_CreditoID       BIGINT(12),			-- Numero de Credito
	Par_NumTransSim     INT(11),  			-- Numero de transaccion del simulador
	Par_FechaAutoriza   DATE,				-- Fecha de Autorizacion
	Par_UsuarioAutoriza INT,				-- Usuario que autoriza
	Par_NumAct          TINYINT UNSIGNED,	-- Numero de Actualizacion

	Par_FechaInicio     DATE,				-- Fecha de Inicio
	Par_FechaVencim     DATE,				-- Fecha de Vencimiento
	Par_ValorCAT        DECIMAL(14,4),		-- Valor del CAT
	Par_MontoRetDes     DECIMAL(14,2),		-- Monto a Retener
	Par_FolioDisper     INT(11),			-- Folio de dispersion

	Par_TipoDisper	  	CHAR(1),			-- Parametro para la actualizacion de Tipo de Dispersion
	Par_TipoPrepago    	CHAR(1), 			-- Tipo de Prepago
	Par_GrupoID			INT(11),			-- Numero de Grupo

	Par_Salida          CHAR(1),			-- Salida S:SI  N:NO
	INOUT Par_NumErr    INT(11),			-- Numero de Error
	INOUT Par_ErrMen    VARCHAR(400),		-- Mensaje de Error

    -- Parametros de Auditoria
	Par_EmpresaID       INT(11),
	Aud_Usuario	        INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN
	/* Declaracion de Constantes */
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT;
	DECLARE Str_NO              	CHAR(1);
	DECLARE Act_Autoriza			INT;
	DECLARE Act_AutorizaAgro		INT;				# Actualizacion de creditos Agropecuarios
	DECLARE Act_PagareImp 			INT;
	DECLARE Estatus_Autorizada	    CHAR(1);
	DECLARE Estatus_Inactiva		CHAR(1);
	DECLARE Estatus_Vigente	    	CHAR(1);
    DECLARE Estatus_Cancelado		CHAR(1);
	DECLARE Estatus_Dispersado		CHAR(1);
	DECLARE Estatus_Desembolsado	CHAR(1);
	DECLARE Estatus_PagImp 			CHAR(1);
	DECLARE Var_Estatus				CHAR(1);
	DECLARE Act_numTransacSim 	    INT;
	DECLARE Act_CreditoAmor 		INT;
	DECLARE Act_FolioDisper        	INT;
	DECLARE Act_MontoDesem         	INT;
	DECLARE Act_TipoDisper         	INT; -- Declara constante para tipo de dispersion
	DECLARE Act_TipoDesemRev       	INT; -- Actualizacion para la reversa del desembolso
	DECLARE Act_TipoPrepago        	INT;
	DECLARE Act_AutorizaWS			INT;
    DECLARE Act_CancelGtiaAgro		INT(11);
    DECLARE Act_CancelaCredito		INT(11);
    DECLARE Act_AprovadoInfoComSI	INT(11);
    DECLARE Act_AprovadoInfoComNO	INT(11);
    DECLARE Act_CuentaClabe			INT(11);			-- Opcion para actualiza la cuenta clabe
    DECLARE Var_RequiereCheckList	CHAR(1); -- Indica si requiere Check List

	DECLARE NumTransaccion 			BIGINT(20);
	DECLARE NombreProceso       	VARCHAR(16);
	DECLARE SalidaNO            	CHAR(1);
	DECLARE SalidaSI            	CHAR(1);
	DECLARE TipoValiAutCre      	INT;
	DECLARE Var_Solictud        	INT(11);
	DECLARE Var_CreditoID			BIGINT(12);
	DECLARE FrecuencCapLib			CHAR(1);
	DECLARE FrecuencIntLib			CHAR(1);
	DECLARE TPagCapitalLib			CHAR(1);
	DECLARE Decimal_Cero        	DECIMAL(12,2);
	DECLARE Act_PagareGrupal		INT(11);
	DECLARE CondicionaSI			CHAR(1);
	DECLARE CondicionaNO			CHAR(1);
    DECLARE EstatusCanGtia			CHAR(1);
    DECLARE EsAgropecuario			CHAR(1);
	DECLARE Blo_Desemb          	INT(11);
	DECLARE DescripBloqSPEI     	VARCHAR(40);
	DECLARE DescripBloqCheq     	VARCHAR(40);
	DECLARE DescripBloqOrden		VARCHAR(50);
	DECLARE DescModificaMontoCred	VARCHAR(50);
	DECLARE Porcentaje				CHAR(1);
    DECLARE MontoComision			CHAR(1);
    DECLARE FormaFinanciada     	CHAR(1);
    DECLARE FormaAnticipada     	CHAR(1);
	DECLARE SiPagaIVA       		CHAR(1);
	DECLARE Cons_Si					CHAR(1);		-- Constante Si
	DECLARE Cons_No					CHAR(1);		-- Constante No
    DECLARE Per_Moral				CHAR(1);		-- Persona Moral
    DECLARE Per_Fisica				CHAR(1);		-- Persona Fisica
    DECLARE Per_Empre				CHAR(1);		-- Persona Fisica Act. Empresarial

	-- Declaracion de variables para desbloquear y bloquear credito
	DECLARE Var_CuentaID		 	BIGINT(12);
	DECLARE Var_MontoCre		 	DECIMAL(12,2);
	DECLARE Var_FechaSistema	 	DATE;
	DECLARE Var_TipoBloqueo		 	INT;
	DECLARE Var_Descripcion	 	 	VARCHAR(25);
	DECLARE Var_TipoDispersion   	CHAR(1);
	DECLARE Var_DisperEfec		 	CHAR(1);
	DECLARE Var_DisperSpei	 	 	CHAR(1);
	DECLARE Var_DisperOrden	 	 	CHAR(1);
	DECLARE Var_DisperChe		 	CHAR(1);
	DECLARE Nat_Bloqueo			 	CHAR(1);
	DECLARE Nat_Desbloqueo		 	CHAR(1);
	DECLARE Var_Bloqueado		 	CHAR(1);
	DECLARE Var_BloqueAct		 	CHAR(1);
	DECLARE TipVal_Individual    	INT(11);
	DECLARE CheckComple     	 	CHAR(1);
	DECLARE Var_MontoPorDesem	 	DECIMAL(14,2);
	DECLARE Var_FrecuencCap      	CHAR(1);
	DECLARE Var_FrecuencInt      	CHAR(1);
	DECLARE Var_ProduCredID      	INT;
	DECLARE Var_PagoCapital		 	CHAR(1);
	DECLARE Var_CicloActual		 	INT(11);
	DECLARE NumAmortizaciones    	INT;            -- Numero de Amortizaciones registradas en AMORTICREDITO -- VK
	DECLARE Pagare_Impreso		 	CHAR(1);
	DECLARE Var_EstCond			 	CHAR(1);
	DECLARE VarControl           	VARCHAR(100);
	DECLARE Var_Consecutivo      	BIGINT(20);
	DECLARE Var_BloqueoID			INT(11);
	DECLARE Var_ValorParametro		CHAR(1);
   	DECLARE Var_MontoComApProd		DECIMAL(12,2);
	DECLARE Var_TipoComXapert		CHAR(1);
	DECLARE Var_FormCobCom          CHAR(1);
	DECLARE Var_ComAperPagado		DECIMAL(12,2);
	DECLARE Var_MontoCredMod		DECIMAL(14,2);
    DECLARE Var_TotalPorcentaje		DECIMAL(12,4);
	DECLARE Var_IVASucursal			DECIMAL(12,2);
	DECLARE Var_ClienteID			INT(11);
    DECLARE Var_SucursalCliente		INT(11);
	DECLARE Var_ComApertura     	DECIMAL(12,4);
	DECLARE Var_ComAperturaIVA     	DECIMAL(12,4);
    DECLARE Var_MontoComApert		DECIMAL(12,2);
	DECLARE Var_IVAComApertura		DECIMAL(12,2);
	DECLARE Var_CliPagIVA   		CHAR(1);
	DECLARE Var_SucCredito      	INT(11);
	DECLARE Var_IVASucurs   		DECIMAL(12,2);
    DECLARE Var_ComAperCont			DECIMAL(12,2);
    DECLARE Var_IVAComAperCont		DECIMAL(12,2);
	DECLARE Var_ComAperConta		DECIMAL(12,2);
	DECLARE Var_IVAComAperConta		DECIMAL(12,2);
	DECLARE Var_ParticipanteID		BIGINT(20);			-- Numero de Participante
	DECLARE Var_TipoParticipante	CHAR(1);			-- Tipo de Participante
	DECLARE Var_MensajeNotificacion	VARCHAR(400);		-- Mensaje de Notificacion
	DECLARE Ope_Participante		TINYINT UNSIGNED;	-- Numero de Operacion para obtener el ID del participante
	DECLARE Inst_Credito			INT(11);			-- Instrumento Solicitud de Credito
	DECLARE Var_DetecNoDeseada		CHAR(1);			-- Valida la activación del proceso de personas no deseadas
    DECLARE Var_RFCOficial			CHAR(13);			-- RFC de la persona
    DECLARE Var_TipoPersona			CHAR(1);			-- Tipo de Persona Moral, Fisica, Fisica Act. Empresarial

	DECLARE Var_CuotaCompProyectada CHAR(1);			-- Tipo de Prepago Cuota Completas Proyectadas 'P'
	DECLARE Var_PermitePrepago		CHAR(1);			-- Permite Prepago
	DECLARE Var_TipoCalInteres		INT(11);			-- Tipo de Calculo de Interes 1 .- Saldos Insolutos 2 .- Monto Original (Saldos Globales)
	DECLARE Var_SaldosGlobales		INT(11);			-- 2 .- Monto Original (Saldos Globales)
	DECLARE Var_SaldosInsolutos		INT(11);			-- 1 .- Saldos Insolutos

    DECLARE Var_NCobraComAper		CHAR(1);		-- Variable para almacenar si convenio cobra comisión por apertura
	DECLARE Var_NManejaEsqConvenio	CHAR(1);		-- Variable para almacenar si convenio maneja esquemas de cobro de comisión por apertura
	DECLARE Var_NEsqComApertID		INT(11);		-- Variable para almacenar ID de esquema de cobro de comisión por apertura del convenio
	DECLARE Var_NTipoComApert		CHAR(1);		-- Variable para almacenar Tipo de cobro de comision por apertura del esquema del convenio
	DECLARE Var_NFormCobroComAper	CHAR(1);		-- Variable para almacenar Forma de cobro de comision por apertura del esquema por convenio
	DECLARE Var_NValor				DECIMAL(12,4);	-- Variable para almacenar el valor de comisión por apertura del esquema por convenio
	DECLARE Var_ConvenioNominaID	BIGINT UNSIGNED;-- Variable para almacenar el convenio de nomina del crédito
	DECLARE Var_InstitucionNominaID	INT(11);		-- Variable para almacenar la institución de nomina del crédito
	DECLARE Var_PlazoID				VARCHAR(20);	-- Variable para almacenar el plazo del crédito
	DECLARE Var_CuentaClabe			VARCHAR(18);	-- Variable de control para verificar si el credito tiene cuentaCLABE

	/* Asignacion de Constantes */
	SET Cadena_Vacia        		:= '';
	SET Fecha_Vacia         		:= '1900-01-01';
	SET Entero_Cero         		:= 0;
	SET Str_NO              		:= 'N';
	SET Estatus_Autorizada  		:= 'A';
	SET Estatus_Inactiva    		:= 'I';
	SET Estatus_Vigente	    		:= 'V';
	SET Estatus_PagImp      		:= 'S';
	SET Estatus_Dispersado          := 'P';
	SET Estatus_Desembolsado        := 'D';
	SET Aud_FechaActual     		:= CURRENT_TIMESTAMP();
	SET Act_Autoriza        		:= 1;           -- Tipo Actualizacion: Autorizacion del Credito
	SET Act_PagareImp       		:= 2;           -- Tipo Actualizacion: Pagare Impreso
	SET Act_numTransacSim   		:= 3;           -- Tipo Actualizacion: Numero de Transaccion de Simulador
	SET Act_CreditoAmor     		:= 4; 			-- Tipo Actualizacion: Fechas de inicio y vencim,Cat, despues de cotizar y grabar amortizaciones
	SET Act_FolioDisper     		:= 5;           -- Tipo Actualizacion: Folio de Dipersion
	SET Act_MontoDesem      		:= 6;           -- Tipo Actualizacion: Monto de Desembolso
	SET Act_TipoDisper	    		:= 7;			-- Tipo Actualizacion: Tipo de Dispersion
	SET Act_TipoDesemRev    		:= 8;			-- Tipo Actualizacion: Reversa de Desembolso
	SET Act_TipoPrepago     		:= 9;            -- Actualiza Tipo de Prepago por credito(Creditos Grupales)
	SET Act_PagareGrupal			:= 10;
	SET Act_AutorizaWS				:= 11;			-- Autorizacion por ws sin checklist
	SET Act_AutorizaAgro			:= 12;			-- Tipo de Actualizacion de creditos Agropecuarios
    SET Act_CancelGtiaAgro			:= 13;			-- Tipo de Actualizacion cancelar garantias fira
	SET Act_CancelaCredito			:= 14;			-- Tipo Actualizacion: Cancelacion de Credito
	SET Act_AprovadoInfoComSI		:= 15;			-- Tipo de Actualizacion aprovadoInfoComercio
	SET Act_AprovadoInfoComNO		:= 16;
	SET Act_CuentaClabe				:= 17;			-- Opcion para actualiza la cuenta clabe
    SET SalidaSI            		:= 'S';
	SET SalidaNO            		:= 'N';
	SET TipoValiAutCre      		:= 2;           -- tipo de validacion autorizacion de credito
	SET NombreProceso       		:= 'CREDITO';   -- Nombre del proceso que dispara el escalamiento interno de PLD de acuerdo a la tabla PROCESCALINTPLD


	SET Nat_Bloqueo					:= 'B';
	SET Nat_Desbloqueo				:= 'D';
	SET Var_TipoBloqueo   			:= 1;
	SET Var_DisperEfec				:= 'E';
	SET Var_DisperSpei				:= 'S';
	SET Var_DisperChe				:= 'C';
	SET Var_DisperOrden				:= 'O';
	SET TipVal_Individual  			:= 1;   			-- Validacion Grupal del CheckList de Creditos
	SET FrecuencCapLib				:= 'L';				-- Frecuencia de capital: Libre
	SET FrecuencIntLib				:= 'L';				-- Frecuencia de interes: LIbre
	SET TPagCapitalLib				:= 'L';             -- Tipo Pago Capital: Libre
	SET Decimal_Cero        		:= 0.0;             -- DECIMAL Cero
	SET CondicionaSI				:= 'S';
    SET EstatusCanGtia				:= 'C';				-- Estatus para cancelacion de garantias fira
    SET EsAgropecuario				:= 'S';				-- Indica si el credito es agropecuario
	SET Estatus_Cancelado			:= 'C';				-- Estatu: Cancelado
	SET Blo_Desemb          		:= 1;
	SET DescripBloqSPEI     		:= 'BLOQUEO DE SALDO POR SPEI';
	SET DescripBloqCheq     		:= 'BLOQUEO DE SALDO POR CHEQUE';
	SET DescripBloqOrden			:= 'BLOQUEO DE SALDO POR ORDEN DE PAGO';
    SET DescModificaMontoCred		:= 'ModificaMontoCred';	-- Descripcion valor Modifica Monto de Credito
	SET Porcentaje      		  	:= 'P';       -- Constante: Porcentaje
	SET MontoComision	     	  	:= 'M';       -- Constante: Monto
	SET FormaFinanciada     	  	:= 'F';       -- Forma de Cobro: FINANCIADA
	SET FormaAnticipada     	  	:= 'A';       -- Forma de Cobro: ANTICIPADA
	SET SiPagaIVA       			:= 'S';		  -- Cliente SI paga IVA
	SET Ope_Participante			:= 1;
	SET Inst_Credito				:= 6;
	SET Cons_No					:= 'N';
    SET Cons_Si					:= 'S';
    SET Per_Moral				:= 'M';
	SET Per_Fisica				:= 'F';
	SET Per_Empre				:= 'A';
	SET Var_CuotaCompProyectada		:= 'P';
	SET Var_SaldosGlobales			:= 2;
	SET Var_SaldosInsolutos			:= 1;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
										concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CREDITOSACT');
				SET VarControl := 'SQLEXCEPTION' ;
			END;

		# Modificacion del CAT con Cuotas Libres
		SELECT      ProductoCreditoID, FrecuenciaCap,     FrecuenciaInt ,	TipoPagoCapital
			INTO    Var_ProduCredID,   Var_FrecuencCap,   Var_FrecuencInt, Var_PagoCapital
			FROM CREDITOS WHERE CreditoID = Par_CreditoID;

		SELECT  CreditoID,		Estatus,		SolicitudCreditoID,		MontoCredito,	ComAperPagado,
				ClienteID,		MontoComApert,	IVAComApertura,			SucursalID,		ComAperCont,
                IVAComAperCont, InstitNominaID,	ConvenioNominaID,		PlazoID
				INTO
				Var_CreditoID,			Var_Estatus,				Var_Solictud,			Var_MontoCre,	Var_ComAperPagado,
                Var_ClienteID,			Var_MontoComApert,			Var_IVAComApertura,		Var_SucCredito,	Var_ComAperCont,
                Var_IVAComAperCont,		Var_InstitucionNominaID,	Var_ConvenioNominaID,	Var_PlazoID
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

		SET Var_Estatus := IFNULL(Var_Estatus, Cadena_Vacia);

        SELECT SucursalOrigen,		PagaIVA
        INTO Var_SucursalCliente,	Var_CliPagIVA
        FROM CLIENTES WHERE ClienteID = Var_ClienteID;

		SET Var_CliPagIVA   	:= IFNULL(Var_CliPagIVA, SiPagaIVA);

		IF(Var_Estatus = Cadena_Vacia AND Par_GrupoID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El credito no existe.';
			SET VarControl := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		-- Autorizacion de credito
		IF(Par_NumAct = Act_Autoriza) THEN

			SET Var_DetecNoDeseada := IFNULL((SELECT  PersonNoDeseadas FROM PARAMETROSSIS LIMIT 1),Cons_No);
			IF(Var_DetecNoDeseada = Cons_Si) THEN
			/*INICIO VALIDACIÓN DE PERSONAS NO DESEADAS*/
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
				Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

				IF(Par_NumErr!=Entero_Cero)THEN
					SET Par_NumErr			:= 050;
					SET Par_ErrMen			:= Par_ErrMen;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			/*FIN VALIDACIÓN DE PERSONAS NO DESEADAS*/
			-- Verifica si existen Amortizaciones registradas para el Credito
			-- En la tabla de AMORTICREDITO
			SELECT COUNT(AmortizacionID) AS Total INTO NumAmortizaciones
					FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID;

			IF(IFNULL(NumAmortizaciones,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 5;
				SET Par_ErrMen := 'Falta Grabar el Pagare de Credito.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Verifica si se Imprimio el Pagare de Credito
			SELECT PagareImpreso INTO Pagare_Impreso FROM CREDITOS WHERE CreditoID = Par_CreditoID;

			IF(IFNULL(Pagare_Impreso,Cadena_Vacia) != Estatus_PagImp ) THEN
				SET Par_NumErr := 6;
				SET Par_ErrMen := 'Falta Imprimir el Pagare de Credito.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Verifica si la Cuenta Asociada al Credito, tiene Saldo Disponible
			-- Si esa Cta, es de Bloqueo Automatico, entonces Desbloquea ese Saldo
			-- Y lo pone como Garantia Liquida.
			CALL CUEAHOBLOAUTCREPRO(
				Par_CreditoID,  SalidaNO,           Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
				Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion );

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Validaciones del credito en la Autorizacion
			CALL VALIDAPRODCREDPRO (
				Par_CreditoID,  Var_Solictud,   TipoValiAutCre,     SalidaNO,           Par_NumErr,
				Par_ErrMen,     Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Estatus_Autorizada) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'El Credito ya se encuentra Autorizado.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Validar si el Credito esta condicionado no  permitir su autorizacion, de lo contrario continuar con el proceso.
			SET Var_EstCond := (SELECT Condicionada FROM SOLICITUDCREDITO
								  WHERE SolicitudCreditoID = Var_Solictud);

			IF(Var_EstCond = CondicionaSI)THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'El Credito esta Condicionado.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;


			SET CheckComple := Cadena_Vacia;

          	SELECT 	Pro.RequiereCheckList
				INTO 	Var_RequiereCheckList
					FROM PRODUCTOSCREDITO Pro,
						 SOLICITUDCREDITO Sol
					WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
					AND Sol.solicitudCreditoID = Var_Solictud;

			-- Validar si requiere check List
			IF (ifnull(Var_RequiereCheckList,SalidaSI) = SalidaSI)THEN

				 -- validar que tenga el checklist de Creditos completo
				CALL CREDITODOCENTVAL(
					Par_CreditoID,      Entero_Cero,    TipVal_Individual,  CheckComple,        SalidaNO,
					Par_NumErr,         Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
					Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					SET Par_NumErr := 3;
					LEAVE ManejoErrores;
				END IF;

				IF(CheckComple = Str_NO) THEN
					SET Par_NumErr := 4;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Var_Estatus = Estatus_Inactiva) THEN

				UPDATE CREDITOS SET
					FechaAutoriza       = Par_FechaAutoriza,
					UsuarioAutoriza	    = Par_UsuarioAutoriza,
					Estatus			    = Estatus_Autorizada,

					EmpresaID           = Par_EmpresaID,
					Usuario			    = Aud_Usuario,
					FechaActual 		= Aud_FechaActual,
					DireccionIP 		= Aud_DireccionIP,
					ProgramaID  		= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion	    = Aud_NumTransaccion
				WHERE CreditoID = Par_CreditoID;

			END IF;

			# Actualiza estatus autorizado de credito
			CALL ESTATUSSOLCREDITOSALT(
			Var_Solictud,              Par_CreditoID,        Estatus_Autorizada,        Cadena_Vacia,             Cadena_Vacia,
			SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,
			Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Credito Autorizado.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

		-- Actualiza estatus de Pagare
		IF(Par_NumAct = Act_PagareImp)THEN

			UPDATE CREDITOS SET
				PagareImpreso   = Estatus_PagImp,

				EmpresaID       = Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
			WHERE CreditoID = Par_CreditoID;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Pagare Impreso.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;


		IF(Par_NumAct = Act_numTransacSim)THEN

			UPDATE CREDITOS SET
				NumTransacSim = Par_NumTransSim,

				EmpresaID       = Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion

			WHERE CreditoID = Par_CreditoID;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Actualizacion Registrada.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

		IF(Par_NumAct = Act_CreditoAmor)THEN

		   IF(IFNULL(Par_TipoPrepago,Cadena_Vacia)) != Cadena_Vacia  THEN

				IF(Par_TipoPrepago = Var_CuotaCompProyectada) THEN
					SET Var_PermitePrepago := (SELECT PermitePrepago FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProduCredID);
					SET Var_PermitePrepago := IFNULL(Var_PermitePrepago, Cons_No);
					SET Var_TipoCalInteres := (SELECT TipoCalInteres FROM CREDITOS WHERE CreditoID = Par_CreditoID);
					SET Var_TipoCalInteres := IFNULL(Var_TipoCalInteres,Var_SaldosInsolutos);

					IF(Var_PermitePrepago != Cons_Si  OR Var_TipoCalInteres != Var_SaldosGlobales)THEN
						SET Par_NumErr := 5;
						SET Par_ErrMen := 'El valor asignado para Tipo de Prepago es Incorrecto, solo Aplica para Saldos Globales';
						SET VarControl := 'creditoID';
						LEAVE ManejoErrores;
					END IF;

				END IF;


				UPDATE CREDITOS SET
					NumTransacSim   = Par_NumTransSim,
					FechaInicio     = Par_FechaInicio,
					FechaVencimien  = Par_FechaVencim,
					FechaMinistrado = Par_FechaInicio,
					ValorCAT        = Par_ValorCAT,

					TipoPrepago     = Par_TipoPrepago,

					EmpresaID       = Par_EmpresaID,
					Usuario         = Aud_Usuario,
					FechaActual     = Aud_FechaActual,
					DireccionIP     = Aud_DireccionIP,
					ProgramaID      = Aud_ProgramaID,
					Sucursal        = Aud_Sucursal,
					NumTransaccion  = Aud_NumTransaccion

				 WHERE CreditoID = Par_CreditoID;
			ELSE

				UPDATE CREDITOS SET
					NumTransacSim   = Par_NumTransSim,
					FechaInicio     = Par_FechaInicio,
					FechaVencimien  = Par_FechaVencim,
					FechaMinistrado = Par_FechaInicio,
					ValorCAT        = Par_ValorCAT,

					EmpresaID       = Par_EmpresaID,
					Usuario         = Aud_Usuario,
					FechaActual     = Aud_FechaActual,
					DireccionIP     = Aud_DireccionIP,
					ProgramaID      = Aud_ProgramaID,
					Sucursal        = Aud_Sucursal,
					NumTransaccion  = Aud_NumTransaccion

				 WHERE CreditoID = Par_CreditoID;
		  END IF;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Actualizacion Registrada.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

		IF(Par_NumAct = Act_FolioDisper)THEN

			UPDATE CREDITOS SET
				FolioDispersion	= Par_FolioDisper,

				EmpresaID       = Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
			WHERE CreditoID = Par_CreditoID;

			IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Credito Actualizado.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

		-- Desembolso en ventanilla
		IF(Par_NumAct = Act_MontoDesem)THEN

			SELECT MontoPorDesemb INTO Var_MontoPorDesem FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;

			SET Var_MontoPorDesem := IFNULL(Var_MontoPorDesem, Entero_Cero);

			IF(Par_MontoRetDes > Var_MontoPorDesem)THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'El Monto a Desembolsar es Mayor al Monto Pendiente de Desembolso.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE CREDITOS SET
				MontoPorDesemb	= MontoPorDesemb - Par_MontoRetDes,
				MontoDesemb		= MontoDesemb + Par_MontoRetDes,

				EmpresaID       = Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
			WHERE CreditoID = Par_CreditoID;

			# Actualizar estatus desembolsado de credito
			CALL ESTATUSSOLCREDITOSALT(
			Var_Solictud,              Par_CreditoID,        Estatus_Dispersado,      Cadena_Vacia,             Cadena_Vacia,
			SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,
			Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Credito Actualizado.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

		-- 8 Reversa de Desembolso del credito
		IF(Par_NumAct = Act_TipoDesemRev)THEN

			IF(Var_Estatus != Estatus_Vigente) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'El Credito no se Encuentra Vigente.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE CREDITOS SET
				MontoPorDesemb	= MontoPorDesemb + Par_MontoRetDes,
				MontoDesemb		= MontoDesemb  - Par_MontoRetDes,

				EmpresaID       = Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
			WHERE CreditoID = Par_CreditoID;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Reversa Realizada exitosamente.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

		-- 7.- Tipo Actualizacion: Tipo de Dispersion
		IF(Par_NumAct = Act_TipoDisper)THEN

			IF(Var_CreditoID = Par_CreditoID)THEN
				-- SE OBTIENE EL VALOR DEL PARAMETRO SI SE REALIZA MODIFICACION DEL MONTO DE CREDITO
				SELECT ValorParametro
				INTO Var_ValorParametro
				FROM PARAMGENERALES
				WHERE LlaveParametro = DescModificaMontoCred;

				SELECT TipoDispersion INTO Var_TipoDispersion
				FROM CREDITOS WHERE CreditoID  = Par_CreditoID;

				-- SI EL VALOR DEL PARAMETRO INDICA QUE SI SE REALIZA MODIFICACION DEL MONTO DE CREDITO
				IF(Var_ValorParametro = CondicionaSI)THEN

					-- SE OBTIENE EL MONTO DEL CREDITO MODIFICADO
					SET Var_MontoCredMod := Par_MontoRetDes;

					-- VALIDACIONES PARA CREDITOS AUTORIZADOS
					IF(Var_Estatus = Estatus_Autorizada)THEN
						-- SE VALIDA EL MONTO DEL CREDITO MODIFICADO
						IF((Var_MontoCredMod > Var_MontoCre || Var_MontoCredMod < Var_MontoCre))THEN
							SET Par_NumErr := 001;
							SET Par_ErrMen := 'Para modificar el Monto el estatus del Credito debe estar INACTIVO.';
							SET VarControl := 'creditoID';
							LEAVE ManejoErrores;
						END IF;
						SET Var_MontoCredMod := Var_MontoCre;
					END IF;

                    -- SE OBTIENE INFORMACION DEL PRODUCTO DE CREDITO PARA LAS COMISIONES POR APERTURA DEL CREDITO
					SELECT
						ForCobroComAper,	MontoComXapert,			TipoComXapert
					INTO
						Var_FormCobCom,		Var_MontoComApProd,		Var_TipoComXapert
					FROM PRODUCTOSCREDITO
					WHERE ProducCreditoID = Var_ProduCredID;


			#Validaciones de esquemas para comision apertura y mora por convenio de nómina
			IF(IFNULL(Var_InstitucionNominaID, Entero_Cero) > Entero_Cero AND IFNULL(Var_ConvenioNominaID, Entero_Cero) > Entero_Cero) THEN

			#Verifica si el convenio cobra comisión por apertura e interes moratorio;
				SELECT CobraComisionApert INTO Var_NCobraComAper FROM CONVENIOSNOMINA WHERE ConvenioNominaID = Var_ConvenioNominaID;
			#Busca esquemas configurados para comision apertura
				IF(Var_NCobraComAper = 'S') THEN

					SELECT 	EsqComApertID,		ManejaEsqConvenio
					INTO 	Var_NEsqComApertID,	Var_NManejaEsqConvenio
					FROM 	ESQCOMAPERNOMINA
					WHERE 	InstitNominaID 		= Var_InstitucionNominaID
					AND		ProducCreditoID		= Var_ProduCredID
					LIMIT 1;

					IF(Var_NManejaEsqConvenio = 'S') THEN
						SELECT 		FormCobroComAper,			TipoComApert,			Valor
						INTO 		Var_NFormCobroComAper,		Var_NTipoComApert,		Var_NValor
						FROM	COMAPERTCONVENIO
						WHERE		EsqComApertID = Var_NEsqComApertID
						AND		(ConvenioNominaID = Var_ConvenioNominaID OR ConvenioNominaID = Entero_Cero)
						AND 	PlazoID = Var_PlazoID
						AND		MontoMin <= Var_MontoCredMod
						AND		MontoMax >= Var_MontoCredMod LIMIT 1;

						IF( IFNULL(Var_NFormCobroComAper, Cadena_Vacia) = Cadena_Vacia OR	IFNULL(Var_NTipoComApert, Cadena_Vacia) = Cadena_Vacia) THEN
									SET Par_NumErr	:= 051;
									SET Par_ErrMen	:= 'No existe esquema configurado para comisión por apertura, empresa-convenio-plazo-monto';
									SET VarControl	:= 'plazoID';
									LEAVE ManejoErrores;
						ELSE
							SET Var_TipoComXapert := Var_NTipoComApert;
							SET Var_FormCobCom := Var_NFormCobroComAper;
							SET Var_MontoComApProd := Var_NValor;
						END IF;
					END IF;

				END IF;
			END IF;

					IF(Var_ClienteID <> Entero_Cero) THEN
						SET Var_IVASucursal := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_SucursalCliente);
					ELSE
						SET Var_IVASucursal := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
					END IF;

                    -- SI EL CLIENTE PAGA IVA SE OBTIENE EL IVA DE LA SUCURSAL DEL CREDITO
					IF(Var_CliPagIVA = SiPagaIVA)THEN
						SET	Var_IVASucurs	:= IFNULL((SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_SucCredito),  Entero_Cero);
					ELSE
						SET Var_IVASucurs	:= Decimal_Cero;
                    END IF;

                    -- SI COBRA COMISION POR APERTURA DE CREDITO
					IF(Var_MontoComApProd > Decimal_Cero) THEN
                        -- SI EL COBRO ES POR PORCENTAJE
						IF(Var_TipoComXapert = Porcentaje) THEN
							IF(Var_FormCobCom = FormaFinanciada) THEN
								SET Var_ComApertura 	:= ROUND(Var_MontoCredMod * (Var_MontoComApProd/100),2);
                                SET Var_ComAperturaIVA  := ROUND((Var_ComApertura * Var_IVASucurs),2);
                                SET Var_ComAperConta	:= Var_ComApertura;
								SET Var_IVAComAperConta	:= Var_ComAperturaIVA;
                                SET Var_MontoCredMod	:= Var_MontoCredMod + Var_ComApertura + Var_ComAperturaIVA;
							ELSE
								SET Var_ComApertura 	:= ROUND((Var_MontoCredMod * (Var_MontoComApProd/100)),2);
								SET Var_ComAperturaIVA  := ROUND((Var_ComApertura * Var_IVASucurs),2);
                                SET Var_ComAperConta	:= Var_ComApertura;
								SET Var_IVAComAperConta	:= Var_ComAperturaIVA;
							END IF;
						ELSE
							-- SI EL COBRO ES POR MONTO
							IF(Var_TipoComXapert = MontoComision) THEN
								SET Var_ComApertura 	:= ROUND(Var_MontoComApProd,2);
                                SET Var_ComAperturaIVA  := ROUND((Var_ComApertura * Var_IVASucurs),2);
								SET Var_ComAperConta	:= Var_ComApertura;
								SET Var_IVAComAperConta	:= Var_ComAperturaIVA;
							END IF;
						END IF;
					END IF;

                    -- SE VALIDA SI LA FORMA DE COBRO DE LA COMISION ES ANTICIPADA Y YA SE HAYA REALIZADO EL PAGO
                    IF(Var_FormCobCom = FormaAnticipada AND Var_ComAperPagado > Decimal_Cero)THEN
						SET Var_ComApertura 	:= Var_MontoComApert;
                        SET Var_ComAperturaIVA 	:= Var_IVAComApertura;
						SET Var_ComAperConta	:= Var_ComAperCont;
						SET Var_IVAComAperConta	:= Var_IVAComAperCont;
                    END IF;

                    SET Var_ComApertura 	:= IFNULL(Var_ComApertura,Decimal_Cero);
					SET Var_ComAperturaIVA 	:= IFNULL(Var_ComAperturaIVA,Decimal_Cero);
					SET Var_ComAperConta 	:= IFNULL(Var_ComAperConta,Decimal_Cero);
					SET Var_IVAComAperConta := IFNULL(Var_IVAComAperConta,Decimal_Cero);

					-- VALIDACIONES PARA CREDITOS INACTIVOS
					IF(Var_Estatus = Estatus_Inactiva)THEN
						-- STORE PARA EL REGISTRO DE CREDITOS DE MONTOS AUTORIZADOS MODIFICADOS
						CALL CREDITOSMONTOAUTOMODALT(
							Par_CreditoID,		Var_MontoCre,		Var_MontoCredMod,	SalidaNO,         	Par_NumErr,
							Par_ErrMen,   		Par_EmpresaID,     	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
							Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							SET VarControl := 'creditoID';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					UPDATE CREDITOS SET
						TipoDispersion  = Par_TipoDisper,
						MontoCredito    = Var_MontoCredMod,
						AporteCliente   = (Var_MontoCredMod * PorcGarLiq)/100,
                        MontoComApert	= Var_ComApertura,
						IVAComApertura  = Var_ComAperturaIVA,
                        ComAperCont		= Var_ComAperConta,
						IVAComAperCont  = Var_IVAComAperConta,

						EmpresaID       = Par_EmpresaID,
						Usuario         = Aud_Usuario,
						FechaActual     = Aud_FechaActual,
						DireccionIP     = Aud_DireccionIP,
						ProgramaID      = Aud_ProgramaID,
						Sucursal        = Aud_Sucursal,
						NumTransaccion  = Aud_NumTransaccion
					WHERE CreditoID = Par_CreditoID;
				END IF;

				-- SI EL VALOR DEL PARAMETRO INDICA QUE NO SE REALIZA MODIFICACION DEL MONTO DE CREDITO
                IF(Var_ValorParametro = Str_NO)THEN
					UPDATE CREDITOS SET
						TipoDispersion  = Par_TipoDisper,

						EmpresaID       = Par_EmpresaID,
						Usuario         = Aud_Usuario,
						FechaActual     = Aud_FechaActual,
						DireccionIP     = Aud_DireccionIP,
						ProgramaID      = Aud_ProgramaID,
						Sucursal        = Aud_Sucursal,
						NumTransaccion  = Aud_NumTransaccion
					WHERE CreditoID = Par_CreditoID;
                END IF;

				SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

                SELECT CuentaID, MontoCredito INTO Var_CuentaID, Var_MontoCre
				FROM CREDITOS WHERE CreditoID  = Par_CreditoID;

				SELECT	BloqueoID INTO Var_BloqueoID
				FROM BLOQUEOS
				WHERE	CuentaAhoID		= Var_CuentaID
				AND 	NatMovimiento 	= Nat_Bloqueo
				AND 	TiposBloqID 	= Blo_Desemb
				AND 	Referencia 		= Par_CreditoID
				AND 	FolioBloq 		= Entero_Cero
				AND 	( Descripcion 	= DescripBloqSPEI
						OR  Descripcion = DescripBloqCheq
						OR	Descripcion = DescripBloqOrden);

				SET Var_BloqueoID   := IFNULL(Var_BloqueoID, Entero_Cero);

				IF(Par_TipoDisper != Var_TipoDispersion AND Par_TipoDisper = Var_DisperEfec AND Var_BloqueoID <> Entero_Cero) THEN

					SET Var_Descripcion := 'DESBLOQUEO POR DISPERSION';

					CALL BLOQUEOSPRO(
						Var_BloqueoID,	    Nat_Desbloqueo,     Var_CuentaID,       Var_FechaSistema,       Var_MontoCre,
						Var_FechaSistema,   Var_TipoBloqueo,  	Var_Descripcion,    Par_CreditoID,     		Cadena_Vacia,
						Cadena_Vacia,       SalidaNO ,          Par_NumErr,         Par_ErrMen,   		    Par_EmpresaID,
						Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

				END IF;

				SET Par_NumErr      :=  Entero_Cero;
				SET Par_ErrMen      := 'Tipo de Desembolso Actualizado.';
				SET VarControl      := 'creditoID';
				SET Var_Consecutivo :=  Par_CreditoID;
			ELSE
				SET Par_NumErr := 1;
				SET Par_ErrMen :=  'El Credito no Existe' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_NumAct = Act_TipoPrepago)THEN

			IF(IFNULL(Par_TipoPrepago,Cadena_Vacia)) != Cadena_Vacia  THEN

				IF(Par_TipoPrepago = Var_CuotaCompProyectada) THEN
					SET Var_PermitePrepago := (SELECT PermitePrepago FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProduCredID);
					SET Var_PermitePrepago := IFNULL(Var_PermitePrepago, Cons_No);
					SET Var_TipoCalInteres := (SELECT TipoCalInteres FROM CREDITOS WHERE CreditoID = Par_CreditoID);
					SET Var_TipoCalInteres := IFNULL(Var_TipoCalInteres,Var_SaldosInsolutos);

					IF(Var_PermitePrepago != Cons_Si  OR Var_TipoCalInteres != Var_SaldosGlobales)THEN
						SET Par_NumErr := 5;
						SET Par_ErrMen := 'El valor asignado para Tipo de Prepago es Incorrecto, solo Aplica para Saldos Globales';
						SET VarControl := 'creditoID';
						LEAVE ManejoErrores;
					END IF;

				END IF;

				UPDATE CREDITOS SET
					TipoPrepago     = Par_TipoPrepago,

					EmpresaID       = Par_EmpresaID,
					Usuario         = Aud_Usuario,
					FechaActual     = Aud_FechaActual,
					DireccionIP     = Aud_DireccionIP,
					ProgramaID      = Aud_ProgramaID,
					Sucursal        = Aud_Sucursal,
					NumTransaccion  = Aud_NumTransaccion
				WHERE CreditoID = Par_CreditoID;
			END IF;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Credito Actualizado.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

		-- Actualiza estatus de Pagare
		IF(Par_NumAct = Act_PagareGrupal)THEN

			SELECT	CicloActual INTO Var_CicloActual
				FROM GRUPOSCREDITO
			WHERE GrupoID = Par_GrupoID;

			UPDATE CREDITOS SET
				PagareImpreso   = Estatus_PagImp,

				EmpresaID       = Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
			WHERE GrupoID = Par_GrupoID
				AND CicloGrupo = Var_CicloActual;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Pagare Impreso.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

		-- Autorizacion de credito
		IF(Par_NumAct = Act_AutorizaWS) THEN
			-- Verifica si existen Amortizaciones registradas para el Credito
			-- En la tabla de AMORTICREDITO
			SELECT COUNT(AmortizacionID) AS Total INTO NumAmortizaciones
					FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID;

			IF(IFNULL(NumAmortizaciones,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 5;
				SET Par_ErrMen := 'Falta Grabar el Pagare de Credito.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Verifica si se Imprimio el Pagare de Credito
			SELECT PagareImpreso INTO Pagare_Impreso FROM CREDITOS WHERE CreditoID = Par_CreditoID;

			IF(IFNULL(Pagare_Impreso,Cadena_Vacia) != Estatus_PagImp ) THEN
				SET Par_NumErr := 6;
				SET Par_ErrMen := 'Falta Imprimir el Pagare de Credito.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Verifica si la Cuenta Asociada al Credito, tiene Saldo Disponible
			-- Si esa Cta, es de Bloqueo Automatico, entonces Desbloquea ese Saldo
			-- Y lo pone como Garantia Liquida.
			CALL CUEAHOBLOAUTCREPRO(
				Par_CreditoID,  SalidaNO,           Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
				Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion );

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Validaciones del credito en la Autorizacion
			CALL VALIDAPRODCREDPRO (
				Par_CreditoID,  Var_Solictud,   TipoValiAutCre,     SalidaNO,           Par_NumErr,
				Par_ErrMen,     Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Estatus_Autorizada) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'El Credito ya se encuentra Autorizado.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Validar si el Credito esta condicionado no  permitir su autorizacion, de lo contrario continuar con el proceso.
			SET Var_EstCond := (SELECT Condicionada FROM SOLICITUDCREDITO
								  WHERE SolicitudCreditoID = Var_Solictud);

			IF(Var_EstCond = CondicionaSI)THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'El Credito esta Condicionado.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Estatus_Inactiva) THEN

				UPDATE CREDITOS SET
					FechaAutoriza       = Par_FechaAutoriza,
					UsuarioAutoriza	    = Par_UsuarioAutoriza,
					Estatus			    = Estatus_Autorizada,

					EmpresaID           = Par_EmpresaID,
					Usuario			    = Aud_Usuario,
					FechaActual 		= Aud_FechaActual,
					DireccionIP 		= Aud_DireccionIP,
					ProgramaID  		= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion	    = Aud_NumTransaccion
				WHERE CreditoID = Par_CreditoID;

			# Actualiza estatus autorizado de credito
			CALL ESTATUSSOLCREDITOSALT(
			Var_Solictud,              Par_CreditoID,        Estatus_Autorizada,        Cadena_Vacia,             Cadena_Vacia,
			SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,
			Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
			END IF;

			END IF;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Credito Autorizado.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

		IF(Par_NumAct = Act_AutorizaAgro) THEN
			-- Verifica si existen Amortizaciones registradas para el Credito
			-- En la tabla de AMORTICREDITO
			SELECT COUNT(AmortizacionID) AS Total INTO NumAmortizaciones
					FROM AMORTICREDITOAGRO WHERE CreditoID = Par_CreditoID;

			IF(IFNULL(NumAmortizaciones,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 5;
				SET Par_ErrMen := 'Falta Grabar el Pagare de Credito.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Verifica si se Imprimio el Pagare de Credito
			SELECT PagareImpreso INTO Pagare_Impreso FROM CREDITOS WHERE CreditoID = Par_CreditoID;

			IF(IFNULL(Pagare_Impreso,Cadena_Vacia) != Estatus_PagImp ) THEN
				SET Par_NumErr := 6;
				SET Par_ErrMen := 'Falta Imprimir el Pagare de Credito.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Verifica si la Cuenta Asociada al Credito, tiene Saldo Disponible
			-- Si esa Cta, es de Bloqueo Automatico, entonces Desbloquea ese Saldo
			-- Y lo pone como Garantia Liquida.
			CALL CUEAHOBLOAUTCREPRO(
				Par_CreditoID,  SalidaNO,           Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
				Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion );

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Validaciones del credito en la Autorizacion
			CALL VALIDAPRODCREDPRO (
				Par_CreditoID,  Var_Solictud,   TipoValiAutCre,     SalidaNO,           Par_NumErr,
				Par_ErrMen,     Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Estatus_Autorizada) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'El Credito ya se encuentra Autorizado.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Validar si el Credito esta condicionado no  permitir su autorizacion, de lo contrario continuar con el proceso.
			SET Var_EstCond := (SELECT Condicionada FROM SOLICITUDCREDITO
								  WHERE SolicitudCreditoID = Var_Solictud);

			IF(Var_EstCond = CondicionaSI)THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'El Credito esta Condicionado.';
				SET VarControl := 'creditoID';
				LEAVE ManejoErrores;
			END IF;


			SET CheckComple := Cadena_Vacia;

            SELECT 	Pro.RequiereCheckList
				INTO 	Var_RequiereCheckList
					FROM PRODUCTOSCREDITO Pro,
						 SOLICITUDCREDITO Sol
					WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
					AND Sol.solicitudCreditoID = Var_Solictud;

			-- Validar si requiere check List
			IF (ifnull(Var_RequiereCheckList,SalidaSI) = SalidaSI)THEN
				 -- validar que tenga el checklist de Creditos completo
				CALL CREDITODOCENTVAL(
					Par_CreditoID,      Entero_Cero,    TipVal_Individual,  CheckComple,        SalidaNO,
					Par_NumErr,         Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
					Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					SET Par_NumErr := 3;
					LEAVE ManejoErrores;
				END IF;

				IF(CheckComple = Str_NO) THEN
					SET Par_NumErr := 4;
					LEAVE ManejoErrores;
				END IF;
			END IF;


			IF(Var_Estatus = Estatus_Inactiva) THEN

				UPDATE CREDITOS SET
					FechaAutoriza       = Par_FechaAutoriza,
					UsuarioAutoriza	    = Par_UsuarioAutoriza,
					Estatus			    = Estatus_Autorizada,

					EmpresaID           = Par_EmpresaID,
					Usuario			    = Aud_Usuario,
					FechaActual 		= Aud_FechaActual,
					DireccionIP 		= Aud_DireccionIP,
					ProgramaID  		= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion	    = Aud_NumTransaccion
				WHERE CreditoID = Par_CreditoID;

				IF (IFNULL(Var_RequiereCheckList, SalidaSI) = SalidaSI) THEN

                    -- Notificacion de Documentos de Guarda Valores
					SET Var_ParticipanteID := IFNULL(FNPARTICIPANTEGRDVALORES(Inst_Credito, Par_CreditoID, Ope_Participante), Entero_Cero);
					SET Var_TipoParticipante := IFNULL(FNTIPOPARTICIPANTEGRDVALORES(Inst_Credito, Par_CreditoID), Cadena_Vacia);

					CALL NOTIFCACORREOGRDVALPRO (
						Var_ParticipanteID,		Var_TipoParticipante,	Str_NO,				Par_NumErr, 		Var_MensajeNotificacion,
						Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,			Aud_NumTransaccion);
						SET Par_NumErr := Entero_Cero;
				END IF;

			END IF;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Credito Autorizado.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

			-- Actualiza estatus de las garantias fira a canceladas
		IF(Par_NumAct = Act_CancelGtiaAgro)THEN

			UPDATE CREDITOS SET
					EstatusGarantiaFIRA	= EstatusCanGtia,

					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual    		= Aud_FechaActual,
					DireccionIP     	= Aud_DireccionIP,
					ProgramaID      	= Aud_ProgramaID,
					Sucursal        	= Aud_Sucursal,
					NumTransaccion  	= Aud_NumTransaccion
				WHERE	CreditoID 		= Par_CreditoID
				AND		EsAgropecuario	= EsAgropecuario;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Cancelacion de Garantia Realizada Exitosamente.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

        IF(Par_NumAct = Act_CancelaCredito)THEN
			SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

            UPDATE SOLICITUDCREDITO Sol
				LEFT JOIN CREDITOS Cre	ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
				LEFT JOIN AMORTICREDITO Amo ON Amo.CreditoID = Cre.CreditoID
			SET	Sol.Estatus  		= Estatus_Cancelado,
				Cre.Estatus  		= Estatus_Cancelado,
				Amo.Estatus  		= Estatus_Cancelado,
				Sol.FechaCancela 	= Var_FechaSistema,
				Sol.EmpresaID		= Par_EmpresaID,
				Sol.Usuario			= Aud_Usuario,
				Sol.FechaActual		= Aud_FechaActual,
				Sol.DireccionIP		= Aud_DireccionIP,
				Sol.ProgramaID		= Aud_ProgramaID,
				Sol.Sucursal		= Aud_Sucursal,
				Sol.NumTransaccion	= Aud_NumTransaccion,
				Cre.EmpresaID		= Par_EmpresaID,
				Cre.Usuario			= Aud_Usuario,
				Cre.FechaActual		= Aud_FechaActual,
				Cre.DireccionIP		= Aud_DireccionIP,
				Cre.ProgramaID		= Aud_ProgramaID,
				Cre.Sucursal		= Aud_Sucursal,
				Cre.NumTransaccion	= Aud_NumTransaccion,
				Amo.EmpresaID		= Par_EmpresaID,
				Amo.Usuario			= Aud_Usuario,
				Amo.FechaActual		= Aud_FechaActual,
				Amo.DireccionIP		= Aud_DireccionIP,
				Amo.ProgramaID		= Aud_ProgramaID,
				Amo.Sucursal		= Aud_Sucursal,
				Amo.NumTransaccion	= Aud_NumTransaccion

		WHERE Cre.CreditoID = Par_CreditoID;


			/* SE QUITA LA CUENTA CLABE AL CREDITO*/
			UPDATE CREDITOS Cre
				SET Cre.CuentaCLABE = Cadena_Vacia
			WHERE Cre.CreditoID = Par_CreditoID;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Credito Cancelado.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;
		END IF;

		IF(Par_NumAct = Act_AprovadoInfoComSI) THEN

			UPDATE CREDITOS SET
				aprobadoInfoComercial = Cons_Si
			WHERE CreditoID = Par_CreditoID;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Actualizada la aprovacion de la informacion comercial exitosamente. ';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;
		IF(Par_NumAct = Act_AprovadoInfoComNO) THEN

			UPDATE CREDITOS SET
				aprobadoInfoComercial = Cons_No
			WHERE CreditoID = Par_CreditoID;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Actualizada la aprovacion de la informacion comercial exitosamente.';
			SET VarControl      := 'creditoID';
			SET Var_Consecutivo :=  Par_CreditoID;

		END IF;

		-- Generacion y actualizacion de Cuenta clabe del Credito
		IF(Par_NumAct = Act_CuentaClabe) THEN
			SELECT 		CreditoID
				INTO 	Var_CreditoID
				FROM CREDITOS 
				WHERE CreditoID = Par_CreditoID;

			IF(IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'No se encontro informacion con el numero de credito proporcionado.';
				SET VarControl  := 'creditoID';
				SET Var_Consecutivo := Par_CreditoID;
				LEAVE ManejoErrores;
			END IF;

			CALL SPEIGENCUENTACLABECREPRO(
				Par_CreditoID, 		Cons_No,			Par_NumErr,				Par_ErrMen,			Var_CuentaClabe,
				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			);

			IF(Par_NumErr <> Entero_Cero) THEN
				SET VarControl      := 'creditoID';
				SET Var_Consecutivo :=  Par_CreditoID;
				LEAVE ManejoErrores;
			END IF;

			UPDATE CREDITOS
				SET Clabe = Var_CuentaClabe,
					EmpresaID = Par_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE CreditoID = Par_CreditoID;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT("Cuenta Clabe generada correctamente:", Var_CuentaClabe);
			SET VarControl  := 'creditoID';
			SET Var_Consecutivo := Par_CreditoID;
		END IF;
	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr          AS Par_NumErr,
				Par_ErrMen          AS ErrMen,
				VarControl          AS control,
				Var_Consecutivo     AS consecutivo;
	END IF;

END TerminaStore$$
