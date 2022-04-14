-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMPLEADOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMPLEADOSBAJ`;DELIMITER $$

CREATE PROCEDURE `EMPLEADOSBAJ`(
	Par_EmpleadoID		int,
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

if(ifnull(Par_EmpleadoID,Entero_Cero)) = Entero_Cero then
	select '001' as NumErr,
		 'El Numero de empleado esta vacio.' as ErrMen,
		 'empleadoID' as control;
	LEAVE TerminaStore;
end if;



Set Aud_FechaActual := CURRENT_TIMESTAMP();

delete from  EMPLEADOS
where EmpleadoID = Par_EmpleadoID;



select '000' as NumErr ,
		  'Empleado Eliminado.' as ErrMen,
		  'empleadoID' as control;

END TerminaStore$$