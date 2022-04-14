-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERAPORTACIONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPERAPORTACIONMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPERAPORTACIONMOD`(
# ===============================================================================
# ------ SP PARA MODIFICAR LAS SUBCUENTAS DE TIPOS PERSONA DE APORTACIONES ------
# ===============================================================================
	Par_ConceptoAportacionID	INT(5),			-- ID del concepto de aportacion
	Par_Fisica		 			CHAR(2),		-- Persona fisica
	Par_FisicaActEmp			CHAR(2),		-- Persona fisica con actividad empresarial
	Par_Moral					CHAR(2),		-- Persona moral

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
										'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCTATIPERAPORTACIONMOD');
			END;

		IF(IFNULL(Par_ConceptoAportacionID,Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Concepto esta Vacio.';
			SET Var_Control	:= 'conceptoAportacionID';
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE SUBCTATIPERAPORTACION SET
					ConceptoAportID	= Par_ConceptoAportacionID,
					FisicaActEmp			= Par_FisicaActEmp,
					Fisica					= Par_Fisica,
					Moral					= Par_Moral,

					EmpresaID				= Aud_EmpresaID,
					Usuario					= Aud_Usuario,
					FechaActual 			= Aud_FechaActual,
					DireccionIP 			= Aud_DireccionIP,
					ProgramaID  			= Aud_ProgramaID,
					Sucursal				= Aud_Sucursal,
					NumTransaccion			= Aud_NumTransaccion
			WHERE  	ConceptoAportID 	= Par_ConceptoAportacionID;

		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'SubCuenta Contable Modificada Exitosamente';
		SET Var_Control	:= 'fisica';
		SET Var_Consecutivo:=Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$