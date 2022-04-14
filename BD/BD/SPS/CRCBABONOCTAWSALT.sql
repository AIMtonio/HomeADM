-- SP CRCBABONOCTAWSALT

DELIMITER ;

DROP PROCEDURE IF EXISTS `CRCBABONOCTAWSALT`;

DELIMITER $$

CREATE PROCEDURE `CRCBABONOCTAWSALT`(
# ========================================================================
# ------- STORE PARA REALIZAR EL ABONO A CUENTA DESDE WS CREDICLUB -------
# ========================================================================
	Par_CuentaAhoID			BIGINT(12),			-- Numero de Cuenta
    Par_Monto				DECIMAL(14,2),		-- Monto del Abono
    Par_NatMovimiento		CHAR(1),			-- Naturaleza de Movimiento
    Par_Fecha				DATE,				-- Fecha del Movimiento
    Par_ReferenciaMov		VARCHAR(50),		-- Referencia del Movimiento

	Par_CodigoRastreo		VARCHAR(200),		-- Codigo de Rastreo

    Par_Salida           	CHAR(1),			-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     	INT(11),			-- Numero de Error
	INOUT Par_ErrMen     	VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control     	VARCHAR(100);	-- Almacena el control de errores
	DECLARE	Var_CrcbAbonoCtaID	BIGINT(12);		-- Variable para almacenar el Numero Consecutivo

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia	CHAR(1);			-- Constante Cadena Vacia
	DECLARE Entero_Cero		INT(1);				-- Entero Cero
	DECLARE Decimal_Cero	DECIMAL(12,2);		-- Decimal Cero
	DECLARE Fecha_Vacia		DATE;				-- Constante para fecha vacia
    DECLARE Salida_SI		CHAR(1);			-- Salida: SI

    DECLARE Salida_NO		CHAR(1);			-- Salida: NO

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Constante Cadena Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.0;				-- Decimal Cero
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
    SET Salida_SI			:= 'S';				-- Salida: SI

    SET Salida_NO			:= 'N';				-- Salida: NO

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CRCBABONOCTAWSALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        -- SE OBTIENE EL VALOR CONSECUTIVO PARA EL REGISTRO EN LA TABLA CRCBABONOCTAWS
		SET Var_CrcbAbonoCtaID := (SELECT IFNULL(MAX(CrcbAbonoCtaID),Entero_Cero)+1 FROM CRCBABONOCTAWS);

        -- SE OBTIENE LA FECHA ACTUAL
		SET Aud_FechaActual  := NOW();

		-- SE REGISTRA LA INFORMACION DEL ABONO A LA CUENTA EN LA TABLA CRCBABONOCTAWS
		INSERT INTO CRCBABONOCTAWS(
			CrcbAbonoCtaID, 		CuentaAhoID,			Monto,					NatMovimiento,			Fecha,
			ReferenciaMov,			CodigoRastreo,			EmpresaID,				Usuario,				FechaActual,
            DireccionIP, 			ProgramaID, 			Sucursal,				NumTransaccion)
		VALUES(
			Var_CrcbAbonoCtaID, 	Par_CuentaAhoID,		Par_Monto,				Par_NatMovimiento,		Par_Fecha,
			Par_ReferenciaMov,		Par_CodigoRastreo,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
            Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Abono a Cuenta Registrada Exitosamente.';
		SET Var_Control	:= 'cuentaAhoID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control	AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$