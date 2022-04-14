-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISEVALUACTEMATRIZALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISEVALUACTEMATRIZALT`;DELIMITER $$

CREATE PROCEDURE `HISEVALUACTEMATRIZALT`(
/* SP DE ALTA EN EL HISTORICO EVALUACIÓN MATRIZ PERIODICA */
	Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT,			-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),

	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control     	CHAR(15);
DECLARE	Var_Consecutivo 	INT(11);
DECLARE	Var_FechaSistema	DATE;

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISEVALUACTEMATRIZALT');
			SET Var_Control:= 'sqlException' ;
		END;

	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID = Aud_EmpresaID);

	IF EXISTS(SELECT FechaEvaluacionMatriz FROM HISEVALUACTEMATRIZ WHERE FechaEvaluacionMatriz = Var_FechaSistema) THEN
		DELETE FROM HISEVALUACTEMATRIZ
			WHERE FechaEvaluacionMatriz = Var_FechaSistema;
	END IF;

	-- SE GUARDA EN EL HISTÓRICO LA EVALUACIÓN ANTERIOR.
	INSERT INTO HISEVALUACTEMATRIZ(
    	FechaEvaluacionMatriz,	ClienteID,				Nacionalidad,			PepNacional,			PepExtr,
    	Actividad,				Localidad,				OperInusual,			OperRelevan,			PaisNacimiento,
    	PaisResidencia,			PuntajeObt,   			Porcentaje,				NivelRiesgo,			PorcentajeAnterior,
    	NivelRiesgoAnterior,	PermiteReactivacion,	TipoPersona,			EmpresaID,				Usuario,
		FechaActual,			DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
	SELECT
    	FechaEvaluacionMatriz,	ClienteID,				Nacionalidad,			PepNacional,			PepExtr,
    	Actividad,				Localidad,				OperInusual,			OperRelevan,			PaisNacimiento,
    	PaisResidencia,			PuntajeObt,   			Porcentaje,				NivelRiesgo,			PorcentajeAnterior,
    	NivelRiesgoAnterior,	PermiteReactivacion,	TipoPersona,			EmpresaID,				Usuario,
		FechaActual,			DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion
	  FROM EVALUACIONCTEMATRIZ;

	-- SE LIMPIA TABLA DE EVALUACIÓN.
	TRUNCATE EVALUACIONCTEMATRIZ;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Evaluacion Guardada Exitosamente en el Historico.';
	SET Var_Control:= 'clienteID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$