-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROIDEMENSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROIDEMENSALT`;DELIMITER $$

CREATE PROCEDURE `COBROIDEMENSALT`(


	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Entero_Cero		int;
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);
DECLARE	Var_Si			char(1);
DECLARE	No_Considerada	char(1);
DECLARE	Considerada		char(1);


declare Var_PeriodoVigente int;
declare Var_MontoExcIDE	decimal(12,2);
declare Var_TasaIDE		decimal(12,2);
declare Var_FechaSistema  date;


Set	Entero_Cero		:= 0;
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';
Set	Var_Si			:= 'S';
Set	No_Considerada	:= 'N';
Set	Considerada		:= 'S';


select MontoExcIDE, TasaIDE , month(FechaSistema), FechaSistema
	into Var_MontoExcIDE, Var_TasaIDE, Var_PeriodoVigente, Var_FechaSistema
	from PARAMETROSSIS;



insert into COBROIDEMENS (
		ClienteID,		PeriodoID,			Cantidad,			MontoIDE,			CantidadCob,
		CantidadPen,	FechaCorte,			EmpresaID, 			Usuario, 			FechaActual,
		DireccionIP,	ProgramaID,			Sucursal, 			NumTransaccion
		)
select 	E.ClienteID,		Var_PeriodoVigente,		E.CantidadMov,		E.CantidadMov* Var_TasaIDE as MontoIDE,
		Entero_Cero,		Entero_Cero,			Var_FechaSistema,	Par_EmpresaID,
		Aud_Usuario, 		Aud_FechaActual, 		Aud_DireccionIP, 	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion
from 	(
	select 	E.ClienteID,
			CASE WHEN ((sum(E.CantidadMov)-ifnull(DP.MontoAplicado,Entero_Cero))> Var_MontoExcIDE)
				THEN (sum(E.CantidadMov)-ifnull(DP.MontoAplicado,Entero_Cero)) - Var_MontoExcIDE else Entero_Cero END AS CantidadMov
		from EFECTIVOMOVS E
		left outer JOIN (select ClienteID, sum(MontoDeposito), ifnull(sum(MontoAplicado),Entero_Cero) as MontoAplicado
				from DEPOSITOPAGOCRE
				group by ClienteID) as DP ON (E.ClienteID = DP.ClienteID)
		where 	NatMovimiento = Nat_Abono
		and 		Estatus	     = No_Considerada
		group by	E.ClienteID,  DP.ClienteID) as E,
		TMPCUENTASAHOCI as T
where E.CantidadMov > Entero_Cero
	and 	T.ClienteID = E.ClienteID
	and T.PagaIDE = Var_Si
	group by T.ClienteID;


UPDATE EFECTIVOMOVS set
	Estatus = Considerada
where NatMovimiento = Nat_Abono
and 	Estatus	     = No_Considerada;

END TerminaStore$$