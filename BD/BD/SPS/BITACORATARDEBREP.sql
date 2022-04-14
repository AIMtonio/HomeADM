-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORATARDEBREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORATARDEBREP`;DELIMITER $$

CREATE PROCEDURE `BITACORATARDEBREP`(
    Par_TarjetaDebID      char(16),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)
TerminaStore: BEGIN




DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;




Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;

 select Tar.TarjetaDebID,Est.Descripcion as Estatus,Cli.ClienteID,NombreCompleto,
                    Cli.CorpRelacionado,LPAD(convert(CTA.CuentaAhoID, CHAR),11,'0') as CuentaAhoID,
                    TCTA.Descripcion TipoCuenta,
                    Tip.TipoTarjetaDebID,Tip.Descripcion as TipoTarjeta,Est.EstatusId,
                    date(Bit.Fecha)as Fecha, upper(Bit.DescripAdicio) as DescripAdicio,Cat.Descripcion as Motivo,
                    (select RazonSocial From CLIENTES WHERE ClienteID= Cli.CorpRelacionado) as RazonSocial
            from BITACORATARDEB AS Bit inner join
                    TARJETADEBITO AS Tar on Bit.TarjetaDebID =Tar.TarjetaDebID
            left join CLIENTES AS Cli on Tar.ClienteID=Cli.ClienteID
            left join ESTATUSTD AS Est on Est.EstatusID=Bit.TipoEvenTDID
            left join CATALCANBLOQTAR AS Cat on Cat.MotCanBloID =Bit.MotivoBloqID
            left join TIPOTARJETADEB AS Tip on Tip.TipoTarjetaDebID=Tar.TipoTarjetaDebID
            left join CUENTASAHO AS CTA on Tar.CuentaAhoID=CTA.CuentaAhoID
            left join TIPOSCUENTAS AS TCTA on TCTA.TipoCuentaID=CTA.TipoCuentaID

      where Tar.TarjetaDebID=Par_TarjetaDebID;
END$$