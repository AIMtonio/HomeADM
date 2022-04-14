-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSMONTOAUTOMODALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSMONTOAUTOMODALT`;DELIMITER $$

CREATE PROCEDURE `CREDITOSMONTOAUTOMODALT`(
# ============================================================================
# --- STORE PARA EL REGISTRO DE CREDITOS CON MONTOS AUTORIZADOS MODIFICADOS --
# ============================================================================
	Par_CreditoID      		BIGINT(12),			-- Numero de Credito
	Par_Monto				DECIMAL(14,2),		-- Monto del Credito
	Par_MontoModificado		DECIMAL(14,2),		-- Monto Modificado del Credito

    Par_Salida           	CHAR(1),			-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     	INT(11),			-- Numero de Error
	INOUT Par_ErrMen     	VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario             INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual         DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP         VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID          VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal            INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion      BIGINT(20)			-- Parametro de Auditoria Numero de la Transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control     	VARCHAR(100);	-- Almacena el control de errores
    DECLARE Var_Fecha			DATE;			-- Almacena la Fecha del Sistema
	DECLARE Var_MontoModificado	DECIMAL(14,2);	-- Almacena el Monto Modificado

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);		-- Entero Cero
    DECLARE Decimal_Cero		DECIMAL(12,2);	-- Decimal Cero
	DECLARE Cadena_Vacia   		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	SalidaSI        	CHAR(1);		-- Salida: SI

    DECLARE	SalidaNO        	CHAR(1);		-- Salida: NO
    DECLARE ConstanteSI			CHAR(1);		-- Constante: SI
	DECLARE ConstanteNO			CHAR(1);		-- Constante: NO

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero Cero
    SET Decimal_Cero		:= 0.00;			-- Decimal Cero
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	SalidaSI        	:= 'S';				-- Salida: SI

    SET	SalidaNO        	:= 'N'; 			-- Salida: NO
    SET ConstanteSI			:= 'S';				-- Constante: SI
	SET ConstanteNO			:= 'N';				-- Constante: NO

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CREDITOSMONTOAUTOMODALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        IF(IFNULL(Par_CreditoID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Credito esta Vacio.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Monto del Credito esta Vacio.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MontoModificado, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'El Monto Modificado del Credito esta Vacio.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT CreditoID FROM CREDITOSMONTOAUTOMOD WHERE CreditoID = Par_CreditoID)THEN
			IF(Par_MontoModificado > Par_Monto)THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := 'El Monto Especificado No debe ser Mayor al Monto Autorizado del Credito.';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF EXISTS (SELECT CreditoID FROM CREDITOSMONTOAUTOMOD WHERE CreditoID = Par_CreditoID)THEN
			SET Par_Monto := (SELECT MontoOriginal FROM CREDITOSMONTOAUTOMOD WHERE CreditoID = Par_CreditoID);
			IF(Par_MontoModificado > Par_Monto) THEN
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := 'El Monto Modificado No debe ser Mayor al Monto Original del Credito.';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

        -- SE OBTIENE LA FECHA DEL SISTEMA
        SET Var_Fecha := (SELECT FechaSistema FROM PARAMETROSSIS);

        -- SE OBTIENE LA FECHA ACTUAL
		SET Aud_FechaActual := NOW();

        -- SE VERIFICA QUE NO EXISTA EL CREDITO EN LA TABLA CREDITOSMONTOAUTOMOD PARA REGISTRAR EL CREDITO
        IF NOT EXISTS (SELECT CreditoID FROM CREDITOSMONTOAUTOMOD WHERE CreditoID = Par_CreditoID)THEN
			IF(Par_MontoModificado <> Par_Monto)THEN
				INSERT INTO CREDITOSMONTOAUTOMOD (
					CreditoID,			MontoOriginal,		MontoModificado,		Simulado,			Fecha,
					FechaSimula,		EmpresaID,			Usuario,				FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				 VALUES (
					Par_CreditoID,		Par_Monto,			Par_MontoModificado,	ConstanteNO,		Var_Fecha,
					Fecha_Vacia,		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);
			END IF;
		END IF;

		-- SE ACTUALIZAN LOS CAMPOS EN LA TABLA CREDITOSMONTOAUTOMOD
		IF EXISTS(SELECT CreditoID FROM CREDITOSMONTOAUTOMOD WHERE CreditoID = Par_CreditoID)THEN
			SET Var_MontoModificado := (SELECT MontoModificado FROM CREDITOSMONTOAUTOMOD WHERE CreditoID = Par_CreditoID);
            SET Var_MontoModificado := IFNULL(Var_MontoModificado,Decimal_Cero);
			IF(Var_MontoModificado <> Par_MontoModificado)THEN
				UPDATE CREDITOSMONTOAUTOMOD
				SET	MontoModificado	= Par_MontoModificado,
					Fecha			= Var_Fecha,
					Simulado		= ConstanteNO,
					FechaSimula		= Fecha_Vacia,

					EmpresaID		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE CreditoID = Par_CreditoID;
			END IF;
        END IF;

		SET Par_NumErr      := Entero_Cero;
		SET Par_ErrMen      := 'Monto de Credito Modificado Exitosamente.';
		SET Var_Control		:= 'creditoID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$