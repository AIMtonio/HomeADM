-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPARAMOPRELALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPARAMOPRELALT`;DELIMITER $$

CREATE PROCEDURE `HISPARAMOPRELALT`(

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN



DECLARE Var_Consecutivo		int;
DECLARE Var_FechaFinVig		Date;
DECLARE Var_MonedaLimOPR		int(11);
DECLARE Var_LimiteInferior		decimal(12,2);
DECLARE Var_FechaInicioVig		Date;
DECLARE Var_LimMensualMicro	decimal(12,2);
DECLARE Var_MonedaLimMicro		int(11);


DECLARE Cadena_Vacia			char(1);
DECLARE Entero_Cero			int;
DECLARE SalidaNO				char(1);
DECLARE SalidaSI				char(1);



Set Cadena_Vacia				:= '';
Set Entero_Cero				:= 0;
Set SalidaNO					:='N';
Set SalidaSI					:='S';


Set Var_Consecutivo		:= (select ifnull(Max(ConsecutivoID),Entero_Cero) from HISPARAMOPREL );
set Var_Consecutivo      := ifnull(Var_Consecutivo, Entero_Cero) + 1;

Set Var_FechaFinVig		:= (select FechaSistema from PARAMETROSSIS);


select 				MonedaLimOPR,		LimiteInferior,		FechaInicioVig,		LimMensualMicro,		MonedaLimMicro
					into 			Var_MonedaLimOPR, 	Var_LimiteInferior,	Var_FechaInicioVig,	Var_LimMensualMicro, Var_MonedaLimMicro
					FROM PARAMETROSOPREL;


insert into HISPARAMOPREL	(	ConsecutivoID,       MonedaLimOPR,			LimiteInferior,		FechaInicioVig,		FechaFinVig,
							LimMensualMicro,		MonedaLimMicro,		EmpresaID,			Usuario,				FechaActual,
							DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion
							)
			values 		(	Var_Consecutivo,		Var_MonedaLimOPR,		Var_LimiteInferior,	Var_FechaInicioVig,	Var_FechaFinVig,
							Var_LimMensualMicro,	Var_MonedaLimMicro,	Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
							Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);



CALL PARAMETROSOPRELBAJ	(	Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,			Aud_NumTransaccion
							);

select  '000' as NumErr,
        'Parámetro agregado Correctamente ' as ErrMen,
		 '' as control,
        '' as consecutivo;


END TerminaStore$$