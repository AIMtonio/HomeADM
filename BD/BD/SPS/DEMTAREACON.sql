-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMTAREACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMTAREACON`;DELIMITER $$

CREATE PROCEDURE `DEMTAREACON`(
	-- descripcion:		STORE PARA CONSULTAR LA INFORMACION DE UNA TAREA PARA EL DEMONIO
	Par_TareaID						INT(11), 			-- ID de la tarea
	Par_NombreClase					VARCHAR(150),		-- Nombre del parametro
	Par_Estatus						CHAR(1), 			-- Estatus de la tarea
	Par_EjecucionMultiple			CHAR(1),			-- Ejecucion multiple

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
	DECLARE Est_Activo				CHAR(1); 			-- Estatus activo

	-- Asignacion de constantes
	SET	Var_ConPrincipal			:= 1;				-- Consulta de una tarea  por ID
	SET Est_Activo	 				:= 'A'; 			-- Estatus activo

	IF(Par_NumCon = Var_ConPrincipal)THEN
		SELECT	TareaID,		NombreClase, 		Estatus, 		EjecucionMultiple,   	CronEjecucion,
                NombreJar
			FROM DEMTAREA
			WHERE	TareaID = Par_TareaID;
	END IF;
END TerminaStore$$