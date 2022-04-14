-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBBITACORAMOVSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBBITACORAMOVSCON`;DELIMITER $$

CREATE PROCEDURE `TARDEBBITACORAMOVSCON`(
	Par_TarjetaDebID		char(16),
	Par_NumCon				tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN


DECLARE Con_MovTarj         int;
DECLARE EstatusActiva       int(11);


Set Con_MovTarj	    	:= 2;
Set EstatusActiva       := 7;


if(Par_NumCon = Con_MovTarj) then
	select Tar.TarjetaDebID,Est.Descripcion,Cli.ClienteID,Cli.NombreCompleto,
	   Cli.CorpRelacionado,Cta.CuentaAhoID,Tcta.Descripcion,Tip.TipoTarjetaDebID,
	   Tip.Descripcion,Est.EstatusId
            from TARDEBBITACORAMOVS AS Tarj inner join
				 TARJETADEBITO AS Tar on Tarj.TarjetaDebID = Tar.TarjetaDebID
            left join CLIENTES AS Cli on Tar.ClienteID = Cli.ClienteID
            inner join ESTATUSTD AS Est on Est.EstatusID = Tar.Estatus
            left join TIPOTARJETADEB AS Tip on Tip.TipoTarjetaDebID = Tar.TipoTarjetaDebID
            left join CUENTASAHO AS Cta on Tar.CuentaAhoID = Cta.CuentaAhoID
            left join TIPOSCUENTAS AS Tcta on Tcta.TipoCuentaID = Cta.TipoCuentaID
				where Est.EstatusID = EstatusActiva
				and Tar.TarjetaDebID = Par_TarjetaDebID;
	end if;
END TerminaStore$$