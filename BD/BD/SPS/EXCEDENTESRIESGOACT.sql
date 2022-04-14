-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXCEDENTESRIESGOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EXCEDENTESRIESGOACT`;DELIMITER $$

CREATE PROCEDURE `EXCEDENTESRIESGOACT`(
# =====================================================================================
# ------- STORED PARA ACTUALIZAR LOS EXCEDENTES DE RIESGO
# =====================================================================================

	Par_Fecha				DATE, 			-- Fecha de Registro del Excedente
    Par_GrupoID				INT(11), 		-- ID de Grupo al que pertenece
    Par_RiesgoID			VARCHAR(200), 	-- ID de Riesgo Comun
    Par_ClienteID			INT(11), 		-- ID de Cliente que presenta Riesgo
    Par_NumAct  			TINYINT UNSIGNED,	-- Tipo de Actualizacion


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
    DECLARE Principal			INT;				-- Actividad Principal

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
    DECLARE Cons_SI 			CHAR(1);
    DECLARE Cons_NO 			CHAR(1);


    -- ASIGNACION DE CONSTANTES
	SET Principal				:=1;
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
							'esto le ocasiona. Ref: SP-EXCEDENTESRIESGOACT');
			SET Var_Control := 'SQLEXCEPTION';
		END;


		SET Aud_FechaActual := NOW();
        SET Par_Fecha	:= DATE_FORMAT(Par_Fecha,'%Y-%m-01');

        IF (Par_NumAct = Principal) THEN
			UPDATE EXCEDENTESGRUPOSRIESGO SET
				RiesgoID 		= Par_RiesgoID
			WHERE GrupoID = Par_GrupoID AND ClienteID = Par_ClienteID AND Fecha = Par_Fecha;

			SET Par_NumErr 		:= 0;
			SET Par_ErrMen 		:= CONCAT('Excedente de Riesgo Procesado Exitosamente' );
			SET Var_Control		:= 'GridMonitor';
		END IF;


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$