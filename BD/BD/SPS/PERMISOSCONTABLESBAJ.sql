-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERMISOSCONTABLESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PERMISOSCONTABLESBAJ`;DELIMITER $$

CREATE PROCEDURE `PERMISOSCONTABLESBAJ`(
	Par_UsuarioID		int(11),

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

DELETE
	FROM 		PERMISOSCONTABLES
where UsuarioID 	= Par_UsuarioID;



select '000' as NumErr,
	  concat("Datos Eliminados: ", convert(Par_UsuarioID, CHAR))  as ErrMen,
	  'usuarioID' as control,
	  Par_UsuarioID as consecutivo;


END TerminaStore$$