-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- UNIDADCONINVAGROMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `UNIDADCONINVAGROMOD`;DELIMITER $$

CREATE PROCEDURE `UNIDADCONINVAGROMOD`(
# =====================================================================================
# ------- STORE PARA MODIFICAR UNA UNIDAD  DE INVERSION---------
# =====================================================================================
	Par_UniConceptoInvID		BIGINT(20),				    -- ID de la Unidad de Inversion
    Par_Unidad		            VARCHAR(100),				-- Unidad de Inversion
	Par_Clave		            VARCHAR(45),				-- Clave de la Unidad

    Par_Salida		            CHAR(1),				    -- indica una salida
    INOUT Par_NumErr		    INT(11),				    -- numero de error
    INOUT Par_ErrMen 		    VARCHAR(400),				-- mensaje de error

    Aud_EmpresaID   		    INT(11),    		        -- parametros de auditoria
    Aud_Usuario     		    INT(11),
    Aud_FechaActual   		    DATETIME,
    Aud_DireccionIP   		    VARCHAR(15),
    Aud_ProgramaID    		    VARCHAR(50),
    Aud_Sucursal       		    INT(11),
    Aud_NumTransaccion  		BIGINT(20)
    )
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
    DECLARE Entero_Cero         INT(11);
	DECLARE Salida_SI 			CHAR(1);

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_Consecutivo		VARCHAR(50);
	DECLARE Var_ClaveInv		VARCHAR(45);

	-- Asignacion de constates
	SET	Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
	SET Entero_Cero         := 0;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-UNIDADCONINVAGROMOD');
			SET Var_Control	:= 'sqlException';
		END;

		SET Par_UniConceptoInvID		:= IFNULL(Par_UniConceptoInvID, Entero_Cero);
		SET Par_Unidad	                := IFNULL(Par_Unidad, Cadena_Vacia);
		SET Par_Clave		        	:= IFNULL(Par_Clave, Cadena_Vacia);

		IF(Par_UniConceptoInvID = Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Numero del Concepto NO Puede Estar Vacio.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'UnidadConceptoInv';
            LEAVE ManejoErrores;
		END IF;

		IF(Par_Unidad = Cadena_Vacia) THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'La Unidad No Puede Estar Vacia.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'Unidad';
            LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		UPDATE UNIDADCONINVAGRO SET
			Unidad		        = Par_Unidad,
			Clave			    = Par_Clave,
			EmpresaID			= Aud_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE UniConceptoInvID		= Par_UniConceptoInvID;

		SET	Par_NumErr			:= 0;
		SET	Par_ErrMen			:= CONCAT('Unidad Modificada Exitosamente: ',CONVERT(Par_UniConceptoInvID,CHAR));
		SET Var_Control			:= 'ConceptoInv';
		SET Var_Consecutivo		:= Par_UniConceptoInvID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$