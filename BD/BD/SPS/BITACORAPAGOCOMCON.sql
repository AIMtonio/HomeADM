-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAPAGOCOMCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAPAGOCOMCON`;DELIMITER $$

CREATE PROCEDURE `BITACORAPAGOCOMCON`(
	Par_TipoTarjetaID		int,
	Par_NumCon				tinyint unsigned,

	Aud_EmpresaID			int(11),
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint
	)
TerminaStore:BEGIN

DECLARE Con_Principal	int;
DECLARE Var_FechaSis	date;

Set Con_Principal	:= 21;
Set Var_FechaSis	:= (SELECT FechaSistema FROM PARAMETROSSIS);

if (Par_NumCon = Con_Principal) then
	SELECT TipoTarjetaDebID
		FROM BITACORAPAGOCOM
		WHERE TipoTarjetaDebID = Par_TipoTarjetaID AND Fecha = Var_FechaSis;
end if;

END TerminaStore$$