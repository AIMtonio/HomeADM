-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINATARIOSFTPPROSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESTINATARIOSFTPPROSBAJ`;

DELIMITER $$

CREATE PROCEDURE `DESTINATARIOSFTPPROSBAJ`(

	Par_Usuario					INT(11),

	Par_Salida					CHAR(1),
	INOUT Par_NumErr			INT(11),
	INOUT Par_ErrMen			VARCHAR(400),

	Aud_EmpresaID				INT(11),
	Aud_UsuarioID				INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore: BEGIN


	DECLARE Var_Control			VARCHAR(100);
	DECLARE Var_Usuario			INT(11);
	DECLARE Var_Estatus			CHAR(1);


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Salida_SI			CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Estatus_Activa		CHAR(1);



	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Entero_Cero		:= 0;
	SET Fecha_Vacia     := '1900-01-01';
	SET Estatus_Activa 	:= 'A';

	SET Var_Control		:= Cadena_Vacia;
    SET Var_Usuario		:= Entero_Cero;


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref:SP-DESTINATARIOSFTPPROSBAJ');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		DELETE FROM DESTINATARIOSFTPPROSA;

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Destinatarios Eliminados Exitosamente.';
		SET Var_Control:= 'usuario' ;


	END ManejoErrores;


	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_Usuario AS Consecutivo;
	END IF;

END TerminaStore$$