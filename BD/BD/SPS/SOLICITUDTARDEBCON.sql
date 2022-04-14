-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDTARDEBCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDTARDEBCON`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDTARDEBCON`(
    Par_Folio           int(11),
    Par_ClienteID       int(11),
    Par_CuentaAhoID     bigint(12),
    Par_Relacion        char(1),
    Par_NumCon          int(11),

    Aud_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Con_Principal  		int;
DECLARE Con_FolioTarNueva  	int;
DECLARE Folio_Nueva			char(1);
DECLARE Folio_Repo 			char(1);
DECLARE Con_FolioTarRepo  	int(11);
DECLARE Con_SolNominativa   int(11);
DECLARE EstatusRecibido     char(1);



set Con_Principal       := 1;
set Con_FolioTarNueva   := 2;
set Con_FolioTarRepo    := 3;
set Con_SolNominativa   := 4;
set Folio_Nueva         := 'N';
set Folio_Repo          := 'R';
set EstatusRecibido     := 'R';



if(Par_NumCon = Con_Principal) then
   Select   Cli.CorpRCon_SolNominativaelacionado, Sol.TarjetaDebAntID,Sol.ClienteID,Cli.NombreCompleto,Sol.CuentaAhoID,
		    Sol.TipoTarjetaDebID,Sol.NombreTarjeta,  Sol.Costo
		from SOLICITUDTARDEB Sol
		inner join CLIENTES Cli on Cli.ClienteID=Sol.ClienteID
		where  FolioSolicitudID= Par_Folio;

end if;

if(Par_NumCon = Con_FolioTarNueva) then

 Select Sol.CorpRelacionadoID,Sol.TarjetaDebAntID,Sol.ClienteID,Cli.NombreCompleto,Sol.CuentaAhoID,
		  Sol.TipoTarjetaDebID,Sol.NombreTarjeta,Sol.Costo,Sol.Estatus,Tar.Descripcion,Sol.Relacion
		from SOLICITUDTARDEB Sol
		inner join CLIENTES Cli on Cli.ClienteID=Sol.ClienteID
		inner join TIPOTARJETADEB Tar on Tar.TipoTarjetaDebID=Sol.TipoTarjetaDebID
		where  TipoSolicitud = Folio_Nueva
		and  FolioSolicitudID= Par_Folio;


end if;

if(Par_NumCon = Con_FolioTarRepo) then

 Select Sol.CorpRelacionadoID,Sol.TarjetaDebAntID,Sol.ClienteID,Cli.NombreCompleto,Sol.CuentaAhoID,
		  Sol.TipoTarjetaDebID,Sol.NombreTarjeta,Sol.Costo,Sol.Estatus,Tar.Descripcion,Sol.Relacion
		from SOLICITUDTARDEB Sol
		inner join CLIENTES Cli on Cli.ClienteID=Sol.ClienteID
		inner join TIPOTARJETADEB Tar on Tar.TipoTarjetaDebID=Sol.TipoTarjetaDebID
		where  TipoSolicitud=Folio_Repo
		and  FolioSolicitudID= Par_Folio;


end if;

if(Par_NumCon = Con_SolNominativa) then
    SELECT Estatus
        FROM SOLICITUDTARDEB
        WHERE CuentaAhoID = Par_CuentaAho AND ClienteID = Par_ClienteID
            AND Estatus = EstatusRecibido AND Relacion = Par_Relacion;
end if;

END TerminaStore$$