-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLPRODBROKERALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLPRODBROKERALT`;DELIMITER $$

CREATE PROCEDURE `PSLPRODBROKERALT`(
	-- Stored procedure para dar de alta los productos del broker
	Par_FechaCatalogo 				DATETIME, 				-- Fecha y hora en la que se consulto el catalogo
	Par_ServicioID 					INT(11), 				-- Identificador del servicio
	Par_Servicio 					VARCHAR(100), 			-- Nombre del servicio
	Par_TipoServicio 				INT(11), 				-- ID del tipo de servicio
	Par_ProductoID 					INT(11), 				-- ID del producto
	Par_Producto 					VARCHAR(200), 			-- Nombre del producto
	Par_TipoFront 					INT(11), 		 		-- TipoFront de Broker
	Par_DigVerificador 				CHAR(1), 		 		-- Digito verificador de Broker,
	Par_Precio 						DECIMAL(14,2), 			-- Precio del producto,
	Par_ShowAyuda 					CHAR(1), 		 		-- Campo ShowAyuda de Broker,
	Par_TipoReferencia 				VARCHAR(20),			-- Campo ShowAyuda de Broker,

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
	DECLARE Var_TipoFront1			INT(11);				-- TipoFront = 1 para las validaciones de tipoReferencia = ""
	DECLARE Var_TipoFront2			INT(11);				-- TipoFront = 2 para las validaciones de precio = 0.0
	DECLARE Var_TipoFront4			INT(11);				-- TipoFront = 4 para las validaciones de precio = 0.0
	DECLARE Var_TipoFront6			INT(11);				-- TipoFront = 6 para las validaciones de precio = 0.0
	DECLARE Var_TipoFront10			INT(11);				-- TipoFront = 10 para las validaciones de tipoReferencia = ""
	DECLARE Var_ProRegistroDef		TINYINT;				-- Proceso de registro con valores por defecto
	DECLARE Var_TRecarga 			TINYINT;				-- Tipo proceso recarga de tiempo aire
	DECLARE Var_TConsultaSaldo		TINYINT;				-- Tipo consulta saldo
	DECLARE Var_TPagoServicio 		TINYINT;				-- Tipo proceso pago de servicios
	DECLARE Var_ClasificacionRE 	CHAR(2); 				-- Clasificacion para Recarga de tiempo aire
	DECLARE Var_ClasificacionCO 	CHAR(2); 				-- Clasificacion para Consulta de Saldo
	DECLARE Var_ClasificacionPS 	CHAR(2); 				-- Clasificacion para Pago de servicios

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control
	DECLARE Var_MenPersUno			VARCHAR(100);			-- Mensaje personalizado para la tabla de MENSAJESISTEMA para el campo MensajeDev
	DECLARE Var_Consecutivo 		INT; 					-- Variable con el consecutivo
	DECLARE Var_TipoServicioID		INT; 					-- ID del tipo de servicio
	DECLARE Var_ClasificacionServ	CHAR(2); 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no
	SET Var_TipoFront1				:= 1;					-- Asignacion de TipoFront = 1
	SET Var_TipoFront2				:= 2;					-- Asignacion de TipoFront = 2
	SET Var_TipoFront4				:= 4;					-- Asignacion de TipoFront = 4
	SET Var_TipoFront6				:= 6;					-- Asignacion de TipoFront = 6
	SET Var_TipoFront10				:= 10;					-- Asignacion de TipoFront = 10
	SET Var_ProRegistroDef 			:= 1;					-- Proceso de registro con valores por defecto
	SET Var_TRecarga 				:= 1;					-- Tipo proceso recarga de tiempo aire
	SET Var_TConsultaSaldo			:= 4;					-- Tipo consulta saldo
	SET Var_TPagoServicio 			:= 2;					-- Tipo proceso pago de servicios
	SET Var_ClasificacionRE 		:= 'RE'; 				-- Clasificacion para Recarga de tiempo aire
	SET Var_ClasificacionCO 		:= 'CO'; 				-- Clasificacion para Consulta de Saldo
	SET Var_ClasificacionPS 		:= 'PS'; 				-- Clasificacion para Pago de servicios

	-- Valores por default
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
											'Disculpe las molestias que esto le ocasiona. Ref: SP-PSLPRODBROKERALT');
			END;

		-- Validaciones
		IF(Par_FechaCatalogo = Fecha_Vacia) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'Especifique la fecha y hora de consulta de catalogo';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ServicioID = Entero_Cero) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'Especifique el identificador de servicio';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Servicio = Cadena_Vacia) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'Especifique el nombre de servicio';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoServicio = Entero_Cero) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'Especifique el tipo de servicio';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ProductoID = Entero_Cero) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'Especifique el identificador del producto';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Producto = Cadena_Vacia) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= 'Especifique el nombre del producto';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoFront = Entero_Cero) THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= 'Especifique el tipo de frente';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_DigVerificador = Cadena_Vacia) THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen	:= 'Especifique el digito verificador';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Precio = Decimal_Cero) THEN
			IF(Par_TipoFront = Var_TipoFront1) THEN
				SET Par_NumErr	:= 9;
				SET Par_ErrMen	:= CONCAT('Especifique el precio del producto con ID ', Par_ProductoID);
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_Precio < Decimal_Cero) THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:= CONCAT('Precio no valido para el producto con ID ', Par_ProductoID);
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ShowAyuda = Cadena_Vacia) THEN
			SET Par_NumErr	:= 11;
			SET Par_ErrMen	:= 'Especifique el campo show ayuda';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoReferencia = Cadena_Vacia) THEN
			IF(Par_TipoFront != Var_TipoFront1 AND Par_TipoFront != Var_TipoFront10) THEN
				SET Par_NumErr	:= 12;
				SET Par_ErrMen	:= 'Especifique el tipo de referencia';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Definimos la clasificacion del servicio
		SELECT 	CASE Par_TipoFront
					WHEN Var_TipoFront1 THEN Var_ClasificacionRE
            		WHEN Var_TipoFront4 THEN Var_ClasificacionCO
            	ELSE Var_ClasificacionPS
            	END AS CalsificacionServ
            INTO Var_ClasificacionServ;

		-- Fin de validaciones
		INSERT INTO PSLPRODBROKER (		FechaCatalogo,			ServicioID,				Servicio,				TipoServicio,			ProductoID,
										Producto,				TipoFront,				DigVerificador,			Precio,					ShowAyuda,
										TipoReferencia, 		ClasificacionServ, 		EmpresaID, 				Usuario, 				FechaActual,
										DireccionIP, 			ProgramaID, 			Sucursal, 	 			NumTransaccion
									  )
								VALUES(
										Par_FechaCatalogo,		Par_ServicioID,			Par_Servicio,			Par_TipoServicio,		Par_ProductoID,
										Par_Producto,			Par_TipoFront,			Par_DigVerificador,		Par_Precio,				Par_ShowAyuda,
										Par_TipoReferencia,		Var_ClasificacionServ, 	Par_EmpresaID, 			Par_Usuario, 			Par_FechaActual,
										Par_DireccionIP, 		Par_ProgramaID, 		Par_Sucursal, 	 		Par_NumTransaccion
								);

		-- Generamos catalog de configuracion con valores por defecto
		CALL PSLCONFIGPRODUCTOPRO (
			Par_ProductoID,
			Par_ServicioID,
			Var_ClasificacionServ,
			Par_Producto,

			Var_ProRegistroDef,

			Var_SalidaNO,
			Par_NumErr,
			Par_ErrMen,

			Par_EmpresaID,
			Par_Usuario,
			Par_FechaActual,
			Par_DireccionIP,
			Par_ProgramaID,
			Par_Sucursal,
			Par_NumTransaccion
		);

		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen;

		IF(Par_NumErr <> Entero_Cero) THEN
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'ALTA DEL PRODUCTO EXITOSO';
		SET Var_Consecutivo := Entero_Cero;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen,
			   'fechaCatalogo' 	AS control,
			   Var_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$