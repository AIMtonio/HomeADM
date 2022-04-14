-- EDOCTAV2CARGOSOBJETADOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2CARGOSOBJETADOSPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2CARGOSOBJETADOSPRO`(
	-- SP PARA GENERAR INFORMACION DE CARGOS OBJETADOS PARA EL ESTADO DE CUENTA BIENESTAR
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
	DECLARE Var_AnioMes					INT(11);			-- Variable para obtener el periodo parametrizado
	DECLARE Var_FecIniMes				DATE;				-- Fecha de Fin de mes
	DECLARE Var_FecFinMes				DATE;				-- Fecha de Fin de mes
	DECLARE Var_FolioProceso			BIGINT(20);			-- Folio de procesamiento
	DECLARE Var_Control					VARCHAR(50);		-- Variable para control de excepciones

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);			-- Entero Cero
	DECLARE Entero_Uno					INT(1);				-- Entero Uno
	DECLARE Var_EstEnProceso			CHAR(1);			-- Estatus En Proceso
	DECLARE Var_SI						CHAR(1);			-- Etiquete Si

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Entero_Uno						:= 1;				-- Entero Uno
	SET Var_EstEnProceso				:= 'P';				-- Estatus En Proceso
	SET Var_SI							:= 'S';				-- Etiquete Si

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2CARGOSOBJETADOSPRO');
			SET Var_Control = 'sqlException';
		END;

		-- Se obtiene el periodo con el que se trabajará
		SELECT		MesProceso,			FechaInicio,		FechaFin,			FolioProceso
			INTO	Var_AnioMes,		Var_FecIniMes,		Var_FecFinMes,		Var_FolioProceso
			FROM	EDOCTAV2PARAMS
			LIMIT	Entero_Uno;

		TRUNCATE TABLE EDOCTAV2CAROBJETADOS;

		INSERT INTO EDOCTAV2CAROBJETADOS	(	AnioMes,		SucursalID,		ClienteID,			Instrumento,		FechaIncidencia,
												Descripcion,	MontoObjetado,	CargoObjetadoID,	FolioProceso,		FechaReporte,
												EmpresaID,		Usuario,		FechaActual,		DireccionIP,		ProgramaID,
												Sucursal,		NumTransaccion	)
									SELECT		Var_AnioMes,	SucursalID,		ClienteID,			Instrumento,		CAST(DATE_FORMAT(FechaIncidencia, '%Y-%m-%d') AS CHAR),
												Descripcion,	MontoObjetado,	CargoObjID,	Var_FolioProceso,	CAST(DATE_FORMAT(FechaReporte, '%Y-%m-%d') AS CHAR),
												Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
												Aud_Sucursal,	Aud_NumTransaccion
										FROM	CARGOSOBJETADOS
										WHERE	Estatus = Var_EstEnProceso AND FechaReporte BETWEEN Var_FecIniMes AND Var_FecFinMes;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso de extraccion de Cargos Objetados Ejecutado con Exito';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control;
	END IF;

END TerminaStore$$