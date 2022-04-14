-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMFALTASOBRACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMFALTASOBRACON`;DELIMITER $$

CREATE PROCEDURE `PARAMFALTASOBRACON`(
	Par_SucursalID			int(11),
	Par_NumCon				tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)



	)
TerminaStore:BEGIN

DECLARE Con_Principal	int;

set Con_Principal		:= 1;

if (Par_NumCon = Con_Principal)then
	select ParamFaltaSobraID, SucursalID, format(MontoMaximoSobra,2) as MontoMaximoSobra,
			format(MontoMaximoFalta,2) as MontoMaximoFalta
		from PARAMFALTASOBRA
		where SucursalID = Par_SucursalID;
end if;

END TerminaStore$$