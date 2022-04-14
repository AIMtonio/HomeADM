-- HUELLADIGITALTARACT

DELIMITER ;
DROP PROCEDURE IF EXISTS `HUELLADIGITALTARACT`;

DELIMITER $$
CREATE PROCEDURE `HUELLADIGITALTARACT`(
# ======================================================================
# ------- STORED PARA ACTUALIZACION DE HUELLA DIGITAL ---------
# ======================================================================
	Par_HuellasDigital 		JSON,					-- Parámetro tipo json con los datos de las huellas a actualizar.
	Par_PIDTarea			VARCHAR(50),			-- Parámetro numero referente a la tarea.
	Par_NumAct				TINYINT UNSIGNED,		-- Parámetro numero de actualizacion.

	Par_Salida          	CHAR(1),				-- Parámetro de salida S=si, N=no.
    INOUT Par_NumErr    	INT(11),				-- Parámetro de salida número de error.
    INOUT Par_ErrMen    	VARCHAR(400),			-- Parámetro de salida mensaje de error.

    Aud_EmpresaID         	INT(11),				-- Parámetro de auditoría ID de la empresa.
	Aud_Usuario         	INT(11),				-- Parámetro de auditoría ID del usuario.
	Aud_FechaActual     	DATETIME,				-- Parámetro de auditoría fecha actual.
	Aud_DireccionIP     	VARCHAR(15),			-- Parámetro de auditoría direccion IP.
	Aud_ProgramaID      	VARCHAR(50),			-- Parámetro de auditoría programa.
	Aud_Sucursal        	INT(11),				-- Parámetro de auditoría ID de la sucursal.
	Aud_NumTransaccion  	BIGINT(20)				-- Parámetro de auditoría numero de transaccion.
)
TerminaStore: BEGIN

	-- DECLARACIÓN DE VARIBLES
	DECLARE Var_Control          	VARCHAR(50);	-- Variable para control de errores.
	DECLARE Var_Indice				INT(11);		-- Variable indice para recorrer las huellas digitales.
	DECLARE Var_CantidadHuellas 	INT(11);		-- Variable para la la cantidad de huellas a actualizar.
	DECLARE Var_HuellaDigitalID		INT(11);		-- Variable para AutHuellaDigitalID.
	DECLARE Var_PIDTarea			VARCHAR(50);	-- Variable para el numero referente a la tarea de la huella.

	DECLARE Var_TipoPersona			CHAR(1);		-- Variable para el tipo de de persona al que pertence la huella.
	DECLARE Var_PersonaID			INT(11);		-- Variable para el ID de la persona.

	-- DECLARACIÓN DE CONSTANTES
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante cadena vacia ''.
	DECLARE	Fecha_Vacia				DATE;			-- Constante fecha vacia 1900-01-01.
	DECLARE	Entero_Cero				INT(11);		-- Constante numero cero (0).
	DECLARE Salida_SI				CHAR(1);		-- Constante afirmativo para salida 'S'.
	DECLARE Salida_NO				CHAR(1);		-- Constante negativo para salida 'N'.

	DECLARE Estatus_Registrado		CHAR(1);		-- Constante estatus registrado 'R'.
	DECLARE Estatus_EnProceso		CHAR(1);		-- Constante estatus en proceso 'P'.
	DECLARE Estatus_Autorizada		CHAR(1);		-- Constante estatus autorizada 'A'.
	DECLARE Estatus_Repetida		CHAR(1);		-- Constante estatus repetida 'R'.
	DECLARE Mail_Autorizada 		INT(11);		-- Constante correo autorizado.

	DECLARE Act_PIDTarea			INT(11);		-- Constante actualizacion PIDTarea de huellas aun no procesadas.
	DECLARE Act_HuellaAutorizada 	INT(11);		-- Consatnte actualizacion de huella como autorizarla.
	DECLARE Act_HuellaRepetida 		INT(11);		-- Constante actualizacion de huella como repetida.
	DECLARE Act_PIDTareaVacia		INT(11);		-- Constante actualizacion borrar PIDTarea de huellas en proceso.

	-- ASIGNACIÓN DE CONSTANTES
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET Salida_SI				:= "S";
	SET Salida_NO				:= "N";

	SET Estatus_Registrado		:= 'V';
	SET Estatus_EnProceso		:= 'P';
	SET Estatus_Autorizada		:= 'A';
	SET Estatus_Repetida		:= 'R';
	SET Mail_Autorizada			:= 2;

	SET Act_PIDTarea			:= 1;
	SET Act_HuellaAutorizada 	:= 2;
	SET Act_HuellaRepetida 		:= 3;
	SET Act_PIDTareaVacia 		:= 4;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-HUELLADIGITALTARACT');
			SET Var_Control = 'sqlException';
		END;

		-- 1.- Actualización de PIDTarea y estatus de huellas a comparar.
		IF (Par_NumAct = Act_PIDTarea) THEN

			IF(Par_PIDTarea = Cadena_Vacia) THEN
				SET Par_NumErr 	:= 507;
				SET Par_ErrMen	:= CONCAT('El PIDTarea se encuentra vacio');
				LEAVE ManejoErrores;
			END IF;

			UPDATE HUELLADIGITAL
			SET PIDTarea		= Par_PIDTarea,
				Estatus 		= Estatus_EnProceso,
				EmpresaID		= Aud_EmpresaID,
				FechaActual		= Aud_FechaActual,
				ProgramaID		= Aud_ProgramaID,
				NumTransaccion	= Aud_NumTransaccion
			WHERE Estatus = Estatus_Registrado
			AND PIDTarea = Cadena_Vacia LIMIT 10;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := 'Huella Actualizada Exitosamente.';
			SET Var_Control  := 'personaID';
			LEAVE ManejoErrores;

		END IF;

		-- 2.- Actualización de huellas como autorizada por no haber encontrado coincidencias.
		IF (Par_NumAct = Act_HuellaAutorizada) THEN

			SET Var_Indice := Entero_Cero;
			SET Var_CantidadHuellas := JSON_LENGTH(Par_HuellasDigital);

			WHILE (Var_Indice < Var_CantidadHuellas) DO

				SET Var_HuellaDigitalID := JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].AutHuellaDigitalID'));
				SET Var_PIDTarea := JSON_UNQUOTE(JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].PIDTarea')));

				IF(IFNULL(Var_PIDTarea, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr 	:= 507;
					SET Par_ErrMen	:= CONCAT('El PIDTarea de la huella digital numero ', Var_HuellaDigitalID, ' se encuentra vacio');
					LEAVE ManejoErrores;
				END IF;

				UPDATE HUELLADIGITAL
				SET Estatus			= Estatus_Autorizada,
					EmpresaID		= Aud_EmpresaID,
					FechaActual		= Aud_FechaActual,
					ProgramaID		= Aud_ProgramaID,
					NumTransaccion	= Aud_NumTransaccion
				WHERE AutHuellaDigitalID = Var_HuellaDigitalID
				AND Estatus = Estatus_EnProceso
				AND PIDTarea = Var_PIDTarea;

				SET Var_TipoPersona := JSON_UNQUOTE(JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].TipoPersona')));
				SET Var_PersonaID := JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].PersonaID'));

				CALL HUELLADIGITALCORREOPRO (
					Var_HuellaDigitalID,	Var_TipoPersona,	Var_PersonaID,	Mail_Autorizada,	Salida_NO,
					Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
				);

				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				SET Var_Indice := Var_Indice + 1;
			END WHILE;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := 'Huella Actualizada Exitosamente.';
			SET Var_Control  := 'personaID' ;
			LEAVE ManejoErrores;
		END IF;

		-- 3.- Actualización de huellas como repetido por haber encontrado coincidencia con otra huella previamente registrada
		IF (Par_NumAct = Act_HuellaRepetida) THEN

			SET Var_Indice := Entero_Cero;
			SET Var_CantidadHuellas := JSON_LENGTH(Par_HuellasDigital);

			WHILE (Var_Indice < Var_CantidadHuellas) DO

				SET Var_HuellaDigitalID := JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].AutHuellaDigitalID'));
				SET Var_PIDTarea := JSON_UNQUOTE(JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].PIDTarea')));

				IF(IFNULL(Var_PIDTarea, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr 	:= 507;
					SET Par_ErrMen	:= CONCAT('El PIDTarea de la huella digital numero ', Var_HuellaDigitalID, ' se encuentra vacio');
					LEAVE ManejoErrores;
				END IF;

				UPDATE HUELLADIGITAL
				SET Estatus			= Estatus_Repetida,
					HuellaUno		= Cadena_Vacia,
					FmdHuellaUno 	= Cadena_Vacia,
					DedoHuellaUno 	= Cadena_Vacia,
					HuellaDos 		= Cadena_Vacia,
					FmdHuellaDos 	= Cadena_Vacia,
					DedoHuellaDos 	= Cadena_Vacia,
					EmpresaID		= Aud_EmpresaID,
					FechaActual		= Aud_FechaActual,
					ProgramaID		= Aud_ProgramaID,
					NumTransaccion	= Aud_NumTransaccion
				WHERE AutHuellaDigitalID = Var_HuellaDigitalID
				AND Estatus = Estatus_EnProceso
				AND PIDTarea = Var_PIDTarea;

				SET Var_Indice := Var_Indice + 1;
			END WHILE;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := 'Huella Actualizada Exitosamente.';
			SET Var_Control  := 'personaID' ;
			LEAVE ManejoErrores;
		END IF;

		-- 4.- Actualización borrar PIDTarea de huellas en proceso
		-- se manda a llamar en el SP BITACORAHUELLAPROCESOPRO
		IF (Par_NumAct = Act_PIDTareaVacia) THEN

			UPDATE HUELLADIGITAL
				SET Estatus			= Estatus_Registrado,
					PIDTarea 		= Cadena_Vacia,
					EmpresaID		= Aud_EmpresaID,
					FechaActual		= Aud_FechaActual,
					ProgramaID		= Aud_ProgramaID,
					NumTransaccion	= Aud_NumTransaccion
			WHERE Estatus = Estatus_EnProceso
			AND PIDTarea <> Cadena_Vacia;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := 'Huella Actualizada Exitosamente.';
			SET Var_Control  := 'personaID' ;
			LEAVE ManejoErrores;

		END IF;

		-- Actualiza a "A" y "" todos los que tengan estatus proceso y PID <> VACIO

		SET Par_NumErr  := 901;
		SET Par_ErrMen  := 'Tipo de Actualizacion No Soportada.';
		SET Var_Control := 'personaID' ;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$