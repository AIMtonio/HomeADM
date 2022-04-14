-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDMOVSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDMOVSLIS`;DELIMITER $$

CREATE PROCEDURE `CREDITOFONDMOVSLIS`(
	Par_CreditoFondeoID	int,
	Par_NumLista		tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal	int;
DECLARE	Var_Abono		char(1);
DECLARE	Var_Cargo		char(1);



Set	Entero_Cero			:= 0;
Set	Lis_Principal		:= 1;
Set	Var_Abono			:= "A";
Set	Var_Cargo			:= "C";


if(Par_NumLista = Lis_Principal)then
	select	Mov.AmortizacionID,	Mov.FechaOperacion,	Mov.Descripcion,	Tip.Descripcion as DescripTipMov,	Mov.TipoMovFonID,
			Mov.NatMovimiento ,	Case when Mov.NatMovimiento = Var_Abono then "ABONO"
									when Mov.NatMovimiento = Var_Cargo then "CARGO" else  Mov.NatMovimiento end as NatMovimientoDes,
				FORMAT(ifnull(round(Mov.Cantidad,2),Entero_Cero),2) as Cantidad
			from	CREDITOFONDMOVS Mov,
					TIPOSMOVSFONDEO Tip
			where	Mov.CreditoFondeoID	= Par_CreditoFondeoID
			and		Mov.TipoMovFonID	= Tip.TipoMovFonID;
end if;


END TerminaStore$$