-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMREGULATORIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMREGULATORIOSCON`;

DELIMITER $$
CREATE PROCEDURE `PARAMREGULATORIOSCON`(
	-- ---------------------------------------------------------------------------------
	-- Consulta los parametros para la pantalla de regulatorios
	-- ---------------------------------------------------------------------------------
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de consulta
	Par_Anio			INT,				-- Anio de Consulta
	Par_Mes				INT,				-- Mes de Consulta
	Par_EmpresaID		INT, 				-- Auditoria

	Aud_Usuario			INT, 				-- Auditoria
	Aud_FechaActual		DATETIME, 			-- Auditoria
	Aud_DireccionIP		VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID		VARCHAR(50), 		-- Auditoria
	Aud_Sucursal		INT, 				-- Auditoria
	Aud_NumTransaccion	BIGINT 				-- Auditoria

	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_ClaveEntidad  	VARCHAR(10); 	-- Clave de La entidad
	DECLARE Var_CuentaEprc    	VARCHAR(18); 	-- Cuenta estimaciones preventivas
	DECLARE Var_TipoRegula    	VARCHAR(4); 	-- Tipo de regulatorios
	DECLARE Var_NivelEntidad  	VARCHAR(4); 	-- Nivel de la Entidad
	DECLARE Var_NivelOperacion  INT; 			-- Nivel de Operaciones
	DECLARE Var_NivelPrudencual INT; 			-- Nivel Prudencial

	-- Declaracion de costantes
	DECLARE Registro_ID			INT;			-- ID del Registro de Parametros
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE	Fecha_Vacia			DATE; 			-- Fecha Vacia
	DECLARE	Entero_Cero			INT; 			-- Entero Cero
	DECLARE	Con_Principal		INT;  			-- Consulta principal
	DECLARE	Con_Historica		INT;  			-- Consulta historica

	-- Seteo de constentes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Con_Principal	:= 1;
	SET	Con_Historica	:= 2;
	SET Registro_ID		:= 1;

	-- Consulta Principal
	IF(Par_NumCon = Con_Principal) THEN

		SELECT 	ClaveEntidad,				CuentaEPRC,				TipoRegulatorios,	NivelOperaciones, 	NivelPrudencial,
				ClaveFederacion,			MuestraRegistros, 		MostrarComoOtros,	IntCredVencidos,	AjusteSaldo,
				CuentaContableAjusteSaldo,	MostrarSucursalOrigen,	ContarEmpleados,	TipoRepActEco,		AjusteResPreventiva,
				AjusteCargoAbono,			AjusteRFCMenor
		FROM PARAMREGULATORIOS
		WHERE ParametrosID = Registro_ID;

	END IF;

	-- Consulta Historica
	IF(Par_NumCon = Con_Historica) THEN

		SELECT  IFNULL( CONCAT(Anio,CASE WHEN Mes < 10 THEN CONCAT(Entero_Cero,Mes) ELSE Mes END),NULL) AS FechaConsulta
		FROM `HIS-CATALOGOMINIMO`
		WHERE Anio = Par_Anio AND Mes = Par_Mes
		LIMIT 1;

	END IF;

END TerminaStore$$