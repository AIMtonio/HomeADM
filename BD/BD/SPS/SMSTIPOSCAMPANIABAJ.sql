-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSTIPOSCAMPANIABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSTIPOSCAMPANIABAJ`;DELIMITER $$

CREATE PROCEDURE `SMSTIPOSCAMPANIABAJ`(
# ========================================================
# ------ SP PARA DAR DE BAJA LOS TIPOS DE CAMPANIA SMS------
# ========================================================
	Par_TipoCampaniaID	INT(11),
	Par_Salida			CHAR(1),

	INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de  variables
	DECLARE VarControl 	VARCHAR(100);
	DECLARE Var_NumCons	INT(11);

	-- Declaración de constantes
	DECLARE	Entero_Cero	INT;
	DECLARE SalidaSI	CHAR(1);
	DECLARE SalidaNO	CHAR(1);

	-- Asignación de constantes
	SET Entero_Cero 	:=0;		-- Entero Cero
	SET SalidaSI		:='S';		-- Salida Si
	SET SalidaNO		:='N';		-- Salida No


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSTIPOSCAMPANIABAJ');
			SET VarControl = 'SQLEXCEPTION';
		END;


		IF(IFNULL(Par_TipoCampaniaID,Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr := 1;
			SET Par_ErrMen := 'El tipo de campania no existe.';
			SET	VarControl 	:= 'tipoCampaniaID';
			SET Var_NumCons := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(EXISTS(SELECT	TC.TipoCampaniaID, C.Tipo
					FROM 	SMSTIPOSCAMPANIAS TC,
							SMSCAMPANIAS C
					WHERE	TC.TipoCampaniaID	= Par_TipoCampaniaID
					AND 	TC.TipoCampaniaID	= C.Tipo)) THEN

			SET	Par_NumErr := 2;
			SET Par_ErrMen := 'El tipo de campania es usada actualmente';
			SET	VarControl 	:= 'tipoCampaniaID';
			SET Var_NumCons := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;



		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		DELETE FROM  SMSTIPOSCAMPANIAS  WHERE Par_TipoCampaniaID	= TipoCampaniaID;

		SET	Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= CONCAT( 'Tipo de Campania Eliminado Exitosamente: ',CAST(Par_TipoCampaniaID AS CHAR));
		SET Var_NumCons	:= Entero_Cero;


	END ManejoErrores;  -- END del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'tipoCampaniaID' AS control,
				Var_NumCons AS consecutivo;

	END IF;

END TerminaStore$$