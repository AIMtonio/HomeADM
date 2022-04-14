-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEAFONDEADORLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEAFONDEADORLIS`;
DELIMITER $$

CREATE PROCEDURE `LINEAFONDEADORLIS`(
	Par_DescripLinea	varchar(20),
 	Par_InstitutFondID	int(11),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
)
TerminaStore:BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal 	int;
DECLARE	Lis_LineaFon 	int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set	Lis_LineaFon	:= 2;

if(Par_NumLis = Lis_Principal) then
	select	`LineaFondeoID`,		substring(`DescripLinea`,1,50)
	from LINEAFONDEADOR
	where  DescripLinea like concat("%", Par_DescripLinea, "%")
	limit 0, 15;
end if;


if(Par_NumLis = Lis_LineaFon) then
	select	`LineaFondeoID`,		substring(`DescripLinea`,1,50)
	from LINEAFONDEADOR
	where  DescripLinea like concat("%", Par_DescripLinea, "%")
	and 	InstitutFondID = Par_InstitutFondID;
end if;

END TerminaStore$$