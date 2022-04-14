-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACOTARDEBCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACOTARDEBCON`;DELIMITER $$

CREATE PROCEDURE `BITACOTARDEBCON`(
	Par_TarjetaDebID		char(16),
	Par_NumCon			int,

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
)
TerminaStore: BEGIN


DECLARE Con_Bitacora  		int;
DECLARE Con_TipoEvenTDID 	int;
DEClARE Con_BitacoraDesbloq int;
DECLARE Con_BitacoraActiva  int;
DECLARE Con_TipoEveTDAct    int;
DECLARE Con_BitacoraEst     int;
DECLARE Var_Estatus         int(11);


set Con_Bitacora		    :=6;
SET Con_BitacoraDesbloq   :=7;
set Con_BitacoraEst	    := 8;

set Con_TipoEvenTDID		 :=8;
set Con_TipoEveTDAct	 := 7;


if(Par_NumCon = Con_Bitacora) then
  select Tar.TarjetaDebID,Est.Descripcion,Cli.ClienteID,NombreCompleto,
                    Cli.CorpRelacionado,Bit.MotivoBloqID, Bit.Fecha, Bit.DescripAdicio
            from BITACORATARDEB AS Bit inner join
                    TARJETADEBITO AS Tar on Bit.TarjetaDebID =Tar.TarjetaDebID
            inner join CLIENTES AS Cli on Tar.ClienteID=Cli.ClienteID
            inner join ESTATUSTD AS Est on Est.EstatusID=Bit.TipoEvenTDID

		where Tar.TarjetaDebID= Par_TarjetaDebID and Bit.TipoEvenTDID =Con_TipoEvenTDID
         ORDER BY Bit.Fecha DESC;
end if;

if(Par_NumCon = Con_BitacoraDesbloq) then
    select Tar.TarjetaDebID,Est.Descripcion,Cli.ClienteID,NombreCompleto,
                    Cli.CorpRelacionado,Cat.Descripcion, date(Bit.Fecha)as Fecha, Bit.DescripAdicio,Est.EstatusId
            from BITACORATARDEB AS Bit inner join
                    TARJETADEBITO AS Tar on Bit.TarjetaDebID =Tar.TarjetaDebID
            inner join CLIENTES AS Cli on Tar.ClienteID=Cli.ClienteID
            inner join ESTATUSTD AS Est on Est.EstatusID=Bit.TipoEvenTDID
            inner join CATALCANBLOQTAR AS Cat on Cat.MotCanBloID =Bit.MotivoBloqID

		where Tar.TarjetaDebID= Par_TarjetaDebID  and Bit.TipoEvenTDID=Con_TipoEvenTDID
         ORDER BY Bit.Fecha DESC
 Limit 1;
end if;

if(Par_NumCon = Con_BitacoraEst) then
	SELECT
		Tar.TarjetaDebID,	upper(Est.Descripcion) as Descripcion,	Cli.ClienteID,			Cli.NombreCompleto,	Cli.CorpRelacionado,
		Cta.CuentaAhoID,	upper(Tipo.Descripcion) as Descripcion,	Tip.TipoTarjetaDebID,	Tip.Descripcion,	EstatusID
	FROM TARJETADEBITO tar
	LEFT JOIN ESTATUSTD Est ON Tar.Estatus = Est.EstatusID
	LEFT JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
	LEFT JOIN CUENTASAHO Cta ON Tar.CuentaAhoID = Cta.CuentaAhoID
	LEFT JOIN TIPOSCUENTAS Tipo ON Cta.TipoCuentaID=Tipo.TipoCuentaID
	LEFT JOIN TIPOTARJETADEB Tip on Tar.TipoTarjetaDebID=Tip.TipoTarjetaDebID
	WHERE Tar.TarjetaDebID = Par_TarjetaDebID;
end if;

END TerminaStore$$