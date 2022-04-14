-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOINVLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPLAZOINVLIS`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPLAZOINVLIS`(
	Par_ConceptoInverID		int(11),
	Par_NumLis				tinyint unsigned,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal 	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;

if(Par_NumLis = Lis_Principal) then
	select 	SubCtaPlazoInvID,	concat(convert(PlazoInferior, CHAR), " - ",convert(PlazoSuperior, CHAR)) as  Plazos
	from 		SUBCTAPLAZOINV
	where 	ConceptoInverID=Par_ConceptoInverID;
end if;

END TerminaStore$$