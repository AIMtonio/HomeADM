-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSRELACIONADOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUESTOSRELACIONADOALT`;DELIMITER $$

CREATE PROCEDURE `PUESTOSRELACIONADOALT`(
# =====================================================================================
# ----- SP QUE DA DE ALTA LOS CARGOS DE LOS DIRECTIVOS -----------------
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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PUESTOSRELACIONADOALT');
				SET Var_Control	:= 'sqlException';
		END;

		SET Par_PuestoRelID		:= IFNULL(Par_PuestoRelID, Entero_Cero);
		SET Par_Descripcion	:= IFNULL(Par_Descripcion, Cadena_Vacia);

		-- VALIDACIONES
		IF(Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Puesto no Puede Estar Vacia.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'descripcion';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_PuestoRelID <> Entero_Cero) THEN
			IF EXISTS(SELECT PuestoRelID FROM PUESTOSRELACIONADO WHERE PuestoRelID = Par_PuestoRelID) THEN
				SET Par_NumErr		:= 002;
				SET Par_ErrMen		:= 'El Puesto ya Existe.';
				SET Var_Consecutivo	:= Cadena_Vacia;
				SET Var_Control		:= 'puestoRelID';
				LEAVE ManejoErrores;
			END IF;
		END IF;
		SET Aud_FechaActual := NOW();

		#SE OBTIENE EL ULTIMO NUMERO DE CARGO QUE SE HA INSERTADO
		SET Par_PuestoRelID:= (SELECT IFNULL(MAX(PuestoRelID),Entero_Cero) + 1
							FROM PUESTOSRELACIONADO);

		# SE INSERTA EL REGISTRO A LA TABLA
		INSERT INTO PUESTOSRELACIONADO(
			PuestoRelID,		Descripcion,		EmpresaID,		Usuario,			FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,  	 	NumTransaccion)
		VALUES (
			Par_PuestoRelID,	Par_Descripcion,	Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET	Par_NumErr			:= 0;
		SET	Par_ErrMen			:= CONCAT('Puesto Agregado Exitosamente: ', CONVERT(Par_PuestoRelID,CHAR));
		SET Var_Control			:= 'puestoRelID';
		SET Var_Consecutivo		:= Par_PuestoRelID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$