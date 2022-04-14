-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAFONDEOCARTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAFONDEOCARTBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTAFONDEOCARTBAJ`(
# ====================================================================
#			SP PARA DAR DE BAJA LA SUBCUENTA POR FONDEADOR
# ====================================================================
	Par_ConceptoCarID		INT(11),		-- Parametro de Concepto
	Par_InstitutFondID		INT(11),		-- Parametro ID Institucion de fondeo
	Par_SubCuenta	 		CHAR(2),		-- Parametro Subcuenta
	Par_Salida				CHAR(1),		-- Parametro salida si
	INOUT	Par_NumErr		INT(11),		-- Parametro Numero de error
	INOUT	Par_ErrMen		VARCHAR(400),	-- Parametro Mensaje de error

    -- Parametros de Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE	SalidaSI		CHAR(1);		-- Constante salida Si

	-- Declaracion de variables
	DECLARE VarControl 		VARCHAR(15);	-- Variable de control

    -- Asignacion de Constantes
    SET	SalidaSI := 'S';

    ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCTAFONDEOCARTBAJ');
				SET VarControl = 'sqlException';
			END;

		IF NOT EXISTS(SELECT	ConceptoCarID,  InstitutFondID
						FROM	SUBCTAFONDEADORCART
							WHERE	ConceptoCarID	= Par_ConceptoCarID
							AND		InstitutFondID	= Par_InstitutFondID
					  )THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'La Subcuenta que intenta Eliminar no Existe';
			LEAVE ManejoErrores;
		END IF;


		DELETE FROM   SUBCTAFONDEADORCART
			WHERE	ConceptoCarID	= Par_ConceptoCarID
			AND		InstitutFondID	= Par_InstitutFondID;

		SET	Par_NumErr	:= '000';
		SET Par_ErrMen	:= 'SubCuenta Eliminada Exitosamente';
		SET	VarControl	:= 'subCuenta6';

	END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				'subCuenta6' 	AS control,
				Par_SubCuenta 	AS consecutivo;
	END IF;
END TerminaStore$$