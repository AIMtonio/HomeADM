-- EDOCTAV2PARAMSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2PARAMSPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2PARAMSPRO`(
	-- SP PRINCIPAL QUE LLAMA A LOS PROCESOS DE EXTRACCION PARA EL ESTADO DE CUENTA BIENESTAR
	Par_Salida							CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr					INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen					VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	Par_EmpresaID 						INT(11),			-- Parametros de auditoria
	Aud_Usuario							INT(11),			-- Parametros de auditoria
	Aud_FechaActual						DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP						VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID						VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal						INT(11), 			-- Parametros de auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Parametros de auditoria
)

TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Control					VARCHAR(50);		-- Variable para control de excepciones
	DECLARE Var_FechaInicio				DATE;				-- Variable para guardar la fecha de inicio del periodo
	DECLARE Var_FechaFin				DATE;				-- Variable para guardar la fecha final del periodo
	DECLARE Var_FolioProceso			INT(11);			-- Variable para guardar el folio de proceso a guardar en la tabla de parametros
	DECLARE Var_ClienteInstit			INT(11);			-- Identificador del cliente que representa a la institucion

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);			-- Entero Cero
	DECLARE Entero_Uno					INT(1);				-- Entero Uno
	DECLARE Var_SI						CHAR(1);			-- Etiquete Si
	DECLARE Var_AnioMes					INT(11);
	DECLARE Var_FechaActualSis			DATE;				-- Fecha Actual del sistema
	DECLARE Var_FechaAntSis				DATE;				-- Fecha del mes anterior

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Entero_Uno						:= 1;				-- Entero Uno
	SET Var_SI							:= 'S';				-- Etiquete Si

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2PARAMSPRO');
			SET Var_Control = 'sqlException';
		END;

		SELECT  FechaSistema INTO Var_FechaActualSis FROM PARAMETROSSIS;

		SET Var_FechaAntSis	= DATE_ADD(Var_FechaActualSis, INTERVAL -1 MONTH);
		SET Var_AnioMes =	CAST(CONCAT(YEAR(Var_FechaAntSis),RIGHT(CONCAT('00',CAST(MONTH(Var_FechaAntSis) AS CHAR)),2)) AS UNSIGNED);

		SELECT		FolioProceso
			INTO	Var_FolioProceso
			FROM	EDOCTAV2PARAMS;

		SET Var_FolioProceso	:= IFNULL(Var_FolioProceso, Entero_Cero);

		SET Var_FolioProceso	:= Var_FolioProceso + Entero_Uno;

		SELECT		CAST(CONCAT(LEFT(CAST(Var_AnioMes AS CHAR), 4), '-', RIGHT(CAST(Var_AnioMes AS CHAR), 2), '-01') AS DATE)
			INTO	Var_FechaInicio;

		SELECT		LAST_DAY(Var_FechaInicio)
			INTO	Var_FechaFin;

		SELECT		ClienteInstitucion
			INTO	Var_ClienteInstit
			FROM	PARAMETROSSIS;

		UPDATE EDOCTAV2PARAMS SET
			ClienteInstitucion	= Var_ClienteInstit,
			MesProceso			= Var_AnioMes,
			FechaInicio			= Var_FechaInicio,
			FechaFin			= Var_FechaFin,
			FolioProceso		= Var_FolioProceso,
			InstitucionID		= Var_ClienteInstit,
			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Actualizacion de Parametros del Estado de Cuenta Ejecutada con Exito';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control;
	END IF;

END TerminaStore$$
