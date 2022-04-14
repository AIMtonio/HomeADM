-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLHISPRODBROKERPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLHISPRODBROKERPRO`;DELIMITER $$

CREATE PROCEDURE `PSLHISPRODBROKERPRO`(
	-- Stored procedure para mandar al historico los produtos de un broker de servicios
	Par_FechaPaseHis 				DATETIME, 				-- Fecha y hora en la que se realizon el respaldo del catalogo al historico
	Par_FechaCatalogo 				DATETIME, 				-- Fecha y hora en la que se consulto el catalogo
	Par_ServicioID 					INT(11), 				-- Identificador del servicio
	Par_Servicio 					VARCHAR(100), 			-- Nombre del servicio
	Par_TipoServicio 				INT(11), 				-- ID del tipo de servicio
	Par_ProductoID 					INT(11), 				-- ID del producto
	Par_Producto 					VARCHAR(200), 			-- Nombre del producto
	Par_TipoFront 					INT(11), 		 		-- TipoFront de Broker
	Par_DigVerificador 				CHAR(1), 		 		-- Digito verificador,
	Par_Precio 						DECIMAL(14,2), 			-- Precio del producto,
	Par_ShowAyuda 					CHAR(1), 		 		-- Campo para mostrar ayuda,
	Par_TipoReferencia 				VARCHAR(20),			-- Campo tipo de referencia,

	Par_NumPro 						TINYINT UNSIGNED,		-- Parametro con el numero de proceso a ejecutar

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen 				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Par_Usuario						INT(11),				-- Parametros de auditoria
	Par_FechaActual					DATETIME,				-- Parametros de auditoria
	Par_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Par_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Par_Sucursal 					INT(11), 				-- Parametros de auditoria
	Par_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(2, 1); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE Var_SalidaNO			CHAR(1);				-- Salida no
	DECLARE Var_ProPaseHis			TINYINT;				-- Proceso de pase de catalogos a historico

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control
	DECLARE Var_MenPersUno			VARCHAR(100);			-- Mensaje personalizado para la tabla de MENSAJESISTEMA para el campo MensajeDev
	DECLARE Var_FechaHoraActual 	DATETIME; 				-- Fecha y hora actual del servidor
	DECLARE Var_NombreBroker 		VARCHAR(100); 			-- Nombre del Broker

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no
	SET Var_ProPaseHis 				:= 1;					-- Proceso de pase de catalogos a historico

	-- Valores por default
	SET Par_FechaPaseHis 			:= IFNULL(Par_FechaPaseHis, Fecha_Vacia);
	SET Par_FechaCatalogo 			:= IFNULL(Par_FechaCatalogo, Fecha_Vacia);
	SET Par_ServicioID 				:= IFNULL(Par_ServicioID, Entero_Cero);
	SET Par_Servicio 				:= IFNULL(Par_Servicio, Cadena_Vacia);
	SET Par_TipoServicio 			:= IFNULL(Par_TipoServicio, Entero_Cero);
	SET Par_ProductoID 				:= IFNULL(Par_ProductoID, Entero_Cero);
	SET Par_Producto 				:= IFNULL(Par_Producto, Cadena_Vacia);
	SET Par_TipoFront 				:= IFNULL(Par_TipoFront, Entero_Cero);
	SET Par_DigVerificador 			:= IFNULL(Par_DigVerificador, Cadena_Vacia);
	SET Par_Precio 					:= IFNULL(Par_Precio, Decimal_Cero);
	SET Par_ShowAyuda 				:= IFNULL(Par_ShowAyuda, Cadena_Vacia);
	SET Par_TipoReferencia			:= IFNULL(Par_TipoReferencia, Cadena_Vacia);

    SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
    SET Par_Usuario					:= IFNULL(Par_Usuario, Entero_Cero);
    SET Par_FechaActual				:= IFNULL(Par_FechaActual, Fecha_Vacia);
	SET Par_DireccionIP				:= IFNULL(Par_DireccionIP, Cadena_Vacia);
	SET Par_ProgramaID				:= IFNULL(Par_ProgramaID, Cadena_Vacia);
	SET Par_Sucursal				:= IFNULL(Par_Sucursal, Entero_Cero);
	SET Par_NumTransaccion			:= IFNULL(Par_NumTransaccion, Entero_Cero);


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
       			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-PSLHISPRODBROKERPRO');
			END;

		-- Proceso de pase de catalogos a historico
		IF(Par_NumPro = Var_ProPaseHis) THEN
			IF(Par_FechaPaseHis = Fecha_Vacia) THEN
				SET Par_NumErr	:= 1;
				SET Par_ErrMen	:= 'Especifique la fecha de pase a historico.';
				LEAVE ManejoErrores;
			END IF;

			-- Insertamos al historico los productos del broker
			INSERT INTO PSLHISPRODBROKER (
						FechaPaseHis,			FechaCatalogo, 			ServicioID, 			Servicio, 				TipoServicio,
						ProductoID, 			Producto, 				TipoFront, 				DigVerificador,			Precio,
						ShowAyuda, 				TipoReferencia, 		ClasificacionServ, 		EmpresaID, 				Usuario,
						FechaActual, 			DireccionIP, 			ProgramaID, 			Sucursal, 	 			NumTransaccion
				)
				SELECT 	Par_FechaPaseHis, 		FechaCatalogo,			ServicioID, 			Servicio, 				TipoServicio,
						ProductoID, 			Producto, 				TipoFront, 				DigVerificador,			Precio,
						ShowAyuda, 				TipoReferencia, 		ClasificacionServ,		EmpresaID, 				Usuario,
						FechaActual, 			DireccionIP, 			ProgramaID, 			Sucursal, 	 			NumTransaccion
					FROM PSLPRODBROKER;

			-- Eliminamos el catalogo de productos previamente respaldados
			DELETE FROM PSLPRODBROKER;

			-- El registro se inserto exitosamente
			SET Par_NumErr		:= 0;
			SET Par_ErrMen		:= 'Pase del catalogo de productos al historico realizado correctamente';

			LEAVE ManejoErrores;
		END IF;	-- Fin del proceso de pase de catalogos a historico
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr		AS NumErr,
			   	Par_ErrMen		AS ErrMen,
			   'cuentaAhoID' 	AS control,
				Entero_Cero 	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$