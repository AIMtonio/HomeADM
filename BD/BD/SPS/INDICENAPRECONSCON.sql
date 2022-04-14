-- INDICENAPRECONSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INDICENAPRECONSCON`;
DELIMITER $$

CREATE PROCEDURE `INDICENAPRECONSCON`(
# ============================================================================
# ----------- CONSULTA DE INDICE NACIONAL DE PRECIOS AL CONSUMIDOR -----------
# ============================================================================
    Par_Anio   				INT(11),		-- Anio del registro
    Par_Mes					INT(11),		-- Mes del registro
    Par_NumCon    		TINYINT UNSIGNED,	-- Numero de consulta

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Entero_Cero		INT(11);
	DECLARE Con_Principal   INT(11);
    DECLARE Con_Foranea     INT(11);

	-- Asignacion de Constantes
    SET Cadena_Vacia		:= '';		-- Cadena vacia
	SET Entero_Cero			:= 0;		-- Entero Cero
	SET Con_Principal    	:= 1;		-- Consulta Principal
    SET Con_Foranea			:= 2;		-- Consulta Foranea

	-- 1.- Consulta Principal Indice Nacional de Precios al Consumidor
	IF(Par_NumCon = Con_Principal) THEN
		SELECT Anio, Mes, ValorINPC
		FROM INDICENAPRECONS
		WHERE Anio = Par_Anio
			AND Mes = Par_Mes;
	END IF;

    -- 2.- Consulta Foranea Indice Nacional de Precios al Consumidor
	IF(Par_NumCon = Con_Foranea) THEN
		SELECT COUNT(Anio) AS NumRegistrosINPC
		FROM INDICENAPRECONS
		WHERE Anio = Par_Anio;
	END IF;

END TerminaStore$$