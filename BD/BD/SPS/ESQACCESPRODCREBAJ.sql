-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQACCESPRODCREBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQACCESPRODCREBAJ`;
DELIMITER $$

CREATE PROCEDURE `ESQACCESPRODCREBAJ`(
-- =======================================================================
-- SP PAR DAR DE BAJA LOS ESQUEMAS PARA PODER DAR DE ALTA NUEVOS ESQUEMAS
-- =======================================================================
	Par_ProducCreditoID 		INT(11), 		# Identificador del Producto de Crédito
	Par_AccesorioID				INT(11), 		# Identificador del Accesorio
	Par_EmpresaNomina			INT(11),		# EmpresaNomnina

	Par_Salida           		CHAR(1),		# Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT,			# Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	# Mensaje de Error

	 /* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN

	/*Declaracion de Variables*/
	DECLARE Var_Control 	VARCHAR(50); 	# Varible Control Pantalla
	DECLARE Var_EmpresaNom	INT(11);		# Variable para identificar a la empresa nomina;

	/*Declaracion de Constantes*/
	DECLARE Entero_Cero 	INT(11); 		# Constante Entero Cero
    DECLARE Salida_Si		CHAR(1); 		# Constante Salida Si

	/*Asignacion de Constantes*/
	SET Entero_Cero 	:= 0; 				# Constante Entero Cero
    SET Salida_Si		:= 'S'; 			# Constante Salida Si

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQACCESPRODCREBAJ');
				SET Var_Control:= 'SQLEXCEPTION' ;
			END;

		IF(IFNULL(Par_ProducCreditoID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 999;
			SET Par_ErrMen := 'El producto de credito esta vacio.';
			SET Var_Control:= 'producCreditoID' ;
		END IF;

		IF(IFNULL(Par_AccesorioID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 999;
			SET Par_ErrMen := 'El accesorio esta vacio.';
			SET Var_Control:= 'accesorioID' ;
		END IF;



		SET Par_EmpresaNomina := IFNULL(Par_EmpresaNomina, Entero_Cero);

		IF Par_EmpresaNomina = Entero_Cero THEN
			DELETE FROM ESQCOBROACCESORIOS
			WHERE ProductoCreditoID = Par_ProducCreditoID
			AND AccesorioID = Par_AccesorioID;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := 'Detalles de Accesorios Eliminados correctamente. ';
			SET Var_Control:= 'producCreditoID' ;
			LEAVE ManejoErrores;
		ELSE

			DELETE		ESQCOBROACCESORIOS
			FROM 		ESQCOBROACCESORIOS
			LEFT JOIN 	CONVENIOSNOMINA ON ESQCOBROACCESORIOS.ConvenioID = CONVENIOSNOMINA.ConvenioNominaID
			WHERE		ESQCOBROACCESORIOS.ProductoCreditoID 	= Par_ProducCreditoID
			AND			ESQCOBROACCESORIOS.AccesorioID			= Par_AccesorioID
			AND			CONVENIOSNOMINA.InstitNominaID			= Par_EmpresaNomina;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := 'Detalles de Accesorios Eliminados correctamente. ';
			SET Var_Control:= 'producCreditoID' ;
			LEAVE ManejoErrores;

		END IF;


	END ManejoErrores;

	IF(Par_Salida=Salida_Si)THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$