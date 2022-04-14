-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAARCHIVOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAARCHIVOSBAJ`;DELIMITER $$

CREATE PROCEDURE `POLIZAARCHIVOSBAJ`(
	Par_PolizaArID			int(11),
	Par_TipoBaja			int(11),

	Par_Salida				char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(400),

	Par_EmpresaID			int(11),
	Aud_Usuario				int(11),
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		Bigint(20)

	)
TerminaStore:BEGIN


DECLARE 	tipoPrincipal		int(11);
DECLARE	Entero_Cero			int;
DECLARE 	SalidaSI			char(1);


set tipoPrincipal		:=1;
set	Entero_Cero			:=0;
set	SalidaSI			:='S';


ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
										"estamos trabajando para resolverla. Disculpe las molestias que ",
										"esto le ocasiona. Ref: SP-POLIZAARCHIVOSBAJ");
				END;

if(Par_TipoBaja = tipoPrincipal) then
		delete from POLIZAARCHIVOS
		where PolizaArchivosID = Par_PolizaArID;

	if Par_Salida = SalidaSI then
			select	'000' as NumErr,
					concat("Archivo Eliminado con Exito: ",cast(Par_PolizaArID as char)) as ErrMen,
					'' as control,
					Entero_Cero	as consecutivo;
		end if;
		LEAVE ManejoErrores;
end if;




END ManejoErrores;

END TerminaStore$$