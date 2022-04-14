-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASFESTIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASFESTIVOSCON`;DELIMITER $$

CREATE PROCEDURE `DIASFESTIVOSCON`(
	Par_Fecha		date,

	Par_NumCon		tinyint unsigned
	)
BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;
DECLARE	Con_DiasHab		int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_DiasHab		:= 2;

if(Par_NumCon = Con_Principal) then
	Select Fecha, EmpresaID, Descripcion
	from DIASFESTIVOS
	where Fecha = Par_Fecha;
end if;

END$$