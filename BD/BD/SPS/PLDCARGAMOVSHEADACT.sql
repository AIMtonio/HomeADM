-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCARGAMOVSHEADACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCARGAMOVSHEADACT`;
DELIMITER $$


CREATE PROCEDURE `PLDCARGAMOVSHEADACT`(
	-- Procedimiento almacenado creado para actualizar informacion de los archivos contenedores de los movimientos de los clientes externos
	Par_CargaID					BIGINT(20),			-- Identificador de la carga realizada, consiste en la fecha de carga acompañada de la hora realizada, sin los guines
	Par_PIDTarea				VARCHAR(50),		-- Numero referente a la tarea
	Par_Estatus					CHAR(1),			-- Estatus de las cargas
	Par_NombreArchivo			VARCHAR(27),		-- Nombre del archivo de texto cargado
	Par_CheckSum				VARCHAR(50),		-- Check Sum del archivo
	Par_FechaCarga				DATETIME,			-- Fecha en la que se cargaron los archivos
	Par_FechaIni				DATE,				-- Fecha de Inicio de los movimientos cargados
	Par_FechaFin				DATE,				-- Fecha de Fin de los movimientos cargados
	Par_MensajeError			VARCHAR(400),		-- Mensaje de error de las cargas

	Par_NumAct					INT(11),			-- Numero de la actualizacion

	-- Parametros de salida
	Par_Salida					CHAR(1),			-- Parametro indicador de salida
	INOUT Par_NumErr			INT(11),			-- Parametro indicador del numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- Parametro indicador del mensaje de error

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- Parametro de Auditoria
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)

TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);			-- Constante Entero cero
	DECLARE Entero_Uno			INT(11);			-- Constante Entero uno
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante Cadena vacia
	DECLARE Fecha_Vacia	    	DATE;				-- Constante Fecha vacia
	DECLARE SalidaSI			CHAR(1);			-- Constante Indica si se regresa una consulta
	DECLARE Var_EstError		CHAR(1);			-- Variable indicadora del estatus erroneo

	-- Declaracion de variables
	DECLARE Var_CargaID			BIGINT(20);			-- Variable contendora del numero de carga
	DECLARE Var_PIDTarea		VARCHAR(50);		-- Variable contendora del PIDTarea
	DECLARE Var_Estatus			CHAR(1);			-- Variable contendora del estatus del archivo
	DECLARE Var_NombreArchivo	VARCHAR(27);		-- Variable contendora del nombre del archivo
	DECLARE Var_CheckSum		VARCHAR(50);		-- Variable contenedora del checksum
	DECLARE Var_FechaCarga		DATETIME;			-- Variable contenedora de la fecha de carga
	DECLARE Var_FechaIni		DATE;				-- Variable contenedora de la fecha de incio
	DECLARE Var_FechaFin		DATE;				-- Variable contenedora de la fehca de fin
	DECLARE Var_MensajeError	VARCHAR(400);		-- Variable contenedora del mensaje de error
	DECLARE Var_NumAct			INT(11);			-- Variable contenedora del numero de actualizacion
	DECLARE Var_ActualizaEst	INT(11);			-- Variable contenedora del numero indicador para la actualizacion del estatus
	DECLARE Var_Control 		CHAR(15);			-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);			-- Variable consecutiva
	DECLARE Act_EstatusError	INT(11);			-- Actualizacion de estatus de error del archivo procesado

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;				-- Entero cero
	SET Entero_Uno				:= 1;				-- Entero uno
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET SalidaSI				:= 'S';				-- Cadena que indica SI

	-- Asignacion de variables
	SET Var_CargaID				:= IFNULL(Par_CargaID, Entero_Cero);
	SET Var_PIDTarea			:= IFNULL(Par_PIDTarea, Cadena_Vacia);
	SET Var_Estatus				:= IFNULL(Par_Estatus,Cadena_Vacia);
	SET Var_NombreArchivo		:= IFNULL(Par_NombreArchivo,Cadena_Vacia);
	SET Var_CheckSum			:= IFNULL(Par_CheckSum,Cadena_Vacia);
	SET Var_FechaIni			:= IFNULL(Par_FechaIni,Fecha_Vacia);
	SET Var_FechaFin			:= IFNULL(Par_FechaFin,Fecha_Vacia);
	SET Var_MensajeError		:= IFNULL(Par_MensajeError,Cadena_Vacia);
	SET Var_NumAct				:= IFNULL(Par_NumAct,Entero_Cero);
	SET Var_Consecutivo			:= Entero_Cero;
	SET Aud_FechaActual			:= NOW();
	SET Var_ActualizaEst		:= Entero_Uno;
	SET Act_EstatusError		:= 2;
	SET Var_EstError			:= 'E';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr			:= 999;
			SET Par_ErrMen			:= CONCAT('El SAFI ha tenido un problema al concretar la operacion.',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDCARGAMOVSHEADACT');
			SET Var_Control 		:= 'sqlException' ;
		END;

		-- Validaciones del SP
		IF(Var_NumAct = Entero_Cero) THEN
			SET Par_NumErr			:= 001;
			SET Par_ErrMen			:= 'El Numero de Actualizacion esta vacio.';
			SET Var_Control			:= 'NumAct';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_NumAct = Var_ActualizaEst) THEN

			IF (IFNULL(Var_PIDTarea, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr			:= 002;
				SET Par_ErrMen			:= 'El numero de la tarea esta vacio.';
				SET Var_Control			:= 'PIDTarea';
				LEAVE ManejoErrores;
			END IF;

			-- Se crea el query UPDATE para actualizar los datos del historico de los movimientos del cliente cargado
			UPDATE PLDCARGAMOVSHEAD SET
				PIDTarea		=	Var_PIDTarea
			WHERE
				PIDTarea		= Cadena_Vacia
			AND
				Estatus			= Cadena_Vacia;

			SET Par_NumErr				:= 000;
			SET Par_ErrMen				:= CONCAT('La Carga fue actualizada con exito: ', Var_PIDTarea);
			SET Var_Control				:= 'PIDTarea';
			SET Var_Consecutivo			:= Var_PIDTarea;

		END IF;

		-- 2.- Actualizamos el Estatus y MensajeError en la tabla PLDCARGAMOVSHEAD para indicar el error sucedido
		IF(Var_NumAct = Act_EstatusError) THEN
			UPDATE PLDCARGAMOVSHEAD
				SET
					Estatus			= Var_EstError,
					MensajeError	= Var_MensajeError
			WHERE CargaID = Var_CargaID
				AND	PIDTarea = Var_PIDTarea;

			SET Par_NumErr				:= 000;
			SET Par_ErrMen				:= CONCAT('La Carga fue actualizada con exito: ', Var_PIDTarea);
			SET Var_Control				:= 'PIDTarea';
			SET Var_Consecutivo			:= Var_PIDTarea;
		END IF;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$