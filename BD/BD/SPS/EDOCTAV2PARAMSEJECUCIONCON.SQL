-- SP EDOCTAV2PARAMSEJECUCIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2PARAMSEJECUCIONCON;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2PARAMSEJECUCIONCON (
	-- SP para la consulta de parametros de ejecucion de estado de cuenta
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta
	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)

TerminaStore: BEGIN
	-- Declaracion de variables
		DECLARE Var_NombreInst		VARCHAR(100);	-- Nombre de la institucion

	-- Declaracion de constantes
	DECLARE Var_ConPrincipal	INT(11);		-- Consulta principal
	DECLARE Var_ConForanea		INT(11);		-- Consulta foranea
	DECLARE Var_ConSmarterW		INT(11);		-- Consulta de datos token y URL, SW
	DECLARE Var_ConDatosUEAU	INT(11);		-- Consulta de datos UEAU

	-- Asignacion de constantes
	SET Var_ConPrincipal		:= 1;			-- Consulta principal
	SET Var_ConForanea			:= 2;			-- Consulta foranea
	SET Var_ConSmarterW			:= 3;			-- Consulta de datos token y URL, SW
	SET Var_ConDatosUEAU		:= 4;			-- Consulta de datos UEAU

	-- Consulta principal
	IF Par_NumCon = Var_ConPrincipal THEN
		SELECT	TipoEjecucion		,EjecucionJobPdf		,EjecucionJobTim		,Instrumentos		,FechaEjecucion,	EjecucionSPPrin
			FROM EDOCTAV2PARAMSEJECUCION;
	END IF;

END TerminaStore$$
