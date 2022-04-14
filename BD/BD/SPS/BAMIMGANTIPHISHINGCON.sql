-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMIMGANTIPHISHINGCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMIMGANTIPHISHINGCON`;DELIMITER $$

CREATE PROCEDURE `BAMIMGANTIPHISHINGCON`(
-- SP para consultar una imagen antiphishing
	Par_ImagenPhishingID		BIGINT,						-- ID de la imagen que se desea consultar

    Par_NumCon				TINYINT UNSIGNED, 				-- Numero de consulta
	Par_EmpresaID			INT(11),						-- Auditoria
	Aud_Usuario				INT(11),						-- Auditoria
	Aud_FechaActual			DATETIME,						-- Auditoria

	Aud_DireccionIP			VARCHAR(15),					-- Auditoria
	Aud_ProgramaID			VARCHAR(50),					-- Auditoria
	Aud_Sucursal			INT(11),						-- Auditoria
	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Con_Principal INT;

	/* Asignacion de Constantes */
	SET	Con_Principal	:= 1; -- Consulta principal


	IF (Par_NumCon=Con_Principal) THEN
		SELECT ImagenPhishingID,	ImagenBinaria,	Descripcion,	Estatus
			FROM BAMIMGANTIPHISHING
			WHERE ImagenPhishingID = Par_ImagenPhishingID;
	END IF;

END TerminaStore$$