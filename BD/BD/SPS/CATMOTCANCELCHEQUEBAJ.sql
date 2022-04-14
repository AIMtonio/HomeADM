-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMOTCANCELCHEQUEBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATMOTCANCELCHEQUEBAJ`;DELIMITER $$

CREATE PROCEDURE `CATMOTCANCELCHEQUEBAJ`(

	Par_EmpresaID			INT(11),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen		VARCHAR(400),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN


DECLARE  Entero_Cero       INT(11);
DECLARE  Decimal_Cero      DECIMAL(14,2);
DECLARE	 Cadena_Vacia	   CHAR(1);
DECLARE  Salida_SI		   CHAR(1);



DECLARE  Var_MotivoID	   INT(11);
DECLARE  Var_Control	   VARCHAR(200);
DECLARE  Var_Consecutivo   INT(11);


SET	Cadena_Vacia		:= '';
SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.0;
SET Salida_SI			:= 'S';


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := '999';
					SET Par_ErrMen := concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											 'esto le ocasiona. Ref: SP-CATMOTCANCELCHEQUEBAJ');
					SET Var_Control := 'sqlException' ;
				END;


	DELETE FROM CATMOTCANCELCHEQUE
	WHERE 	EmpresaID = Par_EmpresaID;


	SET Par_NumErr := 000;
	SET Par_ErrMen := "Motivos de Cancelacion de Cheques Grabados Exitosamente";
    SET Var_Control := 'MotivoID';
    SET Var_Consecutivo := Par_EmpresaID;


END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$