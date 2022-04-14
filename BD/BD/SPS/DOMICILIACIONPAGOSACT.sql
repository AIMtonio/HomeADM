-- SP DOMICILIACIONPAGOSACT

DELIMITER ;

DROP PROCEDURE IF EXISTS DOMICILIACIONPAGOSACT;

DELIMITER $$

CREATE PROCEDURE `DOMICILIACIONPAGOSACT`(
# ======================================================================
# ------------ STORE PARA ACTUALIZAR DOMICILIACION DE PAGOS ------------
# ======================================================================
	Par_FolioID				BIGINT(20),			-- Numero de Folio
    Par_CreditoID			BIGINT(12),			-- Numero de Credito
	Par_NumAct				TINYINT UNSIGNED,	-- Numero de Actualizacion

    Par_Salida           	CHAR(1),			-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     	INT(11),			-- Numero de Error
	INOUT Par_ErrMen     	VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control     VARCHAR(100);	-- Almacena el control de errores

	-- Declaracion de Constantes
	DECLARE Entero_Cero    	INT(11);
    DECLARE Decimal_Cero	DECIMAL(14,2);
	DECLARE Cadena_Vacia   	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	SalidaSI        CHAR(1);

    DECLARE	SalidaNO        CHAR(1);
	DECLARE ConstanteSI		CHAR(1);
    DECLARE Act_Estatus		INT(11);


	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero Cero
    SET Decimal_Cero        := 0.00;			-- Decimal Cero
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	SalidaSI        	:= 'S';				-- Salida Si

    SET	SalidaNO        	:= 'N'; 			-- Salida No
	SET ConstanteSI			:= 'S';				-- Constante: SI
	SET Act_Estatus			:= 1; 				-- Actualiza Estatus Domiciliacion de Pagos

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-DOMICILIACIONPAGOSACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        IF(Par_NumAct = Act_Estatus)THEN
			UPDATE	BITACORADOMICIPAGOS SET
				Reprocesado		= ConstanteSI,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= NOW(),
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE	CreditoID 	= Par_CreditoID
			  AND	FolioID		= Par_FolioID;
        END IF;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Estatus Domiciliacion de Pagos Actualizada Exitosamente.';
		SET Var_Control	:= 'generar';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$