-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAINSTINVBANCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAINSTINVBANCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTAINSTINVBANCON`(



	Par_ConceptoInvBanID 		int(11),
	Par_NumeroInstitucion		int(11),
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
		SELECT ConceptoInvBanID, InstitucionID, SubCuenta FROM SUBCTAINSTINVBAN
		Where ConceptoInvBanID=Par_ConceptoInvBanID and InstitucionID=Par_NumeroInstitucion;
	end if;

END TerminaStore$$