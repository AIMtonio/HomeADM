-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJEROATMTRANSFLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJEROATMTRANSFLIS`;DELIMITER $$

CREATE PROCEDURE `CAJEROATMTRANSFLIS`(
	Par_CajeroTransfID	int,
	Par_CajeroDestinoID	varchar(20),
	Par_UsuarioID		int(11),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Lis_Principal	int;
DECLARE		Lis_Foranea		int;
DECLARE 	EstatusEnviado	char(1);


Set	Lis_Principal	:= 1;
Set	Lis_Foranea		:= 2;
set EstatusEnviado	:='E';

if(Par_NumLis = Lis_Foranea) then


	select TRA.CajeroTransfID, concat("Envia: Caja ",TRA.CajeroOrigenID," Suc. ", SUC.NombreSucurs," ",
								convert(format(TRA.Cantidad,2),char)," Para ATM: ", TRA.CajeroDestinoID,
										" Suc.",SUD.NombreSucurs) as Descrpcion
		from CAJEROATMTRANSF TRA
			inner join CATCAJEROSATM	CA	on TRA.CajeroDestinoID = CA.CajeroID
			inner join SUCURSALES SUC on TRA.SucursalOrigen = SUC.SucursalID
			inner join SUCURSALES SUD on CA.SucursalID = SUD.SucursalID
			inner join USUARIOS U on CA.UsuarioID = U.UsuarioID
				and TRA.Estatus = EstatusEnviado
				and CA.UsuarioID = Par_UsuarioID;
end if;


END TerminaStore$$