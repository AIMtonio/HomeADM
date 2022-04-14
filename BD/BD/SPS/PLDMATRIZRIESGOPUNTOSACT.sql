-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDMATRIZRIESGOPUNTOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDMATRIZRIESGOPUNTOSACT`;DELIMITER $$

CREATE PROCEDURE `PLDMATRIZRIESGOPUNTOSACT`(
	/*SP PARA CONSULTAR LA CONFIGURACION DE LOS RATIOS PARAMETRIZADOS POR PRODUCTO DE CREDITO.*/
	Par_MatrizCatalogoID	INT(11),			# Id del producto de credito
	Par_Porcentaje			DECIMAL(14,2),		# Porcentaje

	Par_Salida 				CHAR(1), 			# Salida S:Si N:No
	INOUT	Par_NumErr		INT(11),			# Numero de error
	INOUT	Par_ErrMen		VARCHAR(400),		# Mensaje de error

	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN
	# DECLARACION DE CONSTANTES
	DECLARE Entero_Cero				INT(11);		# Entero Cero
	DECLARE Cadena_Vacia			CHAR(1);		# Cadena Vacia
	DECLARE Salida_SI				CHAR(1);		# Salida Si
	DECLARE Var_Control				VARCHAR(20);	# Campo para el id del control de pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);	# Consecutivo que se mostrara en pantalla

	# ASIGNACION DE CONSTANTES
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
	SET Salida_SI					:= 'S';
	SET Var_Control					:= 'producCreditoID';
	SET Var_Consecutivo				:= '0';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDMATRIZRIESGOPUNTOSACT');
			SET Var_Control := 'sqlException';
		END;
		SET Par_MatrizCatalogoID	:= IFNULL(Par_MatrizCatalogoID,Entero_Cero);
		SET Par_Porcentaje			:= IFNULL(Par_Porcentaje,Entero_Cero);


		IF(Par_Porcentaje<= Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET	Par_ErrMen	:= CONCAT('El Porcentaje debe ser Mayor a 0.');
			SET Var_Control	:= 'graba';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual			:= NOW();

		UPDATE PLDMATRIZRIESGOXCONC SET
			Porcentaje				= Par_Porcentaje,

			EmpresaID				= Aud_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
			WHERE MatrizCatalogoID	= Par_MatrizCatalogoID;


		SET Par_NumErr := 000;
		SET	Par_ErrMen	:= 'Configuracion Actualizada Exitosamente.';
		SET Var_Control	:= 'graba';
		SET Var_Consecutivo := '';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$