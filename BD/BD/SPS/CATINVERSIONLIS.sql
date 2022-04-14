-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATINVERSIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATINVERSIONLIS`;DELIMITER $$

CREATE PROCEDURE `CATINVERSIONLIS`(
	Par_NumLis		tinyint unsigned
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_TipoInver 	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_TipoInver		:= 1;

if(Par_NumLis = Lis_TipoInver) then
	select 	`TipoInversionID`,	`Descripcion`
	from 		CATINVERSION
	limit 0, 15;
end if;

END TerminaStore$$