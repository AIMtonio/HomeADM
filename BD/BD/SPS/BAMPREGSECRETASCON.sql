-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPREGSECRETASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMPREGSECRETASCON`;DELIMITER $$

CREATE PROCEDURE `BAMPREGSECRETASCON`(

	-- SP Para consultar una pregunta secreta del catalogo
	Par_PreguntaSecretaID	BIGINT,					-- ID de la pregunta a consultar

    Par_NumCon				TINYINT UNSIGNED, 		-- Tipo de consulta
	Par_EmpresaID			INT(11),				-- Auditoria
	Aud_Usuario				INT(11),				-- Auditoria
	Aud_FechaActual			DATETIME,				-- Auditoria

	Aud_DireccionIP			VARCHAR(15),			-- Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Auditoria
	Aud_Sucursal			INT(11),				-- Auditoria
	Aud_NumTransaccion		BIGINT					-- Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Con_Principal INT; 			-- Constante para tomar de referencia en que consultase realizara

	/* Asignacion de Constantes */
	SET	Con_Principal	:= 1; 			-- Asignacion del identificador de la consulta principal en este caso 1


	IF (Par_NumCon=Con_Principal) THEN
		SELECT  PreguntaSecretaID, Redaccion
			FROM BAMPREGSECRETAS
			WHERE PreguntaSecretaID = Par_PreguntaSecretaID;
	END IF;

END TerminaStore$$