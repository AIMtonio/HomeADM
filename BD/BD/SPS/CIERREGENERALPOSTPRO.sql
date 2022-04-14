-- CIERREGENERALPOSTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREGENERALPOSTPRO`;
DELIMITER $$

CREATE PROCEDURE `CIERREGENERALPOSTPRO`(
-- =====================================================================================
-- ---- STORED PARA PROCESOS POST-CIERRE ------
-- =====================================================================================
    Par_FechaSistemaCierre	DATE,			-- Fecha de sistema del dia que se realiza el cierre
    
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
)TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;				-- Fecha de sistema
    DECLARE Var_FecBitaco       DATETIME;			-- Fecha para bitacora bash
    DECLARE Var_MinutosBit      INT(11);			-- Minutos duración del proceso bash

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si   		
	DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no
    DECLARE Pro_EliminaTransPLDTMP INT(11);			-- Número de Proceso bash 

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';
    SET Pro_EliminaTransPLDTMP	:= 10001;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-CIERREGENERALPOSTPRO');
			SET Var_Control = 'sqlException';
		END;
        
        SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
        SET Aud_FechaActual:= NOW();
        
        -- -------------------------------------------------------------------------------------------
		-- INICIO ELIMINA REGISTROS DE TABLAS TEMPORALES DE DETECCION DE OPERACIONES INUSUALES PLD POR TRANSACCION
		-- ------------------------------------------------------------------------------------------
		SET Var_FecBitaco := NOW();

        CALL ELIMINATMPDETOPEPLDTRANSPRO(
            Salida_NO,        	Par_NumErr,     	Par_ErrMen,			Par_EmpresaID,    	Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,   	Aud_NumTransaccion
		);
		
        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;       

        SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
            Pro_EliminaTransPLDTMP,  	Par_FechaSistemaCierre,      	Var_MinutosBit,		Par_EmpresaID,    	Aud_Usuario,
            Aud_FechaActual,    		Aud_DireccionIP,				Aud_ProgramaID,     Aud_Sucursal,   	Aud_NumTransaccion
		);
		-- -------------------------------------------------------------------------------------------
		-- FIN ELIMINA REGISTROS DE TABLAS TEMPORALES DE DETECCION DE OPERACIONES INUSUALES PLD POR TRANSACCION
		-- -------------------------------------------------------------------------------------------

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Post-Cierre Realizado Exitosamente.';
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$