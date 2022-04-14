-- COMENTASEGUIMIENTOPDMALT

DELIMITER ;
DROP PROCEDURE IF EXISTS `COMENTASEGUIMIENTOPDMALT`;
DELIMITER $$
CREATE  PROCEDURE `COMENTASEGUIMIENTOPDMALT`(
	/*
	* SP para grabar el cometario ya sea del cliente o del usuario
	* en el seguimiento de folios JPMovil
	*/
	Par_SeguimientoID		INT(11),
	Par_ComentarioUsuario	VARCHAR(200),
	Par_ComentarioCliente	VARCHAR(200),

	Par_Salida 				CHAR(1),			-- Indica si espera un SELECT de Salida
	INOUT Par_NumErr 		INT(11),			-- Numero de Error
	INOUT Par_ErrMen 		VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID 			INT(11),			-- Parametro de Auditoria
	Aud_Usuario 			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 			VARCHAR(50), 		-- Parametro de Auditoria
	Aud_Sucursal 			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20)			-- Parametro de Auditoria
)

TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);		-- Constante para el valor 0
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante para la cadena vacia
	DECLARE Salida_SI		CHAR(1);		-- Constante para el valor S

	-- Declaracion de Variables
	DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_Control			VARCHAR(50);


	-- Seteo de valores

	SET	Aud_FechaActual		:= NOW();			-- Se setea la fecha Actual

	SET Salida_SI			:= 'S';
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';


	ManejoErrores: BEGIN

	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 					'esto le ocasiona. Ref: SP-COMENTASEGUIMIENTOPDMALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF IFNULL(Par_ComentarioUsuario,Cadena_Vacia) = Cadena_Vacia
			AND IFNULL(Par_ComentarioCliente,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Debe existir al menos un comentario.';
			SET Var_Control:= 'cometario' ;
			LEAVE ManejoErrores;
		END IF;



		SELECT IFNULL(MAX(ConsecutivoID),Entero_Cero)+1 INTO Var_Consecutivo
		FROM COMENTASEGUIMIENTOPDM
		WHERE SeguimientoID = Par_SeguimientoID;


		INSERT INTO COMENTASEGUIMIENTOPDM
		(SeguimientoID,	ConsecutivoID,	ComentarioUsuario,	ComentarioCliente,	EmpresaID,
			Usuario, 	FechaActual,	DireccionIP,		ProgramaID,			Sucursal,
		NumTransaccion)
		VALUES
		(Par_SeguimientoID,	Var_Consecutivo,	Par_ComentarioUsuario,	Par_ComentarioCliente,	Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion);


		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= CONCAT('Cometario Agregado Exitosamente');
		SET Var_Control	:= 'comentario';

	END ManejoErrores;

		IF(Par_Salida = Salida_SI) THEN
			SELECT 	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS Control,
					Var_Consecutivo AS Consecutivo;
		END IF;
END TerminaStore$$