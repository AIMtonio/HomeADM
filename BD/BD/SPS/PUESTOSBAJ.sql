-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUESTOSBAJ`;DELIMITER $$

CREATE PROCEDURE `PUESTOSBAJ`(
	Par_ClavePuestoID		varchar(10),
	Par_Descripcion 		varchar(100),
	Par_AtiendeSuc		char(1),

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



if(ifnull(Par_ClavePuestoID,Cadena_Vacia)) = Cadena_Vacia then
	select '001' as NumErr,
		 'La Clave del Puesto está vacia.' as ErrMen,
		 'clavePuestoID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();


delete from  PUESTOS
where ClavePuestoID = Par_ClavePuestoID;



select '000' as NumErr ,
		  'Puesto Eliminado.' as ErrMen,
		  'clavePuestoID' as control;

END TerminaStore$$