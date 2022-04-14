-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAINSTRUMMONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAINSTRUMMONALT`;DELIMITER $$

CREATE PROCEDURE `PARAINSTRUMMONALT`(

	Par_InstrumentMonID int,
	Par_TipoInstruMonID int,

	Par_EmpresaID		int,
	Aud_Usuario		int,
	Aud_FechaActual	DateTime,
	Aud_DireccionIP	varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN


DECLARE Var_FechaInicio Date;


DECLARE Cadena_Vacia     char(1);
DECLARE Entero_Cero      int;
DECLARE Fecha_Vacia		date;


Set Cadena_Vacia		:= '';
Set Entero_Cero		:= 0;
Set Fecha_Vacia		:='1900-01-01';


Set Var_FechaInicio		:= (select FechaSistema from PARAMETROSSIS);

if(ifnull( Par_TipoInstruMonID, Entero_Cero)) = Entero_Cero then
select  '001' as NumErr,
        'Seleccione un Tipo de Instrumento ' as ErrMen,
		 'tipoInstruMonID' as control,
        Par_TipoInstruMonID as consecutivo;
LEAVE TerminaStore;
end if;

insert into PARAINSTRUMMON(	InstrumentMonID,		TipoInstruMonID,		FechaInicio,		EmpresaID,	Usuario,
						FechaActual,			DireccionIP,			ProgramaID,		Sucursal,		NumTransaccion
						)

			    values   (	Par_InstrumentMonID,	Par_TipoInstruMonID,	Var_FechaInicio,	Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
							);

select  '000' as NumErr,
        'Parámetro agregado Correctamente ' as ErrMen,
		 'instrumentMonID' as control,
        Par_InstrumentMonID as consecutivo;

END TerminaStore$$