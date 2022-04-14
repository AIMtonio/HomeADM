-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALMACENESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS ALMACENESALT;

DELIMITER $$
CREATE PROCEDURE `ALMACENESALT`(
	-- Store Procedure: De Alta para los Almacenes del menu de Guarda Valores
	-- Modulo Guarda Valores
	Par_NombreAlmacen			VARCHAR(50),	-- Nombre o Descripcion del Almacen
	Par_Estatus					CHAR(1),		-- Estatus del Almacen \nA.- Activo \nI.- Inactivo
	Par_SucursalID				INT(11),		-- ID de Sucursal

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Par_AlmacenID		BIGINT(20);		-- ID de Tabla
	DECLARE Var_SucursalID		INT(11);		-- ID de Sucursal

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Constante de Salida SI
	DECLARE	Entero_Cero			INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno			INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero		DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET Var_Control		:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ALMACENESALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el nombre de Almacen este Vacio
		IF( IFNULL(Par_NombreAlmacen, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Nombre del Almacen esta Vacio.';
			SET Var_Control	:= 'nombreAlmacen';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el Estatus de Almacen este Vacio
		IF( IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'El Estatus del Almacen esta Vacio.';
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para la Sucursal este Vacio
		IF( IFNULL(Par_SucursalID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Numero de Sucursal esta Vacio.';
			SET Var_Control	:= 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		SELECT SucursalID
		INTO Var_SucursalID
		FROM SUCURSALES
		WHERE SucursalID = Par_SucursalID;

		SET Var_SucursalID := IFNULL(Var_SucursalID , Entero_Cero);
		IF( Var_SucursalID = Entero_Cero) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= CONCAT('La Sucursal ',Par_SucursalID,' no Existe.');
			SET Var_Control	:= 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		CALL FOLIOSAPLICAACT('ALMACENES', Par_AlmacenID);
		SET Aud_FechaActual := NOW();

		INSERT INTO ALMACENES (
			AlmacenID,			NombreAlmacen,			Estatus,			SucursalID,			EmpresaID,
			Usuario,			FechaActual,			DireccionIP,		ProgramaID,			Sucursal,
			NumTransaccion)
		VALUES(
			Par_AlmacenID,		Par_NombreAlmacen,		Par_Estatus,		Par_SucursalID,		Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Almacen Registrado Correctamente.';
		SET Var_Control	:= 'almacenID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_AlmacenID AS Consecutivo;
	END IF;

END TerminaStore$$