-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAFONDEOCARTMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAFONDEOCARTMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTAFONDEOCARTMOD`(
# ====================================================================
#			SP PARA MODIFICAR LA SUBCUENTA POR FONDEADOR
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

	-- Declaración de constantes
	DECLARE	Cadena_Vacia	CHAR(1);		-- Constante cadena vacia
	DECLARE	Entero_Cero		INT(1);			-- Constante entero cero
	DECLARE	SalidaSI		CHAR(1);		-- COnstante salida si

    -- Declaracion de variables
	DECLARE VarControl 		VARCHAR(15);	-- Variable control

    -- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
    SET SalidaSI			:= 'S';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCTAFONDEOCARTMOD');
				SET VarControl = 'sqlException';
			END;

        IF(IFNULL(Par_ConceptoCarID, Entero_Cero)=Entero_Cero)THEN
			SET	Par_NumErr 	:= '001';
			SET	Par_ErrMen	:= 'El Concepto esta Vacio.';
			SET	VarControl	:= 'conceptoCarID';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_SubCuenta,Cadena_Vacia)=Cadena_Vacia)THEN
			SET	Par_NumErr 	:= '002';
			SET	Par_ErrMen	:= 'La Subcuenta esta Vacia.';
			SET	VarControl	:= 'subCuenta6';
			LEAVE ManejoErrores;
		END IF;

        SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE SUBCTAFONDEADORCART SET
			ConceptoCarID	= Par_ConceptoCarID,
			InstitutFondID	= Par_InstitutFondID,
			SubCuenta		= Par_SubCuenta	,

			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
			WHERE	ConceptoCarID 	= Par_ConceptoCarID
			AND		InstitutFondID	= Par_InstitutFondID;

	SET	Par_NumErr	:= '000';
	SET Par_ErrMen		:= CONCAT("Subcuenta Modificada Exitosamente: ", CONVERT(Par_ConceptoCarID, CHAR));
	SET	VarControl	:= 'subCuenta6';

	END ManejoErrores;  -- End del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				'subCuenta6' 	AS control,
				Par_SubCuenta 	AS consecutivo;
	END IF;

END TerminaStore$$