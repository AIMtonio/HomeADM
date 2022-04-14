-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASCORREOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASCORREOCON`;DELIMITER $$

CREATE PROCEDURE `CUENTASCORREOCON`(
	CuentaCorreoID		int,
	Par_NumCon			tinyint unsigned,
	Par_EmpresaID		int,
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
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;

if(Par_NumCon = Con_Principal) then
	Select CuentaCorreoID,	CorreoContactoCte, AsuntoContactoCte,	CorreoPromocion, AsuntoPromocion,
		 CorreoRiesgos,	AsuntoRiesgos
	from CUENTASCORREO;
end if;

END$$