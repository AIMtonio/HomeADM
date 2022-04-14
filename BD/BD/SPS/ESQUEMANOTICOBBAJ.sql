-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMANOTICOBBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMANOTICOBBAJ`;DELIMITER $$

CREATE PROCEDURE `ESQUEMANOTICOBBAJ`(

	Par_EsquemaID		INT(11),

    Par_Salida 			CHAR(1),
	inout Par_NumErr	INT(11),
    inout Par_ErrMen	VARCHAR(150),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

)
TerminaStore: BEGIN


    DECLARE Var_Control		VARCHAR(50);
    DECLARE Var_Consecutivo	VARCHAR(20);



    DECLARE Fecha_Vacia		DATE;
    DECLARE Entero_Cero		INT(11);
    DECLARE Salida_SI		CHAR(1);



	SET	Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
    SET Salida_SI			:='S';


	ManejoErrores : BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
				concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ESQUEMANOTICOBBAJ');
			SET Var_Control = 'sqlException' ;
		END;

		DELETE FROM ESQUEMANOTICOB;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Esquema Eliminado Exitosamente ');
		SET Var_Control	:= 'esquemaID1';
		SET Var_Consecutivo:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;

END TerminaStore$$