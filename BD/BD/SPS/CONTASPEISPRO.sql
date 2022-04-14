-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTASPEISPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTASPEISPRO`;
DELIMITER $$


CREATE PROCEDURE `CONTASPEISPRO`(
# =====================================================================================
# ------- STORE PARA LA CONTABILIDAD DE SPEI---------
# =====================================================================================
	Par_FolioSpei			BIGINT,
    Par_SucOperacion    	INT,
    Par_MonedaID        	INT,
    Par_FechaOperacion  	DATE,
    Par_FechaAplicacion 	DATE,

    Par_Monto           	DECIMAL(14,4),
	Par_ComisionTrans		DECIMAL(16,2),
	Par_IVAComision			DECIMAL(16,2),
	Par_Descripcion     	VARCHAR(150),
    Par_Referencia      	VARCHAR(50),

    Par_Instrumento     	VARCHAR(20),
    Par_AltaEncPoliza   	CHAR(1),
	INOUT	Par_Poliza      BIGINT,
    Par_ConceptoCon     	INT,
	Par_NatConta        	CHAR(1),

    Par_AltaMovAho      	CHAR(1),
    Par_CuentaAhoID     	BIGINT(12),
    Par_ClienteID       	INT,
    Par_NatAhorro       	CHAR(1),
	Par_ConceptoAho			INT,
    INOUT	Par_Consecutivo	BIGINT,

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT,
	INOUT	Par_ErrMen		VARCHAR(400),

    Par_Empresa         	INT,
    Aud_Usuario         	INT,
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT,
    Aud_NumTransaccion  	BIGINT
)

TerminaStore: BEGIN


	-- Declacion de Variables
	DECLARE Var_Control	    VARCHAR(100);  	-- Variable de control
	DECLARE Var_Consecutivo	BIGINT(20);     -- Variable consecutivo
	DECLARE	Var_Cargos      DECIMAL(14,4);
	DECLARE	Var_Abonos      DECIMAL(14,4);
	DECLARE	Var_DesMov		VARCHAR(150);
	DECLARE Var_EsBloAuto   CHAR(1);
    DECLARE Var_Descripcion	VARCHAR(150);

	-- Declaracon de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Decimal_Cero		DECIMAL(12, 2);
	DECLARE	AltaPoliza_SI		CHAR(1);
	DECLARE	AltaMovAho_SI		CHAR(1);
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE	Pol_Automatica		CHAR(1);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Salida_SI			CHAR(1);
	DECLARE	Con_AhoCapital		INT;
	DECLARE EncPoliza_NO		CHAR(1);
	DECLARE CtoCon_Spei			INT;
	DECLARE	TipoMovAho_Spei		INT;
	DECLARE	TipoMovAhoCom_Spei	INT;
	DECLARE	TipoMovAhoIva_Spei 	INT;
	DECLARE	CtoAho_Spei			INT;
	DECLARE CtoAhoComSpei		INT;
	DECLARE CtoAhoComSpeiIva	INT;
	DECLARE	DesComision			VARCHAR(150);
	DECLARE	DesIvaCom			VARCHAR(150);
	DECLARE Con_Si        		CHAR(1);
	DECLARE Nat_Mov       		CHAR(1);
	DECLARE TipoBloq      		INT;
	DECLARE Descip        		VARCHAR(150);

	DECLARE Var_Automatico		CHAR(1);
	DECLARE Var_TipoMovID		INT;
	DECLARE Par_Consecutivo		BIGINT;
	DECLARE	Cuenta_Vacia		CHAR(25);
	DECLARE Var_Cuenta      	BIGINT(12);
	DECLARE Var_ClabeInst		VARCHAR(18);
	DECLARE Var_InstiIDS		INT(11);      				-- institucion ordenante
	DECLARE Var_NumCtaInstit	VARCHAR(20);  				-- cuenta de la institucion ordenante
	DECLARE Var_SPEIDesembolso	BIGINT(20);					-- Se usara para validar si el SPEI es por desembolso

	-- Asignacion de Constantes
	SET	Cadena_Vacia    	:= '';							-- Cadena vacia
	SET	Fecha_Vacia     	:= '1900-01-01';				-- Fecha Vaci
	SET	Entero_Cero    		:= 0;							-- Entero Cero
	SET	Decimal_Cero    	:= 0.00;						-- DECIMAL Cero
	SET	AltaPoliza_SI   	:= 'S';							-- Alta en poliza si
	SET	AltaMovAho_SI   	:= 'S';							-- Alta en movimiento de ahorro si
	SET	Nat_Cargo		    := 'C';							-- Naturaleza CArgo
	SET	Nat_Abono		    := 'A';							-- Naturaleza Abono
	SET	Pol_Automatica  	:= 'A';							-- Poliza Automatica
	SET	Salida_NO       	:= 'N';							-- Salida en pantalla NO
	SET Salida_SI           := 'S';                 		-- Salida si
	SET	Con_AhoCapital  	:= 1;							-- Concepto Ahorro Capital correcponde con CONCEPTOSAHO
	SET EncPoliza_NO		:= 'N';							-- No genera Encabezado de Poliza en CARGOABONOCUENTAPRO
	SET CtoCon_Spei			:= 808;							-- Concepto Contable de ENVIO SPEI
	SET TipoMovAho_Spei		:= 224;							-- Tipo Movimiento SPEI
	SET TipoMovAhoCom_Spei	:= 212;							-- Tipo Movimiento Comision Spei
	SET TipoMovAhoIva_Spei	:= 213;							-- Tipo Movimiento Iva de Comision Spei
	SET CtoAho_Spei			:= 1;							-- Pasivo
	SET CtoAhoComSpei		:= 24;							-- Concepto Ahorro Comision por Envio Spei
	SET CtoAhoComSpeiIva	:= 25;							-- Concepto Ahorro Iva Comision por Envio Spei
	SET DesComision			:= "Comision SPEI";				-- Descripcion Mov COmision Spei
	SET DesIvaCom			:= "Iva Comision SPEI";			-- Descripcion Mov Iva Comision Spei
	SET Con_Si              := 'S';            				-- Constante SI
	SET Nat_Mov 			:= 'B';            				-- Bloqueo por abono a cuenta
	SET TipoBloq			:= 13;            				-- Bloqueo automatico por tipo de cta
	SET Descip              := 'Bloqueo por abono a cuenta';

	SET Var_Automatico 		:= 'P';
	SET	Cuenta_Vacia		:= '0000000000000000000000000';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTASPEISPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		SELECT 	PS.Clabe,	CO.CuentaAhoID, 	CT.NumCtaInstit,	CT.InstitucionID
		INTO 	Var_ClabeInst, 	Var_Cuenta,		Var_NumCtaInstit,	Var_InstiIDS
			FROM PARAMETROSSPEI PS
				JOIN	CUENTASAHOTESO CT ON  PS.Clabe=CT.CueClave
				JOIN	CUENTASAHO CO ON CT.CuentaAhoID=CO.CuentaAhoID
				JOIN	CLIENTES CTE ON CO.ClienteID=CTE.ClienteID
			WHERE	PS.EmpresaID = Par_Empresa;

		IF(Par_ConceptoCon = CtoCon_Spei)THEN
			SET Var_Descripcion		:= CONCAT('ENVIO SPEI',' ' , Par_Descripcion);
            SET DesComision         := CONCAT(DesComision,' - ',Par_Descripcion);
			SET DesIvaCom           := CONCAT(DesIvaCom,' - ',Par_Descripcion);
		ELSE
			SET Var_Descripcion 	:= Par_Descripcion;
            SET DesComision         := CONCAT(DesComision,' - ',Par_Instrumento);
			SET DesIvaCom           := CONCAT(DesIvaCom,' - ',Par_Instrumento);
		END IF;

		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN

			CALL MAESTROPOLIZASALT(
				Par_Poliza,			Par_Empresa,    	Par_FechaAplicacion, 	Pol_Automatica,		Par_ConceptoCon,
				Var_Descripcion,	Salida_NO,      	Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,   	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				SET Var_Control		:= 'numero' ;
				SET Var_Consecutivo := Par_FolioSpei;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_AltaMovAho = AltaMovAho_SI	) THEN

			CALL CARGOABONOCUENTAPRO(
				Par_CuentaAhoID, 	Par_ClienteID,		Aud_NumTransaccion, Par_FechaOperacion, Par_FechaAplicacion,
				Par_NatAhorro,		Par_Monto,			Var_Descripcion, 	Par_Referencia,		TipoMovAho_Spei,
				Par_MonedaID, 		Par_SucOperacion, 	EncPoliza_NO,		Par_ConceptoCon,	Par_Poliza,
				AltaPoliza_SI, 		Con_AhoCapital,		Par_NatAhorro, 		Par_Consecutivo,	Salida_NO,
				Par_NumErr,			Par_ErrMen,			Par_Empresa,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				SET Var_Control		:= 'numero' ;
				SET Var_Consecutivo := Par_FolioSpei;
				LEAVE ManejoErrores;
			END IF;

				-- Comision e IVA , y el detalle del cargo a la cuenta
			IF (Par_ComisionTrans != Decimal_Cero || Par_IVAComision != Decimal_Cero)THEN
				IF (Par_ComisionTrans != Decimal_Cero) THEN
					CALL CONTAAHOPRO(
						Par_CuentaAhoID,	Par_ClienteID,		Aud_NumTransaccion,	Par_FechaOperacion,	Par_FechaAplicacion,
						Par_NatAhorro,		Par_ComisionTrans,  DesComision,		Par_CuentaAhoID,	TipoMovAhoCom_Spei,
						Par_MonedaID,		Aud_Sucursal,		EncPoliza_NO, 		CtoCon_Spei,		Par_Poliza,
						AltaPoliza_SI,		Con_AhoCapital,		Par_NatAhorro,		Entero_Cero,		Salida_NO,
						Par_NumErr,			Par_ErrMen,			Par_Empresa,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						SET Var_Control		:= 'numero' ;
						SET Var_Consecutivo := Par_FolioSpei;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				IF (Par_IVAComision != Decimal_Cero) THEN
					CALL CONTAAHOPRO(
						Par_CuentaAhoID,	Par_ClienteID,		Aud_NumTransaccion,	Par_FechaOperacion,	Par_FechaAplicacion,
						Par_NatAhorro,		Par_IVAComision,  	DesIvaCom,			Par_CuentaAhoID,	TipoMovAhoIva_Spei,
						Par_MonedaID,		Aud_Sucursal,		EncPoliza_NO, 		CtoCon_Spei,		Par_Poliza,
						AltaPoliza_SI,		Con_AhoCapital,		Par_NatAhorro,		Entero_Cero,		Salida_NO,
						Par_NumErr,			Par_ErrMen,			Par_Empresa,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						SET Var_Control		:= 'numero' ;
						SET Var_Consecutivo := Par_FolioSpei;
						LEAVE ManejoErrores;
					END IF;
				 END IF;
				-- se insertan 2 detalles de la poliza uno por el monto de la comision  y el otro por el IVA  de la comision
				-- se ingresa como referencia el numero de Spei.
				IF(Par_NatConta = Nat_Cargo) THEN
					SET	Var_Cargos	:= Par_ComisionTrans;
					SET	Var_Abonos	:= Decimal_Cero;
				ELSE
					SET	Var_Cargos	:= Decimal_Cero;
					SET	Var_Abonos	:= Par_ComisionTrans;
				END IF;

				CALL POLIZASAHORROPRO(
					Par_Poliza,			Par_Empresa,		Par_FechaOperacion,		Par_ClienteID,		CtoAhoComSpei,
					Par_CuentaAhoID,	Par_MonedaID,		Var_Cargos, 			Var_Abonos,			DesComision,
					Par_Instrumento,	Salida_NO, 			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					SET Var_Control		:= 'numero' ;
					SET Var_Consecutivo := Par_FolioSpei;
					LEAVE ManejoErrores;
				END IF;

				IF(Par_NatConta = Nat_Cargo) THEN
					SET	Var_Cargos	:= Par_IVAComision;
					SET	Var_Abonos	:= Decimal_Cero;
				ELSE
					SET	Var_Cargos	:= Decimal_Cero;
					SET	Var_Abonos	:= Par_IVAComision;
				END IF;

				CALL POLIZASAHORROPRO(
					Par_Poliza,			Par_Empresa,		Par_FechaOperacion,		Par_ClienteID,		CtoAhoComSpeiIva,
					Par_CuentaAhoID, 	Par_MonedaID,		Var_Cargos, 			Var_Abonos,			DesIvaCom,
					Par_Instrumento,	Salida_NO, 			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					SET Var_Control		:= 'numero' ;
					SET Var_Consecutivo := Par_FolioSpei;
					LEAVE ManejoErrores;
				END IF;
			END IF;-- Si cobra comision

			SELECT FolioSPEI
				INTO Var_SPEIDesembolso
				FROM SPEIENVIOSDESEMBOLSO
				WHERE FolioSPEI = Par_FolioSpei;

			SET Var_SPEIDesembolso	:= IFNULL(Var_SPEIDesembolso, Entero_Cero);

			-- BLOQUEO AUTOMATICO SEGUN EL TIPO DE CUENTA
			SELECT  TC.EsBloqueoAuto	INTO	Var_EsBloAuto
				FROM TIPOSCUENTAS TC
					INNER JOIN CUENTASAHO CA ON CA.TipoCuentaID = TC.TipoCuentaID
				WHERE CA.CuentaAhoID = Par_CuentaAhoID;

			IF(Var_EsBloAuto = Con_Si OR Var_SPEIDesembolso != Entero_Cero)THEN

				CALL BLOQUEOSCUENTAPRO(
					Entero_Cero,  	Nat_Mov, 			Par_CuentaAhoID, 	Par_FechaOperacion,   Par_Monto,
					Fecha_Vacia,  	TipoBloq,  			Descip,          	Par_FolioSpei,        Cadena_Vacia,
					Cadena_Vacia,  	Salida_NO,  		Par_NumErr,      	Par_ErrMen,           Par_Empresa,
					Aud_Usuario,   	Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,       Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					SET Var_Control		:= 'numero' ;
					SET Var_Consecutivo := Par_FolioSpei;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_NatAhorro = Nat_Cargo)THEN
				SET Var_TipoMovID	:= 13;
			ELSE
				SET Var_TipoMovID	:= 14;
			END IF;

			CALL TESORERIAMOVIMIALT(
				Var_Cuenta,			Par_FechaOperacion,		Par_Monto,			Var_Descripcion, 	Par_Referencia,
				Cadena_Vacia,     	Par_NatAhorro,  		Var_Automatico, 	Var_TipoMovID,  	Entero_Cero,
				Par_Consecutivo,	Salida_NO,        		Par_NumErr,         Par_ErrMen,     	Par_Empresa,
				Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				SET Var_Control		:= 'numero' ;
				SET Var_Consecutivo := Par_FolioSpei;
				LEAVE ManejoErrores;
			END IF;

			CALL SALDOSCUENTATESOACT(
				Var_NumCtaInstit,	Var_InstiIDS,		Par_Monto,			Par_NatAhorro,		Par_Consecutivo,
				Salida_NO,			Par_NumErr,       	Par_ErrMen,     	Par_Empresa,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				SET Var_Control		:= 'numero' ;
				SET Var_Consecutivo := Par_FolioSpei;
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF(Par_NatConta = Nat_Cargo) THEN
			SET	Var_Cargos	:= Par_Monto;
			SET	Var_Abonos	:= Decimal_Cero;
		ELSE
			SET	Var_Cargos	:= Decimal_Cero;
			SET	Var_Abonos	:= Par_Monto;
		END IF;
		-- Registro de poliza de SPEI
		SET Par_NumErr := 0;

		CALL POLIZASPEIPRO(
			Par_Poliza,			Par_Empresa,		Par_FechaOperacion,	Par_FolioSpei,		Par_SucOperacion,
			Var_Cargos, 		Var_Abonos,			Par_MonedaID,		Var_Descripcion,	Par_FolioSpei,
			Par_Consecutivo,	Salida_NO,			Par_NumErr, 		Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			SET Var_Control		:= 'numero' ;
			SET Var_Consecutivo := Par_FolioSpei;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT("Transaccion Realizada Correctamente: ", CONVERT(Par_FolioSpei, CHAR));
		SET Var_Control	:= 'numero' ;
		SET Var_Consecutivo	:= Par_FolioSpei;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Par_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$