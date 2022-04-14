-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSLINEAFONDEALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSLINEAFONDEALIS`;DELIMITER $$

CREATE PROCEDURE `TIPOSLINEAFONDEALIS`(
	Par_Descripcion		varchar(20),
	Par_InstitutFondID  int(11),
	Par_NumLis			tinyint unsigned,
	Par_EmpresaID		int,

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
DECLARE	Lis_Combo	 	int;
DECLARE Lis_Foranea		int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
set Lis_Foranea		:= 2;

if(Par_NumLis = Lis_Principal) then
	select	`TipoLinFondeaID`,		`Descripcion`
	from TIPOSLINEAFONDEA
	where  Descripcion like concat("%", Par_Descripcion, "%")
	limit 0, 15;
end if;

if(Par_NumLis = Lis_Foranea) then
	select	`TipoLinFondeaID`,		`Descripcion`
	from TIPOSLINEAFONDEA
	where  Descripcion like concat("%", Par_Descripcion, "%")
		and InstitutFondID =Par_InstitutFondID	limit 0, 15;
end if;



END TerminaStore$$