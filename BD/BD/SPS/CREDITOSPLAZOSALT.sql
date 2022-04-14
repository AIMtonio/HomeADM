-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSPLAZOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSPLAZOSALT`;DELIMITER $$

CREATE PROCEDURE `CREDITOSPLAZOSALT`(
	Par_Dias				int,
	Par_Descripcion 		varchar(50),
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
DECLARE		NumPlazo		int;


Set	Cadena_Vacia	:= '';
Set	Entero_Cero		:= 0;
Set	Float_Cero		:= 0.0;
Set	Decimal_Cero	:= 0.0;
set	SalidaSI		:= 'S';
Set	SalidaNO		:= 'N';

Set Aud_FechaActual := CURRENT_TIMESTAMP();


if(ifnull( Par_Dias, Entero_Cero)) = Entero_Cero then

	if (Par_Salida = SalidaSI) then
		select '001' as NumErr,
			 'El no. de Dias esta vacio' as ErrMen,
			 'dias' as control,
			 0 as consecutivo;
	end if;
	if (Par_Salida = SalidaNO) then
		set Par_NumErr := 1;
		set Par_ErrMen := 'El no. de Dias esta vacio';
	end if;

	LEAVE TerminaStore;
end if;

if (ifnull( Par_Descripcion, Entero_Cero)) = Entero_Cero then
	if (Par_Salida = SalidaSI) then
		select '002' as NumErr,
			'La Descripcion esta Vacia.' as ErrMen,
			'descripcion' as control,
			0 as consecutivo;
	end if;
	if (Par_Salida = SalidaNO) then
		set Par_NumErr := 2;
		set Par_ErrMen := 'La Descripcion esta Vacia.';
	end if;
	LEAVE TerminaStore;
end if;

set NumPlazo := (select ifnull(Max(PlazoID),Entero_Cero) + 1 from CREDITOSPLAZOS);

insert CREDITOSPLAZOS (
					PlazoID,			Dias, 				Descripcion, 		EmpresaID, 		Usuario,
					FechaActual,		DireccionIP, 		ProgramaID, 		Sucursal, 		NumTransaccion)
			VALUES (
					NumPlazo,			Par_Dias,			Par_Descripcion,	Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


	if (Par_Salida = SalidaSI) then
	select '000' as NumErr,
		  "Plazo Agregado " as ErrMen,
			 'plazoID' as control, NumPlazo as consecutivo;
	end if;
	if (Par_Salida = SalidaNO) then
		set Par_NumErr := 0;
		set Par_ErrMen := 'Plazo Agregado.';
	end if;
END TerminaStore$$