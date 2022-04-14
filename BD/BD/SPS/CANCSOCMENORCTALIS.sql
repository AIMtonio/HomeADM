-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCSOCMENORCTALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCSOCMENORCTALIS`;DELIMITER $$

CREATE PROCEDURE `CANCSOCMENORCTALIS`(
	Par_ClienteID	 	varchar(50),

	Par_NumLis			tinyint unsigned,

	Aud_Empresa			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int(11);
DECLARE	Lis_Principal 	int(11);
DECLARE Lis_Sucursal    int(11);
DECLARE Lis_Cancelados	int(11);
DECLARE Lis_PrincipalVen int(11);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set Lis_Cancelados	:= 2;
Set Lis_Sucursal	:= 4;
Set Lis_PrincipalVen:= 5;

if(Par_NumLis = Lis_Principal) then
	select DISTINCT Can.ClienteID,Cli.NombreCompleto
		from CANCSOCMENORCTA Can
		inner join CLIENTES Cli on Cli.ClienteID=Can.ClienteID
		left join DIRECCLIENTE dc on Cli.ClienteID=dc.ClienteID and dc.Oficial='S'
		where Cli.NombreCompleto like concat("%",Par_ClienteID,"%")
			and Can.Aplicado="N"
		limit 0, 15;
end if;

if(Par_NumLis = Lis_PrincipalVen) then
	select DISTINCT Can.ClienteID,Cli.NombreCompleto,concat(ifnull(dc.calle,Cadena_Vacia),', ',ifnull(dc.Colonia,Cadena_Vacia)) as Direccion,suc.NombreSucurs
		from CANCSOCMENORCTA Can
		inner join CLIENTES Cli on Cli.ClienteID=Can.ClienteID
		left join DIRECCLIENTE dc on Cli.ClienteID=dc.ClienteID and dc.Oficial='S'
		inner join SUCURSALES suc on Cli.SucursalOrigen=suc.SucursalID
		where Cli.NombreCompleto like concat("%",Par_ClienteID,"%")
					and Can.Aplicado="N"
		limit 0, 50;
end if;

if(Par_NumLis = Lis_Sucursal) then
	select DISTINCT Can.ClienteID,Cli.NombreCompleto,concat(ifnull(dc.calle,Cadena_Vacia),' ',ifnull(dc.Colonia,Cadena_Vacia)) as Direccion,
		Cli.SucursalOrigen
		from CANCSOCMENORCTA Can
		inner join CLIENTES Cli on Can.ClienteID=Cli.ClienteID
		left join DIRECCLIENTE dc on Cli.ClienteID=dc.ClienteID and dc.Oficial='S'
		where Cli.NombreCompleto like concat("%",Par_ClienteID,"%")
			and Can.Aplicado="N"
			and Cli.SucursalOrigen = Aud_Sucursal
		limit 0, 25;
end if;

if(Par_NumLis = Lis_Cancelados) then
	select DISTINCT Can.ClienteID,Cli.NombreCompleto
		from CANCSOCMENORCTA Can
				inner join CLIENTES Cli on Cli.ClienteID=Can.ClienteID
		where Cli.NombreCompleto like concat("%",Par_ClienteID,"%")
	  limit 0,15;
end if;


END TerminaStore$$