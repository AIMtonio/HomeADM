-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EJECUCIONCIERREVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `EJECUCIONCIERREVAL`;DELIMITER $$

CREATE PROCEDURE `EJECUCIONCIERREVAL`(
# =====================================================================================
# -------  STORED DE PROCESO QUE VALIDA INICIO DE CIERRE Y FECHAS ---------
# =====================================================================================
	Par_OrigenOperacion		CHAR(1),			-- P= se ejecuta cierre desde pantalla

    Par_Salida    			CHAR(1), 			-- Parametro de salida S= si, N= no
    INOUT	Par_NumErr 		INT(11),			-- Parametro de salida numero de error
    INOUT	Par_ErrMen  	VARCHAR(400),		-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    DECLARE Var_Consecutivo			VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         	VARCHAR(100);   	-- Variable de Control
    DECLARE EjecutaCierreDia		CHAR(1);
    DECLARE Var_FechaSistema		DATE;
    DECLARE Var_UltimaFechaCierre	DATE;
    DECLARE Var_FechaActual			DATE;
	DECLARE Var_EjecutaCierre		CHAR(1);

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE	Con_Principal		INT;				-- Tipo de Consulta: Principal
	DECLARE Con_UltEjecuta 		INT;				-- Tipo de Consulta: Ultima Ejecucion

    DECLARE ValorSI				CHAR(1);
    DECLARE ValorNO				CHAR(1);
    DECLARE CierrePantalla		CHAR(1);
    DECLARE CierreKTR			CHAR(1);
	DECLARE Act_InicioCierre   	INT(11);

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Con_Principal			:= 1;
	SET	Con_UltEjecuta			:= 2;
    SET ValorSI					:= 'S';				-- Valor:SI
	SET ValorNO					:= 'N';				-- Valor:NO
	SET CierrePantalla			:= 'P';
	SET CierreKTR				:= 'K';
	SET Act_InicioCierre       	:= 5;

	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
						  concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-EJECUCIONCIERREVAL');
		SET Var_Control = 'SQLEXCEPTION';
	END;

		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
		SET Var_FechaActual := NOW();

		-- VALIDAMOS SI YA SE ESTA REALIZANDO EL CIERRE
		SET Var_EjecutaCierre := (SELECT ValorParametro
									FROM PARAMGENERALES
										WHERE LlaveParametro = 'EjecucionCierreDia');

		IF(Var_EjecutaCierre = 'S' )THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'Existe un proceso de cierre de dia ejecutandose en este momento, por tal motivo el cierre no podra ser realizado. ';
			LEAVE ManejoErrores;
		END IF;

		-- -------------------------------------------------------------------------------------------
		-- SE ACTUALIZA PARAMGENERALES BANDERA QUE COMIENZA CIERRE DE DIA
		-- -------------------------------------------------------------------------------------------
		CALL PARAMGENERALESACT(
			Act_InicioCierre,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:='Proceso Realizado Exitosamente';
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;
END TerminaStore$$