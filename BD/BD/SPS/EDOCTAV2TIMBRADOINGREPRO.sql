DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2TIMBRADOINGREPRO;

DELIMITER $$
CREATE PROCEDURE `EDOCTAV2TIMBRADOINGREPRO` (
	-- SP para llenar los datos para el timbrado de acuerdo a los datos del cliente
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
    DECLARE FECHA_VACIA				DATE;
    DECLARE Var_FolioProceso	BIGINT(20);					-- Folio de procesamiento

    -- Asignacion de Constantes
    SET Entero_Cero			:= 0;		-- Constante Entero Cero
    SET Con_SI				:= 'S';		-- Constante Si
    SET SalidaSI			:= 'S';		-- Salida Si
    SET Act_TimbresExitosos	:= 1;		-- actualizacion encargada de actualuzar los registros que se timbraron exitosamente
    SET EstatusTimExito		:= 2;		-- Estatus de timbrado exitoso
	SET EstatusTimNoProc	:= 1;		-- Estatus de timbres no procesados
	SET FECHA_VACIA			:= '1900-01-01';
	SET Cadena_Vacia		:= '';
	SET Act_TimbresFallidos	:= 2;		-- Actualizacion encargada de actualizar los registros de los timbres que  fallaron al momento de timbrarse
	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		SELECT
			FolioProceso
		INTO
			Var_FolioProceso
		FROM EDOCTAV2PARAMS;

		INSERT INTO EDOCTAV2TIMBRADOINGRE
		(AnioMes,			ClienteID,		SucursalID,			CadenaCFDI,			CFDIFechaEmision,
		CFDIVersion,		CFDINoCertSat,	CFDIUUID,			CFDIFechaTimbrado,	CFDISelloCFD,
		CFDISelloSAT,		CFDICadenaOrig,	DiasPeriodo,		CFDIFechaCertifica,	CFDINoCertEmision,
		CFDILugExpedicion,	CFDITotal,		EstatusTimbrado,	FolioProceso,		CodigoQR,
		EmpresaID,			Usuario,		FechaActual,		DireccionIP,		ProgramaID,
		Sucursal 			,NumTransaccion)

		SELECT
		AnioMes,			ClienteID,		SucursalID,			Cadena_Vacia,		FECHA_VACIA,
		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,		FECHA_VACIA,		Cadena_Vacia,
		Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,		FECHA_VACIA,		Cadena_Vacia,
		Cadena_Vacia,		Entero_Cero,	1,					Var_FolioProceso,	Cadena_Vacia,
		Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion
		FROM EDOCTAV2DATOSCTE;

			SET Par_NumErr	=  0;
			SET Par_ErrMen	= 'Actualizacion exitosa';
			SET Var_Control	= '';

	END ManejoErrores;
	-- fin del manejador de errores.

	IF(Par_Salida = SalidaSI) THEN
	 	SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
                Entero_Cero Consecutivo;
	END IF;

END TerminaStore$$
