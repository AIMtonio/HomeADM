-- DEPOSITOACTIVACTAAHOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOACTIVACTAAHOALT`;
DELIMITER $$

CREATE PROCEDURE `DEPOSITOACTIVACTAAHOALT`(
# =====================================================================================
# --- STORED PARA ALTA DE REGISTRO DE DEPOSTIOS PARA ACTIVACION DE CUENTA DE AHORRO ---
# =====================================================================================
	Par_CuentaAhoID 		BIGINT(12), 	-- Identificador de la cuenta de ahorro
	Par_MontoDepositoActiva DECIMAL(18,2), 	-- Monto del deposito para activar la cuenta de ahorro'

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
	DECLARE Var_CuentaAhoID 	BIGINT(12); 		-- Identificador de la cuenta de ahorro
	DECLARE Var_Estatus			CHAR(1);			-- Estatus cuenta
    DECLARE Var_DepositoActCtaID INT(11);			-- Identificador del deposito para activar la cuenta de ahorro

    DECLARE Var_FechaSistema	DATE;				-- Fecha del Sistema

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Est_Registrada		CHAR(1);			-- R estatus registrada
	DECLARE Est_DepReg	     	INT(11);      		-- Estatus registrado Uno
    DECLARE TipoRegCta_Nueva	CHAR(1);			-- Tipo de registro de ceunta nueva

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET	Est_Registrada			:= 'R';
	SET Est_DepReg          	:= 1;
    SET TipoRegCta_Nueva		:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-DEPOSITOACTIVACTAAHOALT');
			SET Var_Control = 'sqlException';
		END;

		IF(IFNULL(Par_CuentaAhoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'La Cuenta de Ahorro esta Vacia.';
			SET Var_Control		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

        SELECT CuentaAhoID,	Estatus
			INTO Var_CuentaAhoID, Var_Estatus
        FROM CUENTASAHO
        WHERE CuentaAhoID = Par_CuentaAhoID;

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'La Cuenta de Ahorro No Existe.';
			SET Var_Control		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_Estatus, Cadena_Vacia) <> Est_Registrada) THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'El Estatus de la Cuenta de Ahorro debe estar Registrada';
			SET Var_Control		:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		SET Var_CuentaAhoID := Entero_Cero;
        SET Var_CuentaAhoID := (SELECT CuentaAhoID FROM DEPOSITOACTIVACTAAHO WHERE CuentaAhoID = Par_CuentaAhoID);

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero) > Entero_Cero) THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'La Cuenta de Ahorro ya tiene un Registro de Deposito.';
			SET Var_Control		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_DepositoActCtaID := (SELECT IFNULL(MAX(DepositoActCtaID),Entero_Cero) + Entero_Uno FROM DEPOSITOACTIVACTAAHO);
		SET Aud_FechaActual := NOW();
   		SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

        INSERT INTO DEPOSITOACTIVACTAAHO(
			DepositoActCtaID, 		FechaRegistro,			CuentaAhoID, 			MontoDepositoActiva, 		FechaDeposito,
            PolizaIDDeposito,		NumTransaccionDep,		FechaBloqueo,			BloqueoID, 					PolizaIDActiva,
            NumTransaccionAct,      Estatus, 				TipoRegistroCta,
            EmpresaID, 				Usuario, 				FechaActual, 			DireccionIP, 				ProgramaID,
            Sucursal, 				NumTransaccion
		)VALUES(
			Var_DepositoActCtaID,	Var_FechaSistema,		Par_CuentaAhoID,		Par_MontoDepositoActiva,	Fecha_Vacia,
            Entero_Cero,			Entero_Cero,			Fecha_Vacia,			Entero_Cero,				Entero_Cero,
            Entero_Cero,            Est_DepReg,				TipoRegCta_Nueva,
            Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Registro de Deposito de Activacion Realizado Exitosamente: ',CAST(Var_DepositoActCtaID AS CHAR) );
		SET Var_Control		:= 'depositoActCtaID';
		SET Var_Consecutivo	:= Var_DepositoActCtaID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$