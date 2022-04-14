-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMDIASFRECUENCIACREDBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMDIASFRECUENCIACREDBAJ`;
DELIMITER $$

CREATE PROCEDURE `PARAMDIASFRECUENCIACREDBAJ`(

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
	DECLARE Var_Estatus				CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion			VARCHAR(100);	-- Almacena la descripcion del producto de credito

	DECLARE Cadena_Vacia			VARCHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cons_NO					CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE Estatus_Inactivo		CHAR(1);	-- Estatus Inactivo

	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET Cons_NO						:= 'N';
	SET Salida_SI					:= 'S';
	SET Estatus_Inactivo			:= 'I';		 -- Estatus Inactivo

	SET Var_Control					:= 'producCreditoID';
	SET Var_Consecutivo				:= '';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr 	= 999;
			SET Par_ErrMen 	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMDIASFRECUENCIACREDBAJ');
			SET Var_Control = 'sqlException';
		END;

		SELECT 	Estatus,		Descripcion
		INTO 	Var_Estatus,	Var_Descripcion
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Par_ProducCreditoID;

		IF(IFNULL(Par_ProducCreditoID, Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr	:= 001;
			SET	Par_ErrMen	:= 'El Numero de Producto de Credito Esta Vacio.';
			SET Var_Control	:= 'producCreditoID';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Estatus = Estatus_Inactivo) THEN
			SET Par_NumErr 		:= 049;
			SET Par_ErrMen 		:= CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control		:= 'producCreditoID';
			SET Var_Consecutivo := '';
			LEAVE ManejoErrores;
		END IF;

        DELETE FROM
			PARAMDIAFRECUENCRED
				WHERE ProducCreditoID=Par_ProducCreditoID;

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('Informacion Grabada Exitosamente para el Producto: ',Par_ProducCreditoID,'.');
		SET Var_Control := 'producCreditoID';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$