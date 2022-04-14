-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPOLPLANLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPOLPLANLIS`;DELIMITER $$

CREATE PROCEDURE `DETALLEPOLPLANLIS`(
	Par_PolizaID		int,
	Par_NumLis			tinyint unsigned,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Lis_Principal	int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Lis_Principal	:= 2;


if(Par_NumLis = Lis_Principal) then
   Select 	PolizaID,		CentroCostoID,		CuentaCompleta,
	         Instrumento,		Descripcion,			Cargos,			Abonos
    from DETALLEPOLPLAN
	where PolizaID = Par_PolizaID;
end if;

END$$