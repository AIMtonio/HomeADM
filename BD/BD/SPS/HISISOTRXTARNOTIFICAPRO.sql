-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISISOTRXTARNOTIFICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS HISISOTRXTARNOTIFICAPRO;

DELIMITER $$
CREATE PROCEDURE `HISISOTRXTARNOTIFICAPRO`(
	-- Store Procedure: Alta de Historico de Notificaciones para la tarea de Notificacion de Saldos a ISOTRX
	-- Modulo Tarjetas de Debito - WS ISOTRX
	Par_FechaOperacion			DATE,				-- ID de Tabla
	Par_RegistroID				BIGINT(20),			-- ID de Tabla

	Par_Salida					CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control						VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_RegistroID					BIGINT(20);		-- ID de  Registro

	-- Declaracion de Constantes
	DECLARE Entero_Cero						INT(11);		-- Constante de Entero Cero
	DECLARE Decimal_Cero					DECIMAL(14,2);	-- Constante de Decimal Cero
	DECLARE Fecha_Vacia						DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia					CHAR(1);		-- Constante de Cadena Vacia
	DECLARE Salida_SI						CHAR(1);		-- Constante Salida SI

	-- Asignacion de Constantes
	SET Entero_Cero 						:= 0;
	SET Decimal_Cero						:= 0.00;
	SET Fecha_Vacia 						:= '1900-01-01';
	SET Cadena_Vacia						:= '';
	SET Salida_SI							:= 'S';

	SET Var_Control							:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									 'esto le ocasiona. Ref: SP-HISISOTRXTARNOTIFICAPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		IF( IFNULL(Par_RegistroID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Numero de Registro No puede ser Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_FechaOperacion, Fecha_Vacia) = Fecha_Vacia ) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'La Fecha de Operacion No puede ser Vacia.';
			LEAVE ManejoErrores;
		END IF;

		SELECT RegistroID
		INTO Var_RegistroID
		FROM ISOTRXTARNOTIFICA
		WHERE FechaOperacion = Par_FechaOperacion
		  AND RegistroID = Par_RegistroID;

		IF( IFNULL(Var_RegistroID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'El Numero de Registro No Existe.';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO HISISOTRXTARNOTIFICA (
			FechaOperacion,		RegistroID,				HoraOperacion,	TipoTarjeta,		TarjetaID,
			CuentaAhoID,		OperacionPeticionID,	Transaccion,	MontoOperacion,		Estatus,
			PIDTarea,			NumeroIntentos,
			EmpresaID,			Usuario,				FechaActual,	DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
		SELECT
			FechaOperacion,		RegistroID,				HoraOperacion,	TipoTarjeta,		TarjetaID,
			CuentaAhoID,		OperacionPeticionID,	Transaccion,	MontoOperacion,		Estatus,
			PIDTarea,			NumeroIntentos,
			EmpresaID,			Usuario,				FechaActual,	DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion
		FROM ISOTRXTARNOTIFICA
		WHERE FechaOperacion = Par_FechaOperacion
		  AND RegistroID = Par_RegistroID;

		DELETE FROM ISOTRXTARNOTIFICA
		WHERE RegistroID = Par_RegistroID
		  AND FechaOperacion = Par_FechaOperacion;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Registro de Operacion realizado Correctamente.';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$