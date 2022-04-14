DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2TIMBRADOINGREACT;

DELIMITER $$
CREATE PROCEDURE `EDOCTAV2TIMBRADOINGREACT` (
	-- SP para actualizar datos de la tabla EDOCTAV2TIMBRADOINGRE
    Par_NumAct				INT(11),		-- Número de Actualizacion

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

    -- Declaracion de Constantes
    DECLARE Entero_Cero				INT(11);
    DECLARE Cadena_Vacia			CHAR(1);
    DECLARE Con_SI					CHAR(1);
    DECLARE SalidaSI				CHAR(1);
    DECLARE Var_Control				VARCHAR(15);
    DECLARE Act_TimbresExitosos		INT(11);
    DECLARE Act_TimbresFallidos		INT(11);
    DECLARE EstatusTimExito			INT(11);
    DECLARE EstatusTimNoProc		INT(11);

    -- Asignacion de Constantes
    SET Entero_Cero			:= 0;		-- Constante Entero Cero
    SET Con_SI				:= 'S';		-- Constante Si
    SET SalidaSI			:= 'S';		-- Salida Si
    SET Act_TimbresExitosos	:= 1;		-- actualizacion encargada de actualuzar los registros que se timbraron exitosamente
    SET EstatusTimExito		:= 2;		-- Estatus de timbrado exitoso
	SET EstatusTimNoProc	:= 1;		-- Estatus de timbres no procesados
	SET Act_TimbresFallidos	:= 2;		-- Actualizacion encargada de actualizar los registros de los timbres que  fallaron al momento de timbrarse
	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									'esto le ocasiona. Ref: SP-EDOCTAV2TIMBRADOINGREACT');
			SET Var_Control = 'sqlException';
		END;


		IF( Par_NumAct = Act_TimbresExitosos ) THEN
			UPDATE EDOCTAV2TIMBRADOINGRE EDOCTA
			INNER JOIN EDOCTAV2RESPTIMBRE CFDI ON EDOCTA.ClienteID = CFDI.ClienteID AND EDOCTA.AnioMes = CFDI.AnioMes AND CFDI.CodigoRespuestaSW = '000000'
			SET     EDOCTA.CFDIFechaEmision			= CFDI.CFDIFechaEmision
					,EDOCTA.CFDIVersion				= CFDI.CFDIVersion
					,EDOCTA.CFDINoCertSAT			= FNSALTOLINEA(CFDI.CFDINoCertSAT, 90)
					,EDOCTA.CFDIUUID				= FNSALTOLINEA(CFDI.CFDIUUID, 20)
					,EDOCTA.CFDIFechaTimbrado		= CFDI.CFDIFechaTimbrado
					,EDOCTA.CFDISelloCFD			= FNSALTOLINEA(CFDI.CFDISelloCFD, 90)
					,EDOCTA.CFDISelloSAT			= FNSALTOLINEA(CFDI.CFDISelloSAT, 90)
					,EDOCTA.CFDICadenaOrig			=  FNSALTOLINEA(CFDI.CFDICadenaOrig, 90)
					,EDOCTA.CFDIFechaCertifica		= CFDI.CFDIFechaEmision
					,EDOCTA.CFDINoCertEmisor		= CFDI.CFDINoCertEmisor
					,EDOCTA.CFDILugExpedicion		= CFDI.CFDILugExpedicion
					,EDOCTA.Estatus = EstatusTimExito  --  estatus de Timbrqdo con Exito
			WHERE EDOCTA.Estatus = EstatusTimNoProc;

			SET Par_NumErr	=  0;
			SET Par_ErrMen	= 'Actualizacion exitosa';
			SET Var_Control	= '';
		END IF;

		IF( Par_NumAct = Act_TimbresFallidos ) THEN

			UPDATE EDOCTAV2TIMBRADOINGRE EDOCTA
			INNER JOIN EDOCTAV2RESPTIMBRE CFDI ON EDOCTA.ClienteID = CFDI.ClienteID AND EDOCTA.AnioMes = CFDI.AnioMes AND CFDI.CodigoRespuestaSW <> '000000'
			SET EDOCTA.Estatus = 3                               --  estatus de Timbrqdo con Error
			WHERE EDOCTA.Estatus = EstatusTimNoProc;

			SET Par_NumErr	=  0;
			SET Par_ErrMen	= 'Actualizacion exitosa';
			SET Var_Control	= '';
		END IF;

	END ManejoErrores;
	-- fin del manejador de errores.

	IF(Par_Salida = SalidaSI) THEN
	 	SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
                Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$
