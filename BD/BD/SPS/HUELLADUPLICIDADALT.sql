-- SP HUELLADUPLICIDADALT

DELIMITER ;
DROP PROCEDURE IF EXISTS `HUELLADUPLICIDADALT`;

DELIMITER $$
CREATE PROCEDURE `HUELLADUPLICIDADALT` (
# ======================================================================
# ------- STORED PARA DAR DE ALTA LAS HUELLAS CON DUPLICIDAD -----------
# ======================================================================
	Par_HuellasDigital 		JSON,					-- Parámetro tipo json con los datos de las huellas.

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
TerminaStore:BEGIN

	-- DECLARACIÓN DE VARIABLES
	DECLARE Var_Indice				INT(11);		-- Variable indice para recorrer las huellas digitales.
	DECLARE Var_CantidadHuellas 	INT(11);		-- Variable para la la cantidad de huellas a actualizar.
	DECLARE Var_HuellaDigitalID		INT(11);		-- Variable para AutHuellaDigitalID en formato entero.
	DECLARE Var_PIDTarea			VARCHAR(50);	-- Variable para el numero referente a la tarea de la huella.
	DECLARE Var_TipoPersonaEval		CHAR(1);		-- Variable para el tipo de de persona evaluada.

	DECLARE Var_PersonaIDEval		INT(11);		-- Variable para el ID de la persona evaluada en formato entero.
	DECLARE Var_TipoPersonaDup		CHAR(1);		-- Variable para el tipo de de persona con quien se encontró duplicidad.
	DECLARE Var_PersonaIDDup		INT(11);		-- Variable para el ID de la persona duplicada en formato entero.

	-- DECLARACIÓN DE CONSTANTE
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante cadena vacía ''.
	DECLARE	Fecha_Vacia				DATE;			-- Constante fecha vacia 1900-01-01.
	DECLARE	Entero_Cero				INT(11);		-- Constante numero cero (0).
	DECLARE Salida_SI				CHAR(1);		-- Constante afirmativo para salida 'S'.
	DECLARE Salida_NO				CHAR(1);		-- Constante negativo para salida 'N'.

	DECLARE Mail_Repetida	 		INT(11);		-- Constante correo repetido.

	-- ASIGNACIÓN DE CONSTANTES
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET Entero_Cero		:= 0;
	SET Salida_SI		:= 'S';
	SET Salida_NO		:= 'N';

    SET Mail_Repetida	:= 1;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-HUELLADUPLICIDADALT');
		END;

		SET Var_Indice := Entero_Cero;
		SET Var_CantidadHuellas := JSON_LENGTH(Par_HuellasDigital);

		WHILE (Var_Indice < Var_CantidadHuellas) DO

			SET Var_HuellaDigitalID := JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].AutHuellaDigitalID'));
			SET Var_PIDTarea := JSON_UNQUOTE(JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].PIDTarea')));
			SET Var_TipoPersonaEval := JSON_UNQUOTE(JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].TipoPersonaEvaluada')));
			SET Var_PersonaIDEval := JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].PersonaIDEvaluada'));
			SET Var_TipoPersonaDup := JSON_UNQUOTE(JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].TipoPersonaDuplicada')));
			SET Var_PersonaIDDup := JSON_EXTRACT(Par_HuellasDigital, CONCAT('$[', Var_Indice, '].PersonaIDDuplicada'));

			INSERT INTO HUELLADUPLICIDAD (
				PIDTarea,					FechaDeteccion,				HuellaDigitalIDEvaluada,	TipoPersonaEvaluada,		PersonaIDEvaluada,
				TipoPersonaDuplicidad,		PersonaIDDuplicidad,		HuellaUnoEvaluada,			FmdHuellaUnoEvaluada,		DedoHuellaUnoEvaluada,
				HuellaDosEvaluada,			FmdHuellaDosEvaluada,		DedoHuellaDosEvaluada,		EmpresaID,					Usuario,
				FechaActual,				DireccionIP,				ProgramaID,					Sucursal,					NumTransaccion)
			SELECT
				HD.PIDTarea,				NOW(),						HD.AutHuellaDigitalID,		HD.TipoPersona,				HD.PersonaID,
				Var_TipoPersonaDup,			Var_PersonaIDDup,			HD.HuellaUno,				HD.FmdHuellaUno,			HD.DedoHuellaUno,
				HD.HuellaDos,				HD.FmdHuellaDos,			HD.DedoHuellaDos,			Aud_EmpresaID,				Aud_Usuario,
				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion
			FROM HUELLADIGITAL HD
			WHERE HD.AutHuellaDigitalID = Var_HuellaDigitalID
			AND HD.PIDTarea = Var_PIDTarea;

			CALL HUELLADIGITALCORREOPRO (
				Var_HuellaDigitalID,	Var_TipoPersonaEval,	Var_PersonaIDEval,	Mail_Repetida,	Salida_NO,
				Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
			);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_Indice := Var_Indice + 1;
		END WHILE;

		SET Par_NumErr  := 0;
		SET Par_ErrMen  := "Bitacora registrada exitosamente.";

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$