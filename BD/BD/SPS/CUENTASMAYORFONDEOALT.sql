-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORFONDEOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORFONDEOALT`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORFONDEOALT`(
	Par_ConceptoFonID		int(11),
   Par_TipoFondeador    char(1),
	Par_Cuenta				varchar(12),
	Par_Nomenclatura		varchar(30),

	Par_Salida				char(1),
	inout	Par_NumErr 		int,
	inout	Par_ErrMen  	varchar(350),

	Aud_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
	)
TerminaStore:BEGIN


DECLARE Cadena_Vacia		char(1);
DECLARE Entero_Cero			int;
DECLARE Decimal_Cero		decimal;
DECLARE SalidaSI			char(1);

set Cadena_Vacia		:='';
set Entero_Cero			:=0;
set Decimal_Cero		:=0.0;
set SalidaSI			:='S';

ManejoErrores:BEGIN

if(Par_Cuenta = Cadena_Vacia)then
		set	Par_NumErr 	:= 2;
		set	Par_ErrMen	:= "La Cuenta esta vacia";
		LEAVE ManejoErrores;
end if;
if(Par_Nomenclatura = Cadena_Vacia)then
		set	Par_NumErr 	:= 2;
		set	Par_ErrMen	:= "La Nomenclatura esta vacia";
		LEAVE ManejoErrores;
end if;


set Aud_FechaActual := CURRENT_TIMESTAMP();

 insert into CUENTASMAYORFONDEO
			values(	Par_ConceptoFonID,Par_TipoFondeador,Par_Cuenta,Par_Nomenclatura,
					Aud_EmpresaID, Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);
		set	Par_NumErr 	:= 0;
		set	Par_ErrMen	:= "Cuenta Mayor Agregada Correctamente";

END ManejoErrores;
if (Par_Salida = SalidaSI) then
	select  convert(Par_NumErr, char(10)) as NumErr,
			Par_ErrMen as ErrMen,
			'cuenta' as control,
			Entero_Cero as consecutivo;
end if;
END  TerminaStore$$