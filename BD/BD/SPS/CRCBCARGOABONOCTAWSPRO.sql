-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCARGOABONOCTAWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCARGOABONOCTAWSPRO`;
DELIMITER $$

CREATE PROCEDURE `CRCBCARGOABONOCTAWSPRO`(
# =====================================================================================
# ------- STORE PARA REALIZAR UN ABONO A CUENTA DESDE WS CLIENTE CREDICLUB ---------
# =====================================================================================
	Par_CuentaAhoID		BIGINT(12),			-- numero de la cuenta, ID de la talba CUENTASAHO
	Par_Monto			DECIMAL(14,2),		-- monto a abonar
	Par_NatMovimiento	CHAR(1),			-- Naturaleza: cargo/ abono
	Par_Referencia		VARCHAR(50),		-- Referencia de la Operacion
	Par_CodigoRastreo	VARCHAR(200),		-- Codigo de Rastreo de la Operacion

	INOUT Par_Poliza	BIGINT(20),			-- Numero de poliza

	Par_Salida			CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr   	INT(11),			-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),		-- Descripcion del Error

	Par_EmpresaID		INT(11),			-- EmpresaID
	Aud_Usuario			INT(11),	        -- Usuario ID
	Aud_FechaActual		DATETIME,           -- Fecha Actual
	Aud_DireccionIP		VARCHAR(15),        -- Direccion IP
	Aud_ProgramaID		VARCHAR(50),        -- Nombre de programa
	Aud_Sucursal		INT(11),            -- Sucursal ID
	Aud_NumTransaccion	BIGINT(20)          -- Numero de transaccion
	)

TerminaStore: BEGIN

	/* Declaracion de variables */
	DECLARE Var_Control	    	VARCHAR(100);			-- variable de control
	DECLARE Var_DescripcionMov	VARCHAR(45);			-- descripcion de movimiento
	DECLARE Var_MonedaID		INT(11);				-- moneda id de la cuenta
	DECLARE Var_SucurCli		INT(11);				-- sucursal del cliente
	DECLARE Var_FechaSis		DATE;					-- fecha del sistema
	DECLARE Var_TipoMovAho		INT(11);				-- tipo de movimiento de ahorro
    DECLARE Var_EmpresaID		INT(11);				-- empresa ID
    DECLARE Var_ClienteID		INT(11);				-- ID del cliente
    DECLARE Var_EstatusC		CHAR(1);				-- estatus de la cuenta
    DECLARE Var_CuentaID		BIGINT(12);				-- numero de cuenta
    DECLARE Var_EstatusCli		CHAR(1);				-- estattus del cliente
	DECLARE Var_NatAhorro		CHAR(1);				-- naruraleza del movimiento de ahorro
	DECLARE Var_ConceptoConta	INT(11);				-- concepto contable
	DECLARE Var_CuentaBancos	VARCHAR(20);			-- cuenta de bancos
    DECLARE Var_Cargos			DECIMAL(14,2);			-- cargos
    DECLARE Var_Abonos			DECIMAL(14,2);			-- abonos
    DECLARE Var_InstitucionID	INT(11);				-- institucionID ala que caeran los movimientos
    DECLARE Var_Consecutivo		BIGINT(12);				-- variable consecutivo
    DECLARE Var_DescripMovBan	VARCHAR(45);			-- descripcion de movimiento de bancos
    DECLARE Var_UsuarioID		INT(11);				-- usuario que realiza operacion
	DECLARE Var_MensajeRes		VARCHAR(400);			-- mensaje de respuesta
    DECLARE Var_NaturalezaBan	CHAR(1);				-- Naturaleza del movimiento de bancos
    DECLARE Var_TipoMovIDC		CHAR(4);				-- ID de la tabla TIPOSMOVTESO
    DECLARE Var_DescripcionOp	VARCHAR(45);
    DECLARE Var_CuentaAhoInsID	VARCHAR(30);			-- CUENTA DE BANCOS
    DECLARE Var_NumErr			INT(11);
	DECLARE Var_ErrMen			VARCHAR(400);
	DECLARE Var_Credito			BIGINT(20);
    DECLARE Var_EjecutaCierre	CHAR(1);				-- indica si se esta realizando el cierre de dia
    DECLARE Var_PagoxReferencia	CHAR(1);
	DECLARE Var_MontoAplicado	DECIMAL(14,2);			-- Monto Aplicado a las Comisiones de Promedio de Saldo
	DECLARE Var_MontoBloquear	DECIMAL(12,2);			-- Monto a Bloquear considerando el cobro de Comisiones

	/* Declaracion de constantes */
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Entero_Cero			INT(11);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE AltaEncPoliza		CHAR(1);
	DECLARE AltaPoliza			CHAR(1);
	DECLARE ConceptoAho			INT(11);
	DECLARE Salida_NO			CHAR(1);
	DECLARE Salida_SI			CHAR(1);
    DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
    DECLARE AbonoCuenta			INT(11);
	DECLARE RetiroCuenta		INT(11);
	DECLARE ConcepContaAbono	INT(11);
	DECLARE ConcepContaCargo	INT(11);
    DECLARE CuentaCargo			VARCHAR(50);
    DECLARE CuentaAbono			VARCHAR(50);
    DECLARE InstitucionBanco	VARCHAR(50);
    DECLARE InstitucionBancoCar	VARCHAR(50);
	DECLARE Tipo_Automatico		CHAR(1);
    DECLARE Mov_CargoCta		CHAR(4);
	DECLARE Mov_AbonoCta		CHAR(4);
	DECLARE BloquearSaldoParaPago	INT(11);
	DECLARE TipoBloq_PagoRefe	INT(11);
	DECLARE Descrip_Bloq		VARCHAR(200);
	DECLARE Naturaleza_Bloq		CHAR(1);
    DECLARE ValorCierre			VARCHAR(30);	-- iNDICA SI SE REALIZA EL CIERRE DE DIA.

	/* Asignacion de constantes */
	SET Decimal_Cero		:= 0.0;						-- DECIMAL cero
	SET Entero_Cero			:= 0;						-- entero cero
    SET	Cadena_Vacia		:= '';						-- cadena vacia
	SET Estatus_Activo		:= 'A';						-- estatus activo
	SET AltaEncPoliza		:= 'N';						-- encabezado de poliza
	SET ConcepContaAbono	:= 45;						-- concepto abono
	SET ConcepContaCargo	:= 46;						-- concepto cargo
	SET AltaPoliza			:= 'S';						-- alta detalle de poliza
	SET ConceptoAho			:= 1;						-- concepto ahorro
	SET Salida_NO			:= 'N';						-- salida NO
    SET Salida_SI			:= 'S';						-- salida SI
    SET	Nat_Cargo			:= 'C';						-- naturaleza cargo
    SET Nat_Abono			:= 'A';						-- naturaleza abono
    SET AbonoCuenta			:= 28;						-- ID del tipo de movimiento de la tabla TIPOSMOVSAHO
    SET RetiroCuenta		:= 29;						-- ID del tipo de movimiento de la tabla TIPOSMOVSAHO
    SET CuentaCargo         := 'CuentaRetiroCtaWS';		-- cuenta de retiro
    SET CuentaAbono         := 'CuentaAbonoCtaWS';		-- cuenta de abono
	SET InstitucionBanco	:= 'InstitucionID';			-- institucion ID
    SET InstitucionBancoCar	:= 'InstitucionIDC';		-- institucion ID
	SET Tipo_Automatico 	:= 'P';						-- mov automatico
    SET Mov_CargoCta		:= '41';
	SET Mov_AbonoCta		:= '40';
	SET BloquearSaldoParaPago := 1;
	SET TipoBloq_PagoRefe	:= 18;						-- Tipo de Bloqueo Pago por Referencia
	SET Descrip_Bloq		:= 'BLOQUEO DE PAGO POR REFERENCIA';
	SET Naturaleza_Bloq		:= 'B';
    SET ValorCierre			:= 'EjecucionCierreDia';

ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBCARGOABONOCTAWSPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

        -- Asignamos valores  ara fecha empresa, cliente y moneda.
        SELECT FechaSistema, EmpresaID INTO	Var_FechaSis, Var_EmpresaID
			FROM PARAMETROSSIS  LIMIT 1;

        SET Var_EjecutaCierre := (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);
        SET Var_PagoxReferencia := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='PagosXReferencia');

        -- Validamos que no se este ejecutando el cierre de dia
        IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=Salida_SI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
        END IF;

        SELECT   CuentaAhoID,	ClienteID,		MonedaID,		Estatus
			INTO Var_CuentaID,	Var_ClienteID, 	Var_MonedaID,	Var_EstatusC
		FROM CUENTASAHO
			WHERE CuentaAhoID = Par_CuentaAhoID;

		SELECT  Estatus, SucursalOrigen INTO Var_EstatusCli, Var_SucurCli
			FROM CLIENTES WHERE ClienteID = Var_ClienteID;

		-- Obtenemos usuario
        SELECT UsuarioID INTO   Var_UsuarioID
            FROM USUARIOS WHERE UsuarioID = Aud_Usuario;

        SET Var_InstitucionID	:=(SELECT ValorParametro FROM	PARAMETROSCRCBWS WHERE LlaveParametro= InstitucionBanco);
        SET Var_DescripMovBan	:= 'MOVIMIENTO DE EFECTIVO EN BANCOS';
		SET Aud_FechaActual		:= NOW();
		SET Par_EmpresaID		:= Var_EmpresaID;
        SET Var_NatAhorro		:= Par_NatMovimiento;
        SET Var_Consecutivo		:= Entero_Cero;

		-- Validamos la cuenta
		IF (IFNULL(Var_CuentaID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Numero de Cuenta No Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_EstatusC,Cadena_Vacia) != Estatus_Activo) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Estatus de la Cuenta No le Permite Realizar la Operacion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El Monto del Movimiento esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Var_UsuarioID,Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'Usuario Incorrecto.';
            LEAVE ManejoErrores;
        END IF;

        -- se valida naturaleza de mov. se asignan valores a conceptos
		IF(Par_NatMovimiento = Nat_Abono)THEN
			-- SE VALIDA EL CODIGO DE RASTREO
			IF(Par_CodigoRastreo != Cadena_Vacia)THEN
				-- SE VALIDA SI EXISTE EL CODIGO DE RASTREO
				IF EXISTS(SELECT CodigoRastreo FROM CRCBABONOCTAWS WHERE CodigoRastreo = Par_CodigoRastreo AND CuentaAhoID = Par_CuentaAhoID)THEN
					SET Par_NumErr  := 5;
					SET Par_ErrMen  := CONCAT('Codigo de Rastreo Existente: ',Par_CodigoRastreo,', el Abono no se Aplicara.');
					LEAVE ManejoErrores;
				END IF;

                -- LLAMADA AL PROCESO CRCBABONOCTAWSALT PARA REALIZAR EL ABONO A CUENTA DESDE WS CREDICLUB
				CALL CRCBABONOCTAWSALT (
					Par_CuentaAhoID,		Par_Monto,			Par_NatMovimiento,		Var_FechaSis,		Par_Referencia,
					Par_CodigoRastreo,		Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,
                    Aud_Usuario,			Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
                    Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Var_ConceptoConta	:= ConcepContaAbono;
			SET Var_TipoMovAho		:= AbonoCuenta;
			SET	Var_Cargos			:= Par_Monto;
			SET	Var_Abonos			:= Decimal_Cero;
            SET Var_NaturalezaBan	:= Nat_Abono;
            SET Var_TipoMovIDC		:= Mov_AbonoCta;
			SET Var_InstitucionID	:= (SELECT ValorParametro FROM	PARAMETROSCRCBWS WHERE LlaveParametro= InstitucionBanco);
            SET Var_CuentaBancos	:= (SELECT ValorParametro FROM	PARAMETROSCRCBWS WHERE LlaveParametro = CuentaAbono);
            SET Var_MensajeRes		:= 'Abono Realizado Exitosamente';
		ELSE
			IF(Par_NatMovimiento = Nat_Cargo)THEN
				SET Var_ConceptoConta	:= ConcepContaCargo;
				SET Var_TipoMovAho		:= RetiroCuenta;
				SET	Var_Cargos			:= Decimal_Cero;
				SET	Var_Abonos			:= Par_Monto;
				SET Var_NaturalezaBan	:= Nat_Cargo;
				SET Var_TipoMovIDC		:= Mov_CargoCta;
				SET Var_InstitucionID	:=(SELECT ValorParametro FROM	PARAMETROSCRCBWS WHERE LlaveParametro= InstitucionBancoCar);
				SET Var_CuentaBancos	:=(SELECT ValorParametro FROM	PARAMETROSCRCBWS WHERE LlaveParametro = CuentaCargo);
				SET Var_MensajeRes		:= 'Retiro Realizado Exitosamente';

           ELSE
				SET Par_NumErr  := 5;
				SET Par_ErrMen  := 'La Naturaleza del Movimiento no es Correcta.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF (IFNULL(Par_Referencia,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 6;
			SET Par_ErrMen  := 'La Referencia del Movimiento esta Vacia.';
			LEAVE ManejoErrores;
        END IF;

        IF (IFNULL(Var_CuentaBancos,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'La Cuenta de Bancos No Ha Sido Configurada.';
			LEAVE ManejoErrores;
        END IF;

		# Se consulta la descripcion del Movimiento
		SET Var_DescripcionMov	:= (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_TipoMovAho);
		SET Var_DescripcionMov	:= RTRIM(LTRIM(IFNULL(Var_DescripcionMov,Cadena_Vacia)));
        -- Descripcion Operativa
		SET Var_DescripcionOp	:= (SELECT Descripcion FROM TIPOSMOVTESO WHERE TipoMovTesoID = Var_TipoMovIDC);
		SET Var_DescripcionOp	:= RTRIM(LTRIM(IFNULL(Var_DescripcionOp,Cadena_Vacia)));

        -- se obtiene cuenta de bancos
        SELECT CuentaAhoID INTO Var_CuentaAhoInsID	FROM CUENTASAHOTESO
			WHERE InstitucionID = Var_InstitucionID
				AND NumCtaInstit  = Var_CuentaBancos;

		IF(IFNULL(Var_CuentaAhoInsID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'La Cuenta de Bancos No Corresponde a la Institucion Bancaria.';
			LEAVE ManejoErrores;
        END IF;

		/*Si la Referencia no viene vacia*/
       /* 1.- Cuando se lance el proceso para abonar a una cuenta y el campo Referencia venga vacio, se realizara el abono a la cuenta sin realizar ninguna otra accion.
       2.- Cuando se lance el proceso para abonar a una cuenta y el campo Referencia venga con datos, en primera instancia se debera de validar si la referencia efectivamente existe, de existir se debera de verificar que el credito ligado a esta referencia corresponda a la cuenta que se este abonando.
        a) Si la referencia no existe, o si existe pero la cuenta a la que estan abonando no  esta ligada al credito que pertenece la referencia,  se realizara el abono a la cuenta sin realizar ninguna otra accion.
        b) Si la referencia existe y el credito que tiene ligada la referencia pertenece a la cuenta que se esta abonando, se realizara el abono correspondiente y posteriormente se realizara un bloqueo automatico por concepto de “Bloqueo de pago por referencia”. Por lo anterior se creara un nuevo tipo de bloqueo de nombre “BLOQUEO DE PAGO POR REFERENCIA” . Este tipo de bloqueo podra desbloquearse manualmente.*/
      /* SET Var_NumErr := 0;
		SET  @Var_ErrMen := '';
		IF(Par_Referencia != Cadena_Vacia) THEN
			CALL PAGOXREFERENCIAVAL(
			Aud_NumTransaccion,			Par_CuentaAhoID,		Par_Referencia,				Par_Monto,				'N',
			Var_NumErr,				@Var_ErrMen,				Var_Credito,				Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion
			);

		END IF;*/

        -- Se manda a llamar SP de abono/cuenta
		CALL CARGOABONOCUENTAPRO(
			Par_CuentaAhoID, 		Var_ClienteID,		Aud_NumTransaccion, 	Var_FechaSis, 			Var_FechaSis,
			Par_NatMovimiento,		Par_Monto,			Var_DescripcionMov, 	Par_Referencia,			Var_TipoMovAho,
			Var_MonedaID, 			Var_SucurCli, 		AltaEncPoliza,			Var_ConceptoConta,		Par_Poliza,
			AltaPoliza, 			ConceptoAho,		Var_NatAhorro, 			Entero_Cero,			Salida_NO,
			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,   		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		CALL POLIZASTESOREPRO(
			Par_Poliza,         Par_EmpresaID,		Var_FechaSis,    		Var_InstitucionID,    Aud_Sucursal,
			Entero_Cero,   		Var_Cargos,         Var_Abonos,             Var_MonedaID,         Entero_Cero,
			Entero_Cero,    	Entero_Cero,  		Var_InstitucionID,      Var_CuentaBancos,     Var_DescripMovBan,
			Par_Referencia,     Var_Consecutivo,	Salida_NO,          	Par_NumErr,           Par_ErrMen,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,       Aud_Sucursal,
			Aud_NumTransaccion  );

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

        -- Se realizan Movimientos operativos y afectaciones al saldo de la cuenta de bancos

		CALL SALDOSCUENTATESOACT(
			Var_CuentaBancos,	Var_InstitucionID,		Par_Monto,			Var_NaturalezaBan,		Var_Consecutivo,
			Salida_NO,          Par_NumErr,         	Par_ErrMen,    		Par_EmpresaID,			Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,   		Aud_ProgramaID,     Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		CALL TESORERIAMOVIMIALT(
			Var_CuentaAhoInsID,	Var_FechaSis,			Par_Monto,				Var_DescripcionOp, 		Aud_NumTransaccion,
			Cadena_Vacia,     	Var_NaturalezaBan,  	Tipo_Automatico, 		Var_TipoMovIDC,  		Aud_NumTransaccion,
			Var_Consecutivo,	Salida_NO,        		Par_NumErr,         	Par_ErrMen,     		Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_MontoAplicado :=  Entero_Cero;
		IF(Par_NatMovimiento = Nat_Abono)THEN
			-- Se realiza el Cobro de Comisiones de Saldo Promedio
			CALL COMSALDOPROMCOBPENDPRO(
				Par_CuentaAhoID,	Par_Monto,		Var_MontoAplicado,	Par_Poliza,		Salida_NO,
				Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

			SET Var_MontoAplicado := IFNULL(Var_MontoAplicado, Entero_Cero);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Var_MontoBloquear := Entero_Cero;

		IF (Var_MontoAplicado > Entero_Cero)THEN
			SET Var_MontoBloquear := Par_Monto - Var_MontoAplicado;
		ELSE
			SET Var_MontoBloquear := Par_Monto;
		END IF;

		-- SI SE TRATA DE UNA CUENTA QUE BLOQUEA DE MANERA AUTOMATICA ***********************************************************************
		IF(Var_PagoxReferencia = 'S' AND Par_Referencia <> '') THEN

            SELECT
				MAX(CRED.CreditoID)
                INTO Var_Credito
				FROM CREDITOS AS CRED
					WHERE CRED.CuentaID = Par_CuentaAhoID
						AND CRED.ReferenciaPago = Par_Referencia
                        AND CRED.ReferenciaPago <> ''
                        AND CRED.Estatus not in ('I','K','C');

            IF IFNULL(Var_Credito,'') <> '' THEN
				CALL BLOQUEOSPRO(
					Entero_Cero,		'B',					Par_CuentaAhoID, 		Var_FechaSis,			Var_MontoBloquear,
					Aud_FechaActual,	TipoBloq_PagoRefe,		Descrip_Bloq,	 		Var_Credito,			Cadena_Vacia,
					Cadena_Vacia,		'N',					Par_NumErr,    			Par_ErrMen,				Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,
					Aud_NumTransaccion);

				 -- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF; -- **********************************************************************************************************************


        SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= Var_MensajeRes;

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr  AS NumErr,
				Par_ErrMen 	AS ErrMen;
	END IF;

END TerminaStore$$