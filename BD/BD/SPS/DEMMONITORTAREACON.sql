-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMMONITORTAREACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMMONITORTAREACON`;DELIMITER $$

CREATE PROCEDURE `DEMMONITORTAREACON`(
	-- STORE PARA CONSULTAR LAS TAREAS ACTUALMENTE EN EJECUCION

	Par_PIDTarea 					VARCHAR(50), 		-- Identificador del hilo de ejecucion de la tarea
	Par_TareaID 					INT(11), 			-- Identificador de la tarea
	Par_FechaHoraIni 				DATETIME, 			-- Fecha y hora de ejecucion

	Par_NumCon						TINYINT UNSIGNED,	-- Numero de lista

	Par_EmpresaID					INT(11),			-- Parametros de Auditoria
	Aud_Usuario						INT(11),			-- Parametros de Auditoria
	Aud_FechaActual					DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP					VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID					VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal					INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Var_ConPrincipal		INT(11);			-- Consulta de una tarea  por ID
	DECLARE Est_Activo	 			CHAR(1); 			-- Estatus activo

	-- Asignacion de constantes
	SET	Var_ConPrincipal			:= 1;				-- Consulta de una tarea  por ID
	SET Est_Activo 					:= 'A'; 			-- Estatus activo

	IF(Par_NumCon = Var_ConPrincipal)
	THEN
		SELECT	PIDTarea,		TareaID, 		FechaHoraIni
			FROM DEMMONITORTAREA
			WHERE	TareaID = Par_TareaID
			LIMIT 1;
	END IF;
END TerminaStore$$