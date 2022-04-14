-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAGARFOGAFIBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAGARFOGAFIBAJ`;
DELIMITER $$


CREATE PROCEDURE `ESQUEMAGARFOGAFIBAJ`(
-- ================================================================
-- SP PARA DAR D BAJA EL ESQUEMA DE GARANTIA FOGAFI
-- ================================================================
	Par_ProducCreditoID		INT(11),			# Indica el Número de Producto

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),

	# Parametros de Auditoria
	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)

TerminaStore:BEGIN
	/* Declaracion de Variables */
	DECLARE Var_CobraGarantiaFinanciada CHAR(1);
	DECLARE varControl 		    CHAR(15);	# Indica el Control de Pantalla
	DECLARE Var_ConsecutivoID	INT(10); 	# Indica Consecutivo

	/* Declaracion de Constantes */
	DECLARE Entero_Cero			INT;		# Constante: Entero Cero
	DECLARE Salida_SI			CHAR(1);	# Constante: Salida Si

	/* Asignacion de Constantes */
	SET Entero_Cero			:= 0;			# Constante: Entero Cero
    	SET Salida_SI			:= 'S';			# Constante: Salida Si

	SELECT ValorParametro
	INTO Var_CobraGarantiaFinanciada
	FROM PARAMGENERALES
	WHERE LlaveParametro = 'CobraGarantiaFinanciada';

	SET Var_CobraGarantiaFinanciada := IFNULL(Var_CobraGarantiaFinanciada, 'N');

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := '999';
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMAGARFOGAFIBAJ');
				SET varControl := 'sqlException' ;
			END;

		IF(ifnull(Par_ProducCreditoID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El Producto de Credito esta vacio.';
			SET varControl  := 'producCreditoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ProducCreditoID
					FROM PRODUCTOSCREDITO
					WHERE ProducCreditoID = Par_ProducCreditoID)THEN
				SET Par_NumErr  := '002';
				SET Par_ErrMen  := 'No existe el Producto de Credito.';
				SET varControl  := 'agregar' ;
				LEAVE ManejoErrores;
		END IF;

		# Se eliminan los registros del esquema para la garantia FOGAFI
		DELETE FROM ESQUEMAGARFOGAFI
		WHERE ProducCreditoID = Par_ProducCreditoID;

		SET Par_NumErr  := '000';
		SET Par_ErrMen  := 'Esquema(s) de Garantia FOGAFI Eliminado(s) exitosamente.';
		SET varControl  := 'producCreditoID' ;

		IF( Var_CobraGarantiaFinanciada = 'N') THEN
			SET Par_ErrMen  := 'Esquema(s) de Garantia Liquida Eliminado(s) exitosamente.';
		END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		 AS ErrMen,
				varControl		 AS control,
				Par_ProducCreditoID	 AS consecutivo;
	end IF;

END TerminaStore$$