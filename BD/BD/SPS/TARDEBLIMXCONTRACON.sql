-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBLIMXCONTRACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBLIMXCONTRACON`;DELIMITER $$

CREATE PROCEDURE `TARDEBLIMXCONTRACON`(
    Par_TipoTarjetaDebID	int(11),
	Par_ClienteID			int(11),
    Par_NumCon              int,

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(100),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
	)
TerminaStore: BEGIN


DECLARE Con_TipoTarjetaCte  		int;



set Con_TipoTarjetaCte       := 2;


    if(Par_NumCon = Con_TipoTarjetaCte) then
         SELECT Tip.TipoTarjetaDebID,	Tip.Descripcion,		Tar.ClienteID, 			Cli.NombreCompleto,
				Tar.DisposiDiaNac,		Tar.DisposiMesNac,      Tar.ComprasDiaNac,		Tar.ComprasMesNac,
				Tar.BloquearATM,		Tar.BloquearPOS,		Tar.BloquearCashBack,	Tar.AceptaOpeMoto,
				Tar.NoDisposiDia,		Tar.NumConsultaMes
        FROM TIPOTARJETADEB Tip
		INNER JOIN TARDEBLIMITXCONTRA Tar ON Tip.TipoTarjetaDebID= Tar.TipoTarjetaDebID
		INNER JOIN CLIENTES Cli ON Cli.ClienteID=Tar.ClienteID
        WHERE Tar.TipoTarjetaDebID =Par_TipoTarjetaDebID
        and Tar.ClienteID =Par_ClienteID;
    end if;

END TerminaStore$$