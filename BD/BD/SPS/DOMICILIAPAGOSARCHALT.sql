-- SP DOMICILIAPAGOSARCHALT

DELIMITER ;

DROP PROCEDURE IF EXISTS DOMICILIAPAGOSARCHALT;

DELIMITER $$

CREATE PROCEDURE `DOMICILIAPAGOSARCHALT`(
# ==========================================================================================
# ---- STORE PARA EL REGISTRO DE ARCHIVOS DE DOMICILIACION DE PAGOS DESPUES DE PROCESAR ----
# ==========================================================================================
	Par_FolioID				BIGINT(20),			-- Numero de Folio
	Par_Fecha				VARCHAR(18),		-- Fecha de Proceso de Domiciliacion de Pago
    Par_NombreArchivo		VARCHAR(200),		-- Nombre del Archivo de Domiciliacion de Pagos Procesado

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
    DECLARE	Var_ConsecutivoID	BIGINT(20);		-- ID Consecutivo
    DECLARE Var_FechaSistema	DATE;			-- Se obtiene la Fecha del Sistema

	-- Declaracion de Constantes
	DECLARE Entero_Cero    	INT(11);
    DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Cadena_Vacia   	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;	
	DECLARE	SalidaSI        CHAR(1);

    DECLARE	SalidaNO        CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero Cero
    SET Decimal_Cero		:= 0.00;			-- Decimal Cero
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia 
	SET	SalidaSI        	:= 'S';				-- Salida Si

    SET	SalidaNO        	:= 'N'; 			-- Salida No


    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-DOMICILIAPAGOSARCHALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        -- Se obtiene la Fecha del Sistema
        SET Var_FechaSistema	:=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
        SET Par_Fecha			:=IFNULL(Par_Fecha,Var_FechaSistema);

        -- Se obtiene el valor consecutivo para el registro en la tabla DOMICILIAPAGOSARCH
		SET Var_ConsecutivoID := (SELECT IFNULL(MAX(ConsecutivoID),Entero_Cero)+1 FROM DOMICILIAPAGOSARCH);

        -- Se obtiene la Fecha Actual
        SET Aud_FechaActual := NOW();

		-- Se registra la informacion en la tabla DOMICILIAPAGOSARCH
		INSERT INTO DOMICILIAPAGOSARCH(
			ConsecutivoID,		FolioID,			Fecha,				NombreArchivo,		EmpresaID,
            Usuario, 			FechaActual,		DireccionIP, 		ProgramaID, 		Sucursal,
            NumTransaccion)
        VALUES(
        	Var_ConsecutivoID,	Par_FolioID,		Par_Fecha,			Par_NombreArchivo,	Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,
            Aud_NumTransaccion);


		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Archivo Domiciliacion de Pagos Agregada Exitosamente.';
		SET Var_Control	:= 'generar';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$