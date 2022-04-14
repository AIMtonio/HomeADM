-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOAPORTACIONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPLAZOAPORTACIONBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPLAZOAPORTACIONBAJ`(
# =======================================================================
# ------ SP PARA ELIMINAR LAS SUBCUENTAS DE PLAZOS DE APORTACIONES ------
# =======================================================================
	Par_ConceptoAportacionID	INT(11),		-- ID del concepto de la aportacion
	Par_TipoAportacionID		INT(11),		-- ID del tipo de aportacion
	Par_PlazoInferior			INT(11),		-- Plazo inferior
	Par_PlazoSuperior			INT(11),		-- Plazo superior

    Par_Salida					CHAR(1),		-- Especifica salida
	INOUT Par_NumErr 			INT(11),		-- Numero de error
	INOUT Par_ErrMen  			VARCHAR(400),	-- Mensaje de error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria
	Aud_Usuario					INT(11),		-- Parametro de auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal				INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria
)
TerminaStore: BEGIN


	-- Declaracion de variables
	DECLARE Var_Control		VARCHAR(50);	-- Variable de control
	DECLARE Var_Consecutivo	INT(11);		-- Consecutivo

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT(3);
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE SalidaSI		CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';			-- Constante cadena vacia
	SET	Entero_Cero			:= 0;			-- Entero cero
	SET	Decimal_Cero		:= 0.0;			-- Decimal cero
    SET SalidaSI			:= 'S';			-- Salida si


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCTAPLAZOAPORTACIONBAJ');
			END;

		DELETE
			FROM	SUBCTAPLAZOAPORTACION
			WHERE	ConceptoAportID	= Par_ConceptoAportacionID
			AND		TipoAportacionID		= Par_TipoAportacionID
            AND		PlazoInferior			= Par_PlazoInferior
            AND		PlazoSuperior			= Par_PlazoSuperior;

		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'SubCuenta Contable Eliminada Exitosamente';
		SET Var_Control	:= 'subCtaPlazoAportacionID';
		SET Var_Consecutivo:=Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$