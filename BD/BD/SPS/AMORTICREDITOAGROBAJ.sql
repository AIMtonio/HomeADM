-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOAGROBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOAGROBAJ`;DELIMITER $$

CREATE PROCEDURE `AMORTICREDITOAGROBAJ`(
/*SP para dar de baja las amortizaciones de crédito agropecuarios del calendario ideal*/
	Par_CreditoID		BIGINT(12),						# Numero de Crédito
	Par_Salida			CHAR(1),						# Salida S:Si N:No
	INOUT Par_NumErr	INT(11),						# Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),					# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);			# Valores paa la pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);			# Valores paa la pantalla
	-- Declaracion de constantes
	DECLARE SalidaNO				CHAR(1);
	DECLARE SalidaSI				CHAR(1);
	DECLARE Entero_Cero				INT(11);

	-- Asignacion de constantes
	SET	SalidaNO 					:= 'N';								# Salida Si
	SET	SalidaSI					:= 'S';								# Salida No
	SET Entero_Cero					:= 0;								# Entero Cero

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTICREDITOAGROBAJ');
			SET Var_Control	:= 'sqlexception';
		END;

		IF(IFNULL(Par_CreditoID, Entero_Cero) = 0) THEN
			SET Par_NumErr			:= 001;
			SET Par_ErrMen			:= 'El Numero de Credito esta Vacio';
			SET Var_Consecutivo		:= Par_CreditoID;
			SET Var_Control			:= 'graba';
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM AMORTICREDITOAGRO WHERE CreditoID = Par_CreditoID;

		SET Par_NumErr			:= 0;
		SET Par_ErrMen			:= 'Amortizaciones Eliminadas Exitosamente.';
		SET Var_Control			:= 'graba';
		SET Var_Consecutivo		:= Par_CreditoID;
	END ManejoErrores;

	 IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Var_Consecutivo 	AS consecutivo;
	 END IF;
END TerminaStore$$