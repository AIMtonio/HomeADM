-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROCUOTABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMASEGUROCUOTABAJ`;DELIMITER $$

CREATE PROCEDURE `ESQUEMASEGUROCUOTABAJ`(

	Par_ProducCreditoID		BIGINT(20),
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
TerminaStore: BEGIN


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


	SET Var_Control					:= 'producCreditoID';
	SET Var_Consecutivo				:= '';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMASEGUROCUOTABAJ');
			SET Var_Control := 'sqlException';
		END;

		IF(IFNULL(Par_ProducCreditoID, Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr	:= 001;
			SET	Par_ErrMen	:= 'El Numero de Producto de Credito Esta Vacio.';
			SET Var_Control	:= 'producCreditoID';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

        DELETE FROM
			ESQUEMASEGUROCUOTA
				WHERE ProducCreditoID=Par_ProducCreditoID;

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('La Parametrizacion para el Producto ',Par_ProducCreditoID,' ha sido Eliminada Exitosamente.');
		SET Var_Control := 'producCreditoID';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$