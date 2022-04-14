-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORADEPREAMORTIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORADEPREAMORTIALT`;DELIMITER $$

CREATE PROCEDURE `BITACORADEPREAMORTIALT`(
# ==============================================================================================================
# ------- STORED PARA ALTA EN BITACORA DE MOVIMIENTOS DE DEPRECIACION Y AMORTIZACION DE ACTIVOS ---------
# ==============================================================================================================
    Par_ActivoID			INT(11), 		-- Idetinficador del activo
    Par_Moi					DECIMAL(16,2), 	-- Monto Original Inversion(MOI)
    Par_DepreciacionAnual	DECIMAL(14,2), 	-- % puede ser un valor a dos decimales en un rango del 1 al 100
    Par_TiempoAmortiMeses	INT(11), 		-- tiempo en meses que se consideraran para amortizar el activo esto solo tratandose de "Otros Activos", en el caso de "Activo Fijo" su valor sera 12 ya que corresponde al periodo de un anio
    Par_DepreciaContaAnual	DECIMAL(16,2), 	-- Indica el monto de Depreciacion Contable Anual

    Par_Anio				INT(11), 		-- Idetinficador del tipo de activo
	Par_Mes					INT(11), 		-- Idetinficador del tipo de activo
    Par_MontoDepreciar		DECIMAL(16,2), 	-- Monto por Depreciar
    Par_DepreciadoAcumulado	DECIMAL(16,2), 	-- Monto depreciado acumulado
    Par_SaldoPorDepreciar	DECIMAL(16,2), 	-- Saldo por depreciar

    Par_Estatus				CHAR(1), 		-- Indica el estatus del movimiento de depreciacion y amortizacion R=Registrado o A=Aplicado
    Par_FechaAplicacion    	DATETIME,		-- Fecha de aplicacion del proceso de depreciacion y amortizacion
    Par_UsuarioID			INT(11), 		-- Usuario que realilza el proceso de depreciacion y amortizacion
	Par_SucursalID			INT(11), 		-- Sucursal donde se realiza el proceso de depreciacion y amortizacion

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
	DECLARE Var_DepreAmortiID	INT(11);   			-- Variable de ID activo

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
							'esto le ocasiona. Ref: SP-BITACORADEPREAMORTIALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;


        SET Var_DepreAmortiID := (SELECT IFNULL(MAX(DepreAmortiID),Entero_Cero) + Entero_Uno FROM BITACORADEPREAMORTI WHERE ActivoID = Par_ActivoID);
		SET Aud_FechaActual := NOW();

        INSERT INTO BITACORADEPREAMORTI(
			DepreAmortiID, 		ActivoID, 			Moi, 				DepreciacionAnual, 		TiempoAmortiMeses,
			DepreciaContaAnual, Anio, 				Mes, 				DepreAcuInicio,			TotalDepreciarIni,
            MontoDepreciar, 	DepreciadoAcumulado,SaldoPorDepreciar, 	Estatus, 				FechaAplicacion,
            UsuarioID, 			SucursalID,
			EmpresaID, 			Usuario, 			FechaActual, 		DireccionIP, 			ProgramaID,
			Sucursal, 			NumTransaccion
        )VALUES(
			Var_DepreAmortiID,		Par_ActivoID, 						Par_Moi, 				Par_DepreciacionAnual, 	Par_TiempoAmortiMeses,
			Par_DepreciaContaAnual, Par_Anio, 							Par_Mes, 				Entero_Cero,			Entero_Cero,
            Par_MontoDepreciar, 	Par_DepreciadoAcumulado, 			Par_SaldoPorDepreciar, 	Par_Estatus, 			Par_FechaAplicacion,
            Par_UsuarioID, 			Par_SucursalID,
			Par_EmpresaID,			Aud_Usuario,						Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
            Aud_Sucursal,			Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Registro Agregado Exitosamente:',CAST(Var_DepreAmortiID AS CHAR) );
		SET Var_Control		:= 'activoID';
		SET Var_Consecutivo	:= Var_DepreAmortiID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$