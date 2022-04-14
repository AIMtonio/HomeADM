-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONFIGPRODUCTOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCONFIGPRODUCTOACT`;DELIMITER $$

CREATE PROCEDURE `PSLCONFIGPRODUCTOACT`(
	-- Stored procedure para actualizar la configuracion de los servicios en linea
	Par_ProductoID 					INT(11), 				-- ID del producto
	Par_ServicioID 					INT(11), 				-- ID del servicio
	Par_ClasificacionServ 			CHAR(2), 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)
	Par_Producto 					VARCHAR(200), 			-- Nombre del producto
	Par_Habilitado 					CHAR(1), 				-- Bandera para habilitar el producto en los canales (S = SI, N = NO)

	Par_NumAct 						INT(11), 				-- Opcion de actualizacion

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen 				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(2, 1); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE SalidaNO				CHAR(1);				-- Salida no
	DECLARE Var_HabilitadoSI 		CHAR(1);				-- Habilitado = SI
	DECLARE Var_HabilitadoNO 		CHAR(1);				-- Habilitado = NO
	DECLARE Est_Activo 				CHAR(1);				-- Estatus activo
	DECLARE Var_HabilitaProd 		TINYINT; 				-- Actualizacion para habilitar el producto
	DECLARE Var_DeshabilProd 		TINYINT; 				-- Actualizacion para desabilitar el producto

	-- Declaracion de variables
	DECLARE Var_Consecutivo 		INT(11); 				-- Variable consecutivo
	DECLARE Var_ServicioID 			INT(11); 				-- ID del servicio
	DECLARE Var_TipoServicioID 		INT(11); 				-- ID del tipo de servicio
	DECLARE Var_ProductoID			INT(11); 				-- ID del producto
	DECLARE Var_Habilitado 			CHAR(1); 				-- Producto habilitado

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_HabilitadoSI 			:= 'S';					-- Habilitado = SI
	SET Var_HabilitadoNO			:= 'N';					-- Habilitado = NO
	SET Est_Activo 					:= 'A';					-- Estatus activo
	SET Var_HabilitaProd 			:= 1; 					-- Actualizacion para habilitar el producto
	SET Var_DeshabilProd 			:= 2; 					-- Actualizacion para desabilitar el producto


	-- Valores por default
	SET Par_ProductoID 				:= IFNULL(Par_ProductoID, Entero_Cero);
	SET Par_ServicioID 				:= IFNULL(Par_ServicioID, Entero_Cero);
	SET Par_ClasificacionServ 		:= IFNULL(Par_ClasificacionServ, Entero_Cero);
	SET Par_Producto				:= IFNULL(Par_Producto, Cadena_Vacia);
	SET Par_Habilitado 				:= IFNULL(Par_Habilitado, Cadena_Vacia);

	SET Aud_EmpresaID				:= IFNULL(Aud_EmpresaID, Entero_Cero);
    SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
    SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
       			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-PSLCONFIGPRODUCTOACT');
			END;


		IF(Par_NumAct = Var_HabilitaProd) THEN
			IF(Par_ProductoID = Entero_Cero) THEN
				SET Par_NumErr	:= 1;
				SET Par_ErrMen	:= 'ID del producto no valido.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			SELECT ProductoID, Habilitado
				INTO Var_ProductoID, Var_Habilitado
				FROM PSLCONFIGPRODUCTO
				WHERE ProductoID = Par_ProductoID;

			IF(Var_ProductoID IS NULL) THEN
				SET Par_NumErr	:= 2;
				SET Par_ErrMen	:= 'El producto no se encuentra registrado.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			UPDATE PSLCONFIGPRODUCTO
				SET 	Habilitado 		= Var_HabilitadoSI,
						Producto		= Par_Producto,
						EmpresaID 		= Aud_EmpresaID,
						Usuario 		= Aud_Usuario,
						FechaActual 	= Aud_FechaActual,
						DireccionIP 	= Aud_DireccionIP,
						ProgramaID 		= Aud_ProgramaID,
						Sucursal 		= Aud_Sucursal,
						NumTransaccion 	= Aud_NumTransaccion
				WHERE ProductoID = Par_ProductoID;

			-- El registro se actualizo exitosamente
			SET Par_NumErr		:= 0;
			SET Par_ErrMen		:= 'Producto actualizado correctamente';
			SET Var_Consecutivo := Par_ProductoID;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumAct = Var_DeshabilProd) THEN
			IF(Par_ProductoID = Entero_Cero) THEN
				SET Par_NumErr	:= 1;
				SET Par_ErrMen	:= 'ID del producto no valido.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			SELECT ProductoID, Habilitado
				INTO Var_ProductoID, Var_Habilitado
				FROM PSLCONFIGPRODUCTO
				WHERE ProductoID = Par_ProductoID;

			IF(Var_ProductoID IS NULL) THEN
				SET Par_NumErr	:= 2;
				SET Par_ErrMen	:= 'El producto no se encuentra registrado.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			UPDATE PSLCONFIGPRODUCTO
				SET 	Habilitado 		= Var_HabilitadoNO,
						Producto		= Par_Producto,
						EmpresaID 		= Aud_EmpresaID,
						Usuario 		= Aud_Usuario,
						FechaActual 	= Aud_FechaActual,
						DireccionIP 	= Aud_DireccionIP,
						ProgramaID 		= Aud_ProgramaID,
						Sucursal 		= Aud_Sucursal,
						NumTransaccion 	= Aud_NumTransaccion
				WHERE ProductoID = Par_ProductoID;

			-- El registro se actualizo exitosamente
			SET Par_NumErr		:= 0;
			SET Par_ErrMen		:= 'Producto actualizado correctamente';
			SET Var_Consecutivo := Par_ProductoID;
			LEAVE ManejoErrores;
		END IF;


		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 1;
		SET Par_ErrMen		:= 'Opcion de actualizacion no valida';
		SET Var_Consecutivo := Entero_Cero;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen,
			   'productoID' 	AS control,
			   Var_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$