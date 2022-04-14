-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPREGUNTASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMPREGUNTASLIS`;DELIMITER $$

CREATE PROCEDURE `BAMPREGUNTASLIS`(
-- Store para listar las preguntas secretas
	Par_Redaccion		VARCHAR(45),				-- Texto de la pregunta  listar
    Par_NumLis			TINYINT UNSIGNED,			-- Numero de lista

    Par_EmpresaID       INT(11),					-- Auditoria
    Aud_Usuario         INT(11),					-- Auditoria
    Aud_FechaActual     DATETIME,					-- Auditoria
    Aud_DireccionIP     VARCHAR(15),				-- Auditoria
    Aud_ProgramaID      VARCHAR(50),				-- Auditoria
    Aud_Sucursal        INT(11),					-- Auditoria
    Aud_NumTransaccion  BIGINT(20)					-- Auditoria
	)
TerminaStore: BEGIN

	/* Declaracion de Constantes */

    DECLARE Lis_Redaccion INT; --  Lista en base a redaccion

    /* Asignacion de Constantes */

    SET Lis_Redaccion := 1;


	IF(Par_NumLis = Lis_Redaccion) THEN
        SELECT `PreguntaSecretaID` AS Pregunta, `Redaccion`
        FROM BAMPREGSECRETAS
        WHERE Redaccion LIKE CONCAT("%", Par_Redaccion, "%")
        LIMIT 0, 15;
    END IF;



END TerminaStore$$