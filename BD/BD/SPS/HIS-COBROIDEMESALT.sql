-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-COBROIDEMESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-COBROIDEMESALT`;DELIMITER $$

CREATE PROCEDURE `HIS-COBROIDEMESALT`(
		)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero	int;
DECLARE	Decimal_Cero	Decimal (12,2);


Set	Cadena_Vacia	:= '';
Set	Entero_Cero	:= 0;
Set	Decimal_Cero	:= 0.0;


insert into `HIS-COBROIDEMENS` (
		ClienteID,		PeriodoID,		Cantidad,		MontoIDE,		CantidadCob,
		CantidadPen,		EmpresaID, 		Usuario, 		FechaActual, 		DireccionIP,
 		ProgramaID,		Sucursal, 		NumTransaccion
	)
SELECT 	ClienteID,		PeriodoID,		Cantidad,		MontoIDE,		CantidadCob,
		CantidadPen,		EmpresaID, 		Usuario, 		FechaActual, 		DireccionIP,
 		ProgramaID,		Sucursal, 		NumTransaccion
FROM 	COBROIDEMENS
where 	CantidadPen = Decimal_Cero;


delete from COBROIDEMENS where CantidadPen = Decimal_Cero;


END TerminaStore$$