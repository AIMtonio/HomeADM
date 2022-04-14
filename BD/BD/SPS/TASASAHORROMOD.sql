-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAHORROMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAHORROMOD`;DELIMITER $$

CREATE PROCEDURE `TASASAHORROMOD`(
	Par_TasaAhorroID		int(11),
	Par_TipoCuentaID		int(11),
	Par_TipoPersona		char(1),
	Par_MonedaID		int(11),
	Par_MontoInferior	decimal(12,2),
	Par_MontoSuperior	decimal(12,2),
	Par_Tasa			float,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		NumTasaAhorro	int;
DECLARE		Cadena_Vacia	char(1);
DECLARE		Entero_Cero		int;
DECLARE		Float_Cero		float;

Set	NumTasaAhorro		:= 0;
Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Float_Cero			:= 0.0;

if(ifnull(Par_TasaAhorroID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Numero de Tasa de Ahorro esta Vacio.' as ErrMen,
		 'tasaAhorroID' as control,
		 Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoCuentaID, Entero_Cero))= Entero_Cero then
	select '002' as NumErr,
		 'El Tipo de Cuenta esta Vacio.' as ErrMen,
		 'tipoCuentaID' as control,
		  Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoPersona,Cadena_Vacia)) = Cadena_Vacia then
	select '003' as NumErr,
		 'El Tipo de Persona esta Vacio.' as ErrMen,
		 'tipoPersona' as control,
		  Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_MonedaID, Entero_Cero))= Entero_Cero then
	select '004' as NumErr,
		 'El tipo de Moneda esta Vacio.' as ErrMen,
		 'monedaID' as control,
		  Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_MontoInferior, Float_Cero))= Float_Cero then
	select '005' as NumErr,
			 'El Monto Inferior esta Vacio.' as ErrMen,
			 'montoInferior' as control,
				Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_MontoSuperior, Float_Cero))= Float_Cero then
	select '006' as NumErr,
			 'El Monto Superior esta Vacio.' as ErrMen,
			 'montoSuperior' as control,
				Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Tasa, Float_Cero))= Float_Cero then
	select '007' as NumErr,
			 'La Tasa esta Vacia.' as ErrMen,
			 'tasa' as control,
				Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;
Set Aud_FechaActual := CURRENT_TIMESTAMP();
update 	TASASAHORRO 	set
		TipoCuentaID	= Par_TipoCuentaID,
		TipoPersona		= Par_TipoPersona,
		MonedaID		= Par_MonedaID,
		MontoInferior	= Par_MontoInferior,
		MontoSuperior	= Par_MontoSuperior,
		Tasa			= Par_Tasa,

		EmpresaID		= Aud_EmpresaID,
		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
where		TasaAhorroID 	= Par_TasaAhorroID;


select '000' as NumErr,
	  concat("Tasa de Ahorro Modificada Exitosamente: ", convert(Par_TasaAhorroID, CHAR))  as ErrMen,
	  'tasaAhorroID' as control,
	  Par_TasaAhorroID as consecutivo;

END TerminaStore$$