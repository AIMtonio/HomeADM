-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ABONOCHEQUESBCCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ABONOCHEQUESBCCON`;DELIMITER $$

CREATE PROCEDURE `ABONOCHEQUESBCCON`(
	Par_ChequeSBCID			int(11),
	Par_CuentaAhoID			bigint(12),
	Par_ClienteID			int(11),
	Par_BancoEmisor			int(11),
    Par_CuentaBancaria		varchar(20),
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
DECLARE Con_Exite		int(1);

set Con_Principal		:=1;
set Con_Exite			:= 2;

if (Par_NumCon=Con_Principal)then
select ChequeSBCID,	CuentaAhoID,ClienteID,		NombreReceptor,	Estatus,
		Monto,		BancoEmisor,CuentaEmisor,	NumCheque,		NombreEmisor,
		SucursalID,	CajaID,		FechaCobro,		FechaAplicacion,UsuarioID
	from ABONOCHEQUESBC
		where ChequeSBCID=Par_ChequeSBCID;
end if;

if (Par_NumCon = Con_Exite)then
	select NumCheque
		from ABONOCHEQUESBC
		where BancoEmisor=Par_BancoEmisor
		and CuentaEmisor=Par_CuentaBancaria
		and NumCheque =	Par_ChequeSBCID;
end if;


END TerminaStore$$