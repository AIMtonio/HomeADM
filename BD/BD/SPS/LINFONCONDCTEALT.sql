-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDCTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINFONCONDCTEALT`;DELIMITER $$

CREATE PROCEDURE `LINFONCONDCTEALT`(
	Par_LineaFondeoID	int(11),
	Par_Sexo			char(1),
	Par_EstadoCivil		varchar(200),
	Par_MontoMinimo		decimal(12,2),
	Par_MontoMaximo		decimal(12,2),

	Par_MonedaID		int(11),
 	Par_DiasGraIngCre	int(11),
	Par_ProductosCre	varchar(600),
	Par_MaxDiasMora		int(11),
	Par_Clasificacion	char(1),

    Par_Salida			char(1),
    inout	Par_NumErr	int,
    inout	Par_ErrMen	varchar(350),
	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),

	Aud_FechaActual		DateTime,
	Aud_ProgramaID		varchar(50),
	Aud_DireccionIP		varchar(15),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE Salida_SI 		char(1);
DECLARE Salida_NO 		char(1);


DECLARE	VarLineaFonID	int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
set	Salida_SI 	   	:= 'S';
set	Salida_NO 	   	:= 'N';


if(not exists(select lineaFondeoID from LINEAFONDEADOR
              where LineaFondeoID = Par_LineaFondeoID)) then
	select '001' as NumErr,
		 'La Linea de Fondeo no Existe.' as ErrMen,
		 'lineaFondeoID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into LINFONCONDCTE (
	LineaFondeoID,		Sexo,				EstadoCivil,		MontoMinimo,		MontoMaximo,
	MonedaID,			DiasGraIngCre,   	ProductosCre,		MaxDiasMora,		Clasificacion,
	EmpresaID,			Usuario,			FechaActual,		ProgramaID,			DireccionIP,
	Sucursal,			NumTransaccion)
values (
	Par_LineaFondeoID,  Par_Sexo,           Par_EstadoCivil,    Par_MontoMinimo,	Par_MontoMaximo,
	Par_MonedaID,		Par_DiasGraIngCre,  Par_ProductosCre,   Par_MaxDiasMora,    Par_Clasificacion,
	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_ProgramaID,		Aud_DireccionIP,
	Aud_Sucursal,		Aud_NumTransaccion);

if (Par_Salida = Salida_SI) then
	select 	'000' as NumErr,
			"Condiciones de Descuento Agregadas."  as ErrMen,
			'lineaFondeoID' as Control,
			VarLineaFonID as Consecutivo;
else
	Set Par_NumErr:=	0;
	Set Par_ErrMen:=	"Condiciones de Descuento Agregadas." ;
end if;

END TerminaStore$$