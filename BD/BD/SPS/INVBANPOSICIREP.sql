-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANPOSICIREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVBANPOSICIREP`;DELIMITER $$

CREATE PROCEDURE `INVBANPOSICIREP`(
    Par_InstitucionID   int,
    Par_NumCtaInstit    varchar(20),
    Par_Fecha           date,
    Par_Formato         char(1),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint	)
TerminaStore: BEGIN




DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Nat_Cargo       char(1);
DECLARE Nat_Abono       char(1);
DECLARE Des_Cargo       varchar(10);
DECLARE Des_Abono       varchar(10);
DECLARE Mov_DescriIni   varchar(100);
DECLARE For_Pantalla    char(1);
DECLARE For_Reporte     char(1);
DECLARE Tip_GenInt      char(3);
DECLARE Des_GenInt      varchar(200);




Set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Nat_Cargo       := 'C';
Set Nat_Abono       := 'A';
Set Des_Cargo       := 'CARGO';
Set Des_Abono       := 'ABONO';
Set For_Pantalla    := 'P';
Set For_Reporte     := 'R';
Set Tip_GenInt      := '002';
Set Des_GenInt      := 'GENERACION INTERES INV. BANCARIAS';

select Inv.InversionID, Inv.InstitucionID, Inv.NumCtaInstit, Inv.TipoInversion,
       Inv.FechaInicio, FechaVencimiento,
       Inv.Monto, Inv.Plazo, Inv.Tasa, Inv.TasaISR,
       Inv.InteresGenerado as InteresRecibir,
       Inv.InteresRetener as InteresRetener,
       round(ifnull((select sum(Mov.Cantidad)
            from INVBANCARIAMOVS Mov
            where Mov.InversionID   = Inv.InversionID
              and Mov.NatMovimiento = Nat_Cargo
              and Mov.TipoMovInbID = Tip_GenInt
              and Mov.Descripcion = Des_GenInt
			  and Mov.Fecha       <= Par_Fecha
              group by Mov.InversionID), Entero_Cero), 2) as InteresProvisionado,
        NombreCorto,
        (Inv.Monto + Inv.InteresGenerado + Inv.InteresRetener) as TotalRecibir
    from INVBANCARIA Inv,
         INSTITUCIONES Ins
    where Inv.InstitucionID = Ins.InstitucionID
      and FechaVencimiento > Par_Fecha
      and Inv.FechaInicio  <= Par_Fecha
      and Inv.InstitucionID = Par_InstitucionID
      and Inv.NumCtaInstit = Par_NumCtaInstit;

END TerminaStore$$