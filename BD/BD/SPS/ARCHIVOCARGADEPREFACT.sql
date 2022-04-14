DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOCARGADEPREFACT`;
DELIMITER $$

CREATE PROCEDURE `ARCHIVOCARGADEPREFACT`(
-- =========================================================================================
-- -- STORED PARA ACTUALIZAR REGISTROS DE ARCHIVOS DE CARGA DE DEPOSITOS REFERENCIADOS -----
-- =========================================================================================
	Par_NumTran				BIGINT(20),		-- Numero de transaccion de la carga del archivo
	Par_FolioCargaID		BIGINT(17),		-- Folio unico de Carga de Archivo a Conciliar
	Par_InstitucionID		INT(11),		-- ID de la institución bancaria
	Par_NumCtaInstit		VARCHAR(20),	-- Numero de cuenta de la institucion bancaria
    Par_NumAct				TINYINT UNSIGNED,-- Numero de actualizacion

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
    DECLARE Var_FechaSistema	DATE;				-- Fecha de sistema

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
    DECLARE Act_EstatusAplicaDepRef	INT(11);		-- Actualizacion 1: Estatus registos aplica deposito

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
    SET Act_EstatusAplicaDepRef	:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ARCHIVOCARGADEPREFACT');
			SET Var_Control = 'sqlException';
		END;

        -- 1 actualiza el estatus de los registros que se aplicaran los depositos referenciados
		IF(Par_NumAct = Act_EstatusAplicaDepRef)THEN

            SET Aud_FechaActual := NOW();
            UPDATE ARCHIVOCARGADEPREF SET
				AplicarDeposito = Cons_SI,

				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE NumTran = Par_NumTran
				AND FolioCargaID = Par_FolioCargaID;

        END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Actualizacion Realizada Exitosamente: ');
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Par_FolioCargaID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$