-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIOMENORCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIOMENORCON`;DELIMITER $$

CREATE PROCEDURE `SOCIOMENORCON`(
	Par_ClienteID		int,
	Par_RFC				char(13),
	Par_CURP				char(18),
	Par_NumCon			tinyint unsigned,
	Par_EmpresaID		int,

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
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;
DECLARE	Con_Foranea		int;
DECLARE	Con_Correo		int;
DECLARE	Con_RFC			int;
DECLARE	Con_OtraPant	int;
DECLARE	Con_Inversion	int;
DECLARE	Con_ResumenCte	int;
DECLARE	Con_PagoCred	int;
DECLARE	Con_TipoPersona	int;
DECLARE	Con_ProspecCli	int;
DECLARE  Con_CURP		int;
DECLARE Con_Tutor		int;
DECLARE Var_TipoTutor	int;
DECLARE Con_NoSocio		int;
DECLARE EsTutor			CHAR(15);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;
Set	Con_Correo		:= 3;
Set	Con_RFC			:= 4;
Set	Con_OtraPant	:= 5;
Set	Con_Inversion	:= 6;
Set	Con_ResumenCte	:= 7;
Set	Con_PagoCred	:= 8;
Set	Con_TipoPersona	:= 9;
Set	Con_ProspecCli	:= 10;
Set	Con_CURP		:= 11;
Set Con_Tutor		:= 12;
Set Con_NoSocio		:= 0;
Set EsTutor			:= 'TUTOR(A)';

if(Par_NumCon = Con_Principal) then
  Select
        ClienteID,      SucursalOrigen,     TipoPersona,        Titulo,             PrimerNombre,
        SegundoNombre,  TercerNombre,       ApellidoPaterno,    ApellidoMaterno,    FechaNacimiento,
        LugarNacimiento,EstadoID,           Nacion,             PaisResidencia,     Sexo,
        CURP,           RFC,                EstadoCivil,        TelefonoCelular,    Telefono,
        Correo,         RazonSocial,        TipoSociedadID,     RFCpm,              GrupoEmpresarial,
        Fax,            OcupacionID,        Puesto,             LugardeTrabajo,     AntiguedadTra,
        TelTrabajo,     Clasificacion,      MotivoApertura,     PagaISR,            PagaIVA,
        PagaIDE,        NivelRiesgo,        SectorGeneral,      ActividadBancoMX,   ActividadINEGI,
        SectorEconomico,PromotorInicial,    PromotorActual,     NombreCompleto,     ActividadFR,
        ActividadFOMURID,Estatus,           TipoInactiva,       MotivoInactiva,     EsMenorEdad,
        ifnull(ClienteTutorID, Entero_Cero), NombreTutor, ExtTelefonoPart, TipoRelacionID,
		Soc.EjecutivoCap, Soc.PromotorExtInv
		from CLIENTES Cli, SOCIOMENOR Soc
		where ClienteID = Par_ClienteID and SocioMenorID = Par_ClienteID;
end if;



if(Par_NumCon = Con_Foranea) then
	Select ClienteID,NombreCompleto
		from CLIENTES
		where ClienteID = Par_ClienteID;
end if;


if(Par_NumCon = Con_RFC) then
	Select  ClienteID, RFCOFicial
		from CLIENTES
		where RFCOFicial = Par_RFC;
end if;


if(Par_NumCon = Con_Correo) then
	Select  ClienteID, NombreCompleto, Correo
		from CLIENTES
		where ClienteID = Par_ClienteID;
end if;


if(Par_NumCon = Con_OtraPant) then
	Select	ClienteID, NombreCompleto, RazonSocial, TipoPersona,	RFC,
			Telefono
		from CLIENTES
		where ClienteID = Par_ClienteID;
end if;


if(Par_NumCon = Con_Inversion) then
	Select  ClienteID, NombreCompleto, Telefono, PagaISR
	from CLIENTES
	where ClienteID = Par_ClienteID;
end if;


if(Par_NumCon = Con_ResumenCte) then
	Select	ClienteID,		TipoPersona,		PromotorActual,	SucursalOrigen,	FechaAlta,
			TipoSociedadID, 	GrupoEmpresarial,	Sexo,			FechaNacimiento,	Nacion,
			EstadoCivil,		Telefono,		Correo,			ActividadBancoMX,	ActividadINEGI,
			SectorEconomico,	OcupacionID,		Puesto
		from CLIENTES
		where ClienteID = Par_ClienteID;
end if;


if(Par_NumCon = Con_PagoCred) then
	Select  ClienteID, NombreCompleto, PagaIVA
		from CLIENTES
		where ClienteID = Par_ClienteID;
end if;

if(Par_NumCon = Con_TipoPersona) then
	Select ClienteID,NombreCompleto, TipoPersona
		from CLIENTES
		where ClienteID = Par_ClienteID;
end if;


if(Par_NumCon = Con_ProspecCli) then
 select	ifnull(Pro.ClienteID,Entero_Cero),	ifnull(Pro.ProspectoID,Entero_Cero), ifnull(Cli.NombreCompleto,Cadena_Vacia), ifnull(Pro.NombreCompleto,Cadena_Vacia)
	from	PROSPECTOS Pro,
			CLIENTES Cli
	where	Cli.ClienteID = Pro.ClienteID
	and		Pro.ClienteID = Par_ClienteID;
end if;
if(Par_NumCon = Con_CURP) then
	Select  ClienteID, CURP
		from CLIENTES
		where CURP = Par_CURP;
end if;

if(Par_NumCon = Con_Tutor) then
Set Var_TipoTutor	:=(Select  ClienteTutorID from SOCIOMENOR	where SocioMenorID = Par_ClienteID);
set Var_TipoTutor = ifnull(Var_TipoTutor,0);
	if(Var_TipoTutor = Con_NoSocio) then
		Select  SocioMenorID,	 ClienteTutorID,	 NombreTutor, EsTutor as ParentescoTutor
			from SOCIOMENOR
			where SocioMenorID = Par_ClienteID;
	end if;
	if(Var_TipoTutor > Con_NoSocio) then
		Select  SM.SocioMenorID,	LPAD(CONVERT(SM.ClienteTutorID, CHAR), 11, 0) AS ClienteTutorID ,	 C.NombreCompleto as NombreTutor, 	ifnull(TR.Descripcion, EsTutor) as ParentescoTutor
			from SOCIOMENOR SM
			inner join CLIENTES C ON SM.clienteTutorID = C.ClienteID
			left join RELACIONCLIEMPLEADO RE ON (SM.SocioMenorID = RE.ClienteID and SM.ClienteTutorID=RE.RelacionadoID)
			left join TIPORELACIONES TR on RE.ParentescoID = TR.TipoRelacionID
			where SocioMenorID = Par_ClienteID;

	end if;
end if;

END TerminaStore$$