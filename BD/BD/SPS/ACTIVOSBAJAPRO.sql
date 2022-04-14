-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVOSBAJAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVOSBAJAPRO`;DELIMITER $$

CREATE PROCEDURE `ACTIVOSBAJAPRO`(
# ==============================================================================================================
# ------- STORED DE PROCESO PARA BAJA DE ACTIVO ---------
# ==============================================================================================================
    Par_ActivoID			INT(11), 		-- Idetinficador del activo
    Par_TipoActivoID		INT(11), 		-- Idetinficador del tipo de activo
    Par_FechaAdquisicion 	DATE, 			-- Fecha de Adquisicion
    Par_Moi					DECIMAL(16,2), 	-- Monto Original Inversion(MOI)
	Par_DepreciadoAcumu		DECIMAL(16,2),	-- Depreciado Acumulado

	Par_TotalDepreciar		DECIMAL(16,2),	-- Total por Depreciar
    Par_EsDepreciado		CHAR(1),		-- Es depreciado el activo S= SI n= NO
    Par_FechaRegistro	 	DATE, 			-- Fecha de registro del activo

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

    DECLARE Var_Consecutivo			VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         	VARCHAR(100);   	-- Variable de Control
    DECLARE Var_DepreAmortiID 		INT(11);

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
    DECLARE Est_Aplicado		CHAR(1);
    DECLARE Cons_SI				CHAR(1);
    DECLARE Cons_NO				CHAR(1);

	DECLARE Entero_Dos	     	INT(1);       		-- Constante Entero cero 0
    DECLARE Est_Registrado		CHAR(1);

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
    SET Est_Aplicado			:= 'A';
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';

	SET Entero_Dos          	:= 2;
    SET Est_Registrado			:= 'R';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ACTIVOSBAJAPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        SET Aud_FechaActual := NOW();

		-- SE OBTIENE EL ID DE LA PROXIMA DEPRECIACION DEL ACTIVO
		SELECT MIN(DepreAmortiID)
			INTO Var_DepreAmortiID
        FROM BITACORADEPREAMORTI
        WHERE ActivoID = Par_ActivoID
			AND Estatus = Est_Registrado;

        -- SE ACTUALIZA EL MONTO POR DEPRECIAR POR EL TOTAL POR DEPRECIAR, AL DAR DE BAJA EL ACTIVO SE DEPRECIARA POR TODO
        UPDATE BITACORADEPREAMORTI SET
			MontoDepreciar = Par_TotalDepreciar,
			DepreciadoAcumulado = Par_DepreciadoAcumu + Par_TotalDepreciar,
			SaldoPorDepreciar = Par_Moi - (Par_DepreciadoAcumu + Par_TotalDepreciar),

			EmpresaID			= Par_EmpresaID,
            Usuario				= Aud_Usuario,
            FechaActual			= Aud_FechaActual,
            DireccionIP			= Aud_DireccionIP,
            ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
            NumTransaccion		= Aud_NumTransaccion
		WHERE ActivoID = Par_ActivoID
			AND DepreAmortiID = Var_DepreAmortiID;

        -- ELIMINA LOS REGISTRO FALTANTES POR DEPRECIAR, SOLO QUEDARA EL ULTIMO POR EL TOTAL POR DEPRECIAR EL ACTIVO
		DELETE FROM BITACORADEPREAMORTI
		WHERE ActivoID = Par_ActivoID
			AND DepreAmortiID > Var_DepreAmortiID;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Proceso Realizado Exitosamente:',CAST(Par_ActivoID AS CHAR) );
		SET Var_Control		:= 'activoID';
		SET Var_Consecutivo	:= Par_ActivoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$