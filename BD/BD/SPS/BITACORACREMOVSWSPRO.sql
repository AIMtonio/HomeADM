-- BITACORACREMOVSWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS BITACORACREMOVSWSPRO;
DELIMITER $$

CREATE PROCEDURE BITACORACREMOVSWSPRO(
	Par_BitacoraMovsWSID	BIGINT(20),			-- ID de la bitacora de WebService
	Par_CreditoID         	BIGINT(12),			-- ID del Credito

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
	DECLARE Est_Pagado			CHAR(1);			-- Estatus Pagado

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
	SET Est_Pagado				:= 'P';				-- Estatus Activo
	SET Aud_FechaActual 		:= Now();			-- Fecha actual

	-- Asignacion de valores por Defecto
	SET Par_BitacoraMovsWSID := IFNULL(Par_BitacoraMovsWSID, Entero_Cero);
	SET Par_CreditoID := IFNULL(Par_CreditoID, Entero_Cero);

	ManejoErrores:BEGIN
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-BITACORACREMOVSWSPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Fecha y Hora Actuales
		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
        SET Var_HoraActual := CURTIME();

		IF(Par_BitacoraMovsWSID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especifique un ID de Bitacora de Web Service.';
			LEAVE ManejoErrores;
		END IF;

		SELECT BitacoraMovsWSID
			INTO Var_BitacoraID
			FROM BITACORAMOVSWS
			WHERE BitacoraMovsWSID = Par_BitacoraMovsWSID;

		IF(IFNULL(Var_BitacoraID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'Especifique un ID de Bitacora valido.';
			LEAVE ManejoErrores;
		END IF;

		SET Var_BitacoraID := NULL;
		SELECT BitacoraMovsWSID
			INTO Var_BitacoraID
			FROM BITACORACREMOVSWS
			WHERE BitacoraMovsWSID = Par_BitacoraMovsWSID
			LIMIT 1;

		IF(IFNULL(Var_BitacoraID, Entero_Cero) <> Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El ID de Bitacora especificado ya ha sido registrado previamente.';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'Especifique un Numero de Credito.';
			LEAVE ManejoErrores;
		END IF;



		INSERT INTO BITACORACREMOVSWS(
					BitacoraMovsWSID,			CreditoID,				AmortizacionID,				
					MontoCuota,
					DiasMoratorio,			
					EmpresaID,					Usuario,				FechaActual,				DireccionIP,				ProgramaID,
					Sucursal,					NumTransaccion
			)
			SELECT 	Par_BitacoraMovsWSID,		CreditoID,				AmortizacionID,				
					FUNCIONEXIGIBLEAMOR(CreditoID,AmortizacionID),
					DATEDIFF(Var_FechaSistema, FechaExigible),
					Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,				Aud_NumTransaccion
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND FechaExigible <= Var_FechaSistema
				AND Estatus <> Est_Pagado;
		
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