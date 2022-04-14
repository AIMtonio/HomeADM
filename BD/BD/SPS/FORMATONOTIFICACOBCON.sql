-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FORMATONOTIFICACOBCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `FORMATONOTIFICACOBCON`;DELIMITER $$

CREATE PROCEDURE `FORMATONOTIFICACOBCON`(

	Par_FormatoID		INT(11),
    Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE Con_Formato	INT(11);


    SET Con_Formato 	:= 1;

	IF(Par_NumCon = Con_Formato) THEN
		SELECT FormatoID, Descripcion, Reporte, Tipo
			FROM FORMATONOTIFICACOB
				WHERE FormatoID = Par_FormatoID;
	END IF;

END TerminaStore$$