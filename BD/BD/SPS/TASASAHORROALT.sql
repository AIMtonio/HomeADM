-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAHORROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAHORROALT`;DELIMITER $$

CREATE PROCEDURE `TASASAHORROALT`(
	Par_TipoCuentaID		int(11),
	Par_TipoPersona		char(1),
	Par_MonedaID		int(11),
	Par_MontoInferior	decimal(12,2),
	Par_MontoSuperior	decimal(12,2),
	Par_Tasa			float,

	Aud_EmpresaID		int,
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
DECLARE		Var_MontoSup	float;
DECLARE		Var_MontoInf	float;
DECLARE		Var_Tasa		float;

Set	NumTasaAhorro		:= 0;
Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Float_Cero			:= 0.0;

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

if(Par_MontoInferior>Par_MontoSuperior)then
	select '008' as NumErr,
				'El Monto Inferior no puede ser menor que el Superior.' as ErrMen,
				'montoInferior' as control,
				Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;

select Tasa, MontoInferior, MontoSuperior into Var_Tasa,Var_MontoInf, Var_MontoSup
                 from TASASAHORRO
			where  TipoCuentaID    = Par_TipoCuentaID
			and    MonedaID        = Par_MonedaID
			and    TipoPersona     = Par_TipoPersona
			and    ((MontoInferior <= Par_MontoInferior
					and  MontoSuperior >= Par_MontoInferior)
					or   (MontoInferior <= Par_MontoSuperior
					and   MontoSuperior >= Par_MontoSuperior));


if(Var_Tasa>=0) then
	select '009' as NumErr,
				concat('El Esquema Esta Dentro del Monto Inferior ', Var_MontoInf ,' y  monto Superior ',Var_MontoSup) as ErrMen,
				'montoInferior' as control,
				Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;



set NumTasaAhorro := (select ifnull(Max(TasaAhorroID),Entero_Cero) + 1
				from TASASAHORRO);
Set Aud_FechaActual := CURRENT_TIMESTAMP();
insert into TASASAHORRO values (	NumTasaAhorro,		Par_TipoCuentaID,	Par_TipoPersona,
						Par_MonedaID,		Par_MontoInferior,	Par_MontoSuperior,
						Par_Tasa,
						Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion
					);

select '000' as NumErr,
	  concat("La Tasa de Ahorro se ha Grabado Exitosamente: ", convert(NumTasaAhorro, CHAR))  as ErrMen,
	  'tasaAhorroID'  as control,
	  NumTasaAhorro as consecutivo;

END TerminaStore$$