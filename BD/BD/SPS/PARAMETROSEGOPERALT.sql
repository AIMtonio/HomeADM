-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSEGOPERALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSEGOPERALT`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSEGOPERALT`(
	Par_TipoPersona		char(1),
	Par_TipoIns			int(11),
	Par_NacCliente		char(1),
	Par_MontoInf		decimal(12,2),
	Par_MonedaComp		int(11),
	Par_FechaIniVig		datetime,
	Par_NivelSeg		int(11),

    Par_Salida    		char(1),
    inout	Par_NumErr 	int,
    inout	Par_ErrMen  varchar(350),

	Par_EmpresaID 		int(11) ,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint  	)
TerminaStore: BEGIN


declare	Cadena_Vacia	char(1);
declare	Fecha_Vacia		date;
declare	Entero_Cero		int;
declare Salida_SI 			char(1);


DECLARE	varTipoPersona	char(1);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
set Salida_SI 	   	:= 'S';



Set Aud_FechaActual := now();

select TipoPersona into varTipoPersona
        from PARAMETROSEGOPER
        where TipoPersona = Par_TipoPersona
		and  NivelSeguimien		=Par_NivelSeg
		and TipoInstrumento		=Par_TipoIns
		and NacCliente			=Par_NacCliente;

	Set varTipoPersona  := ifnull(varTipoPersona, Cadena_Vacia);
	 if(varTipoPersona 	!= Cadena_Vacia ) then
		if (Par_Salida = Salida_SI) then
			select  convert(001, char(10)) as NumErr,
				'El parametro de Seguimiento ya Existe' as ErrMen,
				'tipoPersona' as control,
				(SELECT LPAD(Entero_Cero, 8, 0)) as consecutivo;
				LEAVE TerminaStore;
		end if;
	end if;

insert into PARAMETROSEGOPER (
	TipoPersona,		TipoInstrumento,	NacCliente,			MontoInferior,	MonedaComp,
	FechaInicioVigencia,NivelSeguimien,		EmpresaID,			Usuario,		FechaActual,
	DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
values (
	Par_TipoPersona,	Par_TipoIns,		Par_NacCliente,		Par_MontoInf,	Par_MonedaComp,
	Par_FechaIniVig,	Par_NivelSeg,		Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

set	Par_NumErr := 0;
set	Par_ErrMen := concat("Registro Agregado ");




if (Par_Salida = Salida_SI) then
	select  convert(Par_NumErr, char(10)) as NumErr,
			Par_ErrMen as ErrMen,
			'tipoPersona' as control,
			(SELECT LPAD(Entero_Cero, 8, 0)) as consecutivo;
end if;


END TerminaStore$$