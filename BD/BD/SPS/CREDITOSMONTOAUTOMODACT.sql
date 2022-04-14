-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSMONTOAUTOMODACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSMONTOAUTOMODACT`;DELIMITER $$

CREATE PROCEDURE `CREDITOSMONTOAUTOMODACT`(
# ============================================================================
# ---- STORE PARA ACTUALIZAR CREDITOS CON MONTOS AUTORIZADOS MODIFICADOS -----
# ============================================================================
	Par_CreditoID      		BIGINT(12),			-- Numero de Credito
	Par_NumAct          	TINYINT UNSIGNED,	-- Numero de Actualizacion

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

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);		-- Entero Cero
    DECLARE Decimal_Cero		DECIMAL(12,2);	-- Decimal Cero
	DECLARE Cadena_Vacia   		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	SalidaSI        	CHAR(1);		-- Salida: SI

    DECLARE	SalidaNO        	CHAR(1);		-- Salida: NO
    DECLARE ConstanteSI			CHAR(1);		-- Constante: SI
	DECLARE ConstanteNO			CHAR(1);		-- Constante: NO
	DECLARE Act_Simulado		INT(11);		-- Actualiza a Simulado el Credito con Monto Autorizado Modificado

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero Cero
    SET Decimal_Cero		:= 0.00;			-- Decimal Cero
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	SalidaSI        	:= 'S';				-- Salida: SI

    SET	SalidaNO        	:= 'N'; 			-- Salida: NO
    SET ConstanteSI			:= 'S';				-- Constante: SI
	SET ConstanteNO			:= 'N';				-- Constante: NO
    SET Act_Simulado		:= 1;				-- Actualiza a Simulado el Credito con Monto Autorizado Modificado

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CREDITOSMONTOAUTOMODACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        SET Aud_ProgramaID :=IFNULL(Aud_ProgramaID,'CREDITOSMONTOAUTOMODACT');

        IF(IFNULL(Par_CreditoID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Credito esta Vacio.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

        -- SE OBTIENE LA FECHA DEL SISTEMA
        SET Var_Fecha := (SELECT FechaSistema FROM PARAMETROSSIS);

        -- SE OBTIENE LA FECHA ACTUAL
		SET Aud_FechaActual := NOW();

		-- SE ACTUALIZAN A SIMULADO EL CREDITO CON MONTO AUTORIZADO MODIFICADO
        IF(Par_NumAct = Act_Simulado)THEN
			UPDATE CREDITOSMONTOAUTOMOD
			SET	Simulado		= ConstanteSI,
				FechaSimula		= Var_Fecha,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE CreditoID = Par_CreditoID;
		END IF;

		SET Par_NumErr      := Entero_Cero;
		SET Par_ErrMen      := 'Credito Actualizado Exitosamente.';
		SET Var_Control		:= 'creditoID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$