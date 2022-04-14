-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDTARDEBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDTARDEBLIS`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDTARDEBLIS`(
    Par_Folio      			varchar(11),
    Par_NumLis              tinyint unsigned,

    Aud_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
	)
TerminaStore:BEGIN


DECLARE Lis_Principal		int;
DECLARE Lis_FolioTarNueva	int;
DECLARE Lis_FolioTarRep		int;
DECLARE Entero_Cero			int;
DECLARE Cadena_Vacia		char(1);
DECLARE TarNueva			char(1);
DECLARE TarRepo				char(1);

Set Entero_Cero     	:= 0;
Set Cadena_Vacia   		:= '';
Set Lis_Principal   	:=1;
set Lis_FolioTarNueva	:=2;
set Lis_FolioTarRep  	:=3;
set TarNueva			:='N';
set TarRepo				:='R';

if(Par_NumLis = Lis_Principal) then
    SELECT Sol.FolioSolicitudID,Cli.NombreCompleto
        FROM SOLICITUDTARDEB Sol
		inner join CLIENTES Cli on Cli.ClienteID=Sol.ClienteID
        WHERE FolioSolicitudID like concat("%", Par_Folio, "%") limit 0, 15;
end if;


if(Par_NumLis = Lis_FolioTarNueva) then
    SELECT Sol.FolioSolicitudID,Cli.NombreCompleto
        FROM SOLICITUDTARDEB Sol
		inner join CLIENTES Cli on Cli.ClienteID=Sol.ClienteID
        WHERE FolioSolicitudID like concat("%", Par_Folio, "%")
		and Sol.TipoSolicitud= TarNueva	 limit 0, 15;
end if;



if(Par_NumLis = Lis_FolioTarRep) then
    SELECT Sol.FolioSolicitudID,Cli.NombreCompleto
        FROM SOLICITUDTARDEB Sol
		inner join CLIENTES Cli on Cli.ClienteID=Sol.ClienteID
        WHERE FolioSolicitudID like concat("%", Par_Folio, "%")
		and Sol.TipoSolicitud= TarRepo limit 0, 15;
end if;


END TerminaStore$$