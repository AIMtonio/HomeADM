DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAPAGOSMOVILDETALT`;
DELIMITER $$

CREATE PROCEDURE `BITACORAPAGOSMOVILDETALT`(
	-- STORED PARA EL ALTA DE BITACORA DE PAGOS MOVIL
	Par_BitacoraHeadID        BIGINT(20),    	-- Numero del Registro
	Par_ClienteID             INT(11),       	-- Numero de cliente
	Par_ClaveProm             VARCHAR(45),   	-- Numero del promotor
	Par_SucursalID            INT(11),       	-- Numero de la Sucursal
	Par_DispositivoID         VARCHAR(32),   	-- Identificador del dispositivo
	
	Par_ModelDispos           VARCHAR(32),   	-- Modelo del dispositivo
	Par_TipoPago              CHAR(1),       	-- Tipo de pago (E = Efectivo, C = Cargo a cuenta)
	Par_CreditoID             BIGINT(12),    	-- Numero del Credito
	Par_CuentaAhoID           BIGINT(12),    	-- Numero de cuenta de ahorro
	Par_Monto                 DECIMAL(12,2), 	-- Monto cobrado
	
	Par_CajaID                INT(11),       	-- Numero de caja
	Par_FechaHoraOper         DATETIME ,     	-- Fecha y hora de la operacion
	Par_NumTransacBit     	  BIGINT(20),    	-- Numero de transaccion de la bitacora
	Par_FolioMovil			  VARCHAR(100),		-- Folio del pago generado por la aplicación movil

    Par_Salida    			  CHAR(1),			-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		  INT(11),			-- Parametro de salida numero de error
    INOUT Par_ErrMen  		  VARCHAR(400),		-- Parametro de salida mensaje de error

    Aud_EmpresaID       	  INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	  INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	  DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	  VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	  VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	  INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	  BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
	DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';
	SET Salida_NO           	:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BITACORAPAGOSMOVILDETALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		/** Inicia validaciones **/
		SET Par_BitacoraHeadID := IFNULL(Par_BitacoraHeadID, Entero_Cero);

		IF(Par_BitacoraHeadID = Entero_Cero ) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Numero de Head de Bitacora el Obligatorio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_BitacoraHeadID := (SELECT RegistroID FROM BITACORAPAGMOVILHEAD WHERE RegistroID = Par_BitacoraHeadID LIMIT 1);
		SET Par_BitacoraHeadID := IFNULL(Par_BitacoraHeadID, Entero_Cero);

		IF(Par_BitacoraHeadID = Entero_Cero ) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El numero de bitacora general no existe';
			LEAVE ManejoErrores;
		END IF;

		SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);

		IF(Par_ClienteID = Entero_Cero ) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Numero de Cliente es obligatorio';
			LEAVE ManejoErrores;
		END IF;
		
		SET Par_ClienteID := (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID);
		SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);

		IF(Par_ClienteID = Entero_Cero ) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'El Numero de Cliente no existe';
			LEAVE ManejoErrores;
		END IF;

		SET Par_ClaveProm := IFNULL(Par_ClaveProm, Cadena_Vacia);

		IF(Par_ClaveProm = Cadena_Vacia ) THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := 'La Clave del promotor es obligatorio.';
			LEAVE ManejoErrores;
		END IF;

		SET Par_ClaveProm := (SELECT Clave FROM USUARIOS WHERE Clave = Par_ClaveProm LIMIT 1);
		SET Par_ClaveProm := IFNULL(Par_ClaveProm, Entero_Cero);

		IF(Par_ClaveProm = Cadena_Vacia ) THEN
			SET Par_NumErr  := 6;
			SET Par_ErrMen  := 'La clave del promotor no existe';
			LEAVE ManejoErrores;
		END IF;

		SET Par_SucursalID := IFNULL(Par_SucursalID, Entero_Cero);

		IF(Par_SucursalID = Entero_Cero ) THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'El numero de sucursal el obligatorio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_SucursalID := (SELECT SucursalID FROM SUCURSALES WHERE SucursalID = Par_SucursalID);
		SET Par_SucursalID := IFNULL(Par_SucursalID, Entero_Cero);

		IF(Par_SucursalID = Entero_Cero ) THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'El Numero de Sucursal no existe';
			LEAVE ManejoErrores;
		END IF;

		SET Par_DispositivoID := IFNULL(Par_DispositivoID, Cadena_Vacia);

		IF(Par_DispositivoID = Cadena_Vacia ) THEN
			SET Par_NumErr  := 9;
			SET Par_ErrMen  := 'El ID del dispositivo es obligatorio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_ModelDispos := IFNULL(Par_ModelDispos, Cadena_Vacia);

		IF(Par_ModelDispos = Cadena_Vacia ) THEN
			SET Par_NumErr  := 10;
			SET Par_ErrMen  := 'El Modelo del dispositivo es obligatorio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_TipoPago := IFNULL(Par_TipoPago, Cadena_Vacia);

		IF(Par_TipoPago = Cadena_Vacia ) THEN
			SET Par_NumErr  := 11;
			SET Par_ErrMen  := 'El tipo de pago es obligatorio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_CreditoID := IFNULL(Par_CreditoID, Entero_Cero);

		IF(Par_CreditoID = Entero_Cero ) THEN
			SET Par_NumErr  := 12;
			SET Par_ErrMen  := 'El Numero de Credito es obligatorio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_CreditoID := (SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET Par_CreditoID := IFNULL(Par_CreditoID, Entero_Cero);

		IF(Par_CreditoID = Entero_Cero ) THEN
			SET Par_NumErr  := 13;
			SET Par_ErrMen  := 'El Numero de Credito no existe';
			LEAVE ManejoErrores;
		END IF;

		SET Par_CuentaAhoID := IFNULL(Par_CuentaAhoID, Entero_Cero);

		IF(Par_CuentaAhoID <> Entero_Cero ) THEN
			
			SET Par_CuentaAhoID := (SELECT CuentaAhoID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);
			SET Par_CuentaAhoID := IFNULL(Par_CuentaAhoID, Entero_Cero);

			IF(Par_CuentaAhoID = Entero_Cero ) THEN
				SET Par_NumErr  := 15;
				SET Par_ErrMen  := 'El Numero de Cuenta de Ahorro no existe';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Par_Monto := IFNULL(Par_Monto, Entero_Cero);

		IF(Par_Monto = Entero_Cero ) THEN
			SET Par_NumErr  := 16;
			SET Par_ErrMen  := 'El Monto a pagar es obligatorio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_CajaID := IFNULL(Par_CajaID, Entero_Cero);

		IF(Par_CajaID = Entero_Cero ) THEN
			SET Par_NumErr  := 17;
			SET Par_ErrMen  := 'El numero de caja es obligatorio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_CajaID := (SELECT CajaID FROM CAJASVENTANILLA WHERE CajaID = Par_CajaID LIMIT 1);
		SET Par_CajaID := IFNULL(Par_CajaID, Entero_Cero);

		IF(Par_CajaID = Entero_Cero ) THEN
			SET Par_NumErr  := 18;
			SET Par_ErrMen  := 'El Numero de Caja no existe';
			LEAVE ManejoErrores;
		END IF;

		SET Par_FechaHoraOper := IFNULL(Par_FechaHoraOper, Fecha_Vacia);

		IF(Par_FechaHoraOper = Fecha_Vacia ) THEN
			SET Par_NumErr  := 19;
			SET Par_ErrMen  := 'La Fecha de operacion se encuentra vacia';
			LEAVE ManejoErrores;
		END IF;
		
		IF(IFNULL(Par_FolioMovil, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 20;
			SET Par_ErrMen  := 'Folio movil se encuentra vacio';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumTransacBit := IFNULL(Par_NumTransacBit, Entero_Cero);

		/** Finaliza apartado de validaciones **/

        INSERT INTO BITACORAPAGOSMOVILDET(
			BitacoraHeadID, 	 	 ClienteID,     	 	 ClaveProm,         	 SucursalID,  	 	 DispositivoID,  	
			ModeloDispos,   	 	 TipoPago,      	 	 CreditoID,         	 CuentaAhoID, 	 	 Monto,          	
			CajaID,         	 	 FechaHoraOper, 	 	 NumTransaccionBit, 	 FolioMovil,		 EmpresaID,
			Usuario,        		 FechaActual,    	 	 DireccionIP,   	 	 ProgramaID,         Sucursal,
			NumTransaccion
        )
        VALUES(
			Par_BitacoraHeadID, 	 Par_ClienteID,     	 Par_ClaveProm,     	 Par_SucursalID,  	 Par_DispositivoID,  	
			Par_ModelDispos,    	 Par_TipoPago,      	 Par_CreditoID,     	 Par_CuentaAhoID, 	 Par_Monto,          	
			Par_CajaID,         	 Par_FechaHoraOper, 	 Par_NumTransacBit, 	 Par_FolioMovil,		 Aud_EmpresaID,
			Aud_Usuario,          	 Aud_FechaActual,    	 Aud_DireccionIP,   	 Aud_ProgramaID,     Aud_Sucursal,    	 
			Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Bitacora Agregada Exitosamente');
		SET Var_Control		:= 'bitacoraID';
		SET Var_Consecutivo	:= 0;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$
