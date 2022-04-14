-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWIMGANTIPHISHINGCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWIMGANTIPHISHINGCON`;

DELIMITER $$

CREATE PROCEDURE `APPWIMGANTIPHISHINGCON`(

	Par_ImagenPhishingID		BIGINT,

    Par_NumCon				TINYINT UNSIGNED,
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
)

TerminaStore: BEGIN


	DECLARE	Con_Principal INT;


	SET	Con_Principal	:= 1;


	IF (Par_NumCon=Con_Principal) THEN
		SELECT ImagenPhishingID,	ImagenBinaria,	Descripcion,	Estatus
			FROM APPWIMGANTIPHISHING
			WHERE ImagenPhishingID = Par_ImagenPhishingID;
	END IF;

END TerminaStore$$