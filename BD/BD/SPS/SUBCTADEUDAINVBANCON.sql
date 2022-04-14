-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTADEUDAINVBANCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTADEUDAINVBANCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTADEUDAINVBANCON`(



	Par_ConceptoInvBanID 		int(11),
	Par_NumCon					tinyint unsigned,
	Aud_EmpresaID				int,
	Aud_Usuario					int,
	Aud_FechaActual				DateTime,

	Aud_DireccionIP				varchar(15),
	Aud_ProgramaID				varchar(50),
	Aud_Sucursal				int,
	Aud_NumTransaccion			bigint


)
TerminaStore: BEGIN

	DECLARE		Con_Principal	int;

	Set	Con_Principal	:= 1;

	if(Par_NumCon = Con_Principal) then
		select	ConceptoInvBanID,		TipoDeuGuber,		TipoDeuBanca,	TipoDeuOtros
		from SUBCTADEUDAINVBAN
		where ConceptoInvBanID = Par_ConceptoInvBanID;
	end if;

END TerminaStore$$