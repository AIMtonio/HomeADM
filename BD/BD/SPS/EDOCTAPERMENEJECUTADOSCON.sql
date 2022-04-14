-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAPERMENEJECUTADOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAPERMENEJECUTADOSCON`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAPERMENEJECUTADOSCON`(
	/*	SP para consultar los meses o semestres cuyos estados de cuenta han sido generados */

	Par_Anio						INT(11),				-- Anio en el que se ejecuto la generacion de estado de cuenta
	Par_MesInicio					INT(11),				-- Mes inicial en el que se ejecuto la generacion de estado de cuenta
	Par_MesFin						INT(11),				-- Mes final en el que se ejecuto la generacion de estado de cuenta
	Par_Tipo						CHAR(1),				-- Denota el tipo de ejecucion de generacion de estado de cuenta. M = Mensual, S = Semestral.
	Par_NumCon						TINYINT UNSIGNED,		-- Tipo de consulta que devolvera el SP

	Par_Empresa						INT(11),				-- Parametro de auditoria
	Aud_Usuario						INT(11),				-- Parametro de auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal					INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de auditoria
)

TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Dos				INT(11);
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(14, 2); 		-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;					-- Fecha vacia
	DECLARE Var_SI 					CHAR(1); 				-- Variable con valor SI (S)
	DECLARE Var_ConPrincipal 		TINYINT;				-- Consulta principal
    DECLARE Var_ConPeriodo 			TINYINT;				-- Consulta periodo

	-- Asignacion de constantes
	SET Entero_Dos					:= 2;					-- Asignacion de entero
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_SI						:= 'S';					-- Variable con valor SI (S)
	SET Var_ConPrincipal			:= 1;					-- Consulta principal
    SET Var_ConPeriodo 				:= 2;

	-- Consulta por ID
	IF(Par_NumCon = Var_ConPrincipal) THEN
		SELECT	Anio,			MesInicio,			MesFin,				Tipo
			FROM EDOCTAPERMENEJECUTADOS
			WHERE Anio = Par_Anio
			  AND MesInicio = Par_MesInicio
			  AND MesFin = Par_MesFin
			  AND Tipo = Par_Tipo;
	END IF;
   
    -- Consulta de Periodo
	IF(Par_NumCon = Var_ConPeriodo) THEN
		SELECT	CONCAT(Anio,LPAD(MesInicio,Entero_Dos,Entero_Cero)) AS AnioMes
			FROM EDOCTAPERMENEJECUTADOS
			WHERE Anio = Par_Anio
			  AND MesInicio = Par_MesInicio;
	END IF;

END TerminaStore$$