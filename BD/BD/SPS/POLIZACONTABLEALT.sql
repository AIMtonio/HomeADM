-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACONTABLEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACONTABLEALT`;DELIMITER $$

CREATE PROCEDURE `POLIZACONTABLEALT`(
	Par_Poliza			bigint,
	Par_Empresa			int,
	Par_Fecha			Date,
	Par_Tipo			char(1),
	Par_ConceptoID		int(11),
	Par_Concepto		varchar(150),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN
DECLARE Var_PrimerDiaMes	date;
DECLARE Var_EstatusP		char(1);
DECLARE	Salida_SI			char(1);
DECLARE	Entero_Cero			int;
DECLARE EjercicioCerrado	char(1);
Set	Salida_SI				:= 'S';
Set	Entero_Cero				:= 0;
set EjercicioCerrado		:='C';

if(ifnull( Aud_Usuario, Entero_Cero)) = Entero_Cero then
	select '001' as NumErr,
		 'El Usuario no esta logeado' as ErrMen,
		 'inversionID' as control,
		 0 as consecutivo;
	LEAVE TerminaStore;
end if;
set Var_PrimerDiaMes:= convert(DATE_ADD(Par_Fecha, interval -1*(day(Par_Fecha))+1 day),date);
select Estatus 	into Var_EstatusP
	from PERIODOCONTABLE
		where Inicio=Var_PrimerDiaMes;
if(Var_EstatusP = EjercicioCerrado )then
	select '002' as NumErr,
			 'El Periodo Contable para la Fecha Ingresada se encuentra Cerrado.' as ErrMen,
			 'fecha' as control,
			 0 as consecutivo;
		LEAVE TerminaStore;
else
	CALL MAESTROPOLIZAALT(
			Par_Poliza,		Par_Empresa,	Par_Fecha, 		Par_Tipo,		Par_ConceptoID,
			Par_Concepto,	Salida_SI, 		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
end if;

END TerminaStore$$