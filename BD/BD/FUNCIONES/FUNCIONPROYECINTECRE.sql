-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONPROYECINTECRE
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONPROYECINTECRE`;DELIMITER $$

CREATE FUNCTION `FUNCIONPROYECINTECRE`(
    Par_CreditoID   bigint

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN



DECLARE Var_Proyectado      decimal(14,2);
DECLARE Var_IVASucurs       decimal(12,2);
DECLARE Var_FecActual       date;
DECLARE Var_CreEstatus      char(1);
DECLARE Var_CliPagIVA       char(1);
DECLARE Var_IVAIntOrd       char(1);
DECLARE Var_ValIVAIntOr     decimal(12,2);

DECLARE Var_ProyInPagAde    char(1);
DECLARE Var_PrductoCreID    int;
DECLARE Var_DiasPermPagAnt  int;
DECLARE Var_Frecuencia      char(1);
DECLARE Var_DiasAntici      int;
DECLARE Var_CreTasa         decimal(12,4);
DECLARE Var_DiasCredito     int;
DECLARE Var_IntAntici       decimal(14,4);
DECLARE Var_FecProxPago     date;
DECLARE Var_FecDiasProPag   date;
DECLARE Var_ProxAmorti      int;
DECLARE Var_NumProyInteres  int;

DECLARE Var_CapitaAdela     decimal(14,2);
DECLARE Var_IntProActual    decimal(14,4);
DECLARE Var_TotPagAdela     decimal(14,2);
DECLARE Var_Interes    		decimal(14,4);



DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(14,2);
DECLARE Decimal_Cien    decimal(14,2);
DECLARE EstatusPagado   char(1);
DECLARE SiPagaIVA       char(1);
DECLARE SI_ProyectInt   char(1);



Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.00;
Set Decimal_Cien    := 100.0;
Set EstatusPagado   := 'P';
Set SiPagaIVA       := 'S';
Set SI_ProyectInt   := 'S';

Set Var_Proyectado   := Decimal_Cero;

select FechaSistema, DiasCredito into Var_FecActual, Var_DiasCredito
	from PARAMETROSSIS;

select  Cli.PagaIVA,            Suc.IVA,                Pro.CobraIVAInteres,    Cre.Estatus,
        Pro.ProyInteresPagAde,  Pro.ProducCreditoID,    Cre.FrecuenciaCap,		Cre.TasaFija into

        Var_CliPagIVA,          Var_IVASucurs,          Var_IVAIntOrd,          Var_CreEstatus,
        Var_ProyInPagAde,       Var_PrductoCreID,       Var_Frecuencia,			Var_CreTasa

    from CREDITOS   Cre,
         CLIENTES   Cli,
         SUCURSALES Suc,
         PRODUCTOSCREDITO Pro
    where   Cre.CreditoID           = Par_CreditoID
      and   Cre.ProductoCreditoID   = Pro.ProducCreditoID
      and   Cre.ClienteID           = Cli.ClienteID
      and   Cre.SucursalID          = Suc.SucursalID;

Set Var_CliPagIVA   := ifnull(Var_CliPagIVA, SiPagaIVA);
Set Var_IVAIntOrd   := ifnull(Var_IVAIntOrd, SiPagaIVA);
Set Var_IVASucurs   := ifnull(Var_IVASucurs, Decimal_Cero);

Set Var_CreEstatus = ifnull(Var_CreEstatus, Cadena_Vacia);
Set Var_ValIVAIntOr := Entero_Cero;

if(Var_CreEstatus != Cadena_Vacia) then

    if (Var_CliPagIVA = SiPagaIVA) then
        if (Var_IVAIntOrd = SiPagaIVA) then
            Set Var_ValIVAIntOr  := Var_IVASucurs;
        end if;
    end if;


    set Var_DiasPermPagAnt  := Entero_Cero;
    set Var_IntAntici       := Entero_Cero;
    set Var_NumProyInteres  := Entero_Cero;
    set Var_IntProActual    := Entero_Cero;
    set Var_CapitaAdela     := Entero_Cero;
    set Var_TotPagAdela     := Entero_Cero;



    select Dpa.NumDias into Var_DiasPermPagAnt
        from CREDDIASPAGANT Dpa
        where Dpa.ProducCreditoID = Var_PrductoCreID
          and Dpa.Frecuencia = Var_Frecuencia;

    set Var_DiasPermPagAnt  := ifnull(Var_DiasPermPagAnt, Entero_Cero);

    if(Var_DiasPermPagAnt > Entero_Cero) then


        select min(FechaExigible), min(FechaVencim), min(AmortizacionID) into
               Var_FecProxPago, Var_FecDiasProPag, Var_ProxAmorti
            from AMORTICREDITO
            where CreditoID   = Par_CreditoID
              and FechaVencim > Var_FecActual
              and Estatus     != EstatusPagado;

        set Var_FecProxPago := ifnull(Var_FecProxPago, Fecha_Vacia);
        set Var_FecDiasProPag := ifnull(Var_FecDiasProPag, Fecha_Vacia);
        set Var_ProxAmorti  := ifnull(Var_ProxAmorti, Entero_Cero);

        if(Var_FecProxPago != Fecha_Vacia) then
            set Var_DiasAntici := datediff(Var_FecProxPago, Var_FecActual);
        else
            set Var_DiasAntici := Entero_Cero;
        end if;


        select Amo.NumProyInteres, Amo.Interes,

               ifnull(Amo.SaldoInteresPro, Entero_Cero) + ifnull(Amo.SaldoIntNoConta, Entero_Cero),

               ifnull(SaldoCapVigente, Entero_Cero) + ifnull(SaldoCapAtrasa, Entero_Cero) +
               ifnull(SaldoCapVencido, Entero_Cero) + ifnull(SaldoCapVenNExi, Entero_Cero) into

                Var_NumProyInteres, Var_Interes, Var_IntProActual, Var_CapitaAdela
            from AMORTICREDITO Amo
            where Amo.CreditoID     = Par_CreditoID
              and Amo.AmortizacionID = Var_ProxAmorti
              and Amo.Estatus     != EstatusPagado;

        set Var_NumProyInteres  := ifnull(Var_NumProyInteres, Entero_Cero);
        set Var_IntProActual    := ifnull(Var_IntProActual, Entero_Cero);
        set Var_CapitaAdela     := ifnull(Var_CapitaAdela, Entero_Cero);
		set	Var_Interes			:= ifnull(Var_Interes, Entero_Cero);

        if(Var_NumProyInteres = Entero_Cero) then


            if(Var_DiasAntici <= Var_DiasPermPagAnt and Var_ProyInPagAde = SI_ProyectInt) then


				set Var_IntAntici = round(Var_Interes - Var_IntProActual, 2);

                if(Var_IntAntici < Entero_Cero) then
                    set Var_IntAntici := Entero_Cero;
                end if;

            end if;
        end if;


        if(Var_DiasAntici <= Var_DiasPermPagAnt) then
            set Var_TotPagAdela := Var_CapitaAdela + round(Var_IntAntici + Var_IntProActual,2) +
                                   round(round(Var_IntAntici + Var_IntProActual,2) * Var_ValIVAIntOr, 2);
        end if;

    end if;

    Set Var_Proyectado = ifnull(Var_TotPagAdela, Decimal_Cero);

end if;

return Var_Proyectado;

END$$