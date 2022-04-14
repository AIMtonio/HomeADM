-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERMISOSCONTABLESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PERMISOSCONTABLESALT`;DELIMITER $$

CREATE PROCEDURE `PERMISOSCONTABLESALT`(
	Par_UsuarioID		int(11),
	Par_AfectacionFeVa	char(1),
	Par_CierreEjercicio	char(1),
	Par_CierrePeriodo	char(1),
	Par_ModificaPolizas	char(1),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Entero_Cero		int;
DECLARE		Float_Cero		float;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero		:= 0;
Set	Float_Cero		:= 0.0;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(ifnull( Aud_Usuario, Entero_Cero)) = Entero_Cero then
	select '001' as NumErr,
		 'El Usuario no esta logeado' as ErrMen,
		 'inversionID' as control,
		 0 as consecutivo;
	LEAVE TerminaStore;
end if;

insert PERMISOSCONTABLES VALUES (
	Par_UsuarioID, 	Par_AfectacionFeVa, 	Par_CierreEjercicio,	Par_CierrePeriodo, 	Par_ModificaPolizas,
	Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
	Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion);



select '000' as NumErr,
	  concat("Datos Guardados: ", convert(Par_UsuarioID, CHAR))  as ErrMen,
	  'usuarioID' as control,
	  Par_UsuarioID as consecutivo;


END TerminaStore$$