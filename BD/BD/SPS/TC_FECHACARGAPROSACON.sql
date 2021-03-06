-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_FECHACARGAPROSACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_FECHACARGAPROSACON`;
DELIMITER $$


CREATE PROCEDURE `TC_FECHACARGAPROSACON`(
-- ---------------------------------------------------------------------------------
-- Consulta de informacion de la fecha de proceso
-- ---------------------------------------------------------------------------------
    Par_FechaEjec 			DATE  ,         		-- Fecha de ejecucion del cron job
    Par_TipoArchivo			CHAR(1),				-- Tipo de archivo S= Stats, 	E= EMI
    Par_NumCon				TINYINT UNSIGNED,		-- Nunero de consulta

    Par_EmpresaID           INT(11) ,       -- Auditoria
    Aud_Usuario             INT(11),        -- Auditoria
    Aud_FechaActual         DATETIME ,      -- Auditoria
    Aud_DireccionIP         VARCHAR(15) ,   -- Auditoria
    Aud_ProgramaID          VARCHAR(50) ,   -- Auditoria
    Aud_Sucursal            INT(11) ,       -- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria

)
TerminaStore:BEGIN
	-- Constantes
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(1);			-- Constante entero cero
	DECLARE Cadena_Vacia		VARCHAR(2);		-- Constante Cadena vacia
	DECLARE Estatus_Exito		CHAR(1);		-- Estatus del documento exito
	DECLARE Estatus_Fallido		CHAR(1);		-- Estatus del documento fallido
	DECLARE Entero_Uno			INT(1);			-- Constante entero uno
	DECLARE Con_Principal		INT(1);			-- Consulta principal
	DECLARE Con_Fecha			INT(1);			-- Consulta por fecha
	
	-- Variables
	DECLARE Var_Estatus			CHAR(1);		-- Estatus de la cola de ejecucion
	DECLARE Var_IntentosF		INT(11);		-- Intentos fallidos de lectura
	DECLARE Var_Fecha			DATE;			-- Fecha de la ejecucion
	
	
	-- Asignacion de constantes
	SET Fecha_Vacia     := '1900-01-01';	-- Fecha vacia
	SET Entero_Cero 	:= 0;			-- Asignacion a entero cero
	SET Entero_Uno		:= 1;			-- Asignacion a entero uno
	SET Cadena_Vacia	:= '';			-- Asifnacion a cadena vacia
	
	-- Asignacion de Constantes
	SET Estatus_Exito		:= 'E';			-- Asignacion estatus de Exito
	SET Estatus_Fallido		:= 'F';			-- Asignaci??n estatus Fallido
	SET Con_Principal		:= 1;			-- Asignacion de consulta principal
	SET Con_Fecha			:= 2;			-- Asignacion de consulta por fecha
	

   
	IF(Par_NumCon = Con_Principal) THEN
		SELECT 		FechaCargaProsaID,		IntentosFallidos, 		Estatus,			HoraEjecucion
			FROM TC_FECHACARGAPROSA WHERE 
			Fecha = Par_FechaEjec
			AND TipoArchivo = Par_TipoArchivo;
	END IF;
END TerminaStore$$
