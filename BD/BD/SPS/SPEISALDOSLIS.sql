-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEISALDOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEISALDOSLIS`;DELIMITER $$

CREATE PROCEDURE `SPEISALDOSLIS`(
	Par_EmpresaID		int,
	Par_NumLis			tinyint unsigned,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(20),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

)
TerminaStore: BEGIN

DECLARE Var_FechaActual     date;


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Lis_Principal 		int;


Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
Set	Lis_Principal			:= 4;




if(Par_NumLis = Lis_Principal) then
	select  SaldoActual,	SaldoReservado,	MontoDisponible,	BalanceCuenta
			from SPEISALDOS
		   where EmpresaID	= Par_EmpresaID;
end if;


END TerminaStore$$