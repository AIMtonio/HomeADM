-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROAPORTACIONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPROAPORTACIONMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPROAPORTACIONMOD`(
# =======================================================================
# ------ SP PARA MODIFICAR LAS SUBCUENTAS DE TIPOS DE APORTACIONES ------
# =======================================================================
	Par_ConceptoAportacionID	INT(5),				-- ID del concepto de aportacion
	Par_TipoAportacionID		INT(11),			-- ID del tipo de aportacion
	Par_SubCuenta	 			CHAR(2),			-- Subcuenta

	Par_Salida					CHAR(1),			-- Especifica salida
	INOUT Par_NumErr 			INT(11),			-- Numero de error
	INOUT Par_ErrMen  			VARCHAR(400),		-- Mensaje de error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria
	Aud_Usuario					INT(11),			-- Parametro de auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal				INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control		VARCHAR(50);	-- Variable de control
	DECLARE Var_Consecutivo	INT(11);		-- Variable consecutivo

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT(3);
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE SalidaSI		CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';			-- Constante cadena vacia
	SET	Entero_Cero			:= 0;			-- Entero cero
	SET	Decimal_Cero		:= 0.0;			-- Decimal cero
    SET SalidaSI			:= 'S';			-- Indica salida

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCTATIPROAPORTACIONMOD');
			END;


		IF(IFNULL(Par_ConceptoAportacionID,Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Concepto esta Vacio.';
			SET Var_Control	:= 'conceptoAportacionID';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_SubCuenta,Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 	:= 2;
			SET	Par_ErrMen	:= 'La Subcuenta esta Vacia.';
			SET Var_Control	:= 'subCuenta2';
			LEAVE ManejoErrores;
		END IF;


		UPDATE SUBCTATIPROAPORTACION SET
				ConceptoAportID	= Par_ConceptoAportacionID,
				TipoAportacionID		= Par_TipoAportacionID,
				SubCuenta				= Par_SubCuenta,

				EmpresaID				= Aud_EmpresaID,
				Usuario					= Aud_Usuario,
				FechaActual 			= Aud_FechaActual,
				DireccionIP 			= Aud_DireccionIP,
				ProgramaID  			= Aud_ProgramaID,
				Sucursal				= Aud_Sucursal,
				NumTransaccion			= Aud_NumTransaccion
		WHERE	ConceptoAportID 	= Par_ConceptoAportacionID
		AND	 	TipoAportacionID		= Par_TipoAportacionID;

		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'SubCuenta Contable Modificada Exitosamente';
		SET Var_Control	:= 'tipoProductoID';
		SET Var_Consecutivo:=Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$