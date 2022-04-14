-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDEDOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINFONCONDEDOBAJ`;DELIMITER $$

CREATE PROCEDURE `LINFONCONDEDOBAJ`(
	Par_LineaFondeoID		int(11),

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



delete
	from LINFONCONDEDO
	where LineaFondeoID = Par_LineaFondeoID;

if (Par_Salida = Salida_SI) then
	select 	'000' as NumErr,
			"Condiciones de Descuento Eliminadas."  as ErrMen,
			'lineaFondeoID' as Control,
			Par_LineaFondeoID as Consecutivo;
else
	Set Par_NumErr:=	0;
	Set Par_ErrMen:=	"Condiciones de Descuento Eliminadas." ;
end if;

END TerminaStore$$