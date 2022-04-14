-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMPLEADOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMPLEADOSACT`;DELIMITER $$

CREATE PROCEDURE `EMPLEADOSACT`(
	Par_EmpleadoID		varchar(10),

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
Declare	Estatus_Emp		char(1);



Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set Estatus_Emp			:= 'I';




if(not exists(select EmpleadoID
			from EMPLEADOS
			where EmpleadoID = Par_EmpleadoID)) then
	select '001' as NumErr,
		 'El empleado no existe.' as ErrMen,
		 'empleadoID' as control;
	LEAVE TerminaStore;
end if;


update EMPLEADOS set

	Estatus 			= Estatus_Emp,

	EmpresaID		= Aud_EmpresaID,
	Usuario			= Aud_Usuario,
	FechaActual 		= Aud_FechaActual,
	DireccionIP 		= Aud_DireccionIP,
	ProgramaID  		= Aud_ProgramaID,
	Sucursal			= Aud_Sucursal,
	NumTransaccion	= Aud_NumTransaccion

where EmpleadoID= Par_EmpleadoID;

	select '0' as NumErr,
		   'El Empleado se ha Dado de Baja.' as ErrMen,
		   'empleadoID' as control;

END TerminaStore$$