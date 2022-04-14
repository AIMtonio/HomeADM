-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROYECCIONINDICAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROYECCIONINDICAALT`;DELIMITER $$

CREATE PROCEDURE `PROYECCIONINDICAALT`(
# =====================================================================================
# ------- STORED PARA LA ALTA DE LOS INDICADORES DE PROYECCION
# =====================================================================================

	Par_ConsecutivoID		BIGINT(20), 	-- Numero Consecutivo
    Par_Anio				INT(11), 		-- Anio en el que se genera la Proyeccion
    Par_Mes					VARCHAR(50), 	-- Mes de la Proyeccion
    Par_SaldoTotal			DECIMAL(16,2), 	-- Saldo Total de la Proyeccion
    Par_SaldoFira			DECIMAL(16,2), 	-- Saldo Fira de la Proyeccion

    Par_GastosAdmin			DECIMAL(16,2),	-- Saldo de Gastos de Administracion Acumulados
    Par_CapitalConta		DECIMAL(16,2), 	-- Saldo de Capital Cotable
    Par_UtilidadNeta		DECIMAL(16,2),	-- Saldo de Utilidad Neta Acumulada
    Par_ActivoTotal			DECIMAL(16,2),	-- Saldo Total de Activos
    Par_SaldoVencido		DECIMAL(16,2),		-- Saldo Total de Cartera Vencida

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

	-- Parametros de Auditoria
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
    DECLARE Var_FechaSistema	DATE;
    DECLARE Var_FechaRegistro	DATE;
    DECLARE Var_Estatus			CHAR(1);			-- Estatus Procesado
    DECLARE Var_Comentario		TEXT;

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
    DECLARE Cons_SI 			CHAR(1);
    DECLARE Cons_NO 			CHAR(1);


    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';				-- Constante Cadena Vacia
	SET Fecha_Vacia         	:= '1900-01-01';	-- Constante Fecha Vacia
	SET Entero_Cero         	:= 0;  				-- Constante Cero
	SET Decimal_Cero			:= 0.0;				-- Constate Decimal 0.00
	SET Salida_SI          		:= 'S';				-- Constante Salida SI

	SET Salida_NO           	:= 'N';				-- Constante Salida NO
	SET Cons_SI 				:= 'S';				-- Constante SI
	SET Cons_NO 				:= 'N';				-- Constante NO



	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-PROYECCIONINDICAALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;


		SET Aud_FechaActual := NOW();

        INSERT INTO PROYECCIONINDICA
        VALUES ( Par_ConsecutivoID, Par_Anio, Par_Mes, 	Par_SaldoTotal, 	Par_SaldoFira, 		Par_GastosAdmin,
				Par_CapitalConta, 	Par_UtilidadNeta, 	Par_ActivoTotal, 	Par_SaldoVencido,
                Par_EmpresaID, 		Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,
                Aud_Sucursal, 		Aud_NumTransaccion);


		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Proyeccion Procesada Exitosamente' );
        SET Var_Control		:= 'GridMonitor';


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$