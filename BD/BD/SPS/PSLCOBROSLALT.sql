-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCOBROSLALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCOBROSLALT`;DELIMITER $$

CREATE PROCEDURE `PSLCOBROSLALT`(
	-- Stored procedure para dar de alta los registros de cobro de servicios en linea
	Par_ProductoID 					INT(11), 				-- ID del producto
	Par_ServicioID 					INT(11), 				-- ID del servicio
	Par_ClasificacionServ 			CHAR(2), 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)
	Par_TipoUsuario 				CHAR(1),				-- Campo para el tipo de Usuario (S = Socio/Cliente, U = Usuario )
	Par_NumeroTarjeta 				VARCHAR(30), 			-- Numero de tarjeta
	Par_ClienteID 					INT(11),				-- Identificador del socio o cliente
	Par_CuentaAhoID 				BIGINT(12),				-- Identificador del la cuenta de ahorro
	Par_Producto 					VARCHAR(200),			-- Nombre del producto
	Par_FormaPago 					CHAR(1),				-- Forma de pago por el producto (E = Efectivo, C = Cargo a cuenta de ahorro)
	Par_Precio 						DECIMAL(14,2),			-- Precio del producto
	Par_Telefono					VARCHAR(13),			-- Telefono del servicio
	Par_Referencia					VARCHAR(30),			-- Referencia del servicio
	Par_ComisiProveedor 			DECIMAL(14,2),			-- Monto por la comision del proveedor del servicio
	Par_ComisiInstitucion 			DECIMAL(14,2),			-- Monto por la comision interna
	Par_IVAComision 				DECIMAL(14,2),			-- IVA correspondiente a la comision interna
	Par_TotalComisiones 			DECIMAL(14,2),			-- Monto total de las comisiones a pagar
	Par_TotalPagar 					DECIMAL(14,2),			-- Total a pagar
	Par_FechaHora 					DATETIME,				-- Fecha y hora del cobro de servicio
	Par_SucursalID 					INT(11),				-- Identificador de la sucursal donde ser realizo el cobro de servicio
	Par_CajaID 						INT(11),				-- Identificador de la caja donde ser realizo el cobro de servicio
	Par_CajeroID 					INT(11),				-- Identificador de la cajero que realizo el cobro de servicio
	Par_Canal 						CHAR(1),				-- Identificador del canal por donde ser realizo el servicio (V = Ventanilla, L = Banca en linea, M = Banca mobil)
	Par_PolizaID 					BIGINT(20),				-- Identificador de la poliza contable


	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen 				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	INOUT Par_CobroID 				BIGINT(20), 			-- ID del Cobro

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
	DECLARE Var_SI 					CHAR(1);				-- Variable con valor si
	DECLARE Var_NO 					CHAR(1);				-- Variable con valor no
	DECLARE Est_Transito 			CHAR(1);				-- Estatus en Transito
	DECLARE Est_Activo 				CHAR(1);				-- Estatus activo
	DECLARE Var_Usuario 			CHAR(1);				-- Tipo de usuario Usuario
	DECLARE Var_Socio 				CHAR(1);				-- Tipo de usuario Socio/Cliente
	DECLARE Var_PagoEfect 			CHAR(1);				-- Tipo de pago en Efectivo
	DECLARE Var_PagoCuenta 			CHAR(1);				-- Tipo de pago por Cuenta de ahorro
	DECLARE Var_IDTRRelefono 		CHAR(1);				-- ID Tipo refencia Telefono
	DECLARE Var_CanalV 				CHAR(1);				-- Canal de Ventanilla
	DECLARE Var_CanalL 				CHAR(1);				-- Canal de Banca en Linea
	DECLARE Var_CanalM 				CHAR(1);				-- Canal de Banca Movil
	DECLARE Var_ClasfRecarga 		CHAR(2); 				-- Clasificacion Recarga
	DECLARE Var_RefTelefono 		CHAR(1); 				-- Tipo de refrencia telefono

	-- Declaracion de variables
	DECLARE Var_Consecutivo 		BIGINT(20); 			-- Variable consecutivo
	DECLARE Var_ServicioID 			INT(11); 				-- ID del servicio
	DECLARE Var_TipoServicioID 		INT(11); 				-- ID del tipo de servicio
	DECLARE Var_ProductoID			INT(11); 				-- ID del producto
	DECLARE Var_TipoReferencia 		VARCHAR(2); 			-- Tipo de referencia
	DECLARE Var_CobroID 			BIGINT(20); 			-- ID de cobro
	DECLARE Var_ClienteID 			INT(11); 				-- ID del cliente
	DECLARE Var_CuentaAhoID 		BIGINT(12); 			-- ID de la cuenta de ahorro
	DECLARE Var_SucursalID 			INT(11); 				-- ID de la sucursal

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_SI 						:= 'S';					-- Asignacion de salida si
	SET Var_NO 						:= 'N';					-- Asignacion de salida no
	SET Est_Transito 				:= 'T'; 				-- Estatus en Transito
	SET Est_Activo 					:= 'A';					-- Estatus activo
	SET Var_Usuario 				:= 'U';					-- Tipo de usuario Usuario
	SET Var_Socio 					:= 'S';					-- Tipo de usuario Socio/Cliente
	SET Var_PagoEfect 				:= 'E';					-- Tipo de pago en Efectivo
	SET Var_PagoCuenta 				:= 'C';					-- Tipo de pago por Cuenta de ahorro
	SET Var_IDTRRelefono 			:= 'a'; 				-- ID Tipo refencia Telefono
	SET Var_CanalV 					:= 'V';					-- Canal de Ventanilla
	SET Var_CanalL 					:= 'L';					-- Canal de Banca en Linea
	SET Var_CanalM 					:= 'M';					-- Canal de Banca Movil
	SET Var_ClasfRecarga 			:= 'RE'; 				-- Clasificacion Recarga
	SET Var_RefTelefono 			:= 'a'; 				-- Tipo de refrencia telefono

	-- Valores por default
	SET Par_ProductoID 				:= IFNULL(Par_ProductoID, Entero_Cero);
	SET Par_ServicioID 				:= IFNULL(Par_ServicioID, Entero_Cero);
	SET Par_ClasificacionServ 		:= IFNULL(Par_ClasificacionServ, Entero_Cero);
	SET Par_TipoUsuario				:= IFNULL(Par_TipoUsuario, Cadena_Vacia);
	SET Par_NumeroTarjeta 			:= IFNULL(Par_NumeroTarjeta, Cadena_Vacia);
	SET Par_ClienteID 				:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_CuentaAhoID 			:= IFNULL(Par_CuentaAhoID, Decimal_Cero);
    SET Par_Producto 				:= IFNULL(Par_Producto, Cadena_Vacia);
    SET Par_FormaPago 				:= IFNULL(Par_FormaPago, Cadena_Vacia);
    SET Par_Precio 					:= IFNULL(Par_Precio, Decimal_Cero);
    SET Par_Telefono 				:= IFNULL(Par_Telefono, Cadena_Vacia);
    SET Par_Referencia 				:= IFNULL(Par_Referencia, Cadena_Vacia);
	SET Par_ComisiProveedor 		:= IFNULL(Par_ComisiProveedor, Decimal_Cero);
	SET Par_ComisiInstitucion 		:= IFNULL(Par_ComisiInstitucion, Decimal_Cero);
	SET Par_IVAComision 			:= IFNULL(Par_IVAComision, Decimal_Cero);
	SET Par_TotalComisiones 		:= IFNULL(Par_TotalComisiones, Decimal_Cero);
	SET Par_TotalPagar 				:= IFNULL(Par_TotalPagar, Decimal_Cero);
	SET Par_FechaHora 				:= IFNULL(Par_FechaHora, Fecha_Vacia);
	SET Par_SucursalID 				:= IFNULL(Par_SucursalID, Entero_Cero);
	SET Par_CajaID 					:= IFNULL(Par_CajaID, Entero_Cero);
	SET Par_CajeroID 				:= IFNULL(Par_CajeroID, Entero_Cero);
	SET Par_Canal 					:= IFNULL(Par_Canal, Cadena_Vacia);

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
											'Disculpe las molestias que esto le ocasiona. Ref: SP-PSLCOBROSLALT');
			END;

		IF(Par_ProductoID = Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'ID del producto no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT 		ProductoID, 	TipoReferencia
			INTO 	Var_ProductoID,	Var_TipoReferencia
			FROM PSLPRODBROKER
			WHERE ProductoID = Par_ProductoID;

		IF(Var_ProductoID IS NULL) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'Producto no encontrado.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ServicioID = Entero_Cero) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'ID del servicio no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ClasificacionServ = Cadena_Vacia) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'Clasificacion de servicio no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT ServicioID INTO Var_ServicioID
			FROM PSLCONFIGSERVICIO
			WHERE ServicioID = Par_ServicioID
			AND ClasificacionServ = Par_ClasificacionServ;

		IF(Var_ServicioID IS NULL) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'Servicio no encontrado.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoUsuario = Cadena_Vacia) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= 'Especifique el tipo de usuario.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoUsuario NOT IN (Var_Usuario, Var_Socio)) THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= 'Tipo de usuario no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Producto = Cadena_Vacia) THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen	:= 'Nombre del producto no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_FormaPago = Cadena_Vacia) THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= 'Especifique la forma de pago.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_FormaPago NOT IN (Var_PagoEfect, Var_PagoCuenta)) THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:= 'Forma de pago no valida.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(Par_FormaPago = Var_PagoCuenta) THEN
			IF(Par_ClienteID = Entero_Cero) THEN
				SET Par_NumErr	:= 11;
				SET Par_ErrMen	:= 'ID de socio o cliente vacio.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_CuentaAhoID = Decimal_Cero) THEN
				SET Par_NumErr	:= 12;
				SET Par_ErrMen	:= 'Cuenta de ahorro vacia.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			SELECT CuentaAhoID INTO Var_CuentaAhoID
				FROM CUENTASAHO
				WHERE CuentaAhoID = Par_CuentaAhoID
				AND ClienteID = Par_ClienteID;

			IF(Var_CuentaAhoID IS NULL) THEN
				SET Par_NumErr	:= 13;
				SET Par_ErrMen	:= 'Cuenta de ahorro no encontrada.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_Precio <= Decimal_Cero) THEN
			SET Par_NumErr	:= 14;
			SET Par_ErrMen	:= 'Monto de pago no valida.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ClasificacionServ = Var_ClasfRecarga) THEN
			IF(Var_TipoReferencia = Var_RefTelefono OR Var_TipoReferencia = Cadena_Vacia) THEN
				IF(Par_Telefono = Cadena_Vacia) THEN
					SET Par_NumErr	:= 15;
					SET Par_ErrMen	:= 'Telefono vacio.';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			ELSE
				IF(Par_Referencia = Cadena_Vacia) THEN
					SET Par_NumErr	:= 16;
					SET Par_ErrMen	:= 'Referencia vacia.';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		ELSE
			IF(Par_Referencia = Cadena_Vacia) THEN
				SET Par_NumErr	:= 16;
				SET Par_ErrMen	:= 'Referencia vacia.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_ComisiProveedor < Decimal_Cero) THEN
			SET Par_NumErr	:= 17;
			SET Par_ErrMen	:= 'Comision del proveedor no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ComisiInstitucion < Decimal_Cero) THEN
			SET Par_NumErr	:= 18;
			SET Par_ErrMen	:= 'Comision de la institucion no valida.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_IVAComision < Decimal_Cero) THEN
			SET Par_NumErr	:= 19;
			SET Par_ErrMen	:= 'Comision de la institucion no valida.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TotalComisiones < Decimal_Cero) THEN
			SET Par_NumErr	:= 20;
			SET Par_ErrMen	:= 'Monto total de comisiones no valida.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TotalPagar <= Decimal_Cero) THEN
			SET Par_NumErr	:= 21;
			SET Par_ErrMen	:= 'Monto total a pagar no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_FechaHora = Fecha_Vacia) THEN
			SET Par_NumErr	:= 22;
			SET Par_ErrMen	:= 'Fecha y hora de pago vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_SucursalID = Entero_Cero) THEN
			SET Par_NumErr	:= 23;
			SET Par_ErrMen	:= 'Especifique el ID de la sucursal.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT SucursalID INTO Var_SucursalID
			FROM SUCURSALES
			WHERE SucursalID = Par_SucursalID;

		IF(Var_SucursalID IS NULL) THEN
			SET Par_NumErr	:= 24;
			SET Par_ErrMen	:= 'Sucursal no encontrada.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CajaID = Entero_Cero) THEN
			SET Par_NumErr	:= 25;
			SET Par_ErrMen	:= 'ID de caja no valida.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CajeroID = Entero_Cero) THEN
			SET Par_NumErr	:= 26;
			SET Par_ErrMen	:= 'ID de cajero no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Canal = Cadena_Vacia) THEN
			SET Par_NumErr	:= 27;
			SET Par_ErrMen	:= 'Canal vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Canal NOT IN (Var_CanalV, Var_CanalL, Var_CanalM)) THEN
			SET Par_NumErr	:= 28;
			SET Par_ErrMen	:= 'Canal no valido.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		CALL FOLIOSAPLICAACT('PSLCOBROSL', Var_CobroID);
		SET Par_CobroID = Var_CobroID;

		INSERT INTO PSLCOBROSL (CobroID,				ProductoID,				ServicioID,				ClasificacionServ,			TipoUsuario,
								NumeroTarjeta,			ClienteID,				CuentaAhoID,			Producto, 					FormaPago,
								Precio,					Telefono,				Referencia,				ComisiProveedor,			ComisiInstitucion,
								IVAComision,			TotalComisiones,		TotalPagar,				FechaHora,					SucursalID,
								CajaID,					CajeroID,				Canal,					PolizaID,					Estatus,
								EmpresaID, 				Usuario,				FechaActual, 			DireccionIP,				ProgramaID,
								Sucursal,				NumTransaccion
			)
			VALUES(				Var_CobroID,			Par_ProductoID, 		Par_ServicioID, 		Par_ClasificacionServ,		Par_TipoUsuario,
								Par_NumeroTarjeta,		Par_ClienteID, 			Par_CuentaAhoID,		Par_Producto,				Par_FormaPago,
								Par_Precio,				Par_Telefono,			Par_Referencia,			Par_ComisiProveedor,		Par_ComisiInstitucion,
								Par_IVAComision,		Par_TotalComisiones,	Par_TotalPagar,			Par_FechaHora,				Par_SucursalID,
								Par_CajaID,				Par_CajeroID,			Par_Canal,				Par_PolizaID,				Est_Transito,
								Aud_EmpresaID, 			Aud_Usuario,			Aud_FechaActual, 		Aud_DireccionIP,			Aud_ProgramaID,
								Aud_Sucursal,			Aud_NumTransaccion
			);

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Producto registrado correctamente';
		SET Var_Consecutivo := Var_CobroID;
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