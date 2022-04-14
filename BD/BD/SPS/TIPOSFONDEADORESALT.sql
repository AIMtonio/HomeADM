-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSFONDEADORESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSFONDEADORESALT`;DELIMITER $$

CREATE PROCEDURE `TIPOSFONDEADORESALT`(
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

DECLARE	tipoFodeador		int;


DECLARE  Entero_Cero       int;
DECLARE  Decimal_Cero      decimal(12,2);
DECLARE	Cadena_Vacia		char(1);



set Entero_Cero :=0;
Set Cadena_Vacia		:= '';
set Decimal_Cero :=0.00;

if(ifnull(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia then
	select '001' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_PorcentMora,Decimal_Cero)) = Decimal_Cero then
	select '002' as NumErr,
		 'El % de Participacion en Mora esta vacio.' as ErrMen,
		 'porcentMora' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_PorcentComi,Decimal_Cero)) = Decimal_Cero then
	select '003' as NumErr,
		 'El % de Participacion en Comisiones esta vacio.' as ErrMen,
		 'porcentComi' as control;
	LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();
set tipoFodeador := (select ifnull(Max(TipoFondeadorID),Entero_Cero) + 1
from TIPOSFONDEADORES);

insert into TIPOSFONDEADORES (TipoFondeadorID,	Descripcion,		EsObligadoSol,	PagoEnIncumple,	PorcentajeMora,
						  PorcentajeComisi, 	EmpresaID,		Usuario,			FechaActual,
						  DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)

 values					 (tipoFodeador,		Par_Descripcion,	Par_EsObligSol,	Par_PagoEnIncum,	Par_PorcentMora,
						  Par_PorcentComi,	Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	 Aud_DireccionIP,
						  Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


select '000' as NumErr ,
		  'Tipo de Fondeador Guardado.' as ErrMen,
		  'tipoFondeadorID' as control;

END TerminaStore$$