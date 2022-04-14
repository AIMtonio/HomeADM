-- SP ARCHIVOSCARGAFACTALT

DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOSCARGAFACTALT`;
DELIMITER $$


CREATE PROCEDURE `ARCHIVOSCARGAFACTALT`(
# ==========================================================================
# ------- STORED PARA ALTA DE ARCHIVOS DE CARGA MASIVA DE FACTURAS ---------
# ==========================================================================
    Par_FolioCargaID		INT(11), 		-- Folio de Carga del Archivo
    Par_Mes					INT(11), 		-- Mes de carga del archivo
	Par_UsuarioCarga		INT(11),		-- Usuario que realiza la carga
    Par_FechaCarga			DATE,			-- Fecha de Carga
    Par_NumTotalFacturas	INT(11),		-- Numero total de facturas del archivo

    Par_NumFacturasExito	INT(11),		-- Numero de facturas cargadas exitosamente
    Par_NumFacturasError	INT(11),		-- Numero de facturas cargadas con error
    Par_RutaArchivoFacturas	VARCHAR(250),	-- Ruta de archivo
	INOUT Par_Consecutivo	INT(11),		-- Parametro de entrada salida para regresa algun valor

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

	-- Declaracion de variables
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control

    -- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
    DECLARE Est_SinProcesar		CHAR(1);			-- Estatus N sin procesar

    -- Asignacion de constantes
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';
	SET Entero_Uno          	:= 1;
    SET Est_SinProcesar			:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ARCHIVOSCARGAFACTALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;


		SET Par_UsuarioCarga		:= IFNULL(Par_UsuarioCarga, Entero_Cero);
		SET Par_FechaCarga 			:= IFNULL(Par_FechaCarga, Fecha_Vacia);
        SET Par_NumTotalFacturas	:= IFNULL(Par_NumTotalFacturas, Entero_Cero);
        SET Par_NumFacturasExito	:= IFNULL(Par_NumFacturasExito, Entero_Cero);
        SET Par_NumFacturasError	:= IFNULL(Par_NumFacturasError, Entero_Cero);
        SET Par_RutaArchivoFacturas	:= IFNULL(Par_RutaArchivoFacturas, Cadena_Vacia);

		IF(IFNULL(Par_Mes,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Mes esta Vacio';
			SET Var_Control		:= 'mes';
			LEAVE ManejoErrores;
		END IF;

        SET Par_FolioCargaID := (SELECT IFNULL(MAX(FolioCargaID),Entero_Cero) + Entero_Uno FROM ARCHIVOSCARGAFACT);
		SET Aud_FechaActual := NOW();
        INSERT INTO ARCHIVOSCARGAFACT(
			FolioCargaID, 			Mes,	 				UsuarioCarga, 			FechaCarga, 		NumTotalFacturas,
            NumFacturasExito,		NumFacturasError, 		RutaArchivoFacturas,	Estatus, 			EmpresaID,
            Usuario,				FechaActual, 			DireccionIP, 			ProgramaID,			Sucursal,
            NumTransaccion
        )VALUES(
			Par_FolioCargaID,		Par_Mes,				Par_UsuarioCarga,		Par_FechaCarga,		Par_NumTotalFacturas,
            Par_NumFacturasExito,	Par_NumFacturasError,	Par_RutaArchivoFacturas,Est_SinProcesar,	Par_EmpresaID,
            Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Archivo de Carga Agregado Exitosamente:',CAST(Par_FolioCargaID AS CHAR) );
		SET Var_Control		:= 'mes';
		SET Par_Consecutivo	:= Par_FolioCargaID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_Consecutivo AS Par_FolioCargaID;

	END IF;

END TerminaStore$$