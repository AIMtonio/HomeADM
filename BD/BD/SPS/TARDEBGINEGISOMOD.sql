-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGINEGISOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGINEGISOMOD`;DELIMITER $$

CREATE PROCEDURE `TARDEBGINEGISOMOD`(
	Par_GiroID			int(11),
	Par_Descripcion		varchar(500),
	Par_NombreCorto     varchar(30),
	Par_Estatus		    char(1),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		   int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Estatus_Activo	char(1);
DECLARE	Estatus_Cancel	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE  Modificar       int;

Set	Estatus_Activo	:= 'A';
Set   Estatus_Cancel  := 'C';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

Set    Aud_FechaActual	:= NOW();
set    Modificar :=1;


if not exists(select GiroID
			from TARDEBGIROSNEGISO
                where GiroID = Par_GiroID) then
	select '001' as NumErr,
		 'El Giro de Negocio no Existe.' as ErrMen,
		 'giroID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		 'Especifique la Descripcion.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NombreCorto, Cadena_Vacia)) = Cadena_Vacia then
	select '003' as NumErr,
		 'Especifique el Nombre Corto.' as ErrMen,
		 'nombreCorto' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Estatus, Cadena_Vacia)) = Cadena_Vacia then
	select '004' as NumErr,
		 'Especifique el Estatus.' as ErrMen,
		 'estatus' as control;
	LEAVE TerminaStore;
end if;


update TARDEBGIROSNEGISO set
	Descripcion		= Par_Descripcion,
   Nombrecorto    =Par_NombreCorto,
	Estatus		= Par_Estatus,

	EmpresaID		= Aud_EmpresaID,
	Usuario		= Aud_Usuario,
	FechaActual 	= Aud_FechaActual,
	DireccionIP 	= Aud_DireccionIP,
	ProgramaID  	= Aud_ProgramaID,
	Sucursal		= Aud_Sucursal,
	NumTransaccion	= Aud_NumTransaccion
where GiroID = Par_GiroID;

select '000' as NumErr ,
	  'Giro de Negocio Modificado Exitosamente.' as ErrMen,
	  'giroID' as control,
      Entero_Cero as consecutivo;
END TerminaStore$$