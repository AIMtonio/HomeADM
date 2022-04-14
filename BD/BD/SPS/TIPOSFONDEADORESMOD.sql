-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSFONDEADORESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSFONDEADORESMOD`;DELIMITER $$

CREATE PROCEDURE `TIPOSFONDEADORESMOD`(
	Par_TipoFondID		int,
	Par_Descripcion 		varchar(100),
	Par_EsObligSol		char(1),
	Par_PagoEnIncum		char(1),
	Par_PorcentMora		decimal(8,4),
	Par_PorcentComi		decimal(8,4),
	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN


DECLARE  Entero_Cero       int;
DECLARE  Decimal_Cero      decimal(12,2);
DECLARE	Cadena_Vacia		char(1);




set Entero_Cero :=0;
Set Cadena_Vacia		:= '';
set Decimal_Cero :=0.00;


if(not exists(select TipoFondeadorID
			from TIPOSFONDEADORES
			where TipoFondeadorID = Par_TipoFondID)) then
	select '001' as NumErr,
		 'El Tipo de Fondeador no existe.' as ErrMen,
		 'tipoFondeadorID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoFondID,Entero_Cero)) = Entero_Cero then
	select '002' as NumErr,
		 'El Tipo de Fondeador esta vacio.' as ErrMen,
		 'tipoFondID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia then
	select '003' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;




Set Aud_FechaActual := CURRENT_TIMESTAMP();


update TIPOSFONDEADORES  set

Descripcion		= Par_Descripcion,
EsObligadoSol		= Par_EsObligSol,
PagoEnIncumple	= Par_PagoEnIncum,
PorcentajeMora	= Par_PorcentMora,
PorcentajeComisi	= Par_PorcentComi,
EmpresaID		= Aud_EmpresaID,
Usuario			= Aud_Usuario,
FechaActual		= Aud_FechaActual,
DireccionIP		= Aud_DireccionIP,
ProgramaID		= Aud_ProgramaID,
Sucursal			= Aud_Sucursal,
NumTransaccion 	= Aud_NumTransaccion
where TipoFondeadorID = Par_TipoFondID;


select '000' as NumErr ,
		  'Tipo de Fondeador modificado.' as ErrMen,
		  'tipoFodeadorID' as control;

END TerminaStore$$