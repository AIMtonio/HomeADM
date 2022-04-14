-- SP DOMICILIACIONPAGOSBAJ

DELIMITER ;

DROP PROCEDURE IF EXISTS DOMICILIACIONPAGOSBAJ;

DELIMITER $$

CREATE PROCEDURE `DOMICILIACIONPAGOSBAJ`(
# =======================================================================
# ------------ STORE PARA BAJA DE DOMICILIACION DE PAGOS ----------------
# =======================================================================
    Par_ConsecutivoID		BIGINT(20),			-- ID Consecutivo
	Par_NumTransaccion		BIGINT(20),			-- Numero de Transaccion
	Par_TipoBaja			TINYINT UNSIGNED,	-- Tipo de Baja

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
	DECLARE	Var_Control     	VARCHAR(100);	-- Almacena el control de errores

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);
	DECLARE Cadena_Vacia   	 	CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
    DECLARE	SalidaSI        	CHAR(1);
    DECLARE	SalidaNO        	CHAR(1);

	DECLARE Baja_Detalles		INT(11);
    DECLARE Baja_Domiciliacion	INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0; 				-- Entero Cero
	SET Cadena_Vacia			:= '';   			-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';  	-- Fecha Vacia
    SET	SalidaSI        		:= 'S';				-- Salida Si
    SET	SalidaNO        		:= 'N'; 			-- Salida No

	SET Baja_Detalles			:= 1;				-- Baja de detalles de Domiciliacion de Pagos
    SET Baja_Domiciliacion		:= 2;				-- Baja de Domiciliacion de Pagos

	ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-DOMICILIACIONPAGOSBAJ');
			SET Var_Control = 'SQLEXCEPTION' ;
		END;

		-- 1.-  Baja de detalles de Domiciliacion de Pagos
		IF(Par_TipoBaja = Baja_Detalles)THEN
			DELETE FROM TMPDETDOMICILIAPAGOS WHERE ConsecutivoID = Par_ConsecutivoID AND NumTransaccion = Par_NumTransaccion;

		END IF;

        -- 2.- Baja de Domiciliacion de Pagos
        IF(Par_TipoBaja = Baja_Domiciliacion)THEN
			DELETE FROM TMPDETDOMICILIAPAGOS WHERE NumTransaccion = Par_NumTransaccion;
        END IF;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Domiciliacion de Pagos Eliminada Exitosamente.';
		SET Var_Control	:= 'generarLayout';

	END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$