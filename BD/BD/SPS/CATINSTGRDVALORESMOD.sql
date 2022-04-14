-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATINSTGRDVALORESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS CATINSTGRDVALORESMOD;

DELIMITER $$
CREATE PROCEDURE `CATINSTGRDVALORESMOD`(
	-- Store Procedure: De Modificacion del Catalogo de Instrumentos del menu de Guarda Valores
	-- Modulo Guarda Valores
	Par_CatInsGrdValoresID		INT(11),		-- ID de Tabla
	Par_NombreInstrumento		VARCHAR(50),	-- Nombre del Instrumento
	Par_Descripcion				VARCHAR(150),	-- Descripcion del Instrumento
	Par_Estatus					CHAR(1),		-- Estatus del Instrumento \nA.- Activo \nI.- Inactivo

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
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Retorno en Pantalla

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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CATINSTGRDVALORESMOD');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el Numero de Instrumento este Vacio
		IF( IFNULL(Par_CatInsGrdValoresID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero del Instrumento esta Vacio.';
			SET Var_Control	:= 'catInsGrdValoresID,';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el nombre de Instrumento este Vacio
		IF( IFNULL(Par_NombreInstrumento, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'El Nombre del Instrumento esta Vacio.';
			SET Var_Control	:= 'nombreInstrumento';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para la Descripcion de Instrumento este Vacio
		IF( IFNULL(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Estatus del Instrumento esta Vacio.';
			SET Var_Control	:= 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el Estatus de Instrumento este Vacio
		IF( IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= 'El Estatus del Instrumento esta Vacio.';
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		UPDATE CATINSTGRDVALORES SET
			CatInsGrdValoresID = Par_CatInsGrdValoresID,
			NombreInstrumento  = Par_NombreInstrumento,
			Descripcion		   = Par_Descripcion,
			Estatus			   = Par_Estatus,
			EmpresaID		   = Aud_EmpresaID,
			Usuario			   = Aud_Usuario,
			FechaActual		   = Aud_FechaActual,
			DireccionIP		   = Aud_DireccionIP,
			ProgramaID 		   = Aud_ProgramaID,
			Sucursal 		   = Aud_Sucursal,
			NumTransaccion	   = Aud_NumTransaccion
		WHERE CatInsGrdValoresID = Par_CatInsGrdValoresID;

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Instrumento Registrado Correctamente.';
		SET Var_Control	:= 'catInsGrdValoresID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_CatInsGrdValoresID AS Consecutivo;
	END IF;

END TerminaStore$$