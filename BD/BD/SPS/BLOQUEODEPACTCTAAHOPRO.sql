-- BLOQUEODEPACTCTAAHOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BLOQUEODEPACTCTAAHOPRO`;
DELIMITER $$

CREATE PROCEDURE `BLOQUEODEPACTCTAAHOPRO`(
-- =====================================================================================
-- --- STORED PARA BLOQUEO DEL DEPOSITO DE CUENTA PARA ACTIVACION  ---
-- =====================================================================================
	Par_CuentaAhoID 		BIGINT(12), 	-- Identificador de la cuenta de ahorro
    INOUT Par_PolizaID      BIGINT(20),		-- ID de la poliza contable

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
)TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
	DECLARE Var_CuentaAhoID 	BIGINT(12); 		-- Identificador de la cuenta de ahorro
	DECLARE Var_Estatus			INT(11);			-- Estatus cuenta
	DECLARE Var_MontoDepositoActiva	DECIMAL(18,2); 	-- Si requiere un deposito para activar la cuenta, se indica el monto del deposito

    DECLARE	Var_Cargos			DECIMAL(18,2);		-- Monto de Cargos
	DECLARE	Var_Abonos			DECIMAL(18,2);		-- Monto de Abonos
	DECLARE	Var_CuentaStr		VARCHAR(50);  		-- Descripcion de cuenta
    DECLARE Var_FechaAplicacion DATE;				-- Fecha de aplicacion
    DECLARE Var_FechaDeposito	DATE;				-- Fecha en que se realizo el deposito
    DECLARE Var_ClienteID		INT(11);			-- ID del cliente
    DECLARE Var_Descripcion		VARCHAR(100);		-- Descripcion
    DECLARE Var_MonedaID		INT(11);			-- Id del tipo de moneda

    DECLARE Var_DescripBloq		VARCHAR(150);		-- Descripcion del bloqueo
	DECLARE Var_BloqueID		INT(11);			-- ID de bloqueo

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Est_Registrado		INT(11);			-- 1 estatus registrado
	DECLARE Est_Depositado		INT(11);			-- 2 estatus depositado
	DECLARE Est_DepReg	     	INT(11);      		-- Estatus registrado Uno

	DECLARE	Nat_Cargo			CHAR(1);			-- Monto de cargos
	DECLARE	Nat_Abono			CHAR(1);			-- Monto de abonos
    DECLARE ConceptoAhoID_DepAct INT(11);			-- ID 34: de concepto de ahorro deposito por activacion CONCEPTOSAHORRO
    DECLARE ConceptoAhoID_Abono INT(11);			-- ID 1: Abono a cuenta CONCEPTOSAHORRO
    DECLARE TipoMovAhoID_DepAct	INT(11);			-- ID 113 de Tipo de movimiento de ahorro TIPOSMOVSAHO

	DECLARE Cons_SI       		CHAR(1);      		-- Constante S - si
	DECLARE Cons_NO       		CHAR(1); 			-- Constante N - no
    DECLARE Naturaleza_Bloq		CHAR(1);			-- Naturaleza Bloqueo
    DECLARE TipoBloq_DepAct		INT(11);			-- ID 24 tipo de bloqueo deposito de activacion TIPOSBLOQUEOS
    DECLARE Act_AbonoBloqueo	INT(11);			-- Actualizacion 2 actualiza el deposito si ya se abono y bloqueo el monto

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET	Est_Registrado			:= 1;
	SET	Est_Depositado			:= 2;
	SET Est_DepReg          	:= 1;

	SET	Nat_Cargo				:= 'C';
	SET	Nat_Abono				:= 'A';
    SET ConceptoAhoID_DepAct	:= 34;
    SET ConceptoAhoID_Abono		:= 1;
    SET TipoMovAhoID_DepAct		:= 113;

	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';
    SET Naturaleza_Bloq			:= 'B';
    SET TipoBloq_DepAct			:= 24;
    SET Act_AbonoBloqueo		:= 2;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BLOQUEODEPACTCTAAHOPRO');
			SET Var_Control = 'sqlException';
		END;

		IF(IFNULL(Par_CuentaAhoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'La Cuenta de Ahorro para el Deposito esta Vacia.';
			SET Var_Control		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

        SELECT DEP.CuentaAhoID,		DEP.Estatus, 	DEP.MontoDepositoActiva, 	CTA.ClienteID,		DEP.FechaDeposito,
				CTA.MonedaID
			INTO Var_CuentaAhoID,	 Var_Estatus, 	Var_MontoDepositoActiva, 	Var_ClienteID,		Var_FechaDeposito,
				Var_MonedaID
        FROM DEPOSITOACTIVACTAAHO DEP
			INNER JOIN CUENTASAHO CTA
				ON DEP.CuentaAhoID = CTA.CuentaAhoID
        WHERE DEP.CuentaAhoID = Par_CuentaAhoID;

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero) > Entero_Cero) THEN
			IF(IFNULL(Var_Estatus, Entero_Cero) = Est_Registrado) THEN
				SET Par_NumErr 		:= 2;
				SET Par_ErrMen 		:= CONCAT('La Cuenta de Ahorro Requiere un Deposito en Ventanilla de $',Var_MontoDepositoActiva,' para Activacion.');
				SET Var_Control		:= 'estatus';
				LEAVE ManejoErrores;
			END IF;

            -- SI SE REALIZO  EL DEPOSITO POR ACTIVACION EN VENTANILLA, SE REALIZA EL ABONO A LA CUENTA DEL CLIENTE Y SE BLOQUEA ESTE SALDO
            IF(IFNULL(Var_Estatus, Entero_Cero) = Est_Depositado) THEN

				IF(IFNULL(Par_PolizaID, Entero_Cero) <= Entero_Cero) THEN
					SET Par_NumErr 		:= 3;
					SET Par_ErrMen 		:= 'El ID de Poliza esta Vacio.';
					SET Var_Control		:= 'cuentaAhoID';
					LEAVE ManejoErrores;
				END IF;

				SET	Var_Cargos	:= Var_MontoDepositoActiva;
				SET	Var_Abonos	:= Decimal_Cero;

				SET Var_CuentaStr 	:= CONCAT("Cta.",CONVERT(Par_CuentaAhoID, CHAR));
				SET Var_FechaAplicacion := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
                SET Var_Descripcion := 'DEPOSITO PARA ACTIVACION DE CUENTA';

                -- CARGO A LA CUENTA PUENTE
				CALL `POLIZASAHORROPRO`(
					Par_PolizaID,		Par_EmpresaID,		Var_FechaAplicacion,	Var_ClienteID,		ConceptoAhoID_DepAct,
					Par_CuentaAhoID,	Var_MonedaID,		Var_Cargos,				Var_Abonos,			Var_Descripcion,
					Var_CuentaStr,
					Salida_NO,			Par_NumErr,			Par_ErrMen,				Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
				);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

                -- ABONO A LA CUENTA DE AHORRO
				CALL `CONTABAHORROPRO`(
					Par_CuentaAhoID,		Var_ClienteID,			Aud_NumTransaccion,		Var_FechaAplicacion,	Var_FechaAplicacion,
					Nat_Abono,				Var_MontoDepositoActiva,Var_Descripcion,		Par_CuentaAhoID,		TipoMovAhoID_DepAct,
					Var_MonedaID,			Entero_Cero,			Cons_NO,		 		Entero_Cero,			Par_PolizaID,
					Cons_SI,		 		ConceptoAhoID_Abono,	Nat_Abono,
                    Salida_NO,				Par_NumErr,				Par_ErrMen,				Entero_Cero,			Par_EmpresaID,
                    Aud_Usuario,            Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
                    Aud_NumTransaccion
				);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

                -- BLOQUEO DEL SALDO DE DEPOSITO PARA ACTIVACION DE CUENTA
                SET Var_DescripBloq := 'DEPOSITO ACTIVACION DE CUENTA';
                CALL `BLOQUEOSPRO`(
					Entero_Cero,	 	Naturaleza_Bloq,		Par_CuentaAhoID, 		Var_FechaAplicacion,	Var_MontoDepositoActiva,
					Fecha_Vacia,		TipoBloq_DepAct, 		Var_DescripBloq,		Par_CuentaAhoID,   		Cadena_Vacia,
					Cadena_Vacia,
                    Salida_NO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
                    Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
				);

				IF (Par_NumErr <> Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

                SET Var_BloqueID := (SELECT BloqueoID FROM BLOQUEOS WHERE CuentaAhoID = Par_CuentaAhoID AND TiposBloqID = TipoBloq_DepAct AND NumTransaccion = Aud_NumTransaccion);
				SET Var_BloqueID := IFNUlL(Var_BloqueID,Entero_Cero);

				-- ACTUALIZA EL ESTATUS DEL DEPOSITO
				CALL `DEPOSITOACTIVACTAAHOACT`(
					Par_CuentaAhoID,	Var_FechaAplicacion,		Par_PolizaID,		Var_BloqueID,		Act_AbonoBloqueo,
					Salida_NO,			Par_NumErr,					Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

            END IF;
		END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Proceso Deposito Activacion Cuenta Realizado Exitosamente: ',CAST(Par_CuentaAhoID AS CHAR) );
		SET Var_Control		:= 'depositoActCtaID';
		SET Var_Consecutivo	:= Par_CuentaAhoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$