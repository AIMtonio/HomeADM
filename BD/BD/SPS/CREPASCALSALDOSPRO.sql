-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPASCALSALDOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPASCALSALDOSPRO`;DELIMITER $$

CREATE PROCEDURE `CREPASCALSALDOSPRO`(
	Par_Fecha			date,
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Fecha_Vacia     date;
DECLARE Cadena_Vacia    char(1);
DECLARE Decimal_Cero    decimal(12,2);
DECLARE Entero_Cero     int;
DECLARE Estatus_Vigente char(1);
DECLARE Estatus_Pagado  char(1);
DECLARE Nat_Cargo       char(1);
DECLARE Nat_Abono       char(1);
DECLARE Tip_CapVigente  int;
DECLARE Tip_CapExigible int;
DECLARE Tip_IntProv     int;
DECLARE Tip_IntAtraso   int;
DECLARE Tip_IntMorato   int;
DECLARE Tip_ComFalPago  int;
DECLARE Tip_IVAIntOrd   int;
DECLARE Tip_IVAMorato   int;
DECLARE Tip_IVAFalPa    int;
DECLARE Tip_Retencion   int;

DECLARE Ref_DevInteres  varchar(50);
DECLARE Ref_PasoAtraso  varchar(50);
DECLARE Ref_PagoCredito varchar(50);
DECLARE Ref_PagoAntici  varchar(50);



set Fecha_Vacia     := '1900-01-01';
set Cadena_Vacia    := '';
set Decimal_Cero    := 0.00;
set Entero_Cero     := 0;
set Estatus_Vigente := 'N';
set Estatus_Pagado  := 'P';
set Nat_Cargo       := 'C';
set Nat_Abono       := 'A';
set Tip_CapVigente  := 1;
set Tip_CapExigible := 2;
set Tip_IntProv     := 10;
set Tip_IntAtraso   := 11;
set Tip_IntMorato   := 15;
set Tip_ComFalPago  := 40;
set Tip_IVAIntOrd   := 20;
set Tip_IVAMorato   := 21;
set Tip_IVAFalPa    := 22;
set Tip_Retencion   := 30;


set Ref_DevInteres  := 'GENERACION INTERES';
set Ref_PasoAtraso  := 'GENERACION INTERES MORATORIO';
set Ref_PagoCredito := 'PAGO DE CREDITO PASIVO';
set Ref_PagoAntici  := 'PAGO ANTICIPADO';



insert into SALDOSCREDPASIVOS
    select  Fon.CreditoFondeoID,    Par_Fecha,              Fon.LineaFondeoID,      Fon.InstitutFondID,
            Fon.MonedaID,           Fon.Estatus,         Fon.Monto,       Fon.NumAmortizacion,
            Fon.SaldoCapVigente,    Fon.SaldoCapAtrasad,    Fon.SaldoInteresPro,    Fon.SaldoInteresAtra,
            Fon.SaldoMoratorios,    Fon.SaldoComFaltaPa,    Fon.SaldoOtrasComis,    Fon.SaldoIVAInteres,
            Fon.SaldoIVAMora,       Fon.SaldoIVAComFalP,   Fon.SaldoIVAComisi,       Fon.SaldoRetencion,
            Entero_Cero,            Entero_Cero,

            ifnull(sum(case when Mov.NatMovimiento = Nat_Cargo and
                               Mov.TipoMovFonID = Tip_IntProv and
                               Mov.Referencia = Ref_DevInteres then Mov.Cantidad
                           else Decimal_Cero end) +
                  sum(case when Mov.NatMovimiento = Nat_Cargo and
                               Mov.TipoMovFonID = Tip_IntProv and
                               Mov.Descripcion = Ref_PagoCredito and
                               Mov.Referencia = Ref_PagoAntici then Mov.Cantidad
                           else Decimal_Cero end),
                       Decimal_Cero),

            ifnull(sum(case when Mov.NatMovimiento = Nat_Cargo and
                               Mov.TipoMovFonID = Tip_IntMorato and
                               Mov.Referencia = Ref_PasoAtraso then Mov.Cantidad
                           else Decimal_Cero end),
                       Decimal_Cero),

	       ifnull(sum(case when Mov.NatMovimiento = Nat_Cargo and
                               Mov.TipoMovFonID = Tip_ComFalPago and
                               Mov.Referencia = Ref_PasoAtraso then Mov.Cantidad
                           else Decimal_Cero end),
                       Decimal_Cero),


           ifnull(sum(case when Mov.NatMovimiento = Nat_Abono and
                               Mov.TipoMovFonID = Tip_CapVigente and
                               Mov.Descripcion = Ref_PagoCredito then Mov.Cantidad
                           else Decimal_Cero end),
                       Decimal_Cero),


           ifnull(sum(case when Mov.NatMovimiento = Nat_Abono and
                               Mov.TipoMovFonID = Tip_CapExigible and
                               Mov.Descripcion = Ref_PagoCredito then Mov.Cantidad
                           else Decimal_Cero end),
                       Decimal_Cero),


           ifnull(sum(case when Mov.NatMovimiento = Nat_Abono and
                               Mov.TipoMovFonID = Tip_IntProv and
                               Mov.Descripcion = Ref_PagoCredito then Mov.Cantidad
                           else Decimal_Cero end),
                       Decimal_Cero),


           ifnull(sum(case when Mov.NatMovimiento = Nat_Abono and
                               Mov.TipoMovFonID = Tip_IntAtraso and
                               Mov.Descripcion = Ref_PagoCredito then Mov.Cantidad
                           else Decimal_Cero end),
                       Decimal_Cero),


           ifnull(sum(case when Mov.NatMovimiento = Nat_Abono and
                               Mov.TipoMovFonID = Tip_ComFalPago and
                               Mov.Descripcion = Ref_PagoCredito then Mov.Cantidad
                           else Decimal_Cero end),
                       Decimal_Cero),


           ifnull(sum(case when Mov.NatMovimiento = Nat_Abono and
                               Mov.TipoMovFonID = Tip_IntMorato and
                               Mov.Descripcion = Ref_PagoCredito then Mov.Cantidad
                           else Decimal_Cero end),
                       Decimal_Cero),


          ifnull(sum(case when Mov.NatMovimiento = Nat_Abono and
                               Mov.TipoMovFonID = Tip_IVAIntOrd and
                               Mov.Descripcion = Ref_PagoCredito then Mov.Cantidad
                           else Decimal_Cero end) +

                 sum(case when Mov.NatMovimiento = Nat_Abono and
                               Mov.TipoMovFonID = Tip_IVAMorato and
                               Mov.Descripcion = Ref_PagoCredito then Mov.Cantidad
                           else Decimal_Cero end) +

                sum(case when Mov.NatMovimiento = Nat_Abono and
                               Mov.TipoMovFonID = Tip_IVAFalPa and
                               Mov.Descripcion = Ref_PagoCredito then Mov.Cantidad
                           else Decimal_Cero end),

                       Decimal_Cero),


               ifnull(sum(case when Mov.NatMovimiento = Nat_Cargo and
                                   Mov.TipoMovFonID = Tip_Retencion and
                                   Mov.Descripcion = Ref_PagoCredito then Mov.Cantidad
                               else Decimal_Cero end),
                           Decimal_Cero),


                (select (case when ifnull(min(FechaExigible), Fecha_Vacia) = Fecha_Vacia then 0
                                   else ( datediff(Par_Fecha,min(FechaExigible)) + 1)  end)
                    from AMORTIZAFONDEO Amo
                    where Amo.CreditoFondeoID = Fon.CreditoFondeoID
                      and Amo.Estatus != Estatus_Pagado
                      and Amo.FechaExigible <= Par_Fecha),
            Par_EmpresaID,          Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion

        from CREDITOFONDEO Fon
        LEFT OUTER JOIN CREDITOFONDMOVS as Mov ON 	(Fon.CreditoFondeoID			=  Mov.CreditoFondeoID
                                              and     Mov.FechaOperacion	= Par_Fecha)
        where (	Fon.Estatus = Estatus_Vigente
		   or 	(	Fon.Estatus = Estatus_Pagado
		   and	 	Fon.FechaTerminaci = Par_Fecha	))
		group by Fon.CreditoFondeoID;


END TerminaStore$$