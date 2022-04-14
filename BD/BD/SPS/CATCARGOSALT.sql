-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCARGOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCARGOSALT`;DELIMITER $$

CREATE PROCEDURE `CATCARGOSALT`(
# =====================================================================================
# ----- SP QUE DA DE ALTA LOS CARGOS DE LOS DIRECTIVOS -----------------
# =====================================================================================

    Par_CargoID				INT(11),			# Consecutivo
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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CATCARGOSALT');
				SET Var_Control	:= 'sqlException';
		END;

		SET Par_CargoID		:= IFNULL(Par_CargoID, Entero_Cero);
		SET Par_Descripcion	:= IFNULL(Par_Descripcion, Cadena_Vacia);

		-- VALIDACIONES
		IF(Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'La Descripcion No Puede Estar Vacia.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		IF EXISTS(SELECT CargoID FROM CATCARGOS WHERE CargoID = Par_CargoID) THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'El Cargo ya Existe.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'cargoID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		#SE OBTIENE EL ULTIMO NUMERO DE CARGO QUE SE HA INSERTADO
		SET Par_CargoID:= (SELECT IFNULL(MAX(CargoID),Entero_Cero) + 1
							FROM CATCARGOS);

		# SE INSERTA EL REGISTRO A LA TABLA
		INSERT INTO CATCARGOS(
			CargoID,			Descripcion,		EmpresaID,		Usuario,			FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,  	 	NumTransaccion)
		VALUES (
			Par_CargoID,		Par_Descripcion,	Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET	Par_NumErr			:= 0;
		SET	Par_ErrMen			:= CONCAT('Cargo Agregado Exitosamente: ', CONVERT(Par_CargoID,CHAR));
		SET Var_Control			:= 'cargoID';
		SET Var_Consecutivo		:= Par_CargoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$