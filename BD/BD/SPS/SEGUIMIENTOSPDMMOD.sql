-- SEGUIMIENTOSPDMMOD

DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMIENTOSPDMMOD`;
DELIMITER $$
CREATE  PROCEDURE `SEGUIMIENTOSPDMMOD`(
	/*
	* SP para generar el folio con el que se le dara seguimiento al cliente
	*/
	Par_SeguimientoID		INT(11),			-- Folio del Seguimiento
	Par_NumActualiza			INT(11),			-- Numero de modificacion a realizar
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
	DECLARE Fecha_Vacia		DATE;			-- Constante para la Fecha vacia
	DECLARE CancelaFolio	INT(11);		-- Constante indica valor para cancelar el folio
	DECLARE FinalizaFolio	INT(11);		-- Constante indica valor para folio Resuelto
	DECLARE Est_Cancelado	CHAR(1);		-- Constante para el estatus CANCELADO
	DECLARE Est_Realizado	CHAR(1);		-- Constante para el estatus Realizado

	-- Declaracion de Variables
	DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_FechaSis		DATE;
	DECLARE Var_FechaActual		DATETIME;
	DECLARE Var_ContCliente		INT(11);
	DECLARE Var_ContUsuario		INT(11);
	-- Seteo de valores

	SET	Aud_FechaActual		:= NOW();			-- Se setea la fecha Actual

	SET Salida_SI			:= 'S';
	SET Est_Cancelado		:= 'C';
	SET Est_Realizado		:= 'R';
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SELECT FechaSistema INTO Var_FechaSis FROM PARAMETROSSIS;
	SET Var_FechaActual		:= CONCAT(Var_FechaSis," ",CURTIME());
	SET CancelaFolio		:= 5;
	SET FinalizaFolio		:= 6;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 					'esto le ocasiona. Ref: SP-SEGUIMIENTOSPDMMOD');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SELECT COUNT(ConsecutivoID) INTO Var_ContUsuario
		FROM COMENTASEGUIMIENTOPDM
		WHERE (ComentarioUsuario != NULL OR ComentarioUsuario!='')
			AND SeguimientoID = Par_SeguimientoID;

		SELECT COUNT(ConsecutivoID) INTO Var_ContCliente
		FROM COMENTASEGUIMIENTOPDM
		WHERE (ComentarioCliente != NULL OR ComentarioCliente!='')
			AND SeguimientoID = Par_SeguimientoID;

		SET Var_ContCliente := IFNULL(Var_ContCliente,Entero_Cero);
		SET Var_ContUsuario := IFNULL(Var_ContUsuario,Entero_Cero);

		IF Par_NumActualiza = CancelaFolio THEN

			IF Var_ContCliente = Entero_Cero THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'No se puede Cancelar el Folio Se requiere al menos un comentario del Cliente.';
				SET Var_Control:= 'comentarioCliente' ;
				LEAVE ManejoErrores;
			END IF;

			IF Var_ContUsuario = Entero_Cero THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'No se puede Cancelar el Folio Se requiere al menos un comentario del Usuario.';
				SET Var_Control:= 'comentarioUsuario' ;
				LEAVE ManejoErrores;
			END IF;

			UPDATE SEGUIMIENTOSPDM SET
				Estatus = Est_Cancelado,
				UsuarioCancela = Aud_Usuario,
				FechaCancela = Var_FechaActual,
				EmpresaID 	= Par_EmpresaID,
				Usuario = Aud_Usuario,
				FechaActual = NOW(),
				DireccionIP = Aud_DireccionIP,
				ProgramaID = Aud_ProgramaID,
				Sucursal = Aud_Sucursal,
				NumTransaccion = Aud_NumTransaccion
			WHERE SeguimientoID = Par_SeguimientoID;

			SET Par_NumErr 	:= Entero_Cero;
			SET Par_ErrMen 	:= CONCAT('Folio Cancelado Exitosamente: ',Par_SeguimientoID);
			SET Var_Control	:= 'seguimientoID';
		END IF;


		IF Par_NumActualiza = FinalizaFolio THEN

			IF Var_ContCliente = Entero_Cero THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'No se puede Finalizar el Folio Se requiere al menos un comentario del Cliente.';
				SET Var_Control:= 'comentarioCliente' ;
				LEAVE ManejoErrores;
			END IF;

			IF Var_ContUsuario = Entero_Cero THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'No se puede Finalizar el Folio Se requiere al menos un comentario del Usuario.';
				SET Var_Control:= 'comentarioUsuario' ;
				LEAVE ManejoErrores;
			END IF;

			UPDATE SEGUIMIENTOSPDM SET
				Estatus = Est_Realizado,
				UsuarioFinaliza = Aud_Usuario,
				FechaFinaliza = Var_FechaActual,
				EmpresaID 	= Par_EmpresaID,
				Usuario = Aud_Usuario,
				FechaActual = NOW(),
				DireccionIP = Aud_DireccionIP,
				ProgramaID = Aud_ProgramaID,
				Sucursal = Aud_Sucursal,
				NumTransaccion = Aud_NumTransaccion
			WHERE SeguimientoID = Par_SeguimientoID;

			SET Par_NumErr 	:= Entero_Cero;
			SET Par_ErrMen 	:= CONCAT('Folio Finalizado Exitosamente: ',Par_SeguimientoID);
			SET Var_Control	:= 'seguimientoID';
		END IF;

	END ManejoErrores;

		IF(Par_Salida = Salida_SI) THEN
			SELECT 	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS Control,
					Var_Consecutivo AS Consecutivo;
		END IF;
END TerminaStore$$