-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPREGUNTASSEGCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATPREGUNTASSEGCON`;DELIMITER $$

CREATE PROCEDURE `CATPREGUNTASSEGCON`(
	-- Consulta de Preguntas de Seguridad
	Par_PreguntaID		INT(11),			-- Numero de Pregunta de Seguridad
    Par_NumCon          TINYINT UNSIGNED,	-- Numero de Consulta

    Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)  		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia    CHAR(1);
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT(11);
	DECLARE Con_Principal   INT(11);

	-- Asignacion de constantes
	SET Cadena_Vacia    	:= '';				-- Cadena vacia
	SET Fecha_Vacia     	:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero     	:= 0;				-- Entero cero
	SET Con_Principal   	:= 1;				-- Consulta principal Preguntas de Seguridad

    -- 1.- Consulta Principal Preguntas de Seguridad
	IF(Par_NumCon = Con_Principal) THEN
		SELECT PreguntaID, Descripcion
		FROM CATPREGUNTASSEG
		WHERE PreguntaID  = Par_PreguntaID;
	END IF;

END TerminaStore$$