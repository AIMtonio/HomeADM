-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-EFECTIVOMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-EFECTIVOMOVALT`;DELIMITER $$

CREATE PROCEDURE `HIS-EFECTIVOMOVALT`(
		)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero	int;
DECLARE	Considerada	char(1);


Set	Cadena_Vacia	:= '';
Set	Entero_Cero	:= 0;
Set	Considerada	:= 'S';


insert into `HIS-EFECTIVOMOV` (
		CuentasAhoID, 	ClienteID,		NumeroMov, 		Fecha, 			NatMovimiento,
		CantidadMov, 		DescripcionMov, 	ReferenciaMov, 	TipoMovAhoID, 	MonedaID,
		Estatus, 		EmpresaID, 		Usuario, 		FechaActual,		DireccionIP,
		ProgramaID, 		Sucursal, 		NumTransaccion
	)
select 	CuentasAhoID, 	ClienteID,		NumeroMov, 		Fecha, 			NatMovimiento,
		CantidadMov, 		DescripcionMov, 	ReferenciaMov, 	TipoMovAhoID, 	MonedaID,
		Estatus, 		EmpresaID, 		Usuario, 		FechaActual,		DireccionIP,
		ProgramaID, 		Sucursal, 		NumTransaccion
from 	EFECTIVOMOVS
where 	Estatus = Considerada;

delete from EFECTIVOMOVS where Estatus = Considerada;


END TerminaStore$$