-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCANCELACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCANCELACON`;DELIMITER $$

CREATE PROCEDURE `CLIENTESCANCELACON`(
	Par_ClienteCancelaID	int(11),
	Par_ClienteID			int(11),
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


DECLARE Entero_Cero		int;
DECLARE Con_Principal	int;
DECLARE Con_Cliente		int;
DECLARE Con_SolProtec	int;
DECLARE Con_AutorProtec	int;
DECLARE Con_CanSocio	int;
DECLARE Con_FolioCancela int;
DECLARE Decimal_Cero	decimal(18,2);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE	Est_Registrado	char(1);
DECLARE	Est_Autorizado	char(1);
DECLARE	Var_AtencioSoc	char(3);
DECLARE	Var_Proteccion	char(3);
DECLARE	Var_Cobranza	char(3);
DECLARE Var_CantidadRecibir	decimal(18,2);


set Entero_Cero			:= 0;
set Con_Principal		:= 1;
set Con_Cliente			:= 2;
set Con_SolProtec		:= 3;
set Con_AutorProtec		:= 4;
set Con_CanSocio		:= 5;
set Con_FolioCancela    := 6;
set Decimal_Cero		:= 0.0;
set Cadena_Vacia		:= '';
set Est_Registrado		:= 'R';
set Est_Autorizado		:= 'A';
set Var_AtencioSoc		:= 'Soc';
set Var_Proteccion		:= 'Pro';
set Var_Cobranza		:= 'Cob';




if(Con_Principal = Par_NumCon)then
	select	CC.ClienteCancelaID,		CC.ClienteID,			CC.AreaCancela,			CC.UsuarioRegistra,		CC.FechaRegistro,
			CC.SucursalRegistro,		CC.Estatus,				CC.MotivoActivaID,		CC.Comentarios,			CC.UsuarioAutoriza,
			CC.FechaAutoriza,			CC.SucursalAutoriza,	CC.AplicaSeguro,		CC.ActaDefuncion,		CC.FechaDefuncion,
			ifnull(PR.SaldoFavorCliente,Entero_Cero) as SaldoFavorCliente
	from	CLIENTESCANCELA	CC
			left outer join PROTECCIONES PR ON CC.ClienteCancelaID = PR.ClienteCancelaID
	where CC.ClienteCancelaID = Par_ClienteCancelaID;
end if;


if(Con_Cliente = Par_NumCon)then
	select	Can.ClienteCancelaID,		Can.ClienteID,			Can.AreaCancela,		Can.UsuarioRegistra,		Can.FechaRegistro,
			Can.SucursalRegistro,		Can.Estatus,			Can.MotivoActivaID,		Can.Comentarios,			Can.UsuarioAutoriza,
			Can.FechaAutoriza,			Can.SucursalAutoriza,	Can.AplicaSeguro,		Can.ActaDefuncion,			Can.FechaDefuncion,
			Mot.PermiteReactivacion
	from CLIENTESCANCELA Can,
		 MOTIVACTIVACION Mot
	where Can.ClienteID = Par_ClienteID
	and Can.MotivoActivaID = Mot.MotivoActivaID;
end if;


if(Par_NumCon = Con_SolProtec)then
	select	ClienteCancelaID,		ClienteID,			Estatus,			AplicaSeguro,			ActaDefuncion,
			FechaDefuncion
	from CLIENTESCANCELA
	where	ClienteID	= Par_ClienteID
	 and 	AreaCancela	= Var_Proteccion
	 and 	Estatus		= Est_Registrado;
end if;


if(Par_NumCon = Con_AutorProtec)then
	select	CC.ClienteCancelaID,	CC.ClienteID,		CC.UsuarioRegistra,
			CC.FechaRegistro, 		CC.Estatus, 		Pro.SaldoFavorCliente
	from CLIENTESCANCELA CC
		 left outer join PROTECCIONES Pro
			on CC.ClienteCancelaID = Pro.ClienteCancelaID
	where	CC.ClienteCancelaID = Par_ClienteCancelaID
			and AreaCancela	= Var_Proteccion
			and Estatus		= Est_Autorizado;
end if;


if(Par_NumCon = Con_CanSocio) then

	select CantidadRecibir into Var_CantidadRecibir
		from CLICANCELAENTREGA
		where ClienteCancelaID = Par_ClienteCancelaID
		 and CliCancelaEntregaID = Par_ClienteID
		and 	Estatus 			= Est_Autorizado;

	set Var_CantidadRecibir :=ifnull(Var_CantidadRecibir, Decimal_Cero);

	select	Estatus, Var_CantidadRecibir as CantidadRecibir, case AreaCancela when 	Var_AtencioSoc then Var_AtencioSoc
																				when Var_Proteccion then Var_Proteccion
																				when Var_Cobranza then Var_Cobranza
																				else Cadena_Vacia end as AreaCancela
		from	CLIENTESCANCELA
		where 	ClienteCancelaID = Par_ClienteCancelaID;

end if;

if(Con_FolioCancela = Par_NumCon)then
	select	ClienteCancelaID
	from	PROTECCIONES
	where   ClienteCancelaID = Par_ClienteCancelaID;
end if;


END TerminaStore$$