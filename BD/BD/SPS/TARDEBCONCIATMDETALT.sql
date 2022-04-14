-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCIATMDETALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONCIATMDETALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONCIATMDETALT`(
		-- Registra retiros de ATM
		Par_ConciliaATM		INT(11),			-- Identificador del encabezado del archivo
		Par_Emisor			VARCHAR(5),			-- Emisor de la operacion
		Par_TerminalID		VARCHAR(30),		-- Identicador del Cajero
		Par_TarjetaDebID	CHAR(16),			-- Numero de tarjeta de debito
		Par_CuentaOrigen	VARCHAR(25),		-- Cuenta de Origen de la transaccion
		Par_Descripcion		VARCHAR(20),		-- Descripcion de la transaccion RETIRO,CONSULTA,DEPOSITO

		Par_CodigoRespuesta	VARCHAR(3),			-- Codigo de respuesta de la transaccion
		Par_Secuencia		VARCHAR(7),			-- Numero de Secuencia de la transaccion
		Par_FechaTransac	VARCHAR(10),		-- Fecha en que se realizo la transaccion
		Par_HoraTransac		VARCHAR(10),		-- Hora en que se realizo la transaccion
		Par_Red				VARCHAR(8), 		-- Red del Cajero donde se realiz la transaccion

		Par_MontoTransac	DECIMAL(14,2),		-- Monto de la operacion en caso de retiro
		Par_Comision		DECIMAL(14,2),		-- Comision que cobro el cajero por la operacion
		Par_NumAutorizacion	VARCHAR(7),			-- Numero de autorizacion de la transaccion
		Par_Salida			CHAR(1),            -- Parametro de salida
INOUT	Par_NumErr			INT,                -- Numero de error
INOUT	Par_ErrMen			VARCHAR(400),       -- Mensaje de salida

		Aud_EmpresaID		INT,                -- Auditoria
		Aud_Usuario			INT,                -- Auditoria
		Aud_FechaActual		DATETIME,           -- Auditoria
		Aud_DireccionIP		VARCHAR(15),        -- Auditoria
		Aud_ProgramaID		VARCHAR(50),        -- Auditoria
		Aud_Sucursal		INT,                -- Auditoria
		Aud_NumTransaccion	BIGINT(20)          -- Auditoria
	)
TerminaStore:BEGIN

-- Declaracion de Constantes
DECLARE Cadena_Vacia				CHAR(1);        -- Cadena vacia
DECLARE Entero_Cero					INT;            -- Entero vacio
DECLARE Decimal_Cero				DECIMAL(12,2);  -- Decimal vacio
DECLARE Salida_SI					CHAR(1);        -- Salida del SP
DECLARE Var_FechaTransaccion 		DATE;           -- Fecha de la operacion
DECLARE Var_TipoMovimiento  		VARCHAR(15);    -- Tipo de movimiento
DECLARE Var_Control					VARCHAR(15);    -- Campo de control

-- Declaracion de Variables
DECLARE Var_DetallaATMID			INT(11);        -- Id del detalle de conciliacion
DECLARE TipoRetiro					VARCHAR(15);    -- Tipo de movimiento "retiro"

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';
SET Entero_Cero				:= 0;
SET Decimal_Cero			:= 0.0;
SET Salida_SI				:= 'S';
SET Var_FechaTransaccion 	:= STR_TO_DATE(Par_FechaTransac,'%d/%m/%y');
SET TipoRetiro				:= 'RETIRO';


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TARDEBCONCIATMDETALT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

	IF (IFNULL(Par_Emisor, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'El Emisor esta Vacio';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_TerminalID, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'La Terminal esta Vacia';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_TarjetaDebID, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'El Numero de Tarjeta esta Vacio';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_CuentaOrigen, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'La Cuenta de Origen esta Vacia';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'La Descripcion esta Vacia';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_CodigoRespuesta, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'El Codigo de Respuesta esta Vacio';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;


	IF (IFNULL(Par_HoraTransac, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'La Hora de Transaccion esta Vacia';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_FechaTransac, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'La Fecha de Trasaccion esta Vacia';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_Red, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'La Red del Cajero esta Vacio';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_MontoTransac, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'El Monto esta Vacio';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_NumAutorizacion, Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'El Numero de Autorizacion esta Vacio';
		SET Var_Control := Cadena_Vacia;
		LEAVE ManejoErrores;
	END IF;

    /*
    * Solo se registran los RETIROS, se dejo la validacion en el SP
    * para futuros cambios de esta validacion.
    */
    IF(IFNULL(Par_Descripcion,Cadena_Vacia) LIKE CONCAT('%',TipoRetiro,'%')) THEN

		CALL FOLIOSAPLICAACT('TARDEBCONCIATMDET', Var_DetallaATMID);

		INSERT INTO `TARDEBCONCIATMDET`(
			`ConciliaATMID`,	`DetalleATMID`,	`Emisor`,			`TerminalID`,		`TarjetaDebID`,
			`CuentaOrigen`,		`Descripcion`,	`CodigoRespuesta`,	`Secuencia`,		`FechaTransac`,
			`HoraTransac`,		`Red`,			`MontoTransac`,		`Comision`,			`NumAutorizacion`,
			`EmpresaID`,		`Usuario`,		`FechaActual`,		`DireccionIP`,		`ProgramaID`,
			`Sucursal`,			`NumTransaccion`)
		VALUES(
			Par_ConciliaATM, 		Var_DetallaATMID,			TRIM(Par_Emisor),		TRIM(Par_TerminalID),	TRIM(Par_TarjetaDebID),
			TRIM(Par_CuentaOrigen),	RTRIM(Par_Descripcion), 	Par_CodigoRespuesta,	Par_Secuencia,			Var_FechaTransaccion,
			Par_HoraTransac, 		TRIM(Par_Red), 				Par_MontoTransac,		Par_Comision,			Par_NumAutorizacion,
			Aud_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion	);
	END IF;

	SET Par_NumErr	:=  0;
	SET Par_ErrMen	:= 'Detalle de Transaccion Agregado Exitosamente.';

END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr   AS NumErr,
			Par_ErrMen	 AS ErrMen,
			Cadena_Vacia AS control,
			Cadena_Vacia AS consecutivo;

	END IF;
END TerminaStore$$