-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SECTORESECONOMLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SECTORESECONOMLIS`;DELIMITER $$

CREATE PROCEDURE `SECTORESECONOMLIS`(
	Par_Descripcion	varchar(50),
	Par_NumLis		int
	)
TerminaStore: BEGIN


DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Lis_Principal	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;

if(Par_NumLis = Lis_Principal) then
	select	`SectorEcoID`,		`Descripcion`
	from SECTORESECONOM
	where  Descripcion like concat("%", Par_Descripcion, "%")
	limit 0, 15;
end if;

END TerminaStore$$