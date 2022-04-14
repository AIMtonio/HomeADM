-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAAPLICDEPAMOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAAPLICDEPAMOALT`;DELIMITER $$

CREATE PROCEDURE `BITACORAAPLICDEPAMOALT`(
# ==============================================================================================================
# ----- STORED PARA ALTA EN BITACORA DE APLICACION DEL PROCESO DE DEPRECIACION Y AMORTIZACION DE ACTIVOS -------
# ==============================================================================================================
	Par_Anio				INT(11), 		-- Idetinficador del tipo de activo
	Par_Mes					INT(11), 		-- Idetinficador del tipo de activo
    Par_Fecha		    	DATETIME,		-- Fecha de aplicacion del proceso de depreciacion y amortizacion
    Par_Hora		    	TIME,			-- Hora de aplicacion del proceso de depreciacion y amortizacion
    Par_UsuarioID			INT(11), 		-- Usuario que realilza el proceso de depreciacion y amortizacion

    Par_SucursalID			INT(11), 		-- Sucursal donde se realiza el proceso de depreciacion y amortizacion
    Par_PolizaID 			BIGINT(20),  	-- Numero de poliza

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
	DECLARE Var_BitApliDepAmoID	INT(11);   			-- Variable de ID

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BITACORAAPLICDEPAMOALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        SET Var_BitApliDepAmoID := (SELECT IFNULL(MAX(BitApliDepAmoID),Entero_Cero) + Entero_Uno FROM BITACORAAPLICDEPAMO);
		SET Aud_FechaActual := NOW();

        INSERT INTO BITACORAAPLICDEPAMO(
			BitApliDepAmoID, 		Anio, 				Mes, 				Fecha, 				Hora,
            UsuarioID, 				SucursalID,			PolizaID,
			EmpresaID, 				Usuario, 			FechaActual, 		DireccionIP, 		ProgramaID,
			Sucursal, 				NumTransaccion
        )VALUES(
			Var_BitApliDepAmoID,	Par_Anio, 			Par_Mes, 			Par_Fecha, 			Par_Hora,
            Par_UsuarioID, 			Par_SucursalID,		Par_PolizaID,
			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,			Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Registro Agregado Exitosamente:',CAST(Var_BitApliDepAmoID AS CHAR) );
		SET Var_Control		:= 'activoID';
		SET Var_Consecutivo	:= Var_BitApliDepAmoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$