-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOLISTAPLDMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOLISTAPLDMOD`;DELIMITER $$

CREATE PROCEDURE `CATTIPOLISTAPLDMOD`(
	/*SP para modificar las listas para el catalogo de listas de PLD*/
	Par_TipoListaID			VARCHAR(45),		# Tipo de Lista
	Par_Descripcion			VARCHAR(100),		# Descripcion de la lista
	Par_Estatus				CHAR(1),			# Estatus de la lista A: Activo I: Inactivo
	Par_Salida				CHAR(1),			# Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			# Numero de Error

	INOUT Par_ErrMen		VARCHAR(400),		# Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11) ,
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI 			CHAR(1);

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_Consecutivo		VARCHAR(50);
	DECLARE Var_TipoListaID		VARCHAR(45);

	-- Asignacion de constates
	SET	Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CATTIPOLISTAPLDMOD');
			SET Var_Control	:= 'sqlException';
		END;

		SET Par_TipoListaID		:= IFNULL(Par_TipoListaID, Cadena_Vacia);
		SET Par_Descripcion		:= IFNULL(Par_Descripcion, Cadena_Vacia);
		SET Par_Estatus			:= IFNULL(Par_Estatus, Cadena_Vacia);

		IF(Par_TipoListaID = Cadena_Vacia) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Tipo Lista ID No Puede Estar Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'tipoListaID';
            LEAVE ManejoErrores;
		END IF;

		IF(Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'La Descripcion No Puede Estar Vacia.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'descripcion';
            LEAVE ManejoErrores;
		END IF;

		IF(Par_Estatus = Cadena_Vacia) THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'El Estatus No Puede Estar Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'estatus';
            LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		UPDATE CATTIPOLISTAPLD SET
			Descripcion			= Par_Descripcion,
			Estatus				= Par_Estatus,
			EmpresaID			= Aud_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE TipoListaID		= Par_TipoListaID;

		SET	Par_NumErr			:= 0;
		SET	Par_ErrMen			:= CONCAT('Tipo de Lista de PLD Modificado Exitosamente.');
		SET Var_Control			:= 'tipoListaID';
		SET Var_Consecutivo		:= Par_TipoListaID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$