-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIRECEPCIONESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESPRO`;
DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESPRO`(
-- =====================================================================================
-- ------- STORE PARA PROCESAR LAS RECEPCIONES SPEI  Y DARLAS DE ALTA ---------
-- =====================================================================================
	INOUT Par_FolioSpei		BIGINT,
	Par_TipoPago		   	INT(2),
	Par_TipoCuentaOrd	   	INT(2),
	Par_CuentaOrd		   	VARCHAR(20),
	Par_NombreOrd		   	VARCHAR(100),

	Par_RFCOrd	           	VARCHAR(18),
	Par_TipoOperacion	   	INT(2),
	Par_MontoTransferir	   	DECIMAL(16,2),
	Par_IVA				   	DECIMAL(16,2),
	Par_InstiRemitente	   	INT(5),

	Par_InstiReceptora	   	INT(5),
	Par_CuentaBeneficiario 	VARCHAR(20),
	Par_NombreBeneficiario 	VARCHAR(40),
	Par_RFCBeneficiario	   	VARCHAR(18),
	Par_TipoCuentaBen	   	INT(2),

	Par_ConceptoPago	   	VARCHAR(210),
	Par_ClaveRastreo	   	VARCHAR(30),
	Par_CuentaBenefiDos    	VARCHAR(20),
	Par_NombreBenefiDos    	VARCHAR(40),
	Par_RFCBenefiDos	   	VARCHAR(18),

	Par_TipoCuentaBenDos   	INT(2),
	Par_ConceptoPagoDos    	VARCHAR(40),
	Par_ClaveRastreoDos	   	VARCHAR(30),
	Par_ReferenciaCobranza 	VARCHAR(40),
	Par_ReferenciaNum      	INT(7),

	Par_Prioridad    	   	INT(1),
	Par_FechaCaptura       	DATETIME,
	Par_ClavePago          	VARCHAR(10),
	Par_AreaEmiteID	       	INT(2),
	Par_EstatusRecep       	INT(3),

	Par_CausaDevol         	INT(2),
	Par_InfAdicional       	VARCHAR(100),
	Par_Firma              	VARCHAR(250),
	Par_Folio              	BIGINT(20),
	Par_FolioBanxico       	BIGINT(20),

	Par_FolioPaquete       	BIGINT(20),
	Par_FolioServidor      	BIGINT(20),
	Par_Topologia          	CHAR(1),

	Par_Salida			   	CHAR(1),
	INOUT Par_NumErr	   	INT,
	INOUT Par_ErrMen	   	VARCHAR(400),

	Par_EmpresaID		   	INT(11),
	Aud_Usuario			   	INT(11),
	Aud_FechaActual		   	DATETIME,
	Aud_DireccionIP		   	VARCHAR(20),
	Aud_ProgramaID		   	VARCHAR(50),
	Aud_Sucursal		   	INT(11),
	Aud_NumTransaccion	   	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	 CHAR(1);
	DECLARE	Entero_Cero		 INT;
	DECLARE	Decimal_Cero	 DECIMAL(18,2);
	DECLARE	Fecha_Vacia		 DATE;
	DECLARE Salida_SI 		 CHAR(1);
	DECLARE	Salida_NO		 CHAR(1);
	DECLARE	Num_Uno 		 INT;
	DECLARE Mon_Pesos		 INT;
	DECLARE Str_Coma		 CHAR(1);
	DECLARE	AltaPoliza_NO	 CHAR(1);
	DECLARE	AltaPoliza_SI	 CHAR(1);
	DECLARE CtoConRec_Spei	 INT;
	DECLARE	AltaMovAhorro_SI CHAR(1);
	DECLARE Nat_Abono		 CHAR(1);
	DECLARE Nat_Cargo		 CHAR(1);
	DECLARE	CtoAho_Spei		 INT;
	DECLARE Est_Bloqueada    CHAR(1);
	DECLARE Est_Cancelada    CHAR(1);
	DECLARE Est_Aut          CHAR(1);
	DECLARE tipoPagoCua		 INT(2);         -- Tipo pago sea 4
	DECLARE ImporteMaximo    DECIMAL(20,2);  -- Importe maximo para tranferir spei
	DECLARE Est_Activo		 CHAR(1);
	DECLARE	Tp_tt            INT(2);         -- tipo de pago tercero a tercero
	DECLARE	Tp_ttv           INT(2);         -- tipo de pago tercero a tercero vostro
	DECLARE	Tp_pp            INT(2);         -- tipo de pago participante a participante
	DECLARE	Tp_nom           INT(2);         -- Tipo de pago nomina
	DECLARE Tp_tv            INT(2);         -- tipo de pago de tercero a ventanilla
	DECLARE Tp_tp            INT(2);         -- tipo de pago de tercero a participante
	DECLARE Tp_pt            INT(2);         -- Tipo de pago de participante a tercero
	DECLARE Tp_ptv           INT(2);         -- Tipo de pago de participante a tercero vostro
	DECLARE Tp_ttfsw         INT(2);         -- tipo de pago de tercero a tercero fsw
	DECLARE Tp_ttvfsw        INT(2);         -- tipo de pago de tercero a tercero vostro fsw
	DECLARE Tp_ptfsw         INT(2);         -- tipo de pago de participante a tercero fsw
	DECLARE Tp_ptvfsw        INT(2);         -- tipo de pago de participante a tercero vostro fsw
	DECLARE AltaMovAhorro_NO CHAR(1);
	DECLARE Cta_Fondeo       CHAR(1);        -- tipo de cuenta fondeo
	DECLARE Cta_Aho          CHAR(1);        -- tipo de cuenta ahorro

	-- Declaracion de Variables
	DECLARE Var_NumEnvio	  	BIGINT(20);    	-- Numero de envio
	DECLARE Var_Control	      	VARCHAR(200);  	-- Variable de control
	DECLARE Var_Consecutivo	  	BIGINT(20);     -- Variable consecutivo
	DECLARE Var_ClaveRas      	VARCHAR(30);    -- clave de rastreo del spei
	DECLARE Var_PrioEnvio	  	INT(1);         -- prioridad de envio
	DECLARE Var_FechaAuto     	DATETIME;       -- Fecha de autorizacion
	DECLARE Var_EstatusEnv    	INT(3);         -- Estatus de envio
	DECLARE Var_ClavePago     	VARCHAR(10);    -- Clave de pago
	DECLARE Var_Estatus       	CHAR(1);        -- estatus del safi
	DECLARE Var_FechaRecep    	DATETIME;       -- fecha de recepcion
	DECLARE Var_FechaEnvio    	DATETIME;       -- fecha envio
	DECLARE Var_CausaDevol    	INT(2);         -- causa devolucion
	DECLARE Var_InstiRemi     	INT(5);         -- Institucion remitente
	DECLARE Var_AutTeso       	CHAR(1);        -- si el spei necesita autorizacion de tesoreria
	DECLARE Var_MonReqVen     	DECIMAL(18,2) ; -- Monto a partir del cual spei necesita autorizacion de tesoreria
	DECLARE Var_ClienteID	  	INT;			-- Numero de Cliente
	DECLARE	Var_DesInsRem	  	VARCHAR(100);	-- Nombre de Intitucion Remitente
	DECLARE Var_Referencia	  	VARCHAR(50);	-- Referencia
	DECLARE	Var_Poliza        	BIGINT;			-- Numero de Poliza
	DECLARE Var_CuentaBenID	  	INT(12);		-- Numero de cuenta del Beneficiario
	DECLARE	Var_DescMov		  	VARCHAR(150);	-- Descripcion de Movimiento
	DECLARE Var_CuentaAho     	BIGINT(12);      -- cuenta ahorro
	DECLARE	Var_InstitucionID 	INT;          	-- Institucion ID
	DECLARE	Var_CuentaBancos  	VARCHAR(20);  	-- Cuenta de bancos
	DECLARE Var_Banco         	INT(11);      	-- Banco
	DECLARE Var_MontoDev	  	DECIMAL(16,2);	-- Monto de la devolucion
	DECLARE Var_Moneda        	INT(11);      	-- Moneda de la cuenta
	DECLARE Var_ClabePartici  	VARCHAR(18);	-- Clabe Spei del Participante
	DECLARE Var_InstPartici	  	INT(5);			-- ID de Institucion Participante
	DECLARE Var_EstCli		  	CHAR(1);	    -- Estatus del CLiente
	DECLARE Var_TipoCuenta    	CHAR(1);      	-- Tipo Cuenta
	DECLARE Var_Conse         	INT;
	DECLARE Var_FechaSis      	DATE;         	-- fecha sistema
	DECLARE Var_EstatusPago   	CHAR(1);      	-- estatus de tipo de pago
	DECLARE Var_TipoPagoEnvio 	INT(2);       	-- Var tipo de pago de speienvios
	DECLARE Var_CreditoID 		BIGINT(12); 	-- CreditoID

	DECLARE Var_Refere		  	VARCHAR(35);
	DECLARE Var_Automatico    	CHAR(1);
	DECLARE Var_TipoMovIDC	  	INT;
	DECLARE Var_TipoMovIDA	  	INT;
	DECLARE Par_Consecutivo	  	BIGINT;
	DECLARE Var_CuentaAhoIDS	BIGINT(12);
	DECLARE	Var_InstiIDS		INT(11);
	DECLARE	Var_NumCtaInstitS	VARCHAR(20);
	DECLARE Folio		        BIGINT(20);
	DECLARE ConceptoRemesasEnv  VARCHAR(40);
	DECLARE Var_FechaOpe    	DATE;       	-- fecha operacion

    DECLARE Cons_SI 		 	CHAR(1);		-- Constante SI
    DECLARE Blo_SPEI	  		INT;			-- Tipo de bloqueo SPEI
	DECLARE Var_BloqueoRecep    CHAR(1);		-- Bloqueo de Recepcion SPEI
	DECLARE Var_MontoMinBloqueo DECIMAL(16,2);	-- Monto de Bloqueo de Recepcion SPEI
	DECLARE ConceptoRecepcion  	VARCHAR(40);	-- Concepto de Recepcion SPEI
	DECLARE	Cuenta_Vacia		VARCHAR(25);	-- Cuenta Contable Vacia
	DECLARE	Var_CtaTesoreria	CHAR(25);		-- Cuenta Participante a Participate
	DECLARE	Var_MovParticipante	INT;			-- Tipo de Movimiento SPEI
	DECLARE Var_CentroCostosID	INT(11);		-- ID Centro de Costos

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';             -- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01 00:00:00';   -- Fecha Vacia
	SET	Entero_Cero			:= 0;              -- Entero Cero
	SET	Decimal_Cero		:= 0.0;            -- Decimal cero
	SET Salida_SI 	   		:= 'S';            -- Salida SI
	SET	Salida_NO			:= 'N';            -- Salida NO
	SET Num_Uno         	:= 1;              -- Entero uno
	SET Mon_Pesos			:= 1;			   -- Moneda Pesos
	SET	Str_Coma			:= ',';			   -- Separador
	SET	AltaPoliza_NO		:= 'N';			   -- No Alta de Poliza
	SET	AltaPoliza_SI		:= 'S';			   -- Si Alta de Poliza
	SET CtoConRec_Spei		:= 809;		       -- Concepto Contable de RECEPCION SPEI
	SET AltaMovAhorro_SI	:= 'S';	           -- Si Alta Movimientos Ahorro
	SET Nat_Abono	    	:= 'A';			   -- Tipo Abono
	SET Nat_Cargo	    	:= 'C';			   -- Tipo Cargo
	SET CtoAho_Spei			:= 1;			   -- Concepto Ahorro Pasivo
	SET Est_Bloqueada   	:= 'B';            -- Estatus bloqueado
	SET Est_Cancelada   	:= 'C';            -- Estatus cancelada
	SET Est_Activo			:= 'A';			   -- Estatus Activo
	SET Est_Aut         	:= 'A';            -- Estatus autorizada
	SET tipoPagoCua     	:= 4;              -- tipo de pago sea 4
	SET ImporteMaximo   	:= 999999999999.99;-- importe maximo para las transferencias spei
	SET	Tp_tt           	:= 1;              -- tipo de pago tercero a tercero
	SET Tp_tv           	:= 2;              -- tipo de pago de tercero a ventanilla
	SET	Tp_ttv          	:= 3;              -- tipo de pago tercero a tercero vostro
	SET Tp_tp           	:= 4;              -- tipo de pago de tercero a participante
	SET Tp_pt           	:= 5;              -- Tipo de pago de participante a tercero
	SET Tp_ptv          	:= 6;              -- Tipo de pago de participante a tercero vostro
	SET	Tp_pp           	:= 7;              -- tipo de pago participante a participante
	SET Tp_ttfsw        	:= 8;              -- tipo de pago de tercero a tercero fsw
	SET Tp_ttvfsw       	:= 9;              -- tipo de pago de tercero a tercero vostro fsw
	SET Tp_ptfsw        	:= 10;             -- tipo de pago de participante a tercero fsw
	SET Tp_ptvfsw       	:= 11;             -- tipo de pago de participante a tercero vostro fsw
	SET	Tp_nom          	:= 12;             -- Tipo de pago nomina
	SET AltaMovAhorro_NO 	:= 'N';		   	   -- no se realiza afectacion en las cuentas de ahorro
	SET Cta_Fondeo      	:= 'F';            -- tipo de cuenta fondeo
	SET Cta_Aho         	:= 'A';            -- tipo de cuenta ahorro

	SET Var_Poliza			:= 0;			   -- Inicializar Poliza
	SET	Var_NumEnvio   		:= 0;              -- Numero de Envio
	SET Var_Conse       	:= 0;

	SET Var_Automatico 		:= 'P';
	SET Var_TipoMovIDC		:= 13;
	SET Var_TipoMovIDA		:= 14;
	SET Folio           	:= 0;			   	-- folio de spei
	SET Var_FechaOpe      	:= (SELECT	FechaSistema	FROM	PARAMETROSSIS);
	SET ConceptoRemesasEnv	:= 'ENVIO DE DINERO';

	SET	Var_DescMov := Cadena_Vacia;

	SET Cons_SI 	   		:= 'S';            				-- Constante SI
	SET Blo_SPEI			:= 16;							-- Tipo de bloqueo Automatico por SPEI
	SET ConceptoRecepcion	:= 'POLIZASPEIPRO';				-- Instrumento
	SET	Cuenta_Vacia		:= '0000000000000000000000000';	-- Cuenta Contable Vacia
	SET	Var_MovParticipante	:= 27;							-- Tipo de Movimiento para Detalle Poliza
	SET Var_CentroCostosID	:= 0;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIRECEPCIONESPRO');
				SET Var_Control = 'sqlException';
			END;

		IF NOT EXISTS (SELECT	TipoPagoID
			FROM TIPOSPAGOSPEI
			WHERE	TipoPagoID = Par_TipoPago) THEN
				SET Par_NumErr 	:= 015;
				SET Par_ErrMen 	:='Tipo de pago Erroneo. tipoPago';
				SET Var_Control	:=  'Devolucion' ;
				LEAVE ManejoErrores;
		END IF;
		-- validacion que el tipo de pago este activo
		SET Var_EstatusPago :=(SELECT	Estatus	FROM TIPOSPAGOSPEI	WHERE	TipoPagoID = Par_TipoPago);

		IF (Var_EstatusPago != Est_Activo) THEN
			SET Par_NumErr 	:= 015;
			SET Par_ErrMen 	:= 'Tipo de pago erroneo. estatusPago';
			SET Var_Control	:= 'Devolucion' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT	PS.Clabe,			PS.ParticipanteSpei,	CO.CuentaAhoID,		CT.NumCtaInstit,		CT.InstitucionID,	PS.BloqueoRecepcion,	PS.MontoMinimoBloq,		IFNULL(CtaContableTesoreria,Cuenta_Vacia)
		 INTO 	Var_ClabePartici, 	Var_InstPartici,		Var_CuentaAhoIDS,	Var_NumCtaInstitS,		Var_InstiIDS,		Var_BloqueoRecep,		Var_MontoMinBloqueo,	Var_CtaTesoreria
			FROM PARAMETROSSPEI PS
				JOIN CUENTASAHOTESO CT ON  PS.Clabe		= CT.CueClave
				JOIN CUENTASAHO CO ON CT.CuentaAhoID	= CO.CuentaAhoID
				JOIN CLIENTES CTE ON CO.ClienteID		= CTE.ClienteID
			WHERE	PS.EmpresaID	= Par_EmpresaID;

		-- -----------------------TIPO DE PAGO CERO-------------------------------
		IF(Par_TipoPago = Entero_Cero) THEN
			IF EXISTS(SELECT	ClaveRastreo
				FROM SPEIENVIOS
				WHERE	ClaveRastreo = Par_ClaveRastreo) THEN

				SELECT
						TipoCuentaOrd,
						LEFT(FNDECRYPTSAFI(CuentaOrd),20),
						LEFT(FNDECRYPTSAFI(NombreOrd),40),
						LEFT(FNDECRYPTSAFI(RFCOrd),15),
						TipoOperacion,
						CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),
						IVAPorPagar,				InstiRemitenteID,			InstiReceptoraID,
						LEFT(FNDECRYPTSAFI(CuentaBeneficiario),20),
						LEFT(FNDECRYPTSAFI(NombreBeneficiario),40),
						LEFT(FNDECRYPTSAFI(RFCBeneficiario),18),
						TipoCuentaBen,
						LEFT(FNDECRYPTSAFI(ConceptoPago),40),
						ReferenciaCobranza,
						ReferenciaNum,				PrioridadEnvio,				ClavePago,					AreaEmiteID, 			CuentaAho,
						TipoPagoID
				  INTO  Par_TipoCuentaBen,			Par_CuentaBeneficiario,		Par_NombreBeneficiario,		Par_RFCBeneficiario,	Par_TipoOperacion,
						Par_MontoTransferir,		Par_IVA,					Par_InstiReceptora,			Par_InstiRemitente,		Par_CuentaOrd,
						Par_NombreOrd,				Par_RFCOrd,					Par_TipoCuentaOrd,			Par_ConceptoPago,		Par_ReferenciaCobranza,
						Par_ReferenciaNum,			Par_Prioridad,				Par_ClavePago,				Par_AreaEmiteID,		Var_CuentaAho,
						Var_TipoPagoEnvio
					FROM SPEIENVIOS
					WHERE	ClaveRastreo = Par_ClaveRastreo;

				-- Buscar la cuentaaho o si se trato de un fondeo
			ELSE
				SET Par_NumErr 	:= 050;
				SET Par_ErrMen 	:= 'Clave rastreo no existe';
				SET Var_Control	:=  Par_ClaveRastreo ;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(Par_TipoPago = Tp_tt || Par_TipoPago = Tp_pt || Par_TipoPago = Tp_ttfsw
				|| Par_TipoPago = Tp_ptfsw || Par_TipoPago = Tp_nom || Par_TipoPago = Tp_ttv
				|| Par_TipoPago = Tp_ptv || Par_TipoPago = Tp_ttvfsw || Par_TipoPago = Tp_ptvfsw) THEN


			-- CAUSA DEVOLUCION 1 : CUENTA INEXISTENTE
			IF (Par_TipoCuentaBen = 40) THEN
			-- Buscar si es Fondeo
				IF (Var_ClabePartici = Par_CuentaBeneficiario) THEN

					SET Var_TipoCuenta := Cta_Fondeo;

					ELSE
						IF EXISTS(SELECT CreditoID
								FROM CREDITOS
								WHERE Clabe = Par_CuentaBeneficiario)THEN -- Entra si el SPEI es para un pago de crédito
							SET Var_TipoCuenta := Cta_Aho;
			                            -- Obtiene Id del crédito
			                            SELECT CreditoID INTO Var_CreditoID
										FROM CREDITOS
										WHERE Clabe = Par_CuentaBeneficiario;
			                            -- Obtiene Id de la cuenta de ahorro
			                            SELECT CuentaID INTO Var_CuentaAho
			                            FROM CREDITOS
			                            WHERE Clabe = Par_CuentaBeneficiario;
			                        ELSE
							IF EXISTS(SELECT CuentaAhoID
								FROM CUENTASAHO
								WHERE Clabe = Par_CuentaBeneficiario) THEN
									SET Var_TipoCuenta := Cta_Aho;
									SELECT	CuentaAhoID		INTO	Var_CuentaAho
										FROM CUENTASAHO
										WHERE	Clabe = Par_CuentaBeneficiario;
							ELSE
								SET Par_NumErr 	:= 001;
								SET Par_ErrMen 	:= CONCAT('Cuenta inexistente: ',Par_CuentaBeneficiario );
								SET Var_Control	:= 'Devolucion';
								LEAVE ManejoErrores;
							END IF;
						END IF;
					END IF;
			ELSE
				IF (Par_TipoCuentaBen = 3) THEN -- Tarjeta
					IF EXISTS(SELECT	CuentaAhoID
						FROM TARJETADEBITO
						WHERE	TarjetaDebID = Par_CuentaBeneficiario) THEN
							SET Var_TipoCuenta := Cta_Aho;
							SELECT	CuentaAhoID		INTO	Var_CuentaAho
								FROM TARJETADEBITO
								WHERE	TarjetaDebitoID = Par_CuentaBeneficiario;
					ELSE
						SET Par_NumErr 	:= 001;
						SET Par_ErrMen 	:= CONCAT('Cuenta inexistente: ',Par_CuentaBeneficiario );
						SET Var_Control	:= 'Devolucion';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF (Var_TipoCuenta = Cta_Aho) THEN

				-- CAUSA DEVOLUCION 2 : CUENTA BLOQUEADA
				SELECT	CuentaAhoID,	Estatus
				  INTO	Var_CuentaAho,	Var_Estatus
					FROM CUENTASAHO
					WHERE	CuentaAhoID	= Var_CuentaAho;

				IF(Var_CuentaAho != Entero_Cero AND Var_Estatus = Est_Bloqueada) THEN
					SET Par_NumErr 	:= 002;
					SET Par_ErrMen 	:= CONCAT('Cuenta bloqueada: ',Par_CuentaBeneficiario );
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				-- CAUSA DEVOLUCION 3 : CUENTA CANCELADA

				SELECT	Cue.CuentaAhoID,	Cue.Estatus,	Cli.Estatus
				  INTO	Var_CuentaAho,		Var_Estatus,	Var_EstCli
					FROM CUENTASAHO Cue
						INNER JOIN	CLIENTES Cli ON Cue.ClienteID	= Cli.ClienteID
					WHERE	Cue.CuentaAhoID	= Var_CuentaAho;


				IF((Var_CuentaAho != Entero_Cero AND Var_Estatus = Est_Cancelada) OR ( Var_EstCli != Est_Activo)) THEN
					SET Par_NumErr 	:= 003;
					SET Par_ErrMen 	:= CONCAT('Cuenta Cancelada: ',Par_CuentaBeneficiario );
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;


				-- CAUSA DEVOLUCION 5 : CUENTA CON OTRA DIVISA

				SELECT	CuentaAhoID,	MonedaID
				  INTO	Var_CuentaAho,	Var_Moneda
					FROM CUENTASAHO
					WHERE	Clabe = Par_CuentaBeneficiario;

				IF(Var_CuentaAho != Entero_Cero AND Var_Moneda != Mon_Pesos) THEN
					SET Par_NumErr 	:= 005;
					SET Par_ErrMen 	:='Cuenta en otra Divisa';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		-- -------------------- VALIDACIONES DE CAUSAS DE DEVOLUCION ------------------------------------
		-- si no esta activo o no existe lo regresamos con Devoluion 15

		-- CAUSA DEVOLUCION 15 : TIPO DE PAGO ERRONEO

		-- SI EL TIPO DE PAGO NO EXISTE EN LA TABLA TIPOSPAGOSPEI

		IF(Par_TipoPago != Entero_Cero) THEN

			-- VALIDACIONES REQUERIDAS SEGUN LOS TIPOS DE PAGO
			-- CAUSA DEVOLUCION 14 : FALTA INFORMACION MANDATORIA PARA COMPLETAR EL PAGO

			IF (Par_TipoPago = Tp_tt || Par_TipoPago = Tp_tv || Par_TipoPago = Tp_tp
				|| Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_nom || Par_TipoPago = Tp_ttv
				|| Par_TipoPago = Tp_ttvfsw) THEN

				IF(IFNULL(Par_NombreOrd,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPago = Tp_tt || Par_TipoPago = Tp_tv || Par_TipoPago = Tp_tp
				|| Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_nom || Par_TipoPago = Tp_ttv
				|| Par_TipoPago = Tp_ttvfsw) THEN

				IF (IFNULL(Par_TipoCuentaOrd,Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago. ';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;


			IF (Par_TipoPago = Tp_tt || Par_TipoPago = Tp_tv || Par_TipoPago = Tp_tp
				|| Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_nom || Par_TipoPago = Tp_ttv
				|| Par_TipoPago = Tp_ttvfsw) THEN

				IF (IFNULL(Par_CuentaOrd,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPago = Tp_tt || Par_TipoPago = Tp_tv || Par_TipoPago = Tp_tp
				|| Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_nom || Par_TipoPago = Tp_ttv
				|| Par_TipoPago = Tp_ttvfsw) THEN

				IF (ISNULL(Par_RFCOrd)) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPago = Tp_tt || Par_TipoPago = Tp_tv || Par_TipoPago = Tp_pt
				|| Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw || Par_TipoPago = Tp_nom
				|| Par_TipoPago = Tp_ttv || Par_TipoPago = Tp_ptv
				|| Par_TipoPago = Tp_ttvfsw || Par_TipoPago = Tp_ptvfsw) THEN

				IF (IFNULL(Par_NombreBeneficiario,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPago = Tp_tt || Par_TipoPago = Tp_pt || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw
				|| Par_TipoPago = Tp_nom || Par_TipoPago = Tp_ttv || Par_TipoPago = Tp_ptv
				|| Par_TipoPago = Tp_ttvfsw || Par_TipoPago = Tp_ptvfsw) THEN

				IF(IFNULL(Par_TipoCuentaBen,Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				-- CAUSA DEVOLUCION 17 : TIPO DE CUENTA NO CORRESPONDE
				-- SI EL TIPO DE CUENTA NO EXISTE EN LA TABLA TIPOSCUENTASPEI
				IF NOT EXISTS (SELECT	TipoCuentaID
					FROM TIPOSCUENTASPEI
					WHERE	TipoCuentaID = Par_TipoCuentaBen) THEN
						SET Par_NumErr 	:= 017;
						SET Par_ErrMen 	:= 'El tipo de cuenta no corresponde.tipoCuentBen';
						SET Var_Control	:= 'Devolucion' ;
						LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPago = Tp_tt || Par_TipoPago = Tp_pt || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw
				|| Par_TipoPago = Tp_nom || Par_TipoPago = Tp_ttv || Par_TipoPago = Tp_ptv
				|| Par_TipoPago = Tp_ttvfsw || Par_TipoPago = Tp_ptvfsw) THEN

				IF (IFNULL(Par_CuentaBeneficiario,Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPago = Tp_tt || Par_TipoPago = Tp_pt || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw
				|| Par_TipoPago = Tp_nom || Par_TipoPago = Tp_ttv || Par_TipoPago = Tp_ptv
				|| Par_TipoPago = Tp_ttvfsw || Par_TipoPago = Tp_ptvfsw) THEN

				IF (ISNULL(Par_RFCBeneficiario)) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPago = Tp_tt 	|| Par_TipoPago = Tp_tv 	|| Par_TipoPago = Tp_tp 	|| Par_TipoPago = Tp_pt
			   || Par_TipoPago = Tp_pp 	|| Par_TipoPago = Tp_ttfsw 	|| Par_TipoPago = Tp_ptfsw 	|| Par_TipoPago = Tp_nom
			   || Par_TipoPago = Tp_ttv || Par_TipoPago = Tp_ptv 	|| Par_TipoPago = Tp_ttvfsw
			   || Par_TipoPago = Tp_ptvfsw) THEN


				IF (ISNULL(Par_AreaEmiteID)) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:=  'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS (SELECT	AreaEmiteID
					FROM AREASEMITESPEI
					WHERE	AreaEmiteID = Par_AreaEmiteID)THEN
						SET Par_NumErr	:= 014;
						SET Par_ErrMen	:= 'Falta informacion mandatoria para completar el pago. AreaEmiteID';
						SET Var_Control	:= 'Devolucion' ;
						LEAVE ManejoErrores;
				END IF;

				IF (ISNULL(Par_ConceptoPago)) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				IF (IFNULL(Par_MontoTransferir,Decimal_Cero)) = Decimal_Cero THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago. montoTransferir';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				-- VALIDACION QUE EL MONTO A TRANSFERIR SEA MAYOR AL PERMITIDO POR SPEI
				IF (Par_MontoTransferir > ImporteMaximo) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago. montoTransferir';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				IF (ISNULL(Par_IVA)) THEN
					SET Par_NumErr 	:= 14;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				IF (ISNULL(Par_ReferenciaNum)) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				IF (ISNULL(Par_TipoPago)) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				IF (ISNULL(Par_Prioridad)) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				IF (IFNULL(Par_ClaveRastreo,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				-- VALIDACION QUE LA INSTITUCION REMITENTE Y RECEPTORA NO SEA LA MISMA
				IF (Par_InstiRemitente = Par_InstiReceptora) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago. InstiRemitente';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS (SELECT	InstitucionID
					FROM INSTITUCIONESSPEI
					WHERE	InstitucionID = Par_InstiRemitente) THEN
						SET Par_NumErr	:= 014;
						SET Par_ErrMen	:= 'Falta informacion mandatoria para completar el pago. InstiRemitente';
						SET Var_Control	:= 'Devolucion' ;
						LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS (SELECT	InstitucionID
					FROM INSTITUCIONESSPEI
					WHERE	InstitucionID = Par_InstiReceptora)THEN
						SET Par_NumErr	:= 014;
						SET Par_ErrMen	:= 'Falta informacion mandatoria para completar el pago. InstiReceptora';
						SET Var_Control	:= 'Devolucion' ;
						LEAVE ManejoErrores;
				END IF;

				IF EXISTS (SELECT	ClaveRastreo
					FROM SPEIRECEPCIONES
					WHERE	ClaveRastreo 		= Par_ClaveRastreo
					  AND	InstiRemitenteID 	= Par_InstiRemitente
					  AND	FechaOperacion 	=  Var_FechaOpe) THEN
						SET Par_NumErr	:= 014;
						SET Par_ErrMen	:= 'Clave de Rastreo Duplicada';
						LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPago = Tp_tt || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_nom
				|| Par_TipoPago = Tp_ttv || Par_TipoPago = Tp_ttvfsw) THEN

				IF (ISNULL(Par_ReferenciaCobranza)) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago.';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPago = Tp_tv) THEN
				IF (ISNULL(Par_ClavePago)) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago. tipoOperacion';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;
				-- si el tipo de pago es 4 entonces se valida que el tipo de operacion no sea vacio
			IF (Par_TipoPago = Tp_tp) THEN
				IF (IFNULL(Par_TipoOperacion,Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago. tipoOperacion';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPago = Tp_tp || Par_TipoPago = Tp_pp) THEN
				IF (ISNULL(Par_TipoOperacion)) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago. tipoOperacion';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

				-- CAUSA DEVOLUCION 16 : TIPO DE OPERACION ERRONEA
				-- SI EL TIPO DE OPERACION NO EXISTE EN LA TABLA TIPOSOPERACIONSPEI
			IF (Par_TipoOperacion !=Entero_Cero) THEN
				IF NOT EXISTS (SELECT	TipoOperacionID
					FROM TIPOSOPERACIONSPEI
					WHERE	TipoOperacionID = Par_TipoOperacion) THEN
						SET Par_NumErr 	:= 016;
						SET Par_ErrMen 	:= 'Tipo de operacion Erronea. tipoOperacion';
						SET Var_Control	:= 'Devolucion' ;
						LEAVE ManejoErrores;
				END IF;
			END IF;


			-- CAUSA DEVOLUCION 19 : CARACTER INVALIDO
			-- LLAMADA A LA FUNCION DE VALIDACION DE CARACTERES SPEI
			-- VALIDACIONES PARA EL ORDENANTE

			IF (Par_TipoPago = Tp_tt 	|| Par_TipoPago = Tp_tv 	|| Par_TipoPago = Tp_tp 	|| Par_TipoPago = Tp_pt
			   || Par_TipoPago = Tp_pp 	|| Par_TipoPago = Tp_ttfsw 	|| Par_TipoPago = Tp_ptfsw 	|| Par_TipoPago = Tp_nom
			   || Par_TipoPago = Tp_ttv || Par_TipoPago = Tp_ptv 	|| Par_TipoPago = Tp_ttvfsw
			   || Par_TipoPago = Tp_ptvfsw) THEN

				SET Par_NumErr := FNVALIDACARACSPEI(Par_NombreOrd);
				IF (Par_NumErr = 100) THEN
					SET Par_NumErr 	:= 019;
					SET Par_ErrMen 	:= 'Caracter invalido';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				SET Par_NumErr:= FNVALIDACARACSPEI(Par_RFCOrd);
				IF ( Par_NumErr= 100) THEN
					SET Par_NumErr 	:= 019;
					SET Par_ErrMen 	:= 'Caracter invalido';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				-- VALIDACIONES PARA ELBENEFICIARIO UNO

				SET Par_NumErr:= FNVALIDACARACSPEI(Par_NombreBeneficiario);
				IF (Par_NumErr = 100) THEN
					SET Par_NumErr 	:= 019;
					SET Par_ErrMen 	:= 'Caracter invalido';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				SET  Par_NumErr:= FNVALIDACARACSPEI(Par_RFCBeneficiario);
				IF (Par_NumErr = 100) THEN
					SET Par_NumErr 	:= 019;
					SET Par_ErrMen 	:= 'Caracter invalido';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				SET Par_NumErr:= FNVALIDACARACSPEI(Par_ConceptoPago);
				IF (Par_NumErr = 100) THEN
					SET Par_NumErr 	:= 019;
					SET Par_ErrMen 	:= 'Caracter invalido';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				-- VALIDACIONES DEL BENEFICIARIO DOS

				IF (Par_NombreBenefiDos != Cadena_Vacia AND Par_RFCBenefiDos!= Cadena_Vacia AND Par_ConceptoPagoDos != Cadena_Vacia) THEN
					SET Par_NumErr:= FNVALIDACARACSPEI(Par_NombreBenefiDos);
					IF (Par_NumErr = 100) THEN
						SET Par_NumErr 	:= 019;
						SET Par_ErrMen 	:= 'Caracter invalido';
						SET Var_Control	:= 'Devolucion' ;
						LEAVE ManejoErrores;
					END IF;

					SET Par_NumErr:= FNVALIDACARACSPEI(Par_RFCBenefiDos);
					IF (Par_NumErr = 100) THEN
						SET Par_NumErr 	:= 019;
						SET Par_ErrMen 	:= 'Caracter invalido';
						SET Var_Control	:= 'Devolucion' ;
						LEAVE ManejoErrores;
					END IF;

					SET Par_NumErr:= FNVALIDACARACSPEI(Par_ConceptoPagoDos);
					IF (Par_NumErr = 100) THEN
						SET Par_NumErr 	:= 019;
						SET Par_ErrMen 	:= 'Caracter invalido';
						SET Var_Control	:= 'Devolucion' ;
						LEAVE ManejoErrores;
					END IF;
				END IF; -- BENEFECIARIO DOS
			END IF;
		END IF;


		CALL SPEIRECEPCIONESALT(
			Par_FolioSpei,			Par_TipoPago,      		Par_TipoCuentaOrd,   	Par_CuentaOrd,			Par_NombreOrd,
			Par_RFCOrd,				Par_TipoOperacion,      Par_MontoTransferir,    Par_IVA,      		    Par_InstiRemitente,
			Par_InstiReceptora,	    Par_CuentaBeneficiario, Par_NombreBeneficiario,	Par_RFCBeneficiario, 	Par_TipoCuentaBen,
			Par_ConceptoPago,		Par_ClaveRastreo,       Par_CuentaBenefiDos,	Par_NombreBenefiDos,    Par_RFCBenefiDos,
			Par_TipoCuentaBenDos,   Par_ConceptoPagoDos,	Par_ClaveRastreoDos,    Par_ReferenciaCobranza,	Par_ReferenciaNum,
			Par_Prioridad,          Par_FechaCaptura,		Par_ClavePago,	        Par_AreaEmiteID,        Par_EstatusRecep,
			Par_CausaDevol,			Par_InfAdicional,       Par_Firma,              Par_Folio,              Par_FolioBanxico,
			Par_FolioPaquete,       Par_FolioServidor,      Par_Topologia,          Salida_NO,              Par_NumErr,
			Par_ErrMen,   			Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,	    Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,           Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'FolioSpei' ;
			LEAVE ManejoErrores;
		END IF;

		-- MOVIMIENTOS CONTABLES
		-- se setea la fecha de operaciona  fecha del sistema
		SELECT	FechaSistema	INTO	Var_FechaSis
		FROM	PARAMETROSSIS;

		-- Se busca el Spei de Fondeo en donde la cuenta del beneficiario (Clabe) sea la asignada por Banxico para la institucion
		IF (Var_ClabePartici = Par_CuentaBeneficiario) THEN
			IF (Par_TipoPago != Entero_Cero) THEN
				IF EXISTS(SELECT	InstitucionID
					FROM INSTITUCIONES
					WHERE	ClaveParticipaSpei	= Par_InstiRemitente) THEN

					SELECT	InstitucionID	INTO	Var_InstitucionID
						FROM	INSTITUCIONES
						WHERE	ClaveParticipaSpei	= Par_InstiRemitente;
				ELSE
					SET Par_NumErr := 020;
					SET Par_ErrMen := CONCAT('La institucion no existe: ',Par_InstiRemitente);
					LEAVE ManejoErrores;
				END IF;

				IF EXISTS (SELECT	NumCtaInstit
					FROM CUENTASAHOTESO
					WHERE	InstitucionID	= Var_InstitucionID
					  AND	CueClave 		= Par_CuentaOrd) THEN

					SELECT	cht.NumCtaInstit, 	ch.CuentaAhoID, 	ch.ClienteID
					  INTO	Var_CuentaBancos,	Var_CuentaAho, 		Var_ClienteID
						FROM CUENTASAHOTESO cht
							JOIN	CUENTASAHO ch ON cht.CuentaAhoID = ch.CuentaAhoID
						WHERE	cht.InstitucionID	= Var_InstitucionID
						  AND	cht.CueClave 		= Par_CuentaOrd;
				ELSE
					SET Par_NumErr := 020;
					SET Par_ErrMen := CONCAT('La cuenta no existe: ',Par_CuentaOrd);
					LEAVE ManejoErrores;
				END IF;


				SET Var_DescMov	:= CONCAT('FONDEO SPEI',' ' , Par_ConceptoPago);
				-- REFERENCIA PARA LA PARTE OPERATIVA
				SET	Var_Refere := CONCAT('Tran: ', CONVERT(Aud_NumTransaccion,CHAR),', Suc:',CONVERT(Aud_Sucursal,CHAR));


				CALL TESORERIAMOVIMIALT(
					Var_CuentaAho,		Var_FechaSis,		Par_MontoTransferir,	Var_DescMov, 		Var_Refere,
					Cadena_Vacia,     	Nat_Cargo,  		Var_Automatico, 		Var_TipoMovIDC,  	Entero_Cero,
					Par_Consecutivo,	Salida_NO,        	Par_NumErr,         	Par_ErrMen,     	Par_EmpresaID,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET	Var_DescMov := CONCAT('DEVOLUCION SPEI',' ' , Par_ConceptoPago);
				SET Var_Refere 	:= CONCAT('Tran: ', CONVERT(Aud_NumTransaccion,CHAR),', Suc:',CONVERT(Aud_Sucursal,CHAR));
			END IF;

			CALL TESORERIAMOVIMIALT(
				Var_CuentaAhoIDS,	Var_FechaSis,		Par_MontoTransferir,	Var_DescMov, 		Var_Refere,
				Cadena_Vacia,     	Nat_Abono,  		Var_Automatico, 		Var_TipoMovIDA,  	Entero_Cero,
				Par_Consecutivo,	Salida_NO,        	Par_NumErr,         	Par_ErrMen,     	Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control:= 'FolioSpei' ;
				LEAVE ManejoErrores;
			END IF;

			CALL CONTASPEISPRO(
				Par_FolioSpei,			Aud_Sucursal,		Mon_Pesos,			Var_FechaSis,	    Var_FechaSis,
				Par_MontoTransferir,	Entero_Cero,		Entero_Cero,		Var_DescMov,		Par_ClaveRastreo,
				Entero_Cero,			AltaPoliza_SI, 		Var_Poliza,			CtoConRec_Spei, 	Nat_Cargo,
				AltaMovAhorro_NO,		Var_CuentaAho, 		Var_ClienteID, 		Nat_Abono,			CtoAho_Spei,
				Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control:= 'FolioSpei' ;
				LEAVE ManejoErrores;
			END IF;

			IF (Par_ConceptoPago = ConceptoRemesasEnv && Par_TipoPago = Entero_Cero) THEN

				IF EXISTS (SELECT	ClaveRastreo
					FROM SPEIREMESAS
					WHERE 	ClaveRastreo = Par_ClaveRastreo ) THEN

					CALL POLIZAREMESASPRO(
						Var_Poliza,				Par_EmpresaID,		Var_FechaSis,		Par_FolioSpei,		Aud_Sucursal,
						Entero_Cero, 			Par_MontoTransferir,Mon_Pesos,			Var_DescMov,	    Var_Refere,
						Par_FolioSpei,			Salida_NO,			Par_NumErr, 		Par_ErrMen,			Aud_Usuario,
						Aud_FechaActual,	    Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr != Entero_Cero) THEN
						SET Var_Control:= 'FolioSpei' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF(Par_TipoPago != Entero_Cero) THEN
				CALL POLIZASTESOREPRO(
					Var_Poliza,      	Par_EmpresaID,      	Var_FechaSis,          	Par_CuentaBeneficiario,		Aud_Sucursal,
					Entero_Cero,        Decimal_Cero,			Par_MontoTransferir,	Mon_Pesos, 	    			Entero_Cero,
					Entero_Cero,    	Entero_Cero,       		Var_InstitucionID,      Var_CuentaBancos,  			Var_DescMov,
					Par_FolioSpei,  	Var_Conse,				Salida_NO,         		Par_NumErr,             	Par_ErrMen,
					Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,    			Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;

				-- afecta a la cuenta bancos
				CALL SALDOSCUENTATESOACT(
					Var_CuentaBancos,	Var_InstitucionID,	Par_MontoTransferir,	Nat_Cargo,			Par_Consecutivo,
					Salida_NO,			Par_NumErr,       	Par_ErrMen,     		Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 		Aud_Sucursal,     	Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- afecta cuentas spei
			CALL SALDOSCUENTATESOACT(
				Var_NumCtaInstitS,	Var_InstiIDS,		Par_MontoTransferir,	Nat_Abono,			Par_Consecutivo,
				Salida_NO,			Par_NumErr,       	Par_ErrMen,     		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 		Aud_Sucursal,     	Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control:= 'FolioSpei' ;
				LEAVE ManejoErrores;
			END IF;

		ELSE   -- ABONO A CUENTA

			-- Si el tipo de pago es 0 , es una devolucion de un envio

			SELECT	LTRIM(RTRIM(Descripcion))	INTO	Var_DesInsRem
				FROM INSTITUCIONESSPEI
				WHERE	InstitucionID = Par_InstiRemitente;

			SELECT	ClienteID	INTO	Var_ClienteID
				FROM CUENTASAHO
				WHERE	CuentaAhoID	= Var_CuentaAho;


			IF (Par_TipoPago = Entero_Cero AND (Var_TipoPagoEnvio NOT IN (Tp_tp,Tp_pp,Tp_pt))) THEN

                /* Se agrega esta validacion para los tipo de cuenta vostro ya que falla CONTASPEIPRO */
				IF ((Par_TipoCuentaBen <> 3 OR Par_TipoCuentaBen <> 40) AND IFNULL(Var_CuentaAho,0) = 0 ) THEN
					SET Par_NumErr 	:= 017;
					SET Par_ErrMen 	:= 'El tipo de cuenta no corresponde.tipoCuentBen';
					SET Var_Control	:= 'Devolucion' ;
					LEAVE ManejoErrores;
				END IF;

				SET	Var_DescMov := CONCAT('DEVOLUCION SPEI',' ' , Par_ConceptoPago);

				CALL CONTASPEISPRO(
					Par_FolioSpei,			Aud_Sucursal,		Mon_Pesos,			Var_FechaSis,		Var_FechaSis,
					Par_MontoTransferir,   	Decimal_Cero,		Decimal_Cero,		Var_DescMov,		Par_ClaveRastreo,
					Var_CuentaAho,			AltaPoliza_SI, 		Var_Poliza,			CtoConRec_Spei, 	Nat_Cargo,
					AltaMovAhorro_SI,		Var_CuentaAho, 		Var_ClienteID, 		Nat_Abono,			CtoAho_Spei,
					Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;

			ELSEIF(Par_TipoPago = Entero_Cero AND (Var_TipoPagoEnvio IN (Tp_tp,Tp_pp,Tp_pt)))THEN

				IF EXISTS(SELECT	InstitucionID
					FROM INSTITUCIONES
					WHERE	ClaveParticipaSpei	= Par_InstiRemitente) THEN

					SELECT	InstitucionID	INTO	Var_InstitucionID
						FROM	INSTITUCIONES
						WHERE	ClaveParticipaSpei	= Par_InstiRemitente;
				ELSE
					SET Par_NumErr := 020;
					SET Par_ErrMen := CONCAT('La institucion no existe: ',Par_InstiRemitente);
					LEAVE ManejoErrores;
				END IF;

				IF EXISTS (SELECT	NumCtaInstit
					FROM CUENTASAHOTESO
					WHERE	InstitucionID	= Var_InstitucionID
					  AND	CueClave 		= Par_CuentaOrd) THEN

					SELECT	cht.NumCtaInstit, 	ch.CuentaAhoID, 	ch.ClienteID
					  INTO	Var_CuentaBancos,	Var_CuentaAho, 		Var_ClienteID
						FROM CUENTASAHOTESO cht
							JOIN	CUENTASAHO ch ON cht.CuentaAhoID = ch.CuentaAhoID
						WHERE	cht.InstitucionID	= Var_InstitucionID
						  AND	cht.CueClave 		= Par_CuentaOrd;
				ELSE
					SET Par_NumErr := 020;
					SET Par_ErrMen := CONCAT('La cuenta no existe: ',Par_CuentaOrd);
					LEAVE ManejoErrores;
				END IF;


				SET	Var_DescMov := CONCAT('DEVOLUCION SPEI',' ' , Par_ConceptoPago);
				SET Var_Refere 	:= CONCAT('Tran: ', CONVERT(Aud_NumTransaccion,CHAR),', Suc:',CONVERT(Aud_Sucursal,CHAR));

				  CALL TESORERIAMOVIMIALT(
					Var_CuentaAhoIDS,	Var_FechaSis,		Par_MontoTransferir,	Var_DescMov, 		Var_Refere,
					Cadena_Vacia,     	Nat_Abono,  		Var_Automatico, 		Var_TipoMovIDA,  	Entero_Cero,
					Par_Consecutivo,	Salida_NO,        	Par_NumErr,         	Par_ErrMen,     	Par_EmpresaID,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;

				CALL CONTASPEISPRO(
					Par_FolioSpei,			Aud_Sucursal,		Mon_Pesos,			Var_FechaSis,	    Var_FechaSis,
					Par_MontoTransferir,	Entero_Cero,		Entero_Cero,		Var_DescMov,		Par_ClaveRastreo,
					Entero_Cero,			AltaPoliza_SI, 		Var_Poliza,			CtoConRec_Spei, 	Nat_Cargo,
					AltaMovAhorro_NO,		Var_CuentaAho, 		Var_ClienteID, 		Nat_Abono,			CtoAho_Spei,
					Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;

				CALL SALDOSCUENTATESOACT(
					Var_NumCtaInstitS,	Var_InstiIDS,		Par_MontoTransferir,	Nat_Abono,			Par_Consecutivo,
					Salida_NO,			Par_NumErr,       	Par_ErrMen,     		Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 		Aud_Sucursal,     	Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;

				CALL TESORERIAMOVIMIALT(
					Var_CuentaAho,		Var_FechaSis,		Par_MontoTransferir,	Var_DescMov, 		Var_Refere,
					Cadena_Vacia,     	Nat_Cargo,  		Var_Automatico, 		Var_TipoMovIDC,  	Entero_Cero,
					Par_Consecutivo,	Salida_NO,        	Par_NumErr,         	Par_ErrMen,     	Par_EmpresaID,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;

				CALL POLIZASTESOREPRO(
					Var_Poliza,      	Par_EmpresaID,      	Var_FechaSis,          	Par_CuentaOrd,		Aud_Sucursal,
					Entero_Cero,        Decimal_Cero,			Par_MontoTransferir,	Mon_Pesos, 	    	Entero_Cero,
					Entero_Cero,    	Entero_Cero,       		Var_InstitucionID,      Var_CuentaBancos,  	Var_DescMov,
					Par_FolioSpei,  	Var_Conse,				Salida_NO,         		Par_NumErr,         Par_ErrMen,
					Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,    	Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;


				CALL SALDOSCUENTATESOACT(
					Var_CuentaBancos,	Var_InstitucionID,	Par_MontoTransferir,	Nat_Cargo,			Par_Consecutivo,
					Salida_NO,			Par_NumErr,       	Par_ErrMen,     		Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 		Aud_Sucursal,     	Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;

			ELSE
				-- Si el tipo de pago es diferente de 0, es una recepcion

				IF (Par_TipoPago = Tp_tt || Par_TipoPago = Tp_pt || Par_TipoPago =Tp_ttfsw
					|| Par_TipoPago = Tp_ptfsw || Par_TipoPago = Tp_nom || Par_TipoPago = Tp_ttv
					|| Par_TipoPago = Tp_ptv || Par_TipoPago = Tp_ttvfsw || Par_TipoPago = Tp_ptvfsw) THEN

                    /* Se agrega esta validacion para los tipo de cuenta vostro ya que falla CONTASPEIPRO */
                    IF ((Par_TipoCuentaBen <> 3 OR Par_TipoCuentaBen <> 40) AND IFNULL(Var_CuentaAho,0) = 0 ) THEN
                        SET Par_NumErr 	:= 017;
						SET Par_ErrMen 	:= 'El tipo de cuenta no corresponde.tipoCuentBen';
						SET Var_Control	:= 'Devolucion' ;
						LEAVE ManejoErrores;
					END IF;

					SET Var_DescMov := CONCAT('Recepcion SPEI',' ' , Par_ClaveRastreo);

					SET	Var_Referencia	:= (RTRIM(CONVERT(Par_ReferenciaNum,CHAR(7))));
					SET Var_CuentaAho := IFNULL(Var_CuentaAho,0);

					-- Alta de movientos a cuentas de Ahorro y contables
					CALL CONTASPEISPRO(
						Par_FolioSpei,			Aud_Sucursal,		Mon_Pesos,			Var_FechaSis,		Var_FechaSis,
						Par_MontoTransferir,	Decimal_Cero,		Decimal_Cero,		Var_DescMov,		Par_ClaveRastreo,
						Var_CuentaAho,			AltaPoliza_SI, 		Var_Poliza,			CtoConRec_Spei, 	Nat_Cargo,
						AltaMovAhorro_SI,		Var_CuentaAho, 		Var_ClienteID, 		Nat_Abono,			CtoAho_Spei,
						Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
						Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF (Par_NumErr != Entero_Cero) THEN
						SET Var_Control:= 'FolioSpei' ;
						LEAVE ManejoErrores;
					END IF;


					IF( IFNULL(Var_CuentaAho, Entero_Cero) != Entero_Cero AND IFNULL(Var_BloqueoRecep, Cadena_Vacia) = Cons_SI )THEN

						IF Par_MontoTransferir >= IFNULL(Var_MontoMinBloqueo, Entero_Cero) THEN
							-- Bloqueo del saldo en la cuenta

							SET	Var_DescMov := CONCAT('RECEPCION SPEI ',Par_ClaveRastreo);

							CALL BLOQUEOSPRO(
								Entero_Cero, 		Est_Bloqueada, 		Var_CuentaAho,      Var_FechaSis,   	Par_MontoTransferir,
								Fecha_Vacia,  		Blo_SPEI, 			Var_DescMov, 		Par_FolioSpei,  	Cadena_Vacia,
								Cadena_Vacia, 		Salida_NO,  		Par_NumErr,     	Par_ErrMen,  		Par_EmpresaID,
								Aud_Usuario,    	Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

							IF (Par_NumErr != Entero_Cero) THEN
								SET Var_Control := 'FolioSpei' ;
								LEAVE ManejoErrores;
							END IF;

						END IF;

					END IF;


				ELSE IF(Par_TipoPago = Tp_tp || Par_TipoPago = Tp_pp ||Var_TipoPagoEnvio = Tp_tp ||Var_TipoPagoEnvio = Tp_pp) THEN

					SET	Var_DescMov 	:= 'Recepcion SPEI';
					SET	Var_Referencia	:= (RTRIM(CONVERT(Par_ReferenciaNum,CHAR(7))));

					CALL CONTASPEISPRO(
						Par_FolioSpei,			Aud_Sucursal,		Mon_Pesos,			Var_FechaSis,	    Var_FechaSis,
						Par_MontoTransferir,	Entero_Cero,		Entero_Cero,		Var_DescMov,		Var_Referencia,
						Cadena_Vacia,			AltaPoliza_SI, 		Var_Poliza,			CtoConRec_Spei, 	Nat_Cargo,
						AltaMovAhorro_NO,		Entero_Cero, 		Entero_Cero, 		Nat_Abono,			CtoAho_Spei,
						Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
						Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF (Par_NumErr != Entero_Cero) THEN
						SET Var_Control:= 'FolioSpei' ;
						LEAVE ManejoErrores;
					END IF;

					SET	Var_DescMov := CONCAT('RECEPCION SPEI ', Par_FolioSpei);

					-- Alta del movimiento de Tesoreria con la cuenta configurada es PARAMETROSSPEI
					CALL TESORERIAMOVIMIALT(
						Var_CuentaAhoIDS,	Var_FechaSis,		Par_MontoTransferir,	Var_DescMov, 			Par_FolioSpei,
						Salida_NO,	     	Nat_Abono,  		Salida_NO, 				Var_TipoMovIDA,  		Entero_Cero,
						Par_Consecutivo,	Salida_NO,        	Par_NumErr,        		Par_ErrMen,     		Par_EmpresaID,
						Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						SET Var_Control := 'FolioSpei' ;
						LEAVE ManejoErrores;
					END IF;

					-- Actualizacion del Saldo de la Cuenta de Tesoreria
					CALL SALDOSCUENTATESOACT(
						Var_NumCtaInstitS,	Var_InstiIDS,		Par_MontoTransferir,	Nat_Abono,		Par_Consecutivo,
						Salida_NO,			Par_NumErr,       	Par_ErrMen,     		Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 		Aud_Sucursal,	Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						SET Var_Control:= 'FolioSpei' ;
						LEAVE ManejoErrores;
					END IF;

					SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);

                    -- Alta del detalle poliza de tipo Abono
                    CALL DETALLEPOLIZASALT(
						Par_EmpresaID,		Var_Poliza,			Var_FechaSis, 			Var_CentroCostosID,		Var_CtaTesoreria,
						Par_FolioSpei,		Mon_Pesos,			Entero_Cero,			Par_MontoTransferir,	Var_DescMov,
						Par_FolioSpei,		ConceptoRecepcion,	Var_MovParticipante,	Cadena_Vacia,			Decimal_Cero,
						Cadena_Vacia,		Salida_NO,			Par_NumErr,				Par_ErrMen,				Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						SET Var_Consecutivo := Par_FolioSpei;
						LEAVE ManejoErrores;
					END IF;

				END IF;
			END IF;
		    END IF; -- fin del IF para devoluciones o recepciones
	END IF;

	-- Validaciones para el pago de credito
	IF(IFNULL(Var_CreditoID,Entero_Cero)<>Entero_Cero)THEN
		CALL PAGOCREDITOSPEIPRO(
			Var_CreditoID, 			Var_CuentaAho, 		Par_MontoTransferir, 	Var_FechaSis, 			Var_Poliza,
			Salida_NO,				Par_NumErr,			Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			SET Var_Consecutivo := Par_FolioSpei;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Par_NumErr	:= 000;
	SET Par_ErrMen	:= CONCAT("Recepcion SPEI Agregado Exitosamente: ", CONVERT(Par_FolioSpei, CHAR));
	SET Var_Control	:= 'numero' ;
	SET Var_Consecutivo := Par_FolioSpei;


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				IFNULL(Var_Control,Cadena_Vacia) AS control,
				Var_Consecutivo AS consecutivo,
				Var_ClaveRas AS campoGenerico;
	END IF;

END TerminaStore$$