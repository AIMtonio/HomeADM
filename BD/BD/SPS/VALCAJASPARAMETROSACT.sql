-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALCAJASPARAMETROSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALCAJASPARAMETROSACT`;
DELIMITER $$

CREATE PROCEDURE `VALCAJASPARAMETROSACT`(
# ==============================================================
# ----------- SP PARA ACTUALIZAR LOS VALCAJASPARAMETROSACT---------------
# ==============================================================
	Par_ValCajaParamID		INT(11),			-- Llave primaria tabla VALCAJASPARAMETROS
	Par_HoraInicio			VARCHAR(5),			-- Horario en el que iniciará el proceso automático
	Par_NumEjecuciones		TINYINT(2),			-- Número de veces que se ejecutará el proceso
	Par_Intervalo			TINYINT(2),			-- Intervalo de tiempo entre cada ejecución
	Par_RemitenteID			INT(11),			-- ID del usuario remitente
	Par_Cron				VARCHAR(50),		-- Expresión de cron
	Par_NumAct				TINYINT UNSIGNED,	-- Numero de actualización

	Par_Salida				CHAR(1),			-- Parametro de SALIDA S: SI N: No
	INOUT Par_NumErr		INT(11),			-- Parametro de SALIDA numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de SALIDA Mensaje de error

	Par_EmpresaID			INT(11),			-- Parámetro de Auditoría
	Aud_Usuario				INT(11),			-- Parámetro de Auditoría
	Aud_FechaActual			DATETIME,			-- Parámetro de Auditoría
	Aud_DireccionIP			VARCHAR(15),		-- Parámetro de Auditoría
	Aud_ProgramaID			VARCHAR(50),		-- Parámetro de Auditoría
	Aud_Sucursal			INT(11),			-- Parámetro de Auditoría
	Aud_NumTransaccion		BIGINT(20)			-- Parámetro de Auditoría
)

TerminaStore: BEGIN

	-- DECLARACIÓN DE CONSTANTES
	DECLARE Salida_SI 			CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE Cadena_Vacia		VARCHAR(1);
	DECLARE ActPrincipal		INT(1);
	DECLARE ActRemitente		INT(1);
	DECLARE Var_TareaID			INT(11);

	-- DECLARACIÓN DE VARIABLES
	DECLARE Var_Control 			CHAR(15);		-- Almacena el elemento que es incorrecto

	-- ASIGNACIÓN DE CONSTANTES
	SET Salida_SI				:= 'S';			-- Constante Si
	SET Cadena_Vacia			:= '';			-- STRING vacía
	SET Entero_Cero				:= 0;			-- Constante Cero
	SET ActPrincipal			:= 1;			-- Número de actualización principal
	SET ActRemitente			:= 2;			-- Número de actualización para el remitente
	SET Var_TareaID				:= 10;			-- ID de la validación de cajas y transferencias, DEMTAREA

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:=	999;
			SET Par_ErrMen	:=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: VALCAJASPARAMETROSACT');
		END;

		IF(Par_NumAct = ActPrincipal) THEN
			IF(IFNULL(Par_HoraInicio, Cadena_Vacia)) = Entero_Cero THEN
				SET Par_NumErr := 02;
				SET Par_ErrMen := 'El Número de Horas está Vacío';
				SET Var_Control := 'horaInicio';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumEjecuciones, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 02;
				SET Par_ErrMen := 'El Número de Ejecuciones está Vacío';
				SET Var_Control := 'numEjecuciones';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Intervalo, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 03;
				SET Par_ErrMen := 'El Número de Intervalo está Vacío';
				SET Var_Control := 'intervalo';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_NumAct = ActRemitente) THEN
			IF(IFNULL(Par_RemitenteID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 04;
				SET Par_ErrMen := 'El ID del Remitente está Vacío';
				SET Var_Control := 'remitenteID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_NumAct = ActPrincipal) THEN

			UPDATE VALCAJASPARAMETROS SET
				HoraInicio		= Par_HoraInicio,
				NumEjecuciones	= Par_NumEjecuciones,
				Intervalo		= Par_Intervalo,

				EmpresaID 		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE ValCajaParamID = Par_ValCajaParamID;

			UPDATE DEMTAREA SET
				CronEjecucion	= Par_Cron,

				EmpresaID 		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE TareaID = Var_TareaID;

		END IF;

		IF(Par_NumAct = ActRemitente) THEN
			UPDATE VALCAJASPARAMETROS SET
				RemitenteID		= Par_RemitenteID,

				EmpresaID 		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE ValCajaParamID = Par_ValCajaParamID;
		END IF;

		SET	Par_NumErr 	:= Entero_Cero;
		SET	Par_ErrMen 	:= 'Configuración Guardada Exitosamente';
		SET Var_Control	:= 'horaInicio' ;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$