-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASINVERSIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASINVERSIONLIS`;DELIMITER $$

CREATE PROCEDURE `DIASINVERSIONLIS`(
	Par_TipoInversionID 	int,
	Par_NumLis			tinyint unsigned,
	Par_Empresa			int,

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
DECLARE	Lis_TipoInver 	int;
DECLARE	Lis_Principal 	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_TipoInver		:= 2;
Set	Lis_Principal		:= 1;

if(Par_NumLis = Lis_Principal) then
	select `DiaInversionID`,`TipoInversionID`, `PlazoInferior`, `PlazoSuperior`
	from DIASINVERSION
	where	TipoInversionID = Par_TipoInversionID;
end if;

if(Par_NumLis = Lis_TipoInver) then
	select 	`DiaInversionID`,	concat(convert(PlazoInferior, CHAR), " - ",convert(PlazoSuperior, CHAR)) as  Plazos
	from 		DIASINVERSION
	where		TipoInversionID = Par_TipoInversionID;
end if;

END TerminaStore$$