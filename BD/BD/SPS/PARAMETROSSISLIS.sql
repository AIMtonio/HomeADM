-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSISLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSISLIS`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSSISLIS`(
	Par_EmpresaID			int,
	Par_Nombre				varchar(100),
	Par_NumLis				tinyint unsigned,

	Aud_Usuario				int(11),
	Aud_FechaActual			datetime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint(20)
	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Lis_Principal	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;

if(Par_NumLis = Lis_Principal) then
	select PS.EmpresaID, INS.Nombre
	from 	PARAMETROSSIS PS,
			INSTITUCIONES INS
	where   INS.Nombre like concat("%", Par_Nombre, "%")
			and INS.InstitucionID=PS.InstitucionID

	limit 0, 15;
end if;

END TerminaStore$$