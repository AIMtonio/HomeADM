-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCONTALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSCONTALIS`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSCONTALIS`(
	Par_Descripcion 		varchar(30),
	Aud_EmpresaID		int,
	Par_NumLis			tinyint unsigned,


	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Lis_Principal	int;
DECLARE		Lis_Foranea		int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set	Lis_Foranea		:= 2;

if(Par_NumLis = Lis_Principal) then
	select 	ConceptoContaID,	Descripcion
	from  	CONCEPTOSCONTA
	where 	Descripcion 	like concat("%", Par_Descripcion, "%")
	or 		ConceptoContaID 	like concat("%", Par_Descripcion, "%") limit 15;
end if;

END TerminaStore$$