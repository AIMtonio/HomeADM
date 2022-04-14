-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJEROATMTRANSFCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJEROATMTRANSFCON`;DELIMITER $$

CREATE PROCEDURE `CAJEROATMTRANSFCON`(
	Par_CajeroTransfID		int(11),
	Par_CajeroOrigenID		varchar(20),
	Par_CajeroDestinoID		varchar(20),
	Par_NumCon				tinyint unsigned,

	Par_EmpresaID			int(11),
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint

	)
TerminaStore:BEGIN



DECLARE Con_Destino	int;
DECLARE Con_Principal	int;

set Con_Destino		:=2;
set Con_Principal	:=1;

if (Par_NumCon = Con_Destino)then
	select CajeroTransfID,	CajeroOrigenID,		CajeroDestinoID,	Fecha,			Cantidad,
			Estatus,		MonedaID,			SucursalOrigen
		from CAJEROATMTRANSF T
		left join CATCAJEROSATM C on C.CajeroID = T.CajeroDestinoID
			where CajeroDestinoID = Par_CajeroDestinoID;
end if;
if (Par_NumCon = Con_Principal)then
	select CajeroTransfID,	CajeroOrigenID,		CajeroDestinoID,		Fecha,		format(Cantidad,2) as Cantidad,
			Estatus,		MonedaID,			SucursalOrigen
		from CAJEROATMTRANSF
			where CajeroTransfID = Par_CajeroTransfID;
end if;

END TerminaStore$$