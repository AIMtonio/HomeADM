-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALIDAAHORROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDAAHORROPRO`;DELIMITER $$

CREATE PROCEDURE `VALIDAAHORROPRO`(
	Par_Anio			int,
	Par_Mes				int(2),
	Par_NumMeses		int(2),
	Par_CuentaAhoID		bigint(12),
	Par_Monto			decimal(14,2),
	out	Par_Aceptable	char(1),

	Par_Salida              char(1),
	inout Par_NumErr        int,
	inout Par_ErrMen        varchar(400),

	Par_EmpresaID           int(11),
	Aud_Usuario             int,
	Aud_FechaActual         DateTime,
	Aud_DireccionIP         varchar(15),
	Aud_ProgramaID          varchar(50),
	Aud_Sucursal            int(11),
	Aud_NumTransaccion      bigint(20)

)
TerminaStore:BEGIN

DECLARE Var_FechaActual			date;
DECLARE Var_FechaInicial		date;
DECLARE	Var_FechaFinal			date;
DECLARE	Var_CantMeseAhoFrec		int;


DECLARE Var_UltimoDiaMesAct		date;
DECLARE Var_FechaFinalHist		date;
declare Var_FechaInicialUltDia	date;

DECLARE Var_FechaFinalUltDia	date;
DECLARE Var_NumMesesAhoFrec		int;
DECLARE Var_NumMesesAhoFrecHis	int;
DECLARE Var_NumMesesAhoFrecAct	int;

DECLARE PrimerDiaMes			char(2);
DECLARE Entero_Cero				int;

set PrimerDiaMes				:='01';
set Entero_Cero					:=0;

ManejoErrores: BEGIN

	If Par_NumMeses > 0 and Par_Monto > 0 then

			set Var_FechaActual			:=(select FechaSistema from PARAMETROSSIS LIMIT 1);

			set	Var_FechaInicial		:= DATE(CONCAT(cast(year(Var_FechaActual) as char),"-",cast(Par_Mes as char),"-",PrimerDiaMes));
			set	Var_FechaInicial		:= DATE_ADD(Var_FechaInicial,INTERVAL ((Par_NumMeses-1) * -1) MONTH);

			set	Var_FechaFinal		:= DATE_ADD(Var_FechaInicial,INTERVAL Par_NumMeses MONTH);
			set	Var_FechaFinal		:= DATE_ADD(Var_FechaFinal,INTERVAL -1 DAY);



			select count(CuentaAhoID)
						into Var_NumMesesAhoFrecHis
					from `HIS-CUENTASAHO`
					where	CuentaAhoID = Par_CuentaAhoID
					  and Fecha >=  Var_FechaInicial
					  and Fecha <=  Var_FechaFinal
					  and case when (AbonosMes) < Entero_Cero then Entero_Cero
							else	(AbonosMes) end  >= Par_Monto ;

			set	Var_NumMesesAhoFrecHis		:= ifnull(Var_NumMesesAhoFrecHis, Entero_Cero);


			if(month(Var_FechaActual)  <= month(Var_FechaFinal))then

					select count(CuentaAhoID)
						into Var_NumMesesAhoFrecAct
					from CUENTASAHO
					where  CuentaAhoID= Par_CuentaAhoID
					  and	case when (AbonosMes) < Entero_Cero then Entero_Cero
							else (AbonosMes) end  >= Par_Monto ;


			end if;

			set	Var_NumMesesAhoFrecAct		:= ifnull(Var_NumMesesAhoFrecAct, Entero_Cero);

			set Var_NumMesesAhoFrec := Var_NumMesesAhoFrecHis + Var_NumMesesAhoFrecAct;

			if (Var_NumMesesAhoFrec  >= Par_NumMeses)then
				set Par_Aceptable	:='S';
				set Par_NumErr	:= 0;
				set Par_ErrMen	:= 'Meses de Ahorro Constante Validado(s) Correctamente';
			else
				set Par_Aceptable	:= 'N';
				set Par_NumErr		:= 2;
				set Par_ErrMen		:= Concat('Existen ',Var_NumMesesAhoFrec, ' de ',Par_NumMeses , ' Meses de Ahorro Frecuente.') ;
			end if;
	else

		set Par_Aceptable	:='S';
		set Par_NumErr		:= 0;
		set Par_ErrMen		:= 'Meses de Ahorro Constante Validado(s) Correctamente';
	end if;

END ManejoErrores;



END TerminaStore$$