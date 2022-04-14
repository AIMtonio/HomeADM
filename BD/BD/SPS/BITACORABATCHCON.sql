-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORABATCHCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORABATCHCON`;DELIMITER $$

CREATE PROCEDURE `BITACORABATCHCON`(
# =================================================================
# -------- SP QUE CONSULTA LA BITACORA DE LOS PROCESOS BATCH-------
# =================================================================
	Par_ProcesoBatchID  	INT(11),			-- Numero de Proceso
    Par_Fecha           	DATE,				-- Fecha de Proceso
    INOUT Par_FechaBatch	DATE,				-- Se obtiene la Fecha de Proceso Regitrado en  BITACORABATCH
	Par_NumCon          	TINYINT UNSIGNED,	-- Numero de consulta
    /* Parametros de Auditoria */
    Par_EmpresaID           INT(11),

    Aud_Usuario     		INT(11),
    Aud_FechaActual	 		DATETIME,
    Aud_DireccionIP 		VARCHAR(15),
    Aud_ProgramaID  		VARCHAR(50),
    Aud_Sucursal        	INT(11),

    Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
    DECLARE Var_FechaBatch		DATE;
    DECLARE Var_FechaEjec		DATETIME;
	DECLARE Var_Existe			CHAR(1);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
    DECLARE Fecha_Vacia			DATE;
    DECLARE Entero_Cero			INT(11);
	DECLARE Con_Principal		INT(11);
	DECLARE Con_ExisteEjec		INT(11);
	DECLARE ConstanteSI			CHAR(1);
	DECLARE ConstanteNO			CHAR(1);

    -- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena vacia
    SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
    SET Entero_Cero				:= 0;				-- Entero cero
    SET Con_Principal			:= 1;				-- Consulta Principal
    SET Con_ExisteEjec			:= 2;				-- Consulta Principal
	SET ConstanteSI				:= 'S';				-- Constante SI
	SET ConstanteNO				:= 'N';				-- Constante NO

    -- Consulta principal
	IF(Par_NumCon = Con_Principal) THEN
		SELECT B.Fecha
		  INTO Var_FechaBatch
		FROM PROCESOSBATCH P LEFT JOIN BITACORABATCH B ON (P.ProcesoBatchID = B.ProcesoBatchID AND B.Fecha = Par_Fecha)
			WHERE P.ProcesoBatchID = Par_ProcesoBatchID;

		SET Var_FechaBatch  := IFNULL(Var_FechaBatch,Fecha_Vacia);
		SET Par_FechaBatch 	:= Var_FechaBatch;
    END IF;

    -- Consulta existencia de ejecución de procesos en la bitácora batch
	IF(Par_NumCon = Con_ExisteEjec) THEN
		IF(EXISTS(SELECT B.Fecha FROM BITACORABATCH B WHERE B.ProcesoBatchID = Par_ProcesoBatchID AND B.Fecha = Par_Fecha))THEN
			SET Var_Existe := ConstanteSI;
			SET Var_FechaEjec := (SELECT CONCAT(B.Fecha,' ',TIME(FechaActual))
									FROM BITACORABATCH B WHERE B.ProcesoBatchID = Par_ProcesoBatchID AND B.Fecha = Par_Fecha);
		ELSE
			SET Var_Existe := ConstanteNO;
			SET Var_FechaEjec := Fecha_Vacia;
	    END IF;

	    SELECT Var_Existe AS ExisteEjecucion, Var_FechaEjec AS Fecha;
    END IF;

END TerminaStore$$