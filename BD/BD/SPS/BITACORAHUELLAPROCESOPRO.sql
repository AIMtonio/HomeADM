-- BITACORAHUELLAPROCESOPRO

DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAHUELLAPROCESOPRO`;

DELIMITER $$
CREATE PROCEDURE `BITACORAHUELLAPROCESOPRO` (
	-- SP DE PROCESO PARA LA BITACORA DE VALIDACIÓN DE HUELLA DIGITAL.
	Par_TipoProceso			TINYINT UNSIGNED,	-- Parámetro que indica el tipo de proceso a realizar.
	Par_PIDTarea			VARCHAR(50), 		-- Parámetro identificador del hilo de ejecucion de la tarea.
	Par_HuellasNuevas		INT(11), 			-- Parámetro cantidad de huella nuevas.
	Par_HuellasSAFI			INT(11), 			-- Parámetro cantidad de huellas existentes en SAFI.
	Par_HuellasRepetidas	INT(11), 			-- Parámetro cantidad de huellas que fueron detectadas como repetidas.
	Par_HuellasAutorizadas	INT(11), 			-- Parámetro cantidad de huellas que fueron autorizadas.

	Par_Salida          	CHAR(1),			-- Parámetro de salida S=si, N=no.
    INOUT Par_NumErr    	INT(11),			-- Parámetro de salida número de error.
    INOUT Par_ErrMen    	VARCHAR(400),		-- Parámetro de salida mensaje de error.

	Aud_EmpresaID         	INT(11),			-- Parámetro de auditoría ID de la empresa.
	Aud_Usuario         	INT(11),			-- Parámetro de auditoría ID del usuario.
	Aud_FechaActual     	DATETIME,			-- Parámetro de auditoría fecha actual.
	Aud_DireccionIP     	VARCHAR(15),		-- Parámetro de auditoría direccion IP.
	Aud_ProgramaID      	VARCHAR(50),		-- Parámetro de auditoría ID del programa.
	Aud_Sucursal        	INT(11),			-- Parámetro de auditoría ID de la sucursal.
	Aud_NumTransaccion  	BIGINT(20)			-- Parámetro de auditoría numero de transaccion.
)TerminaStore:BEGIN

	-- Declaración de variables
	DECLARE Var_RegistroExiste 	INT(11);		-- Variable para almacenar la cantidad de registros.
	DECLARE Var_FechaActual	   	DATETIME;		-- Variable para almacenar la fecha actual del sistema.

	-- Declaración de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante cadena vacia ''.
	DECLARE	Fecha_Vacia			DATE;			-- Constante fecha vacia 1900-01-01.
	DECLARE	Entero_Cero			INT(11);		-- Constante numero cero (0).
	DECLARE	Salida_SI			CHAR(1);		-- Constante afirmativo para salida 'S'.
	DECLARE	Salida_NO			CHAR(1);		-- Constante negativo para salida 'N'.

	DECLARE	Est_Proceso			CHAR(1);		-- Constante estatus en proceso 'P'.
	DECLARE	Est_Terminado		CHAR(1);		-- Constante estatus terminado 'T'.
	DECLARE	Est_Error			CHAR(1);		-- Constante estatus error 'E'.
	DECLARE Pro_Inicio 			INT(11);		-- Constante proceso tipo inicio (1).
	DECLARE Pro_Fin 			INT(11);		-- Constante proceso tipo fin (2).

	DECLARE Pro_Error 			INT(11);		-- Constante proceso tipo error (3).
	DECLARE Act_PIDTarea		INT(11);		-- Constante actualizacion asignar PIDTarea.
	DECLARE Act_PIDTareaVacia 	INT(11);		-- Constante actualizacion vaciar PIDTarea.
	DECLARE Json_Vacio			VARCHAR(4);		-- Constante JSON vacio '[{}]'.

	-- Asignación de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';

	SET Est_Proceso			:= 'P';
	SET Est_Terminado		:= 'T';
	SET Est_Error			:= 'E';
	SET Pro_Inicio			:= 1;
	SET Pro_Fin 			:= 2;

	SET Pro_Error 			:= 3;
	SET Act_PIDTarea		:= 1;
	SET Act_PIDTareaVacia	:= 4;
	SET Json_Vacio			:= '[{}]';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-BITACORAHUELLAPROCESOPRO');
		END;

		SET Var_FechaActual := CONCAT((SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1),' ',TIME(NOW()));

		IF (Par_TipoProceso = Pro_Inicio) THEN

			SET Var_RegistroExiste := 	(SELECT COUNT(AutRegistroID)
										FROM BITACORAHUELLAPROCESO Bta
										INNER JOIN HUELLADIGITAL Hue ON Hue.Estatus = Est_Proceso
										WHERE Bta.Estatus = Est_Proceso);

			SET Var_RegistroExiste := IFNULL(Var_RegistroExiste, Entero_Cero);

			IF (Var_RegistroExiste > Entero_Cero) THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := "Existe un Proceso actualmente de validacion de Huellas Repetidas";
				LEAVE ManejoErrores;
			ELSE

				UPDATE BITACORAHUELLAPROCESO Bta
					SET Bta.Estatus = Est_Terminado
				WHERE Bta.Estatus = Est_Proceso;

			END IF;

			CALL HUELLADIGITALTARACT (
				Json_Vacio,			Cadena_Vacia,		Act_PIDTareaVacia,	Salida_NO,			Par_NumErr,
				Par_ErrMen, 		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL HUELLADIGITALTARACT (
				Json_Vacio,			Par_PIDTarea,		Act_PIDTarea,		Salida_NO,			Par_NumErr,
				Par_ErrMen, 		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_RegistroExiste := (SELECT COUNT(AutHuellaDigitalID) FROM HUELLADIGITAL WHERE PIDTarea = Par_PIDTarea);

			IF (IFNULL(Var_RegistroExiste, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr  := 4;
				SET Par_ErrMen  := "No hay huellas nuevas para comparar.";
				LEAVE ManejoErrores;
			END IF;

			SET @Var_NumHuellas := Entero_Cero;
			SET @Var_RegPorPagina := Entero_Cero;
			SET @Var_NumPaginas := Entero_Cero;

			CALL PAGINACIONHUELLAPRO (
				@Var_NumHuellas,	@Var_RegPorPagina,	@Var_NumPaginas,	Salida_NO,			Par_NumErr,
				Par_ErrMen,			Aud_EmpresaID, 		Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP,
				Aud_ProgramaID, 	Aud_Sucursal, 		Aud_NumTransaccion
			);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			INSERT INTO BITACORAHUELLAPROCESO (
				PIDTarea,				FechaInicio,			Estatus,		HuellasNuevas,		HuellasSAFI,
				HuellasRepetidas,		HuellasAutorizadas,		FechaFin,		EmpresaID,			Usuario,
				FechaActual,			DireccionIP,			ProgramaID,		Sucursal,			NumTransaccion
			) VALUES (
				Par_PIDTarea,			Var_FechaActual,		Est_Proceso,	Par_HuellasNuevas,	Par_HuellasSAFI,
				Par_HuellasRepetidas,	Par_HuellasAutorizadas,	Fecha_Vacia,	Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
			);

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := "Bitacora registrada exitosamente.";
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoProceso = Pro_Fin) THEN

			SET Var_RegistroExiste :=(SELECT COUNT(AutRegistroID) FROM BITACORAHUELLAPROCESO
									WHERE Estatus = Est_Proceso AND PIDTarea = Par_PIDTarea);

			IF Var_RegistroExiste = Entero_Cero THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := CONCAT("No Existe un Proceso con el PID ",Par_PIDTarea);
				LEAVE ManejoErrores;
			END IF;

			UPDATE BITACORAHUELLAPROCESO
			SET Estatus 			= Est_Terminado,
				FechaFin 			= Var_FechaActual,
				HuellasNuevas 		= Par_HuellasNuevas,
				HuellasSAFI   		= Par_HuellasSAFI,
				HuellasRepetidas 	= Par_HuellasRepetidas,
				HuellasAutorizadas  = Par_HuellasAutorizadas,
				FechaActual 		= NOW()
			WHERE PIDTarea = Par_PIDTarea;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := "Bitacora actualziada exitosamente.";
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoProceso = Pro_Error) THEN

			SET Var_RegistroExiste :=(SELECT COUNT(AutRegistroID) FROM BITACORAHUELLAPROCESO
									WHERE Estatus = Est_Proceso AND PIDTarea = Par_PIDTarea );

			IF Var_RegistroExiste = Entero_Cero THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := CONCAT("No Existe un Proceso con el PID ",Par_PIDTarea);
				LEAVE ManejoErrores;
			END IF;

			UPDATE BITACORAHUELLAPROCESO
				SET Estatus 			= Est_Error,
					FechaFin 			= Var_FechaActual,
					HuellasNuevas 		= Par_HuellasNuevas,
					HuellasSAFI   		= Par_HuellasSAFI,
					HuellasRepetidas 	= Par_HuellasRepetidas,
					HuellasAutorizadas  = Par_HuellasAutorizadas,
					FechaActual 		= NOW()
			WHERE PIDTarea = Par_PIDTarea;

			CALL HUELLADIGITALTARACT (
				Json_Vacio,		Cadena_Vacia,	Act_PIDTareaVacia,	Salida_NO,			Par_NumErr,
				Par_ErrMen, 	Aud_EmpresaID, 	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
			);

			IF Par_NumErr <> Entero_Cero THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := "Bitacora actualizada exitosamente.";
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr  := 901;
		SET Par_ErrMen  := "Proceso no soportado";

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 			AS NumErr,
				Par_ErrMen 			AS ErrMen,
				@Var_NumHuellas		AS NumeroHuellas,
				@Var_RegPorPagina	AS RegPorPagina,
				@Var_NumPaginas		AS NumeroPaginas;
	END IF;

END TerminaStore$$