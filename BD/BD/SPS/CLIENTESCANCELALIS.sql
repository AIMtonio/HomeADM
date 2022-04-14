-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCANCELALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCANCELALIS`;DELIMITER $$

CREATE PROCEDURE `CLIENTESCANCELALIS`(
	Par_NombreComp		varchar(100),
	Par_AreaCancela		char(3),
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


DECLARE Lis_Principal	int;
DECLARE Lis_Autorizadas	int;
DECLARE Lis_AutorizaPro	int;
DECLARE Lis_ProtAho		int;
DECLARE Est_Registrado	char(1);
DECLARE Est_Autorizado	char(1);
DECLARE Est_Pagado		char(1);
DECLARE AreaProteccion	char(3);


Set	Lis_Principal	:= 1;
Set	Lis_Autorizadas	:= 2;
Set	Lis_AutorizaPro := 3;
Set Lis_ProtAho		:= 4;
Set	Est_Registrado	:= 'R';
Set	Est_Autorizado	:= 'A';
Set	Est_Pagado		:= 'P';
Set AreaProteccion  := 'Pro';



if(Par_NumLis = Lis_Principal) then
	select	CC.ClienteCancelaID,	CC.ClienteID,	CL.NombreCompleto,	CC.Estatus,
			case CC.Estatus when Est_Registrado then "REGISTRADO"
						 when Est_Autorizado then "AUTORIZADO"
						 when Est_Pagado then "PAGADO" else CC.Estatus end as EstatusDes
		from	CLIENTESCANCELA CC,
				CLIENTES		CL
		where 	CL.NombreCompleto like concat("%", Par_NombreComp, "%")
		 and	CC.ClienteID	= CL.ClienteID
		 and 	CC.AreaCancela	= Par_AreaCancela
		order by CC.Estatus=Est_Pagado,	CC.Estatus=Est_Autorizado, CC.Estatus=Est_Registrado,
			 CL.NombreCompleto
		limit 0, 15;
end if;


if(Par_NumLis = Lis_Autorizadas) then
	select	CC.ClienteCancelaID,	CC.ClienteID,	CL.NombreCompleto,	CC.Estatus,
			case CC.Estatus when Est_Registrado then "REGISTRADO"
						 when Est_Autorizado then "AUTORIZADO"
						 when Est_Pagado then "PAGADO" else CC.Estatus end as EstatusDes
		from	CLIENTESCANCELA CC,
				CLIENTES		CL
		where 	CL.NombreCompleto like concat("%", Par_NombreComp, "%")
		 and	CC.ClienteID	= CL.ClienteID
		 and 	CC.Estatus		= Est_Autorizado
		order by CL.NombreCompleto
		limit 0, 15;
end if;


if(Par_NumLis = Lis_AutorizaPro) then
	select CC.ClienteCancelaID, CC.ClienteID, Cli.NombreCompleto,CC.Estatus,
		case CC.Estatus when 'A' then "AUTORIZADO"
		end as EstatusDes
		from CLIENTESCANCELA CC,
			 CLIENTES Cli,
			 PROTECCIONES Pro
		where Cli.NombreCompleto like concat("%", Par_NombreComp, "%")
				 and CC.ClienteID	= Cli.ClienteID
				 and Pro.ClienteID	= Cli.ClienteID
				 and CC.Estatus	= Est_Autorizado
				 and  CC.AreaCancela= AreaProteccion
				order by Cli.NombreCompleto
				limit 0, 15;
end if;


if(Par_NumLis = Lis_ProtAho) then
	select	CC.ClienteCancelaID,	CC.ClienteID,	CL.NombreCompleto,	CC.Estatus,
			case CC.Estatus when Est_Registrado then "REGISTRADO"
						 when Est_Autorizado then "AUTORIZADO"
						 when Est_Pagado then "PAGADO" else CC.Estatus end as EstatusDes
		from	CLIENTESCANCELA CC,
				CLIENTES		CL
		where 	CL.NombreCompleto like concat("%", Par_NombreComp, "%")
		 and	CC.ClienteID	= CL.ClienteID
		 and 	CC.AreaCancela	= Par_AreaCancela
		order by CC.Estatus=Est_Pagado,	CC.Estatus=Est_Autorizado, CC.Estatus=Est_Registrado,
			 CL.NombreCompleto
		limit 0, 15;
end if;
END TerminaStore$$