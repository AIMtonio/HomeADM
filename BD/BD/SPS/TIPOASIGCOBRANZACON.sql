-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOASIGCOBRANZACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOASIGCOBRANZACON`;DELIMITER $$

CREATE PROCEDURE `TIPOASIGCOBRANZACON`(
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


    DECLARE Con_TipoAsig	INT(11);


    SET Con_TipoAsig 	:= 1;

	IF(Par_NumCon = Con_TipoAsig) THEN
		SELECT TipoAsigCobranzaID, Descripcion
			FROM TIPOASIGCOBRANZA;
	END IF;


END TerminaStore$$