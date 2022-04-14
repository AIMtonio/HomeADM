-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIREMESASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIREMESASPRO`;
DELIMITER $$

CREATE PROCEDURE `SPEIREMESASPRO`(
# =====================================================================================
# ------- STORE PARA PROCESAR LAS REMESAS SPEI Y DARLAS DE ALTA ---------
# =====================================================================================
	Par_SpeiRemID   	BIGINT(20),
	Par_CuentaAhoID		BIGINT(12),
	Par_ClienteID	    INT(11),
	Par_UsuarioAutoriza	VARCHAR(30),
	Par_TipoOperacion	INT(2),

	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),

	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Decimal_Cero		DECIMAL(18,2);

	DECLARE Salida_SI 			CHAR(1);
	DECLARE	Salida_NO			CHAR(1);

	DECLARE	AltaPoliza_NO		CHAR(1);
	DECLARE	AltaPoliza_SI		CHAR(1);
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE	AltaMovAhorro_SI	CHAR(1);
	DECLARE AltaMovAhorro_NO    CHAR(1);
	DECLARE	Var_DescMov			CHAR(150);
	DECLARE tipoOperRemesa      INT;
	DECLARE tipoOperAgente      INT;
	DECLARE Var_NumActRemesas   INT;
	DECLARE EstatusActivo       CHAR(1);
	DECLARE EstatusEnviado      CHAR(1);
	DECLARE CtoCon_RemSpei		INT;
	DECLARE CtoConFon_Spei		INT;
	DECLARE CtoAho_Spei			INT;
	DECLARE Var_OrigenOperacion	CHAR(1);			-- Define el origen de la Operacion
	DECLARE Var_EstLiquidado	INT(11);
	DECLARE Act_EstatusRem		INT;				-- Actualizacion: estatus de REMESASWS
	DECLARE Est_Pagado			CHAR(1);			-- Estatus Pagado 'P' REMESASWS

	-- Declaracion de Variables
	DECLARE Var_Folio              BIGINT(20);   	-- Folio
	DECLARE Var_ClaveRas    	   VARCHAR(30);  	-- clave de rastreo del spei
	DECLARE Var_TipoPago		   INT(2);		 	-- tipo de pago
	DECLARE	Var_CuentaAho		   BIGINT(12);		 	-- cuenta de ahorro
	DECLARE	Var_TipoCuentaOrd	   INT(2);       	-- tipo de cuenta del ordenate
	DECLARE	Var_CuentaOrd		   VARCHAR(20);  	-- cuenta ordenate
	DECLARE	Var_NombreOrd		   VARCHAR(40);  	-- nombre ordenante

	DECLARE	Var_RFCOrd	           VARCHAR(18);		-- rfc ordenante
	DECLARE	Var_MonedaID		   INT(11);      	-- moneda
	DECLARE	Var_TipoOperacion	   INT(2);	     	-- tipo de operacion spei
	DECLARE	Var_MontoTransferir	   DECIMAL(16,2); 	-- monto de la transferencia
	DECLARE	Var_IVAPorPagar		   DECIMAL(16,2); 	-- iva por pagar

	DECLARE Var_ComisionTrans	   DECIMAL(16,2); 	-- comision de la transferencia
	DECLARE	Var_IVAComision		   DECIMAL(16,2); 	-- iva de la comision
	DECLARE	Var_TotalCargoCuenta   DECIMAL(18,2); 	-- total cargo a cuenta
	DECLARE Var_InstiReceptora	   INT(5);		  	-- institucion receptora
	DECLARE	Var_CuentaBeneficiario VARCHAR(20);	  	-- cuenta del beneficiario

	DECLARE	Var_NombreBeneficiario VARCHAR(40);	  	-- nombre del beneficiario
	DECLARE	Var_RFCBeneficiario	   VARCHAR(18);	  	-- rfc del beneficiario
	DECLARE	Var_TipoCuentaBen	   INT(2);        	-- tipo de cuenta del beneficiario
	DECLARE Var_ConceptoPago	   VARCHAR(40);	  	-- concepto de pago
	DECLARE	Var_CuentaBenefiDos    VARCHAR(20);   	-- cuenta del beneficiario dos

	DECLARE	Var_NombreBenefiDos    VARCHAR(40);	 	-- nombre del benefiaciario dos
	DECLARE	Var_RFCBenefiDos	   VARCHAR(18);  	-- rfc del beneficiario dos
	DECLARE	Var_TipoCuentaBenDos   INT(2);       	-- tipo cuenta del beneficiario dos
	DECLARE Var_ConceptoPagoDos    VARCHAR(40);	 	-- concepto de pago dos
	DECLARE	Var_ReferenciaCobranza VARCHAR(40);  	-- referencia de cobranza

	DECLARE	Var_ReferenciaNum      INT(7);	       	-- referencia numerica
	DECLARE	Var_UsuarioEnvio       VARCHAR(30);	   	-- ucuario que envia
	DECLARE	Var_AreaEmiteID  	   INT(2);	       	-- area que emite
	DECLARE Var_PrioEnvio		   INT(1);         	-- prioridad de envio
	DECLARE Var_FechaAuto   	   DATETIME;       	-- Fecha de autorizacion
	DECLARE Var_EstatusEnv         INT(3);         	-- Estatus de envio
	DECLARE Var_ClavePago   	   VARCHAR(10);    	-- Clave de pago
	DECLARE Var_Estatus     	   CHAR(1);        	-- estatus del safi
	DECLARE Var_FechaRecep         DATETIME;       	-- fecha de recepcion
	DECLARE Var_FechaEnvio         DATETIME;       	-- fecha envio
	DECLARE Var_FechaVeri		   DATETIME;       	-- fecha de recepcion
	DECLARE Var_FechaOpe	   	   DATE;       		-- Fecha de autorizacion
	DECLARE Var_CausaDevol  	   INT(2);         	-- causa devolucion
	DECLARE Var_AutTeso     	   CHAR(1);        	-- si el spei necesita autorizacion de tesoreria
	DECLARE Var_InstiRemi          INT(5);         	-- Institucion remitente
	DECLARE Var_Firma       	   VARCHAR(1000);	-- firma
	DECLARE Var_Control	    	   VARCHAR(200);   	-- Variable de control
	DECLARE Var_FechaSis    	   DATE;           	-- fecha sistema
	DECLARE	Var_Poliza             BIGINT;
	DECLARE Var_Consecutivo		   BIGINT;

	DECLARE Var_Automatico		   CHAR(1);
	DECLARE Var_TipoMovID		   INT;
	DECLARE Par_Consecutivo		   BIGINT;
	DECLARE	Cuenta_Vacia		   INT(25);
	DECLARE Var_Cuenta      	   VARCHAR(50);
	DECLARE Var_ClabeInst		   VARCHAR(18);
	DECLARE Var_InstiIDS		   INT(11);      	-- institucion ordenante
	DECLARE Var_NumCtaInstit	   VARCHAR(20);  	-- cuenta de la institucion ordenante
	DECLARE Var_Refere			   VARCHAR(35);
	DECLARE Var_EstAutorizado	   CHAR(1);			-- Estatus A : Autorizado
	DECLARE Var_RemesaWSID		   BIGINT(20);

	-- Asignacion de Constantes
	SET	Cadena_Vacia	    := '';             			-- Cadena Vacia
	SET	Fecha_Vacia	    	:= '1900-01-01 00:00:00';   -- Fecha Vacia
	SET	Entero_Cero		    := 0;              			-- Entero Cero
	SET	Decimal_Cero	    := 0.0;            			-- Decimal cero
	SET Salida_SI 	     	:= 'S';            			-- Salida SI
	SET	Salida_NO	       	:= 'N';            			-- Salida NO

	SET	AltaPoliza_NO		:= 'N';		       			-- No Alta de Poliza
	SET	AltaPoliza_SI		:= 'S';		       			-- Si Alta de Poliza
	SET Nat_Cargo			:= 'C';	           			-- Naturaleza Cargo
	SET Nat_Abono			:= 'A';		       			-- Naturaleza Cargo
	SET AltaMovAhorro_SI	:= 'S';		       			-- Si Alta Movimientos Ahorro
	SET AltaMovAhorro_NO    := 'N'; 			   		-- NO Alta Movimientos Ahorro
	SET	Var_DescMov 		:= 'ENVIO REMESA SPEI'; 	-- descripcion del movimiento
	SET	Var_Poliza          := 0;               		-- poliza
	SET CtoCon_RemSpei		:= 813;			   			-- Concepto Contable de REMESAS SPEI
	SET CtoConFon_Spei  	:= 811;			   			-- Concepto contable FONDEO A PAGADOR
	SET Var_NumActRemesas   := 1;              			-- numero de actualizacion para SPEIREMESAS
	SET tipoOperRemesa      := 1;              			-- tipo de operacion de remesas
	SET tipoOperAgente      := 2;			   			-- tipo de operacion de agentes
	SET EstatusActivo       := 'A';             		-- estatus activo
	SET EstatusEnviado      := 'E';
	SET CtoAho_Spei			:= 1;			   			-- Concepto Ahorro Pasivo

	SET Var_Automatico 		:= 'P';
	SET	Cuenta_Vacia		:= '0000000000000000000000000';
	SET Var_TipoMovID		:= 13;
	SET Var_OrigenOperacion	:= 'R'; 					-- Origen de la operacion Remesa
	SET Var_EstAutorizado	:= 'A';						-- Estatus A : Autorizado
	SET Var_EstLiquidado	:= 2;
	SET Act_EstatusRem		:= 3;
	SET Est_Pagado			:= 'P';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIREMESASPRO');
				SET Var_Control = 'sqlException';
			END;

		SELECT	PS.Clabe,			CO.CuentaAhoID, 	CT.NumCtaInstit,		CT.InstitucionID
		  INTO 	Var_ClabeInst, 		Var_Cuenta,			Var_NumCtaInstit,		Var_InstiIDS
			FROM PARAMETROSSPEI PS
				JOIN CUENTASAHOTESO CT ON  PS.Clabe = CT.CueClave
				JOIN CUENTASAHO CO ON CT.CuentaAhoID = CO.CuentaAhoID
				JOIN CLIENTES CTE ON CO.ClienteID = CTE.ClienteID
			WHERE	PS.EmpresaID	= Par_EmpresaID;

		-- valida que reciba SpeiRemID
		IF(IFNULL(Par_SpeiRemID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'El numero de Remesa SPEI esta vacio';
			SET Var_Control	:= 'tipoBusqueda' ;
			LEAVE TerminaStore;
		END IF;

		-- valida que la cuenta de ahorro exista
		IF (Par_CuentaAhoID != Entero_Cero) THEN
			IF NOT EXISTS (SELECT	CuentaAhoID
				FROM CUENTASAHO
				WHERE	CuentaAhoID = Par_CuentaAhoID) THEN
					SET Par_NumErr 	:= 002;
					SET Par_ErrMen 	:= 'La Cuenta de Ahorro no Existe';
					SET Var_Control	:= 'cuentaAhoID' ;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		-- valida que la cuenta de ahorro se encuentre activa
		IF (Par_CuentaAhoID != Entero_Cero) THEN
			IF NOT EXISTS (SELECT	Estatus
				FROM CUENTASAHO
				WHERE	CuentaAhoID = Par_CuentaAhoID
				  AND	Estatus 	= EstatusActivo) THEN
					SET Par_NumErr 	:= 003;
					SET Par_ErrMen 	:= 'La Cuenta de Ahorro no esta Activa';
					SET Var_Control	:= 'cuentaAhoID' ;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		-- valida que la cuenta de ahorro se encuentre activa
		IF (Par_CuentaAhoID != Entero_Cero) THEN
			IF NOT EXISTS (SELECT	CuentaAhoID
				FROM CUENTASAHO
				WHERE 	CuentaAhoID = Par_CuentaAhoID
				  AND	ClienteID 	= Par_ClienteID) THEN
					SET Par_NumErr 	:= 004;
					SET Par_ErrMen 	:= 'La Cuenta de Ahorro no pertenece al Cliente';
					SET Var_Control	:= 'cuentaAhoID' ;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		-- valida que el cliente exista
		IF(Par_ClienteID != Entero_Cero) THEN
			IF NOT EXISTS (SELECT	ClienteID
				FROM CLIENTES
				WHERE	ClienteID = Par_ClienteID) THEN
					SET Par_NumErr 	:= 005;
					SET Par_ErrMen 	:= 'La numero de Cliente no Existe';
					SET Var_Control	:= 'cuentaAhoID' ;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_ClienteID != Entero_Cero) THEN
			IF NOT EXISTS (SELECT	Estatus
				FROM CUENTASAHO
				WHERE	ClienteID = Par_ClienteID
				  AND	Estatus = EstatusActivo) THEN
					SET Par_NumErr 	:= 006;
					SET Par_ErrMen 	:= 'El Cliente no esta Activo';
					SET Var_Control	:= 'cuentaAhoID' ;
					LEAVE ManejoErrores;
			END IF;
		END IF;


		SELECT
				SpeiRemID, 				ClaveRastreo, 		TipoPagoID, 		CuentaAho,   		TipoCuentaOrd,
				LEFT(FNDECRYPTSAFI(CuentaOrd),20),
				LEFT(FNDECRYPTSAFI(NombreOrd),40),
				LEFT(FNDECRYPTSAFI(RFCOrd),18),
				MonedaID,				TipoOperacion,
				CONVERT(FNDECRYPTSAFI(MontoTransferir),DECIMAL(16,2)),
				IVAPorPagar,			ComisionTrans,		IVAComision,		InstiRemitenteID,
				CONVERT(CASE WHEN FNDECRYPTSAFI(TotalCargoCuenta) = '' THEN '0'
							 ELSE FNDECRYPTSAFI(TotalCargoCuenta) END , DECIMAL(16,2)),
				InstiReceptoraID,
				LEFT(FNDECRYPTSAFI(CuentaBeneficiario),20),
				LEFT(FNDECRYPTSAFI(NombreBeneficiario),40),
				LEFT(FNDECRYPTSAFI(RFCBeneficiario),18),
				TipoCuentaBen,
				LEFT(FNDECRYPTSAFI(ConceptoPago),40),
				CuentaBenefiDos,		NombreBenefiDos,	RFCBenefiDos,
				TipoCuentaBenDos,   	ConceptoPagoDos,    ReferenciaCobranza, ReferenciaNum,      PrioridadEnvio,
				FechaAutorizacion,      Entero_Cero,     	Cadena_Vacia,	    UsuarioEnvio,		AreaEmiteID,
				Estatus,                FechaRecepcion,     CausaDevol,         Firma

		  INTO 	Var_Folio,              Var_ClaveRas,           Var_TipoPago,           Var_CuentaAho,     		Var_TipoCuentaOrd,
				Var_CuentaOrd,			Var_NombreOrd,          Var_RFCOrd,		        Var_MonedaID,           Var_TipoOperacion,
				Var_MontoTransferir,    Var_IVAPorPagar,        Var_ComisionTrans,      Var_IVAComision,        Var_InstiRemi,
				Var_TotalCargoCuenta,   Var_InstiReceptora,	    Var_CuentaBeneficiario, Var_NombreBeneficiario,	Var_RFCBeneficiario,
				Var_TipoCuentaBen,	    Var_ConceptoPago,	    Var_CuentaBenefiDos,	Var_NombreBenefiDos,    Var_RFCBenefiDos,
				Var_TipoCuentaBenDos,   Var_ConceptoPagoDos,	Var_ReferenciaCobranza,	Var_ReferenciaNum,      Var_PrioEnvio,
				Var_FechaAuto,	        Var_EstatusEnv,		    Var_ClavePago,	        Var_UsuarioEnvio,       Var_AreaEmiteID,
				Var_Estatus,		    Var_FechaRecep,         Var_CausaDevol,			Var_Firma
			FROM SPEIREMESAS
			WHERE	SpeiRemID = Par_SpeiRemID;

		SET Var_Folio := (SELECT IFNULL(MAX(FolioEnvio),Entero_Cero) + 1 FROM	PARAMETROSSPEI);
		UPDATE	PARAMETROSSPEI
			SET	FolioEnvio	= Var_Folio;

		SELECT	FechaSistema	INTO	Var_FechaSis
			FROM PARAMETROSSIS;

		-- se setea la fecha de operaciona  fecha del sistema
		SET Var_FechaOpe 	:= Var_FechaSis;
		SET Var_FechaEnvio 	:= CURRENT_TIMESTAMP();
		SET Var_FechaVeri	:= CURRENT_TIMESTAMP();

		IF (IFNULL(Var_FechaAuto,Fecha_Vacia) = Fecha_Vacia) THEN
			SET Var_FechaAuto := CURRENT_TIMESTAMP();
		END IF;

		SELECT SUBSTRING(NombreCompleto, 1, 30)
			INTO Var_UsuarioEnvio
			FROM USUARIOS
			WHERE UsuarioID =  Aud_Usuario;

		SET Var_UsuarioEnvio := IFNULL(Var_UsuarioEnvio, Cadena_Vacia);

		-- SE REGISTRA EL SPEI ENVIO
		CALL SPEIENVIOSPRO (
			Var_Folio, 				Var_ClaveRas, 			Var_TipoPago,			Var_CuentaAho,			Var_TipoCuentaOrd,
			Var_CuentaOrd, 			Var_NombreOrd,			Var_RFCOrd,				Var_MonedaID,			Entero_Cero,
			Var_MontoTransferir,	Var_IVAPorPagar,		Var_ComisionTrans,		Var_IVAComision,		Var_MontoTransferir,
			Var_InstiReceptora,		Var_CuentaBeneficiario,	Var_NombreBeneficiario,	Var_RFCBeneficiario,	Var_TipoCuentaBen,
			Var_ConceptoPago,		Var_CuentaBenefiDos,	Var_NombreBenefiDos,	Var_RFCBenefiDos,		Var_TipoCuentaBenDos,
			Var_ConceptoPagoDos,	Cadena_Vacia,			Var_ReferenciaNum,		Var_UsuarioEnvio,		Var_AreaEmiteID,
			'V',
			Salida_NO, 				Par_NumErr,	     	Par_ErrMen, 				Par_EmpresaID,     		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,    Aud_ProgramaID,	 			Aud_Sucursal,       	Aud_NumTransaccion
		);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'numero' ;
			LEAVE ManejoErrores;
		END IF;

		-- SE ACTUALIZA LA TABLA SPEIREMESAS
		CALL SPEIREMESASACT(
			Par_SpeiRemID, 		Var_ClaveRas,		Var_Folio, 				Par_UsuarioAutoriza,	Var_NumActRemesas,
			Salida_NO, 			Par_NumErr,	     	Par_ErrMen, 			Par_EmpresaID,     		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,	 		Aud_Sucursal,       	Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'numero' ;
			LEAVE ManejoErrores;
		END IF;


		IF (Par_TipoOperacion = tipoOperRemesa) THEN
			-- REFERENCIA PARA LA PARTE OPERATIVA
			SET Var_Refere := CONCAT('Tran: ', CONVERT(Aud_NumTransaccion,CHAR),', Suc:',CONVERT(Aud_Sucursal,CHAR));

			CALL CONTASPEISPRO(
				Var_Folio,				Aud_Sucursal,		Var_MonedaID,		Var_FechaSis,		Var_FechaSis,
				Var_MontoTransferir,	Var_ComisionTrans,	Var_IVAComision,	Var_DescMov,		Entero_Cero,
				Var_Folio,	  			AltaPoliza_SI, 		Var_Poliza,		    CtoCon_RemSpei, 	Nat_Abono,
				AltaMovAhorro_NO,		Entero_Cero, 		Entero_Cero, 		Nat_Cargo,		    CtoAho_Spei,
				Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control	:= 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			CALL TESORERIAMOVIMIALT(
				Var_Cuenta,			Var_FechaSis,		Var_MontoTransferir,	Var_DescMov,	 	Var_Refere,
				Cadena_Vacia,     	Nat_Cargo,  		Var_Automatico, 		Var_TipoMovID,  	Entero_Cero,
				Par_Consecutivo,	Salida_NO,        	Par_NumErr,         	Par_ErrMen,     	Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control	:= 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			CALL SALDOSCUENTATESOACT(
				Var_NumCtaInstit,	Var_InstiIDS,		Var_MontoTransferir,	Nat_Cargo,			Par_Consecutivo,
				Salida_NO,			Par_NumErr,       	Par_ErrMen,     		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 		Aud_Sucursal,     	Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control	:= 'numero' ;
				LEAVE ManejoErrores;
			END IF;

			CALL POLIZAREMESASPRO(
				Var_Poliza,				Par_EmpresaID,		Var_FechaSis,		Var_Folio,			Aud_Sucursal,
				Var_MontoTransferir, 	Decimal_Cero,		Var_MonedaID,		Var_DescMov,	    Var_Folio,
				Var_Consecutivo,		Salida_NO,			Par_NumErr, 		Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	    Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control	:= 'numero' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF (Par_TipoOperacion = tipoOperAgente) THEN

			SET Var_RemesaWSID := (SELECT SD.RemesaWSID FROM SPEIREMESAS SR
										INNER JOIN SPEIDESCARGASREM SD ON SD.SpeiDetSolDesID = SR.SpeiDetSolDesID
											AND SD.SpeiSolDesID = SR.SpeiSolDesID
										WHERE SR.SpeiRemID = Par_SpeiRemID);

			CALL REMESASWSACT (
				Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,	Decimal_Cero,	Cadena_Vacia,
				Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,
				Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,
				Entero_Cero, 		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,
				Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,

				Entero_Cero,		Entero_Cero,		Entero_Cero,	Cadena_Vacia,	Cadena_Vacia,
				Cadena_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,
				Entero_Cero, 		Entero_Cero,		Entero_Cero,	Entero_Cero,	Entero_Cero,
				Cadena_Vacia, 		Cadena_Vacia,		Fecha_Vacia,	Cadena_Vacia,	Cadena_Vacia,
				Cadena_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,	Entero_Cero,

				Entero_Cero, 		Entero_Cero,		Entero_Cero,	Cadena_Vacia,	Entero_Cero,
				Cadena_Vacia, 		Entero_Cero,		Entero_Cero,	Entero_Cero,	Entero_Cero,
				Entero_Cero,		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia,	Cadena_Vacia,
				Cadena_Vacia, 		Entero_Cero,		Fecha_Vacia,	Cadena_Vacia,	Entero_Cero,
				Fecha_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,	Entero_Cero,

				Entero_Cero, 		Entero_Cero,		Entero_Cero,	Cadena_Vacia,	Entero_Cero,
				Cadena_Vacia, 		Cadena_Vacia,		Entero_Cero,	Entero_Cero,	Cadena_Vacia,
				Cadena_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,
				Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia,	Entero_Cero,	Cadena_Vacia,
				Entero_Cero, 		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia,	Entero_Cero,

				Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia, 	Entero_Cero, 	Cadena_Vacia,
				Entero_Cero, 		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia, 	Entero_Cero,
				Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia,	Entero_Cero, 	Cadena_Vacia,
				Entero_Cero, 		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia, 	Var_RemesaWSID,
				Entero_Cero,		Est_Pagado,			Act_EstatusRem,

				Salida_NO,			Par_NumErr, 		Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
			);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		UPDATE SPEIREMESAS SET
			Estatus		= EstatusEnviado
		WHERE SpeiRemID = Par_SpeiRemID;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= 'Remesa SPEI Actualizada Exitosamente';
		SET Var_Control	:= 'numero' ;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr ,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Aud_NumTransaccion AS consecutivo,
					Var_Folio AS campoGenerico;
		END IF;

END TerminaStore$$