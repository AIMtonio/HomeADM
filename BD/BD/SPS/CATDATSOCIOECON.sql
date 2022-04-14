-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATDATSOCIOECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATDATSOCIOECON`;DELIMITER $$

CREATE PROCEDURE `CATDATSOCIOECON`(

	Par_CatSocioEID			INT(11),
	Par_NumCon				TINYINT UNSIGNED,


	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN

DECLARE ConsultaPrincipal	int;

set ConsultaPrincipal		:=1;

if(Par_NumCon = ConsultaPrincipal)then
	select CatSocioEID, Descripcion, Tipo,Estatus
		from CATDATSOCIOE
		where CatSocioEID = Par_CatSocioEID;
end if;

END TerminaStore$$