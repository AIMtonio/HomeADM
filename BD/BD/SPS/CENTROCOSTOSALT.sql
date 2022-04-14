-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CENTROCOSTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CENTROCOSTOSALT`;DELIMITER $$

CREATE PROCEDURE `CENTROCOSTOSALT`(
	Par_CCostoID		int,
	Par_Descripcion		varchar(100),
	Par_Responsable		varchar(100),
	Par_PlazaID			int,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	NumeroPlaza		int;

Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

if(ifnull(Par_CCostoID,Entero_Cero)) = Entero_Cero then
	select '001' as NumErr,
		 'El Numero de C.C. esta Vacio.' as ErrMen,
		 'centroCostoID' as control;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Responsable, Cadena_Vacia)) = Cadena_Vacia then
	select '003' as NumErr,
		 'El responsable esta Vacio.' as ErrMen,
		 'responsable' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_PlazaID, Entero_Cero)) = Entero_Cero then
	select '004' as NumErr,
		 'La Plaza esta Vacia.' as ErrMen,
		 'plazaID' as control;
	LEAVE TerminaStore;
end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into CENTROCOSTOS values  (Par_CCostoID, 	Par_EmpresaID, 	Par_Descripcion,
						Par_Responsable,	Par_PlazaID,	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,	Aud_NumTransaccion);



select '000' as NumErr,
	  concat("Centro de Costos Agregado: ", convert(Par_CCostoID, CHAR))  as ErrMen,
	  'centroCostoID	' as control;

END TerminaStore$$