-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONTACOBROSLPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCONTACOBROSLPRO`;
DELIMITER $$

CREATE PROCEDURE `PSLCONTACOBROSLPRO`(
	-- Stored procedure para dar de alta los movimientos contables y operativos al realizar un pago de servicio en linea
	Par_PolizaID 					INT(11), 				-- ID de la Poliza
	Par_MonedaID 					INT(11), 				-- ID de la Moneda

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

	Par_NumPro 						INT, 					-- Numero de proceso a ejecutar
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
	DECLARE Var_SI 					CHAR(1);				-- Variable con valor si
	DECLARE Var_NO 					CHAR(1);				-- Variable con valor no
	DECLARE Est_Activo 				CHAR(1);				-- Estatus activo
	DECLARE Var_Usuario 			CHAR(1);				-- Tipo de usuario Usuario
	DECLARE Var_Socio 				CHAR(1);				-- Tipo de usuario Socio/Cliente
	DECLARE Var_PagoEfect 			CHAR(1);				-- Tipo de pago en Efectivo
	DECLARE Var_PagoCuenta 			CHAR(1);				-- Tipo de pago por Cuenta de ahorro
	DECLARE Var_IDTRRelefono 		CHAR(1);				-- ID Tipo refencia Telefono
	DECLARE Var_CanalV 				CHAR(1);				-- Canal de Ventanilla
	DECLARE Var_CanalL 				CHAR(1);				-- Canal de Banca en Linea
	DECLARE Var_CanalM 				CHAR(1);				-- Canal de Banca Movil
	DECLARE Var_MovimientoCargo 	CHAR(1); 				-- Movimiento de Cargo
	DECLARE Var_MovimientoAbono 	CHAR(1); 				-- Movimiento de Abono
	DECLARE Var_ForSucOrigen       	CHAR(3);
	DECLARE Var_ForSucCliente      	CHAR(3);
	DECLARE Var_NomProducto			VARCHAR(150); 			-- Nombre del producto
	DECLARE Var_DescPagServLinea 	VARCHAR(30); 			-- Leyenda con Pago de Servicio en linea
	DECLARE Var_ProcContable 		VARCHAR(20);
	DECLARE Var_InstrumentoID 		INT(11);				-- ID de Tipo Instrumento de Pago de Servicios en linea
	DECLARE Var_DescComisiIns 		VARCHAR(25);
	DECLARE Var_DescIVAComisiIns 	VARCHAR(25);
	DECLARE Var_ConcepMovCuenta 	INT(11);
	DECLARE Var_ConcepContaPSL 		INT(11);
	DECLARE Var_TipoMovAhoPSL 		INT(11);
	DECLARE Var_TipoFrontRec 		INT(11); 				-- Tipo Front de Recarga de Tiempo Aire

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
	DECLARE Var_CCostosServicio     VARCHAR(30);			-- Centro de Costo del Servicio
	DECLARE Var_CentroCostosID      INT(11);				-- Centro de Costo
	DECLARE Var_SucCliente          INT(11);				-- Sucursal del Cliente
	DECLARE Var_CContaServicio		VARCHAR(25);			-- Cuenta Contable para el Cobro del Servicio
	DECLARE Var_CContaComisi 		VARCHAR(25);			-- Cuenta Contable para la Comision
	DECLARE Var_CContaIVAComisi 	VARCHAR(25);			-- Cuenta Contable del IVA por Comision
	DECLARE Var_NomenclaturaCC 		VARCHAR(3);				-- Nomenclatura del Centro de Costo
	DECLARE Var_Referencia 			VARCHAR(30);			-- Referencia


	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_SI 						:= 'S';					-- Asignacion de salida si
	SET Var_NO 						:= 'N';					-- Asignacion de salida no
	SET Est_Activo 					:= 'A';					-- Estatus activo
	SET Var_Usuario 				:= 'U';					-- Tipo de usuario Usuario
	SET Var_Socio 					:= 'S';					-- Tipo de usuario Socio/Cliente
	SET Var_PagoEfect 				:= 'E';					-- Tipo de pago en Efectivo
	SET Var_PagoCuenta 				:= 'C';					-- Tipo de pago por Cuenta de ahorro
	SET Var_IDTRRelefono 			:= 'a'; 				-- ID Tipo refencia Telefono
	SET Var_CanalV 					:= 'V';					-- Canal de Ventanilla
	SET Var_CanalL 					:= 'L';					-- Canal de Banca en Linea
	SET Var_CanalM 					:= 'M';					-- Canal de Banca Movil
	SET Var_MovimientoCargo 		:= 'C'; 				-- Movimiento de Cargo
	SET Var_MovimientoAbono			:= 'A'; 				-- Movimiento de Abono
	SET Var_ForSucOrigen       		:= '&SO';
	SET Var_ForSucCliente      		:= '&SC';
	SET Var_DescPagServLinea 		:= 'PAGO DE SERVICIO EN LINEA - ';
	SET Var_DescComisiIns 			:= 'COMISION INSTITUCION';
	SET Var_DescIVAComisiIns 		:= 'IVA COMISION INSTITUCION';
	SET Var_ProcContable       		:= 'PSLCONTACOBROSLPRO';
	SET Var_InstrumentoID			:= 30; 					-- ID de Tipo Instrumento de Pago de Servicios en linea
	SET Var_ConcepMovCuenta 		:= 1;					-- Concepto de Movimiento de Cuenta
	SET Var_ConcepContaPSL 			:= 1000;				-- Concepto Contable de Pago de Servicios en Linea
	SET Var_TipoMovAhoPSL 			:= 229; 				-- Tipo de movimiento de Pago de Servicios en Linea
	SET Var_TipoFrontRec 			:= 1; 					-- Tipo Front de Recarga de Tiempo Aire

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
	SET Var_CentroCostosID			:=0;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
       			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-PSLCONTACOBROSLPRO');
			END;

		IF(Par_FormaPago NOT IN (Var_PagoCuenta, Var_PagoEfect)) THEN
			SET Par_NumErr		:= 1;
			SET Par_ErrMen		:= 'Forma de Pago no valida.';
			SET Var_Consecutivo := Entero_Cero;

			LEAVE ManejoErrores;
		END IF;

		IF(Par_Precio <= Entero_Cero) THEN
			SET Par_NumErr		:= 2;
			SET Par_ErrMen		:= 'Monto del Servicio no valido.';
			SET Var_Consecutivo := Entero_Cero;

			LEAVE ManejoErrores;
		END IF;

		IF(Par_TotalPagar <= Entero_Cero) THEN
			SET Par_NumErr		:= 3;
			SET Par_ErrMen		:= 'Total a pagar no valido.';
			SET Var_Consecutivo := Entero_Cero;

			LEAVE ManejoErrores;
		END IF;

		IF(Par_FormaPago = Var_PagoCuenta AND Par_CuentaAhoID = Cadena_Vacia) 	THEN
			SET Par_NumErr		:= 4;
			SET Par_ErrMen		:= 'Especifique la Cuenta de Ahorro.';
			SET Var_Consecutivo := Entero_Cero;

			LEAVE ManejoErrores;
		END IF;

		-- Consultamos la informacion de las cuentas contables y centros de costo del producto
		SELECT 		CCONTASER.CuentaCompleta,	CCONTACOM.CuentaCompleta,	CCONTAIVA.CuentaCompleta,	SERV.NomenclaturaCC
			INTO 	Var_CContaServicio, 		Var_CContaComisi,			Var_CContaIVAComisi,		Var_NomenclaturaCC
			FROM PSLCONFIGSERVICIO SERV
			LEFT JOIN CUENTASCONTABLES CCONTASER ON CCONTASER.CuentaCompleta = SERV.CContaServicio
            LEFT JOIN CUENTASCONTABLES CCONTACOM ON CCONTACOM.CuentaCompleta = SERV.CContaComision
            LEFT JOIN CUENTASCONTABLES CCONTAIVA ON CCONTAIVA.CuentaCompleta = SERV.CContaIVAComisi
			WHERE ServicioID = Par_ServicioID
			AND ClasificacionServ = Par_ClasificacionServ;

		IF(Var_CContaServicio = Cadena_Vacia) THEN
			SET Par_NumErr 	= 5;
			SET Par_ErrMen	= 'Configure primero la cuenta contable del servicio.';
			SET Var_Consecutivo = Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_CContaComisi = Cadena_Vacia) THEN
			SET Par_NumErr 	= 6;
			SET Par_ErrMen	= 'Configure primero la cuenta contable de la comision.';
			SET Var_Consecutivo = Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(Var_CContaIVAComisi = Cadena_Vacia) THEN
			SET Par_NumErr 	= 7;
			SET Par_ErrMen	= 'Configure primero la cuenta contable del IVA por comision.';
			SET Var_Consecutivo = Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ComisiProveedor < Entero_Cero) THEN
			SET Par_NumErr		:= 8;
			SET Par_ErrMen		:= 'Comision del Proveedor del Servicio no valido';
			SET Var_Consecutivo := Entero_Cero;

			LEAVE ManejoErrores;
		END IF;

		-- Establecemos el centro de costo
		IF LOCATE(Var_ForSucCliente, Var_NomenclaturaCC) > 0 THEN
            SELECT 	SucursalOrigen
            		INTO Var_SucCliente
                    FROM CLIENTES WHERE ClienteID = Par_ClienteID;

            IF (Var_SucCliente > 0) THEN
                SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
            ELSE
                SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
            END IF;
        ELSE
            SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
        END IF;


        IF(Par_Referencia = Cadena_Vacia) THEN
    		SET Var_Referencia := Par_Telefono;
    	ELSE
    		SET Var_Referencia := Par_Referencia;
    	END IF;

        -- Realizamos el alta del detalle de Poliza del cobro de servicio
        IF(Par_Precio > Decimal_Cero) THEN
        	IF(Par_ComisiProveedor > Entero_Cero) THEN
        		SET Par_Precio = Par_Precio + Par_ComisiProveedor;
        	END IF;


        	SET Var_NomProducto = CONCAT(Var_DescPagServLinea, Par_Producto);
        	CALL DETALLEPOLIZAALT(
	            Aud_EmpresaID,          Par_PolizaID,       Par_FechaHora,      Var_CentroCostosID, Var_CContaServicio,
	            Par_ProductoID,     	Par_MonedaID,       Entero_Cero,        Par_Precio,         Var_NomProducto,
	            Var_Referencia,         Var_ProcContable,   Var_InstrumentoID,  Cadena_Vacia,       Decimal_Cero,
	            Cadena_Vacia,           Var_NO,          	Par_NumErr,         Par_ErrMen,         Aud_Usuario ,
	            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
	        );


			IF(Par_NumErr > Entero_Cero) THEN
				SET Var_Consecutivo = Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
        END IF;

        -- Realizamos el alta del detalle de Poliza de la Comision de Institucion
        IF(Par_ComisiInstitucion > Decimal_Cero) THEN
        	SET Var_NomProducto = CONCAT(Var_DescPagServLinea, Var_DescComisiIns);

        	CALL DETALLEPOLIZAALT(
	            Aud_EmpresaID,          Par_PolizaID,       Par_FechaHora,      Var_CentroCostosID,     Var_CContaComisi,
	            Par_ProductoID,     	Par_MonedaID,       Entero_Cero,        Par_ComisiInstitucion,	Var_NomProducto,
	            Var_Referencia,         Var_ProcContable,   Var_InstrumentoID,  Cadena_Vacia,       	Decimal_Cero,
	            Cadena_Vacia,           Var_NO,          	Par_NumErr,         Par_ErrMen,         	Aud_Usuario ,
	            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       	Aud_NumTransaccion
	        );


			IF(Par_NumErr > Entero_Cero) THEN
				SET Var_Consecutivo = Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
        END IF;

        -- Realizamos el alta del detalle de Poliza del IVA en Comision de Institucion
        IF(Par_IVAComision > Decimal_Cero) THEN
        	SET Var_NomProducto = CONCAT(Var_DescPagServLinea, Var_DescIVAComisiIns);
        	CALL DETALLEPOLIZAALT(
	            Aud_EmpresaID,          Par_PolizaID,       Par_FechaHora,      Var_CentroCostosID,     Var_CContaIVAComisi,
	            Par_ProductoID,    	 	Par_MonedaID,       Entero_Cero,        Par_IVAComision,		Var_NomProducto,
	            Var_Referencia,         Var_ProcContable,   Var_InstrumentoID,  Cadena_Vacia,       	Decimal_Cero,
	            Cadena_Vacia,           Var_NO,          	Par_NumErr,         Par_ErrMen,         	Aud_Usuario ,
	            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       	Aud_NumTransaccion
	        );


			IF(Par_NumErr > Entero_Cero) THEN
				SET Var_Consecutivo = Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
        END IF;

        -- Realizamos el cargo para forma de pago con cargo a Cuenta de ahorro
        IF(Par_FormaPago = Var_PagoCuenta) THEN
        	SET Var_NomProducto = CONCAT(Var_DescPagServLinea, Par_Producto);

        	CALL CARGOABONOCTAPRO(
			    Par_CuentaAhoID,			Par_ClienteID,			Aud_NumTransaccion,			Aud_FechaActual,		Aud_FechaActual,
				Var_MovimientoCargo,		Par_TotalPagar,			Var_NomProducto,			Var_Referencia,			Var_TipoMovAhoPSL,
			    Par_MonedaID,				Entero_Cero,			Var_NO,						Var_ConcepContaPSL,		Par_PolizaID,
			    Var_SI,						Var_ConcepMovCuenta,	Var_MovimientoCargo,		SalidaNO,				Par_NumErr,
				Par_ErrMen,					Var_Consecutivo,		Aud_EmpresaID,				Aud_Usuario,			Aud_FechaActual,
			    Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
    		);

    		IF(Par_NumErr = Entero_Cero) THEN
    			LEAVE ManejoErrores;
    		END IF;
        END IF;

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Movimientos registrados correctamente.';
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