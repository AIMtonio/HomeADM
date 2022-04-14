-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVIDADESINEGILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVIDADESINEGILIS`;DELIMITER $$

CREATE PROCEDURE `ACTIVIDADESINEGILIS`(
	Par_Descripcion	varchar(50),
	Par_NumLis		tinyint unsigned
	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	int;
DECLARE		Fecha_Vacia	char(1);
DECLARE		Entero_Cero	char(1);
DECLARE		Lis_Principal	char(1);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;

if(Par_NumLis = Lis_Principal) then
	select	`ActividadINEGIID`,		`Descripcion`
	from ACTIVIDADESBMX
	where  Descripcion like concat("%", Par_Descripcion, "%")
	limit 0, 15;
end if;

END TerminaStore$$