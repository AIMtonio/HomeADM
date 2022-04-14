-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACONTAPLANLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACONTAPLANLIS`;DELIMITER $$

CREATE PROCEDURE `POLIZACONTAPLANLIS`(
	Par_Descripcion		varchar(150),
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

  Select 	PolizaID,		Descripcion
	from POLIZACONTAPLAN
	where  Descripcion like concat("%", Par_Descripcion, "%")
	limit 0, 15;
end if;

END$$