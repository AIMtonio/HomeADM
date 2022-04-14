-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSLINEAFONDEAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSLINEAFONDEAALT`;DELIMITER $$

CREATE PROCEDURE `TIPOSLINEAFONDEAALT`(
	Par_DescTipoLin		varchar(50),
	Par_InstitutFondID	int(11),


	Par_Salida				char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

	DECLARE	tipoFodeador		int;
	DECLARE Entero_Cero     	int;
	DECLARE Decimal_Cero      	decimal(12,2);
	DECLARE	Cadena_Vacia		char(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE	consecutivo			int;

	set Entero_Cero 			:=0;
	Set Cadena_Vacia			:= '';
	set Decimal_Cero 			:=0.00;
	set SalidaSI				:='S';
	set SalidaNO				:='N';


	if(ifnull(Par_DescTipoLin, Cadena_Vacia))= Cadena_Vacia then
		if(Par_Salida = SalidaSI)then
			select '002' as NumErr,
				'La descripcion del Tipo de Linea esta Vacia.' as ErrMen,
				'TipoLinFondeaID'  as control,
				Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = SalidaNO)then
			set	 Par_NumErr := 2;
			set  Par_ErrMen := 'La descripcion del Tipo de Linea esta Vacia.';
		end if;
	end if;

	if(ifnull(Par_institutFondID, Entero_Cero))= Entero_Cero then
		if(Par_Salida = SalidaSI)then
			select '003' as NumErr,
				'El Número de Institución esta vacio.' as ErrMen,
				'TipoLinFondeaID'  as control,
				Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = SalidaNO)then
			set	 Par_NumErr := 3;
			set  Par_ErrMen :='El Número de Institución esta vacio.';
		end if;
	end if;
set consecutivo := (SELECT ifnull(COUNT(*),0)+1 FROM TIPOSLINEAFONDEA);
set Aud_FechaActual := CURRENT_TIMESTAMP();

if not exists (select InstitutFondID from INSTITUTFONDEO
						where InstitutFondID=Par_InstitutFondID)then
		if(Par_Salida = SalidaSI)then
			select '004' as NumErr,
				'El Número de Institución no existe.' as ErrMen,
				'TipoLinFondeaID'  as control,
				Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = SalidaNO)then
			set	 Par_NumErr := 3;
			set  Par_ErrMen :='El Número de Institución no existe.';
		end if;
	end if;
INSERT TIPOSLINEAFONDEA values (consecutivo,	 Par_InstitutFondID,	Par_DescTipoLin, Aud_EmpresaID,	Aud_Usuario,
							    Aud_FechaActual, Aud_DireccionIP,       Aud_ProgramaID,	 Aud_Sucursal,	Aud_NumTransaccion);


	if(Par_Salida = SalidaSI)then
		select	'000' as NumErr ,
			concat("Tipo de Linea Agregada: ", convert(consecutivo, CHAR))  as ErrMen,
			'tipoLinFondeaID'  as control,
			consecutivo as consecutivo;
		else
		Set Par_NumErr := 0;
		Set Par_ErrMen := concat("Tipo de Linea Agregada: ", convert(consecutivo, CHAR));
	end if;


END TerminaStore$$