-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUESTOSACT`;DELIMITER $$

CREATE PROCEDURE `PUESTOSACT`(
	Par_ClavePuestoID		varchar(10),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
Declare	Estatus_Pto		char(1);



Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set Estatus_Pto			:= 'B';




if(not exists(select ClavePuestoID
			from PUESTOS
			where ClavePuestoID = Par_ClavePuestoID)) then
	select '001' as NumErr,
		 'El Puesto no existe.' as ErrMen,
		 'clavePuestoID' as control;
	LEAVE TerminaStore;
end if;



if(not exists(select P.ClavePuestoID
			from PUESTOS P
			inner join EMPLEADOS E on P.ClavePuestoID=E.ClavePuestoID
			where P.ClavePuestoID = Par_ClavePuestoID
			and E.Estatus='A')) then
				update PUESTOS set

	Estatus 			= Estatus_Pto,

	EmpresaID		= Aud_EmpresaID,
	Usuario			= Aud_Usuario,
	FechaActual 		= Aud_FechaActual,
	DireccionIP 		= Aud_DireccionIP,
	ProgramaID  		= Aud_ProgramaID,
	Sucursal			= Aud_Sucursal,
	NumTransaccion	= Aud_NumTransaccion

where ClavePuestoID= Par_ClavePuestoID;

	select '0' as NumErr,
		   'El Puesto se ha Dado de Baja.' as ErrMen,
		   'clavePuestoID' as control;

else
	select '002' as NumErr,
		   'Imposible Eliminar, el Puesto tiene empleados Activos.' as ErrMen,
		   'clavePuestoID' as control;
end if;

END TerminaStore$$