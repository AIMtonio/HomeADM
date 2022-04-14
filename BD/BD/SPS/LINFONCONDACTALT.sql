-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDACTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINFONCONDACTALT`;DELIMITER $$

CREATE PROCEDURE `LINFONCONDACTALT`(
	Par_LineaFondeoID		int(11),
	Par_ActividadBMXID		varchar(15),

    Par_Salida    			char(1),
    inout	Par_NumErr 		int,
    inout	Par_ErrMen  	varchar(350),

	Par_EmpresaID			int(11),
	Aud_Usuario				int(11),
	Aud_FechaActual			datetime,
	Aud_ProgramaID			varchar(50),
	Aud_DireccionIP			varchar(15),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint(20)
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE Salida_SI 		char(1);
DECLARE Salida_NO 		char(1);




Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
set	Salida_SI 	   	:= 'S';
set	Salida_NO 	   	:= 'N';


if(not exists(select LineaFondeoID from LINEAFONDEADOR
              where LineaFondeoID = Par_LineaFondeoID)) then
	select '001' as NumErr,
		 'La Linea de Fondeo no Existe.' as ErrMen,
		 'lineaFondeoID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
end if;

if(not exists(select ActividadBMXID from ACTIVIDADESBMX
              where ActividadBMXID = Par_ActividadBMXID)) then
	select '001' as NumErr,
		 'La ActividadBMX no Existe.' as ErrMen,
		 'actividadBMXID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
end if;

if(exists(select ActividadBMXID from LINFONCONDACT
              where ActividadBMXID = Par_ActividadBMXID
              and LineaFondeoID = Par_LineaFondeoID)) then
	select '001' as NumErr,
		 'La ActividadBMX no Existe.' as ErrMen,
		 'actividadBMXID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into LINFONCONDACT (
	LineaFondeoID,		ActividadBMXID,		EmpresaID,			Usuario,			FechaActual,
	ProgramaID,			DireccionIP,		Sucursal,			NumTransaccion)
values (
	Par_LineaFondeoID,	Par_ActividadBMXID,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
	Aud_ProgramaID,		Aud_DireccionIP,	Aud_Sucursal,		Aud_NumTransaccion);

if (Par_Salida = Salida_SI) then
	select 	'000' as NumErr,
			"Condiciones de Descuento Agregadas."  as ErrMen,
			'lineaFondeoID' as Control,
			Par_LineaFondeoID as Consecutivo;
else
	Set Par_NumErr:=	0;
	Set Par_ErrMen:=	"Condiciones de Descuento Agregadas." ;
end if;


END TerminaStore$$