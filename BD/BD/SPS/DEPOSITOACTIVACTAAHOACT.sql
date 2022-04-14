-- DEPOSITOACTIVACTAAHOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOACTIVACTAAHOACT`;
DELIMITER $$

CREATE PROCEDURE `DEPOSITOACTIVACTAAHOACT`(
-- =====================================================================================
-- --- STORED PARA ACTUALIZAR DEPOSTIOS PARA ACTIVACION DE CUENTA DE AHORRO ------------
-- =====================================================================================
	Par_CuentaAhoID 		BIGINT(12), 	-- Identificador de la cuenta de ahorro
    Par_FechaAplicacion     DATE,			-- Fecha de aplicación de la operacion
    Par_PolizaID      		BIGINT(20),		-- ID de la poliza contable
    Par_BloqueoID 			INT(11),		-- ID del bloqueo del monto de deposito para activar
	Par_NumAct				TINYINT UNSIGNED,-- Numero de Actualizacion

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
	DECLARE Est_DepReg	     	INT(11);      		-- Estatus 1 registrado Uno
	DECLARE Est_DepPag	     	INT(11);      		-- Estatus 2  pagado dos

	DECLARE Est_AboBlo	     	INT(11);      		-- Estatus 3 abono y bloqueo tres
	DECLARE Est_Desbloqueo     	INT(11);      		-- Estatus 4 debloqueo cuatro

    DECLARE Act_DepositoVent	INT(11);			-- 1 actualizacion del deposito hecho en ventanilla
	DECLARE Act_AbonoBloqueo	INT(11);			-- 2 actualizacion del deposito al activar la cuenta, abonar y bloquear el monto
	DECLARE Act_Desbloqueo		INT(11);			-- 3 actualizacion del deposito al desbloquear el monto de activacion

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
	SET Est_DepPag          	:= 2;

	SET Est_AboBlo          	:= 3;
    SET Est_Desbloqueo			:= 4;

	SET Act_DepositoVent		:= 1;
    SET Act_AbonoBloqueo		:= 2;
    SET Act_Desbloqueo			:= 3;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-DEPOSITOACTIVACTAAHOACT');
			SET Var_Control = 'sqlException';
		END;

		-- 1 actualizacion del deposito hecho en ventanilla
        IF(Par_NumAct = Act_DepositoVent)THEN

			SET Aud_FechaActual := NOW();

			UPDATE DEPOSITOACTIVACTAAHO SET
				FechaDeposito 	= Par_FechaAplicacion,
				PolizaIDDeposito = Par_PolizaID,
                NumTransaccionDep = Aud_NumTransaccion,
                Estatus			= Est_DepPag,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE CuentaAhoID = Par_CuentaAhoID;

			SET Par_NumErr 		:= 0;
			SET Par_ErrMen 		:= CONCAT('Actualizacion de Deposito de Activacion Realizado Exitosamente: ',CAST(Par_CuentaAhoID AS CHAR) );
			SET Var_Control		:= 'depositoActCtaID';
			SET Var_Consecutivo	:= Par_CuentaAhoID;
		END IF;

		-- 2 actualizacion del deposito al activar la cuenta, se abono y se bloquea el monto
        IF(Par_NumAct = Act_AbonoBloqueo)THEN

			SET Aud_FechaActual := NOW();

			UPDATE DEPOSITOACTIVACTAAHO SET
				FechaBloqueo 	= Par_FechaAplicacion,
                BloqueoID		= Par_BloqueoID,
				PolizaIDActiva 	= Par_PolizaID,
                NumTransaccionAct = Aud_NumTransaccion,
                Estatus			= Est_AboBlo,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE CuentaAhoID = Par_CuentaAhoID;

			SET Par_NumErr 		:= 0;
			SET Par_ErrMen 		:= CONCAT('Actualizacion de Deposito de Activacion Realizado Exitosamente: ',CAST(Par_CuentaAhoID AS CHAR) );
			SET Var_Control		:= 'depositoActCtaID';
			SET Var_Consecutivo	:= Par_CuentaAhoID;
		END IF;

		-- 3 actualizacion del deposito cuando se desbloquea el monto del deposito de activacion
        IF(Par_NumAct = Act_Desbloqueo)THEN

			SET Aud_FechaActual := NOW();

			UPDATE DEPOSITOACTIVACTAAHO SET
                Estatus			= Est_Desbloqueo,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE CuentaAhoID = Par_CuentaAhoID
				AND BloqueoID = Par_BloqueoID;

			SET Par_NumErr 		:= 0;
			SET Par_ErrMen 		:= CONCAT('Actualizacion de Deposito de Activacion Realizado Exitosamente: ',CAST(Par_CuentaAhoID AS CHAR) );
			SET Var_Control		:= 'depositoActCtaID';
			SET Var_Consecutivo	:= Par_CuentaAhoID;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$