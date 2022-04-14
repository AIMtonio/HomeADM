-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOINVERSIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOINVERSIONLIS`;DELIMITER $$

CREATE PROCEDURE `MONTOINVERSIONLIS`(
	Par_TipoInversionID	int,
	Par_NumLis			int,
	Par_Empresa			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

DECLARE 	Lis_MontoIversion	int;
DECLARE	Lis_Principal	int;

Set	Lis_Principal		:= 1;
Set	Lis_MontoIversion	:= 2;

if(Par_NumLis = Lis_Principal) then
	select `MontoInversionID`,`TipoInversionID`, `PlazoInferior`, `PlazoSuperior`
	from MONTOINVERSION
	where	TipoInversionID = Par_TipoInversionID;
end if;

if(Par_NumLis = Lis_MontoIversion) then
	select MontoInversionID, CONCAT(FORMAT(PlazoInferior,2), '  a  ', FORMAT(PlazoSuperior,2), '')as MontosPlazo
	from MONTOINVERSION
	where  TipoInversionID = Par_TipoInversionID;
end if;

END TerminaStore$$