-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INDICENAPRECONSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INDICENAPRECONSLIS`;DELIMITER $$

CREATE PROCEDURE `INDICENAPRECONSLIS`(
# ============================================================================
# ------------- LISTA DE INDICE NACIONAL DE PRECIOS AL CONSUMIDOR ------------
# ============================================================================
	Par_MesAnio   		VARCHAR(10),			-- Mes y Anio
	Par_NumLis			TINYINT UNSIGNED,		-- Numero de Lista

	Par_EmpresaID		INT(11),				-- Parametro de Auditoria
    Aud_Usuario			INT(11),				-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal		INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)   			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Entero_Cero		INT(11);
	DECLARE Lis_Principal   INT(11);

	-- Asignacion de Constantes
    SET Cadena_Vacia		:= '';		-- Cadena vacia
	SET Entero_Cero			:= 0;		-- Entero Cero
	SET Lis_Principal    	:= 1;		-- Lista Principal

	-- 1.- Lista Principal Indice Nacional de Precios al Consumidor
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT MesAnio,ValorINPC
			FROM INDICENAPRECONS
				WHERE MesAnio LIKE CONCAT("%", Par_MesAnio, "%")
			LIMIT 0,15;
	END IF;

END TerminaStore$$