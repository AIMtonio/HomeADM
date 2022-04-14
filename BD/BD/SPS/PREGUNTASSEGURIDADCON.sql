-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREGUNTASSEGURIDADCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREGUNTASSEGURIDADCON`;DELIMITER $$

CREATE PROCEDURE `PREGUNTASSEGURIDADCON`(
	-- Consulta de Preguntas de Seguridad
    Par_ClienteID		INT(11),			-- Numero de Cliente
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE Con_NumPreguntas	INT(11);

	-- Asignacion de Constantes
	SET	Cadena_Vacia		    := '';           -- Cadena vacia
	SET	Fecha_Vacia			    := '1900-01-01'; -- Fecha vacia
	SET	Entero_Cero			    := 0;            -- Entero cero
	SET	Decimal_Cero		    := 0.0;          -- Decimal cero
	SET	Con_NumPreguntas		:= 3;			 -- Consulta Numero de Preguntas

	-- 3.- Consulta Numero de Preguntas
	IF(Par_NumCon = Con_NumPreguntas) THEN
		SELECT IFNULL(COUNT(PreguntaSegID),Entero_Cero) AS NumPreguntas
        FROM PREGUNTASSEGURIDAD
        WHERE ClienteID = Par_ClienteID;
	END IF;

END TerminaStore$$