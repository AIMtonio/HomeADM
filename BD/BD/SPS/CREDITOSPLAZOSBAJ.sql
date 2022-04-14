-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSPLAZOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSPLAZOSBAJ`;DELIMITER $$

CREATE PROCEDURE `CREDITOSPLAZOSBAJ`(

	Par_Salida				char(1),
	inout Par_NumErr    int,
	inout Par_ErrMen    varchar(400),
	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
		)
TerminaStore: BEGIN


DECLARE		Cadena_Vacia	char(1);
DECLARE		Entero_Cero		int;
DECLARE		Float_Cero		float;
DECLARE		Decimal_Cero	decimal(12,2);
DECLARE		SalidaSI		char(1);
DECLARE		SalidaNO		char(1);


Set	Cadena_Vacia	:= '';
Set	Entero_Cero		:= 0;
Set	Float_Cero		:= 0.0;
Set	Decimal_Cero	:= 0.0;
set	SalidaSI		:= 'S';
Set	SalidaNO		:= 'N';

Set Aud_FechaActual := CURRENT_TIMESTAMP();

delete
from CREDITOSPLAZOS;


	if (Par_Salida = SalidaSI) then
	select '000' as NumErr,
		  "Plazo Eliminado " as ErrMen,
			 'dias' as control, Entero_Cero as consecutivo;
	end if;
	if (Par_Salida = SalidaNO) then
		set Par_NumErr := 0;
		set Par_ErrMen := 'Plazo Eliminado.';
	end if;
END TerminaStore$$