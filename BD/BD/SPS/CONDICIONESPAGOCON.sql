-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONDICIONESPAGOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONDICIONESPAGOCON`;DELIMITER $$

CREATE PROCEDURE `CONDICIONESPAGOCON`(
	Par_CondPagoID      int,
    Par_NumCon			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Con_Principal	int;
DECLARE		Con_Foranea		int;
DECLARE		Con_Dias		int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;
Set	Con_Dias		:= 3;


if(Par_NumCon = Con_Dias) then
	select	NumeroDias
		from CONDICIONESPAGO
		where  CondicionPagoID = Par_CondPagoID;
end if;


END TerminaStore$$