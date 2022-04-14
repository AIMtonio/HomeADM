-- DEPOSITOACTIVACTAAHOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOACTIVACTAAHOPRO`;
DELIMITER $$

CREATE PROCEDURE `DEPOSITOACTIVACTAAHOPRO`(
	-- ----------------------------------------------------------------------------------------------------
	-- -- SP DE PROCESO DE DEPOSITO EN VENTANILLA PARA ACTIVAR CUENTA  --
	-- ----------------------------------------------------------------------------------------------------
	Par_CuentaAhoID         BIGINT(12),		-- ID de la cuenta de ahorro
    Par_ClienteID           BIGINT(20),		-- ID del cliente relacionado al a cuenta
    Par_FechaAplicacion     DATE,			-- Fecha de aplicación de la operacion
    Par_NatMovimiento       CHAR(1),		-- Naturaleza Contable del movimiento Cargo o Abono
    Par_CantidadMov         DECIMAL(12,2),	-- Monto del movimiento

    Par_DescripcionMov      VARCHAR(150),	-- Descripcion del movimiento
    Par_MonedaID            INT(11),		-- ID del tipo de moneda
    Par_ConceptoAhoID       INT(11),		-- ID de concepto de ahorro tabla CONCEPTOSAHORRO
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
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_Consecutivo     VARCHAR(20);
	DECLARE	Var_Cargos			DECIMAL(18,2);
	DECLARE	Var_Abonos			DECIMAL(18,2);
	DECLARE	Var_CuentaStr		VARCHAR(20);

	DECLARE Var_ConceptoAhoID	INT(11);

	-- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Entero_Cero     INT(11);
	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);

	DECLARE	Salida_SI		CHAR(1);
	DECLARE Act_DepositoVent INT(11);			-- 1 actualizacion del deposito hecho en ventanilla
    DECLARE Decimal_Cero	DECIMAL(18,2);
	DECLARE Fecha_Vacia     DATE;		   		-- Constante Fecha vacia 1900-01-01

	-- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
	SET	Nat_Cargo			:= 'C';
	SET	Nat_Abono			:= 'A';
	SET	Salida_NO			:= 'N';

	SET	Salida_SI			:= 'S';
	SET Act_DepositoVent	:= 1;
    SET Decimal_Cero		:= 0.0;
	SET Fecha_Vacia         := '1900-01-01';

    ManejoErrores: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				'Disculpe las molestias que esto le ocasiona. Ref: SP-DEPOSITOACTIVACTAAHOPRO');
			SET Var_Control := 'sqlException' ;
		END;

		IF(IFNULL(Par_CuentaAhoID,Entero_Cero)<= Entero_Cero)THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'La Cuenta de Ahorro esta vacia.';
			SET Var_Control		:= 'cuentaAhoIDdepAct';
			LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_ClienteID,Entero_Cero)<= Entero_Cero)THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El Cliente esta vacio.';
			SET Var_Control		:= 'cuentaAhoIDdepAct';
			LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_FechaAplicacion,Fecha_Vacia) = Fecha_Vacia)THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'La Fecha de Aplicacion esta vacia.';
			SET Var_Control		:= 'cuentaAhoIDdepAct';
			LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_NatMovimiento,Cadena_Vacia) <> Nat_Cargo AND IFNULL(Par_NatMovimiento,Cadena_Vacia) <> Nat_Abono)THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'La Natuaraleza del Movimiento esta vacio.';
			SET Var_Control		:= 'cuentaAhoIDdepAct';
			LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_CantidadMov,Entero_Cero)<= Entero_Cero)THEN
			SET Par_NumErr 		:= 5;
			SET Par_ErrMen 		:= 'El monto del Deposito debe ser mayor a cero.';
			SET Var_Control		:= 'cuentaAhoIDdepAct';
			LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_DescripcionMov,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr 		:= 6;
			SET Par_ErrMen 		:= 'La Descripcion esta vacia.';
			SET Var_Control		:= 'cuentaAhoIDdepAct';
			LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_MonedaID,Entero_Cero)<= Entero_Cero)THEN
			SET Par_NumErr 		:= 7;
			SET Par_ErrMen 		:= 'El ID de Moneda esta vacio.';
			SET Var_Control		:= 'cuentaAhoIDdepAct';
			LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_ConceptoAhoID,Entero_Cero)<= Entero_Cero)THEN
			SET Par_NumErr 		:= 8;
			SET Par_ErrMen 		:= 'El ID del Concepto de Ahorro esta vacio.';
			SET Var_Control		:= 'cuentaAhoIDdepAct';
			LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_PolizaID,Entero_Cero)<= Entero_Cero)THEN
			SET Par_NumErr 		:= 9;
			SET Par_ErrMen 		:= 'El ID del Poliza esta vacio.';
			SET Var_Control		:= 'cuentaAhoIDdepAct';
			LEAVE ManejoErrores;
        END IF;

        SELECT ConceptoAhoID
			INTO Var_ConceptoAhoID
		FROM CUENTASMAYORAHO
		WHERE ConceptoAhoID = Par_ConceptoAhoID;

		IF(IFNULL(Var_ConceptoAhoID,Entero_Cero)<= Entero_Cero)THEN
			SET Par_NumErr 		:= 10;
			SET Par_ErrMen 		:= 'Realizar la Parametrizacion de la guia Contable para Continuar con la Operacion.';
			SET Var_Control		:= 'cuentaAhoIDdepAct';
			LEAVE ManejoErrores;
        END IF;

		IF(Par_NatMovimiento = Nat_Cargo) THEN
			SET	Var_Cargos	:= Par_CantidadMov;
			SET	Var_Abonos	:= Decimal_Cero;
		  ELSE
			SET	Var_Cargos	:= Decimal_Cero;
			SET	Var_Abonos	:= Par_CantidadMov;
		END IF;

		SET Var_CuentaStr 	:= CONCAT("Cta.",CONVERT(Par_CuentaAhoID, CHAR));

		-- MOVIMIENTO CONTABLE
		-- ABONO A LA CUENTA PUENTE PARA DEPOSITOS DE ACTIVACION
		CALL `POLIZASAHORROPRO`(
			Par_PolizaID,		Par_EmpresaID,		Par_FechaAplicacion,	Par_ClienteID,		Par_ConceptoAhoID,
			Par_CuentaAhoID,	Par_MonedaID,		Var_Cargos,				Var_Abonos,			Par_DescripcionMov,
			Var_CuentaStr,
            Salida_NO,			Par_NumErr,			Par_ErrMen,				Aud_Usuario,		Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
		);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        -- MOVIMIENTO OPERATIVO
        -- ACTUALIZACION DEL ESTATUS DEL DEPOSITO, COMO PAGADO
		CALL `DEPOSITOACTIVACTAAHOACT`(
			Par_CuentaAhoID,	Par_FechaAplicacion,		Par_PolizaID,		Entero_Cero,		Act_DepositoVent,
            Salida_NO,			Par_NumErr,					Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Deposito para Activacion Procesado Exitosamente.');
        SET Var_Control := 'cuentaAhoIDdepAct' ;
        SET Var_Consecutivo := Par_PolizaID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr  AS NumErr,
                Par_ErrMen  AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo  AS consecutivo;
    END IF;

END TerminaStore$$