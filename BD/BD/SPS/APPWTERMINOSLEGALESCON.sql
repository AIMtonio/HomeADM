-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWTERMINOSLEGALESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWTERMINOSLEGALESCON`;

DELIMITER $$
CREATE PROCEDURE `APPWTERMINOSLEGALESCON`(


	Par_TerminoLegalID		INT(11),
    Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	DECLARE	Entero_Cero			INT(11);
	DECLARE	Con_Principal		INT(11);


	SET	Entero_Cero				:= 0;
	SET	Con_Principal			:= 1;


	SET Par_TerminoLegalID		:= IFNULL(Par_TerminoLegalID, Entero_Cero);
	SET Par_NumCon				:= IFNULL(Par_NumCon, Entero_Cero);


	IF(Par_NumCon	= Con_Principal) THEN
		SELECT	TerminoLegalID,	TermLegalDescri,	TermLegalContenido
			FROM APPWTERMINOSLEGALES
			WHERE	TerminoLegalID	= Par_TerminoLegalID;
	END IF;

END TerminaStore$$