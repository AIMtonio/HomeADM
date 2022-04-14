-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDCTEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINFONCONDCTEMOD`;DELIMITER $$

CREATE PROCEDURE `LINFONCONDCTEMOD`(
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
    inout	Par_NumErr 	int,
    inout	Par_ErrMen 	varchar(350),
	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),

	Aud_FechaActual		datetime,
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

update LINFONCONDCTE  set
	Sexo = Par_Sexo,
	EstadoCivil		= Par_EstadoCivil,
	MontoMinimo		= Par_MontoMinimo,
	MontoMaximo		= Par_MontoMaximo,
	MonedaID		= Par_MonedaID,
	DiasGraIngCre	= Par_DiasGraIngCre,

	ProductosCre	= Par_ProductosCre,
	MaxDiasMora		= Par_MaxDiasMora,
	Clasificacion	= Par_Clasificacion,
	EmpresaID		= Par_EmpresaID,
	Usuario			= Aud_Usuario,

	FechaActual		= Aud_FechaActual,
	ProgramaID		= Aud_ProgramaID,
	DireccionIP		= Aud_DireccionIP,
	Sucursal		= Aud_Sucursal,
	NumTransaccion = Aud_NumTransaccion
where LineaFondeoID = Par_LineaFondeoID;

if (Par_Salida = Salida_SI) then
	select 	'000' as NumErr,
			"Condiciones de Descuento Modificadas."  as ErrMen,
			'lineaFondeoID' as Control,
			VarLineaFonID as Consecutivo;
else
	Set Par_NumErr:=	0;
	Set Par_ErrMen:=	"Condiciones de Descuento Modificadas." ;
end if;

END TerminaStore$$