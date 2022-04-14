-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMTAREALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMTAREALIS`;DELIMITER $$

CREATE PROCEDURE `DEMTAREALIS`(
	-- STORE PARA LISTAR LAS TAREAS QUE CARGARA EL DEMONIO
	Par_TareaID						INT(11),			-- ID la tarea
	Par_NombreClase 				VARCHAR(150),		-- Nombre del parametro
	Par_Estatus 					CHAR(1),			-- Estatus de la tarea
	Par_EjecucionMultiple 			CHAR(1),			-- Ejecucion multiple

	Par_NumLis						TINYINT UNSIGNED,	-- Numero de lista

	Par_EmpresaID					INT(11),			-- Parametros de Auditoria
	Aud_Usuario						INT(11),			-- Parametros de Auditoria
	Aud_FechaActual					DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP					VARCHAR(15),		-- Parametros de Auditorias
	Aud_ProgramaID					VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal					INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Var_LisTareasActivas	INT(11);			-- Lista de tareas activas
	DECLARE Var_LisTareasTodas		INT(11);			-- Lista de tareas activas
	DECLARE Est_Activo				CHAR(1);			-- Estatus activo

	-- Asignacion de constantes
	SET	Var_LisTareasActivas		:= 1;				-- Lista de tareas activas
	SET Est_Activo					:= 'A';				-- Estatus activo
	SET Var_LisTareasTodas			:= 2;				-- Lista de todas las tareas

	IF(Par_NumLis = Var_LisTareasActivas)THEN
		SELECT	TareaID,		NombreClase,		Estatus,		EjecucionMultiple,		CronEjecucion,
				NombreJar
			FROM DEMTAREA
			WHERE	Estatus = Est_Activo;
	END IF;


	IF(Par_NumLis = Var_LisTareasTodas)THEN
		SELECT	TareaID,		NombreClase,		Estatus,		EjecucionMultiple,		CronEjecucion,
				NombreJar
			FROM DEMTAREA
			ORDER BY Estatus ASC;
	END IF;
END TerminaStore$$