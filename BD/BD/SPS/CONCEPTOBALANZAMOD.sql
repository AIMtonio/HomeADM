-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOBALANZAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOBALANZAMOD`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOBALANZAMOD`(
	Par_ConBalanzaID		bigint,
	Par_Descripcion 		varchar(100),
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
DECLARE	Cadena_Vacia		char(1);




set Entero_Cero :=0;
Set Cadena_Vacia		:= '';

if(not exists(select ConBalanzaID
			from CONCEPTOBALANZA
			where ConBalanzaID = Par_ConBalanzaID)) then
	select '001' as NumErr,
		 'El Numero de Concepto de Balanza no existe.' as ErrMen,
		 'conceptoBalanzaID' as control;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_ConBalanzaID,Entero_Cero)) = Entero_Cero then
	select '002' as NumErr,
		 'El numero de Concepto esta vacio.' as ErrMen,
		 'conBalanzaID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia then
	select '003' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();


update CONCEPTOBALANZA  set

ConBalanzaID		= Par_ConBalanzaID,
Descripcion		= Par_Descripcion,
EmpresaID		= Aud_EmpresaID,
Usuario			= Aud_Usuario,
FechaActual		= Aud_FechaActual,
DireccionIP		= Aud_DireccionIP,
ProgramaID		= Aud_ProgramaID,
Sucursal			= Aud_Sucursal,
NumTransaccion 	= Aud_NumTransaccion

where ConBalanzaID= Par_ConBalanzaID;


select '000' as NumErr ,
		  'Concepto de Balanza Modificado' as ErrMen,
		  'ConBalanzID' as control;

END TerminaStore$$