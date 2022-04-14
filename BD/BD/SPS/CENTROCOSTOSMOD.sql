-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CENTROCOSTOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CENTROCOSTOSMOD`;DELIMITER $$

CREATE PROCEDURE `CENTROCOSTOSMOD`(
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

Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(not exists(select CentroCostoID
			from CENTROCOSTOS
			where CentroCostoID = Par_CCostoID)) then
	select '001' as NumErr,
		 'El C.C. no existe.' as ErrMen,
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

update CENTROCOSTOS set
	Descripcion		= Par_Descripcion,
	Responsable		= Par_Responsable,
	PlazaID		= Par_PlazaID,
	EmpresaID		= Par_EmpresaID,

	Usuario		= Aud_Usuario,
	FechaActual 	= Aud_FechaActual,
	DireccionIP 	= Aud_DireccionIP,
	ProgramaID  	= Aud_ProgramaID,
	Sucursal		= Aud_Sucursal,
	NumTransaccion	= Aud_NumTransaccion

where CentroCostoID = Par_CCostoID;

select '000' as NumErr ,
	  concat('Centro de Costo Modificado: ',Par_CCostoID) as ErrMen,
	  'centroCostoID' as control;

END TerminaStore$$