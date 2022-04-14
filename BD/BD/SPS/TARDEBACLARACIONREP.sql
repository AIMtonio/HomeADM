-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBACLARACIONREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBACLARACIONREP`;DELIMITER $$

CREATE PROCEDURE `TARDEBACLARACIONREP`(
    Par_ReporteID             int(11),
    Par_TarjetaDebID        char(16),

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
	)
TerminaStore: BEGIN

DECLARE Var_EstatusExis     char(1);

DECLARE Con_Principal  		int;


DECLARE EstatusSolic    char(1);
DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE Est_Activada    int;
DECLARE Est_Asigna      int;
DECLARE EstatusCanc     int;
DECLARE Est_Expirada    int;


set Con_Principal       :=1;


    SELECT LPAD(convert(Tarj.ClienteID, CHAR),10,0) as ClienteID,Tarj.TarjetaDebID,Tarj.NombreTarjeta,
        Tar.DetalleReporte,Tar.FechaAclaracion,Tar.DetalleResolucion,Ope.Descripcion,Tar.Comercio,Tar.FechaOperacion,Tar.UsuarioResolucion,US.NombreCompleto
        FROM TARDEBACLARACION as Tar inner join TARJETADEBITO AS Tarj on Tarj.TarjetaDebID=Tar.TarjetaDebID
            inner join TARDEBOPEACLARA AS Ope on Ope.TipoAclaraID=Tar.TipoAclaraID and Ope.OpeAclaraID=Tar.OpeAclaraID
            inner join USUARIOS as US on Tar.UsuarioResolucion=US.UsuarioID
        where Tar.TarjetaDebID= Par_TarjetaDebID and Tar.ReporteID=Par_ReporteID;


END TerminaStore$$