-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBLIMITESXTIPOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBLIMITESXTIPOCON`;DELIMITER $$

CREATE PROCEDURE `TARDEBLIMITESXTIPOCON`(
    Par_TipoTarjetaDebID	int(11),
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


DECLARE Con_TipoTarjeta	int;


Set Con_TipoTarjeta		:= 2;


    if(Par_NumCon = Con_TipoTarjeta) then
		SELECT Tip.TipoTarjetaDebID,	Tip.Descripcion,	Tar.DisposiDiaNac,	Tar.DisposiMesNac,
				Tar.ComprasDiaNac,		Tar.ComprasMesNac,	Tar.BloquearATM,	Tar.BloquearPOS,
				Tar.BloquearCashBack,	Tar.AceptaOpeMoto,	Tar.NoDisposiDia,	Tar.NumConsultaMes
        FROM TARDEBLIMITESXTIPO Tar
		INNER JOIN TIPOTARJETADEB Tip ON Tar.TipoTarjetaDebID= Tip.TipoTarjetaDebID
        WHERE Tar.TipoTarjetaDebID =Par_TipoTarjetaDebID;
    end if;

END TerminaStore$$