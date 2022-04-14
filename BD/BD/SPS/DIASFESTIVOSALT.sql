-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASFESTIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASFESTIVOSALT`;DELIMITER $$

CREATE PROCEDURE `DIASFESTIVOSALT`(
	Par_Fecha			Date,
	Par_EmpresaID		int,
	Par_Descripcion		varchar(100),
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(20),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;


if(ifnull(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia then
	select '001' as NumErr,
		 'La Fecha esta vacia.' as ErrMen,
		 'fechaFestiva' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;


if exists(select Fecha from DIASFESTIVOS where Fecha = Par_Fecha) then
select '003' as NumErr,
		 'La Fecha ya existe.' as ErrMen,
		 'fechaFestiva' as control;
	LEAVE TerminaStore;
end if;



insert DIASFESTIVOS VALUES (Par_Fecha,			Par_EmpresaID, 		Par_Descripcion,		Aud_Usuario,	Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

select '000' as NumErr,
	  concat("Fecha Festiva Agregada: ", convert(Par_Fecha, CHAR(10)))  as ErrMen,
	  'numero' as control;



END TerminaStore$$