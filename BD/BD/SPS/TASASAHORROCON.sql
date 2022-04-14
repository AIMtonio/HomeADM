-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAHORROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAHORROCON`;DELIMITER $$

CREATE PROCEDURE `TASASAHORROCON`(
	Par_TasaAhorroID	int,
	Par_NumCon		tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Con_Principal	int;
DECLARE		Con_Foranea		int;

Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;

if(Par_NumCon = Con_Principal) then
	select	TasaAhorroID,	TipoCuentaID,		TipoPersona,
			MonedaID,		CONCAT(FORMAT(MontoInferior,2)) as MontoInferior,		CONCAT(FORMAT(MontoSuperior,2)) as MontoSuperior,
			CONCAT(FORMAT(Tasa,4)) as Tasa
	from TASASAHORRO
	where  TasaAhorroID 	= Par_TasaAhorroID;
end if;

END TerminaStore$$