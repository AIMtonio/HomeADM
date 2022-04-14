-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROIDEMENSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROIDEMENSACT`;DELIMITER $$

CREATE PROCEDURE `COBROIDEMENSACT`(


		Par_CuentaAhoID	bigint (12),
		Par_PeriodoID		int,
		Par_CantidadMov	decimal(12,2)
			)
TerminaStore: BEGIN


DECLARE	Entero_Cero		int;
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);
DECLARE	Var_Si			char(1);
DECLARE 	Var_MovIDE		varchar(4);
DECLARE 	Var_MovIDE2		varchar(4);


declare Var_PeriodoVigente int;



Set	Entero_Cero		:= 0;
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';
Set	Var_Si			:= 'S';
Set	Var_MovIDE		:= '221';
Set	Var_MovIDE2		:= 'IDE';


set Var_PeriodoVigente := (select PeriodoVigente from PARAMETROSSIS );





update 	COBROIDEMENS CIM,
		TMPCUENTASAHOCI TCA
	set
		CIM.CantidadCob 	= CIM.CantidadCob + Par_CantidadMov,
		CIM.CantidadPen 	= CIM.CantidadPen - Par_CantidadMov,
		TCA.CargosDia		= TCA.CargosDia	 + Par_CantidadMov ,
		TCA.CargosMes		= TCA.CargosMes	 + Par_CantidadMov ,
		TCA.SaldoDispon	= TCA.SaldoDispon - Par_CantidadMov,
		TCA.Saldo		= TCA.Saldo		- Par_CantidadMov
	WHERE CIM.ClienteID	= TCA.ClienteID
	and 	TCA.CuentaAhoID	= Par_CuentaAhoID
	and	CIM.PeriodoID		= Par_PeriodoID
	and	TCA.PagaIDE		=  Var_Si
	and TCA.NumTransaccion = CIM.NumTransaccion;


END TerminaStore$$