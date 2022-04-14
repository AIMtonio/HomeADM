-- BITACORAMOVSWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS BITACORAMOVSWSALT;
DELIMITER $$

CREATE PROCEDURE BITACORAMOVSWSALT(
	Par_CreditoID         	BIGINT(12),			-- ID del Credito
	Par_ClienteID         	INT(11),			-- ID del Cliente
	Par_TipoMov				CHAR(2),			-- Tipo De movimiento (Pago de Credito = PC, Impago de Credito = IC, Registro de Cliente = RC)
	Par_CatRazonImpagoID  	INT(11),			-- ID de Motivo de no Pago (Solo para TipoMovID IC)
	Par_MontoPago         	DECIMAL(12, 2),		-- Monto de Pago de Credito (Solo para TipoMovID PC)

	Par_PromotorID			INT(11),			-- ID del Promotor
	Par_CuentaAhoID 		BIGINT(12),			-- ID de la Cuenta de Ahorro
    Par_CajaID				INT(11),			-- ID de la Caja (Solo para TipoMovID PC)

    Par_Salida    			CHAR(1), 			-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),			-- Parametro de salida numero de error
    INOUT Par_ErrMen	  	VARCHAR(400),		-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;				-- Fecha del sistema
    DECLARE Var_AccesoID		BIGINT(12);			-- ID de registro de acceso
    DECLARE Var_FechaAcceso		DATETIME;			-- Fecha y hora en la que accede
    DECLARE Var_UsuarioID		INT(11);			-- ID del usuario
    DECLARE Var_PromotorID		INT(11);			-- ID del Promotor
    DECLARE Var_CreditoID		BIGINT(12);			-- ID del Credito
    DECLARE Var_BitacoraID		BIGINT(20);			-- ID del movimiento de bitacora
    DECLARE Var_HoraActual 		TIME;				-- Hora Actual del servidor
    DECLARE Var_CatImpCreID 	INT(11);			-- ID de la razon de no pago
    DECLARE Var_ClienteID		INT(11);			-- ID del Cliente

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE AccesoRecursos     	INT(11);      		-- Tipo de acceso a recursos
	DECLARE MovImpagoCre		CHAR(2);			-- Movimiento para Impago de Credito
	DECLARE MovPagoCre			CHAR(2);			-- Movimiento para Pago de Credito
	DECLARE MovRegCli			CHAR(2);			-- Movimiento de Registro de Cliente
	DECLARE Est_Activo			CHAR(1);			-- Estatus Activo

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';				-- Constante cadena vacia ''
	SET Fecha_Vacia         	:= '1900-01-01';	-- Constante Fecha vacia 1900-01-01
	SET Entero_Cero         	:= 0;				-- Constante Entero cero 0
	SET Decimal_Cero			:= 0.0;				-- DECIMAL cero
	SET Salida_SI          		:= 'S';				-- Parametro de salida SI
	SET Salida_NO           	:= 'N';				-- Parametro de salida NO
	SET Entero_Uno          	:= 1;				-- Entero Uno
	SET AccesoRecursos        	:= 3;				-- Tipo de acceso a recursos
	SET MovImpagoCre 			:= 'IC';			-- Movimiento para Impago de Credito
	SET MovPagoCre 				:= 'PC';			-- Movimiento para Impago de Credito
	SET MovRegCli				:= 'RC';			-- Movimiento de Registro de Cliente
	SET Est_Activo				:= 'A';				-- Estatus Activo
	SET Aud_FechaActual 		:= Now();			-- Fecha actual

	-- Asignacion de valores por Defecto
	SET Par_CreditoID := IFNULL(Par_CreditoID, Entero_Cero);
	SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_TipoMov := IFNULL(Par_TipoMov, Cadena_Vacia);
	SET Par_CatRazonImpagoID := IFNULL(Par_CatRazonImpagoID, Entero_Cero);
	SET Par_MontoPago := IFNULL(Par_MontoPago, Decimal_Cero);
	SET Par_PromotorID := IFNULL(Par_PromotorID, Entero_Cero);
	SET Par_CajaID := IFNULL(Par_CajaID, Entero_Cero);
	SET Par_CuentaAhoID := IFNULL(Par_CuentaAhoID, Entero_Cero);
	SET Aud_DireccionIP := IFNULL(Aud_DireccionIP,Cadena_Vacia);
	SET Aud_ProgramaID := IFNULL(Aud_ProgramaID,'BITACORAMOVSWSALT');

	ManejoErrores:BEGIN
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-BITACORAACCESOALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;


		-- Fecha y Hora Actuales
		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
        SET Var_HoraActual := CURTIME();

		IF(Par_TipoMov NOT IN(MovImpagoCre, MovPagoCre, MovRegCli)) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especifique un tipo de movimiento valido.';
			LEAVE ManejoErrores;
		END IF;

		-- Validaciones especificas para el pago de Credito
		IF(Par_TipoMov = MovPagoCre) THEN
			SELECT 		CreditoID
				INTO 	Var_CreditoID
				FROM CREDITOS WHERE CreditoID = Par_CreditoID;

			IF(IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'Especifique un ID de Credito valido.';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_MontoPago = Decimal_Cero) THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'Especifique un monto valido para el pago de credito.';
				LEAVE ManejoErrores;
			END IF;

			SELECT 		Usuario
				INTO 	Var_UsuarioID
				FROM CAJASVENTANILLA
				WHERE CajaID = Par_CajaID;

			SET Var_UsuarioID := IFNULL(Var_UsuarioID, Entero_Cero);

			SELECT 		PromotorID 
				INTO 	Var_PromotorID
				FROM PROMOTORES 
				WHERE UsuarioID = Var_UsuarioID;

			SET Var_PromotorID := IFNULL(Var_PromotorID, Entero_Cero);
		END IF;

		-- Validaciones especificas para el Impago de Credito
		IF(Par_TipoMov = MovImpagoCre) THEN
			SELECT 		CreditoID
				INTO 	Var_CreditoID
				FROM CREDITOS WHERE CreditoID = Par_CreditoID;

			IF(IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'Especifique un ID de Credito valido.';
				LEAVE ManejoErrores;
			END IF;

			SELECT 		CatRazonImpagoCreID
				INTO 	Var_CatImpCreID
				FROM CATRAZONIMPAGOCRE
				WHERE CatRazonImpagoCreID = Par_CatRazonImpagoID
				AND Estatus = Est_Activo;

			IF(IFNULL(Var_CatImpCreID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'Especifique una razon de no pago valido.';
				LEAVE ManejoErrores;
			END IF;

			SELECT 		Usuario
				INTO 	Var_UsuarioID
				FROM CAJASVENTANILLA
				WHERE CajaID = Par_CajaID;

			SET Var_UsuarioID := IFNULL(Var_UsuarioID, Entero_Cero);

			SELECT 		PromotorID 
				INTO 	Var_PromotorID
				FROM PROMOTORES 
				WHERE UsuarioID = Var_UsuarioID;

			SET Var_PromotorID := IFNULL(Var_PromotorID, Entero_Cero);
		END IF;

		-- Validaciones especificas para el registro de Cliente
		IF(Par_TipoMov = MovRegCli) THEN
			SELECT 		ClienteID
				INTO 	Var_ClienteID
				FROM CLIENTES
				WHERE ClienteID = Par_ClienteID;

			IF(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'Especifique un ID de Cliente valido.';
				LEAVE ManejoErrores;
			END IF;

			SET Var_PromotorID := Par_PromotorID;

			SELECT 		UsuarioID
				INTO 	Var_UsuarioID
				FROM PROMOTORES
				WHERE PromotorID = Par_PromotorID;

			SET Var_UsuarioID := IFNULL(Var_UsuarioID, Entero_Cero);
		END IF;

        SET Var_BitacoraID := (SELECT MAX(BitacoraMovsWSID) + 1 FROM BITACORAMOVSWS);
        SET Var_BitacoraID := IFNULL(Var_BitacoraID, Entero_Uno);

        INSERT INTO BITACORAMOVSWS(
			BitacoraMovsWSID,		CreditoID, 				ClienteID,			Fecha, 				Hora,
			TipoMov,				CatRazonImpagoID,		MontoPago,			PromotorID,			UsuarioID,
			CajaID,					CuentaAhoID,			EmpresaID, 			Usuario, 			FechaActual,
			DireccionIP,			ProgramaID,				Sucursal, 			NumTransaccion
        )VALUES(
			Var_BitacoraID,			Par_CreditoID,			Par_ClienteID,		Var_FechaSistema,	Var_HoraActual,
			Par_TipoMov,			Par_CatRazonImpagoID,  	Par_MontoPago,		Var_PromotorID,		Var_UsuarioID,
			Par_CajaID,				Par_CuentaAhoID, 		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
        );

        IF(Par_TipoMov = MovImpagoCre) THEN
        	CALL BITACORACREMOVSWSPRO(
        		Var_BitacoraID,		Par_CreditoID,			Salida_NO,				Par_NumErr,				Par_ErrMen,
        		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
        		Aud_Sucursal,		Aud_NumTransaccion
        	);

        	IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
        	END IF;
        END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Bitacora de WS registrada exitosamente.';
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$