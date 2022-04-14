-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPARAINSTRUMMALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPARAINSTRUMMALT`;DELIMITER $$

CREATE PROCEDURE `HISPARAINSTRUMMALT`(

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN



DECLARE Var_Consecutivo		int(11);
DECLARE Var_InstrumentMon		int(11);
DECLARE Var_TipoInstruMon		int(11);
DECLARE Var_FechaInicio		Date;
DECLARE Var_FechaFinVig		Date;


DECLARE Cadena_Vacia			char(1);
DECLARE Entero_Cero			int;
DECLARE SalidaNO				char(1);
DECLARE SalidaSI				char(1);



Set Cadena_Vacia				:= '';
Set Entero_Cero				:= 0;
Set SalidaNO					:='N';
Set SalidaSI					:='S';


Set Var_Consecutivo		:= (select ifnull(Max(ConsecutivoID),Entero_Cero)+1
				    		from HISPARAINSTRUMM );

Set Var_FechaFinVig		:= (select FechaSistema from PARAMETROSSIS);


select 				InstrumentMonID,		TipoInstruMonID,		FechaInicio
	           into 	Var_InstrumentMon, 	Var_TipoInstruMon,	Var_FechaInicio
			  FROM	PARAINSTRUMMON;


insert into HISPARAINSTRUMM	(	ConsecutivoID,	InstrumentMonID,		TipoInstruMonID,		FechaInicio,		FechaFin,
								EmpresaID,		Usuario,				FechaActual,			DireccionIP,		ProgramaID,
								Sucursal,		NumTransaccion)

			values 		(	Var_Consecutivo,		Var_InstrumentMon,	Var_TipoInstruMon,	Var_FechaInicio,	Var_FechaFinVig,
							Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,			Aud_NumTransaccion);



CALL PARAINSTRUMMONBAJ	(	Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,			Aud_NumTransaccion
							);





select  '000' as NumErr,
        'Parámetro agregado Correctamente ' as ErrMen,
		 '' as control,
        '' as consecutivo;


END TerminaStore$$