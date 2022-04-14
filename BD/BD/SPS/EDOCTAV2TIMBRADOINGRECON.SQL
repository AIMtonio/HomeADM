-- SP EDOCTAV2TIMBRADOINGRE
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2TIMBRADOINGRECON;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2TIMBRADOINGRECON (
	-- SP para la consulta de parametros de estado de cuenta
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
	DECLARE CadenaVacia			CHAR(1);
	DECLARE EnteroUno			INT(11);

	-- Asignacion de constantes
	SET CadenaVacia				:='';
	SET Var_ConPrincipal		:= 1;			-- Consulta que devuelve los registros  de los clientes que no se han timbrado
	SET EnteroUno				:= 1;


	-- Consulta principal
	IF Par_NumCon = Var_ConPrincipal THEN
		SELECT	TimIng.AnioMes, 	TimIng.ClienteID,			TimIng.SucursalID,		Cte.RFC,	TimIng.CadenaCFDI, 
		Param.URLWSHub, 		    Param.CredencialesHub,		 Param.TokenWS
		FROM EDOCTAV2DATOSCTE Cte
		INNER JOIN EDOCTAV2TIMBRADOINGRE TimIng ON Cte.ClienteID = TimIng.ClienteID AND Cte.AnioMes = TimIng.AnioMes
        INNER JOIN EDOCTAV2PARAMSEJECUCION Ejec
        INNER JOIN EDOCTAV2PARAMS Param
		WHERE EstatusTimbrado	= 1
		AND TRIM(CadenaCFDI) <> ''
		AND FIND_IN_SET(IF( Ejec.TipoEjecucion = 'S', Cte.SucursalID, Cte.ClienteID), Ejec.Instrumentos)
		ORDER BY  IF( Ejec.TipoEjecucion = 'S', Cte.SucursalID,Cte.ClienteID) ;
	END IF;

END TerminaStore$$
