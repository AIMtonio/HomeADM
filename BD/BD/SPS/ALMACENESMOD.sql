-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALMACENESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS ALMACENESMOD;

DELIMITER $$
CREATE PROCEDURE `ALMACENESMOD`(
	-- Store Procedure: De Modificacion para los Almacenes del menu de Guarda Valores
	-- Modulo Guarda Valores
	Par_AlmacenID				BIGINT(20),		-- ID de Tabla
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
	DECLARE Var_SucursalID		INT(11);		-- ID de Sucursal
	DECLARE Var_Documentos 		INT(11);		-- Documentos

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Constante de Salida SI
	DECLARE	Est_Inactivo		CHAR(1);		-- Constante de Estatus Inactivo
	DECLARE	Est_Prestamo		CHAR(1);		-- Constante de Estatus Prestamo
	DECLARE	Entero_Cero			INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno			INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero		DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Est_Inactivo	:= 'I';
	SET	Est_Prestamo	:= 'P';
	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET Var_Control		:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ALMACENESMOD');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el ID de Almacen este Vacio
		IF( IFNULL(Par_AlmacenID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero de Almacen esta Vacio.';
			SET Var_Control	:= 'almacenID';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el nombre de Almacen este Vacio
		IF( IFNULL(Par_NombreAlmacen, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'El Nombre del Almacen esta Vacio.';
			SET Var_Control	:= 'nombreAlmacen';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el Estatus de Almacen este Vacio
		IF( IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Estatus del Almacen esta Vacio.';
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para la Sucursal este Vacio
		IF( IFNULL(Par_SucursalID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 004;
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

		SELECT IFNULL(COUNT(DocumentoID), Entero_Cero )
		INTO Var_Documentos
		FROM DOCUMENTOSGRDVALORES
		WHERE AlmacenID = Par_AlmacenID
		  AND Estatus = Est_Prestamo;

		IF(Var_Documentos <> Entero_Cero AND Par_Estatus = Est_Inactivo) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= CONCAT('El Almacen ',Par_AlmacenID,' Tiene Documentos en Prestamo y no puede Inhabilitarse.');
			SET Var_Control	:= 'almacenID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();
		UPDATE ALMACENES SET
			NombreAlmacen	= Par_NombreAlmacen,
			Estatus			= Par_Estatus,
			SucursalID		= Par_SucursalID,
			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE AlmacenID = Par_AlmacenID;

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Almacen Modificado Correctamente.';
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