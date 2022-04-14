-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICCREDITOLIS`;DELIMITER $$

CREATE PROCEDURE `CLASIFICCREDITOLIS`(
	Par_Descripcion		varchar(100),
	Par_NumLis			tinyint unsigned,
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal	int;
DECLARE	Lis_Combo		int;
DECLARE Lis_ComboCartera int;


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Lis_Principal		:= 1;
Set	Lis_Combo			:= 2;
Set Lis_ComboCartera	:= 3;


if(Par_NumLis = Lis_Principal) then
	select	ClasificacionID,		DescripClasifica
	from CLASIFICCREDITO
	where  DescripClasifica like concat("%", Par_Descripcion, "%")
	limit 0, 15;
end if;


if(Par_NumLis = Lis_Combo) then
	select	ClasificacionID,		DescripClasifica
		from CLASIFICCREDITO;
end if;


if(Par_NumLis = Lis_ComboCartera) then
	select	ClasificacionID, concat(ClasificacionID," ",DescripClasifica) as DescripClasifica
		from CLASIFICCREDITO;
end if;


END TerminaStore$$