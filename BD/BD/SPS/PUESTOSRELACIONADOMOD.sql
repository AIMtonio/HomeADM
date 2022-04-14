-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSRELACIONADOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUESTOSRELACIONADOMOD`;DELIMITER $$

CREATE PROCEDURE `PUESTOSRELACIONADOMOD`(
# =====================================================================================
# ----- SP PARA MODIFICAR LOS CARGOS DE LOS DIRECTIVOS -----------------
# =====================================================================================
    Par_PuestoRelID			INT(11),			# Consecutivo
	Par_Descripcion			VARCHAR(50),		# Descripcion

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

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI 			CHAR(1);
    DECLARE Entero_Cero			INT(11);

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_Consecutivo		VARCHAR(50);

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
    SET Entero_Cero 			:= 0;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PUESTOSRELACIONADOMOD');
			SET Var_Control	:= 'sqlException';
		END;

		SET Par_PuestoRelID	:= IFNULL(Par_PuestoRelID, Entero_Cero);
		SET Par_Descripcion	:= IFNULL(Par_Descripcion, Cadena_Vacia);

		# VALIDACIONES
		IF(Par_PuestoRelID	 =	Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Puesto No Puede Estar Vacio.';
			SET Var_Consecutivo	:= Entero_Cero;
			SET Var_Control		:= 'puestoRelID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'La Descripcion No Puede Estar Vacia.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'descripcion';
            LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

        # SE ACTUALIZA LA TABLA DE CARGOS
		UPDATE PUESTOSRELACIONADO SET
			Descripcion			= Par_Descripcion,
			EmpresaID			= Aud_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE PuestoRelID		= Par_PuestoRelID;

		SET	Par_NumErr			:= 0;
		SET	Par_ErrMen			:= CONCAT('Puesto Modificado Exitosamente: ', CONVERT(Par_PuestoRelID,CHAR));
		SET Var_Control			:= 'puestoRelID';
		SET Var_Consecutivo		:= Par_PuestoRelID;

	END ManejoErrores;

    # RESULTADO DE SALIDA
	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$