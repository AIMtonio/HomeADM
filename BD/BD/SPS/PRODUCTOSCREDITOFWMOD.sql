
-- PRODUCTOSCREDITOFWMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRODUCTOSCREDITOFWMOD`;
DELIMITER $$


CREATE PROCEDURE `PRODUCTOSCREDITOFWMOD`(
	-- Stored procedure para modificar un producto de credito del formulario web
	Par_ProductoCreditoFWID		INT(11),		-- ID identificador de la tabla
	Par_ProductoCreditoID		INT(11),		-- ID del producto de credito
	Par_DestinoCreditoID		INT(11),		-- ID del destino de credito
	Par_ClasificacionDestino	CHAR(1),		-- Clasificacion del destino de credito.
	Par_PerfilID				INT(11),		-- ID del perfil

	Par_Salida					CHAR(1),		-- Parametro para salida de datos
	INOUT Par_NumErr			INT(11),		-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen 			VARCHAR(400),	-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID 				INT(11), 		-- Parametros de auditoria
	Aud_Usuario					INT(11),		-- Parametros de auditoria
	Aud_FechaActual				DATETIME,		-- Parametros de auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametros de auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametros de auditoria
	Aud_Sucursal 				INT(11), 		-- Parametros de auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametros de auditoria
)

TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(14,2);			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;					-- Fecha vacia
	DECLARE Var_SalidaSI			CHAR(1);				-- Salida si
	DECLARE Var_SalidaNO			CHAR(1);				-- Salida no

	-- Declaracion de variables
	DECLARE Var_Consecutivo 		BIGINT(20); 			-- Variable consecutivo
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_SalidaSI				:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no

	-- Asignacion de variables
	SET Var_Consecutivo 			:= Entero_Cero;
	SET Var_Control		 			:= Cadena_Vacia;

	-- Valores por default
	SET Par_ProductoCreditoID 			:= IFNULL(Par_ProductoCreditoID, Entero_Cero);
	SET Par_DestinoCreditoID 			:= IFNULL(Par_DestinoCreditoID, Entero_Cero);
	SET Par_ClasificacionDestino 		:= IFNULL(Par_ClasificacionDestino, Cadena_Vacia);
	SET Par_PerfilID 					:= IFNULL(Par_PerfilID, Entero_Cero);

	SET Par_EmpresaID					:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario						:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual					:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP					:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID					:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal					:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion				:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-PRODUCTOSCREDITOFWMOD');
			SET Var_Control = 'sqlException';
		END;

		IF(Par_ProductoCreditoFWID = Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El producto de credito para formulario web es obligatorio.';
			SET Var_Control	:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ProductoCreditoID = Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El ProductoCreditoID es obligatorio.';
			SET Var_Control	:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_DestinoCreditoID = Entero_Cero) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El DestinoCreditoID es obligatorio.';
			SET Var_Control	:= 'destinoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ClasificacionDestino = Cadena_Vacia) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'La ClasificacionDestino es obligatorio.';
			SET Var_Control	:= 'clasificacionDestino';
			LEAVE ManejoErrores;
		END IF;

		UPDATE PRODUCTOSCREDITOFW SET
			ProductoCreditoID		= Par_ProductoCreditoID,
            DestinoCreditoID		= Par_DestinoCreditoID,
            ClasificacionDestino	= Par_ClasificacionDestino,
            PerfilID				= Par_PerfilID,

			EmpresaID			= Par_EmpresaID,
            Usuario				= Aud_Usuario,
            FechaActual			= Aud_FechaActual,
            DireccionIP			= Aud_DireccionIP,
            ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
            NumTransaccion		= Aud_NumTransaccion
        WHERE ProductoCreditoFWID = Par_ProductoCreditoFWID;

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Registro modificado exitosamente';
		SET Var_Control		:= 'productoCreditoID';

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$