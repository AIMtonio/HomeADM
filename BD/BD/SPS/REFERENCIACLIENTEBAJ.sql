-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFERENCIACLIENTEBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `REFERENCIACLIENTEBAJ`;DELIMITER $$

CREATE PROCEDURE `REFERENCIACLIENTEBAJ`(

	Par_SolicitudCreditoID	BIGINT(20),
    Par_Salida 				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),
	Aud_Usuario				INT(11),

	Aud_Empresa				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore:BEGIN

	DECLARE Var_SolicitudCreditoID	BIGINT(20);
	DECLARE Var_Control				VARCHAR(20);
	DECLARE Var_Consecutivo			VARCHAR(50);

	DECLARE Cadena_Vacia			VARCHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cons_NO					CHAR(1);
	DECLARE Salida_SI				CHAR(1);

	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET Cons_NO						:= 'N';
	SET Salida_SI					:= 'S';

	SET Var_Control					:= 'solicitudCreditoID';
	SET Var_Consecutivo				:= 0;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-REFERENCIACLIENTEBAJ');
				SET Var_Control := 'sqlException';
			END;




		 IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero)) = Entero_Cero THEN
					SET	Par_NumErr	:= 001;
					SET	Par_ErrMen	:= 'El Numero de Solicitud de Credito Esta Vacio.';
					SET Var_Control	:= 'solicitudCreditoID';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

		DELETE FROM
			REFERENCIACLIENTE
				WHERE SolicitudCreditoID=Par_SolicitudCreditoID;

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('Referencias Eliminadas Exitosamente para la Solicitud de Credito: ',Par_SolicitudCreditoID);
		SET Var_Control := 'solicitudCreditoID';
	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$