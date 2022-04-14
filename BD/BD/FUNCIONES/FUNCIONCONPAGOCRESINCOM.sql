-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONCONPAGOCRESINCOM
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONCONPAGOCRESINCOM`;DELIMITER $$

CREATE FUNCTION `FUNCIONCONPAGOCRESINCOM`(
    Par_CreditoID   bigint

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN




DECLARE Var_MontoExigible	decimal(14,2);
DECLARE Var_IVASucurs       decimal(12,2);
DECLARE Var_FecActual       date;
DECLARE Var_CreEstatus      char(1);
DECLARE Var_CliPagIVA       char(1);
DECLARE Var_IVAIntOrd       char(1);
DECLARE Var_IVAIntMor       char(1);
DECLARE Var_ValIVAIntOr     decimal(12,2);
DECLARE Var_ValIVAIntMo     decimal(12,2);
DECLARE Var_ValIVAGen       decimal(12,2);

DECLARE Var_ProyInPagAde    char(1);
DECLARE Var_PrductoCreID    int;
DECLARE Var_DiasPermPagAnt  int;
DECLARE Var_Frecuencia      char(1);
DECLARE Var_DiasAntici      int;
DECLARE Var_CreTasa         decimal(12,4);
DECLARE Var_DiasCredito     int;
DECLARE Var_IntAntici       decimal(14,4);
DECLARE Var_FecProxPago     date;
DECLARE Var_ProxAmorti      int;
DECLARE Var_NumProyInteres  int;
DECLARE Var_IntProActual    decimal(14,4);
DECLARE Var_Interes    		decimal(14,4);


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(14,2);
DECLARE Decimal_Cien    decimal(14,2);
DECLARE EstatusPagado   char(1);
DECLARE SiPagaIVA       char(1);
DECLARE SI_ProyectInt   char(1);
DECLARE Tol_DifPago     decimal(10,4);



Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.00;
Set Decimal_Cien    := 100.0;
Set EstatusPagado   := 'P';
Set SiPagaIVA       := 'S';
Set SI_ProyectInt   := 'S';
Set Tol_DifPago     := 0.02;

Set Var_MontoExigible   := Decimal_Cero;

select FechaSistema, DiasCredito into Var_FecActual, Var_DiasCredito
	from PARAMETROSSIS;

select  Cli.PagaIVA,            Suc.IVA,                Pro.CobraIVAInteres,    Cre.Estatus,
        Pro.CobraIVAMora,       Pro.ProyInteresPagAde,  Pro.ProducCreditoID,    Cre.FrecuenciaCap,
        Cre.TasaFija into
        Var_CliPagIVA,          Var_IVASucurs,          Var_IVAIntOrd,          Var_CreEstatus,
        Var_IVAIntMor,          Var_ProyInPagAde,       Var_PrductoCreID,       Var_Frecuencia,
        Var_CreTasa

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
Set Var_IVAIntMor   := ifnull(Var_IVAIntMor, SiPagaIVA);
Set Var_IVASucurs   := ifnull(Var_IVASucurs, Decimal_Cero);

Set Var_CreEstatus = ifnull(Var_CreEstatus, Cadena_Vacia);

Set Var_ValIVAIntOr := Entero_Cero;
Set Var_ValIVAIntMo := Entero_Cero;
Set Var_ValIVAGen   := Entero_Cero;

if(Var_CreEstatus != Cadena_Vacia) then


    if (Var_CliPagIVA = SiPagaIVA) then

        Set Var_ValIVAGen  := Var_IVASucurs;

        if (Var_IVAIntOrd = SiPagaIVA) then
            Set Var_ValIVAIntOr  := Var_IVASucurs;
        end if;

        if (Var_IVAIntMor = SiPagaIVA) then
            Set Var_ValIVAIntMo  := Var_IVASucurs;
        end if;

    end if;


    set Var_DiasPermPagAnt  := Entero_Cero;
    set Var_IntAntici       := Entero_Cero;
    set Var_NumProyInteres  := Entero_Cero;



    select Dpa.NumDias into Var_DiasPermPagAnt
        from CREDDIASPAGANT Dpa
        where Dpa.ProducCreditoID = Var_PrductoCreID
          and Dpa.Frecuencia = Var_Frecuencia;

    set Var_DiasPermPagAnt  := ifnull(Var_DiasPermPagAnt, Entero_Cero);

    if(Var_DiasPermPagAnt > Entero_Cero) then


        select min(FechaVencim), min(AmortizacionID) into Var_FecProxPago, Var_ProxAmorti
            from AMORTICREDITO
            where CreditoID   = Par_CreditoID
              and FechaVencim > Var_FecActual
              and Estatus     != EstatusPagado;


        set Var_FecProxPago := ifnull(Var_FecProxPago, Fecha_Vacia);
        set Var_ProxAmorti  := ifnull(Var_ProxAmorti, Entero_Cero);

        if(Var_FecProxPago != Fecha_Vacia) then
            set Var_DiasAntici := datediff(Var_FecProxPago, Var_FecActual);
        else
            set Var_DiasAntici := Entero_Cero;
        end if;


        select Amo.NumProyInteres,	Amo.Interes,
               ifnull(Amo.SaldoInteresPro, Entero_Cero) + ifnull(Amo.SaldoIntNoConta, Entero_Cero) into
			   Var_NumProyInteres, Var_Interes, Var_IntProActual
            from AMORTICREDITO Amo
            where Amo.CreditoID     = Par_CreditoID
              and Amo.AmortizacionID = Var_ProxAmorti
              and Amo.Estatus     != EstatusPagado;

        set Var_NumProyInteres  := ifnull(Var_NumProyInteres, Entero_Cero);
        set Var_IntProActual := ifnull(Var_IntProActual, Entero_Cero);
		set	Var_Interes	:= ifnull(Var_Interes, Entero_Cero);

        if(Var_NumProyInteres = Entero_Cero) then


            if(Var_DiasAntici <= Var_DiasPermPagAnt and Var_ProyInPagAde = SI_ProyectInt) then

				set Var_IntAntici = round(Var_Interes - Var_IntProActual,2);

                if(Var_IntAntici < Entero_Cero) then
                    set Var_IntAntici := Entero_Cero;
                end if;

            end if;
        end if;

    end if;

    select round(
                    ifnull(sum(SaldoCapVigente),Entero_Cero) +
                    ifnull(sum(SaldoCapAtrasa),Entero_Cero) +
                    ifnull(sum(SaldoCapVencido),Entero_Cero) +
                    ifnull(sum(SaldoCapVenNExi),Entero_Cero) +

                    ifnull(sum(round(SaldoInteresOrd,2)),Entero_Cero) +
                    ifnull(sum(round(SaldoInteresAtr,2)),Entero_Cero) +
                    ifnull(sum(round(SaldoInteresVen,2)),Entero_Cero) +
                    round(ifnull(sum(SaldoInteresPro),Entero_Cero) + Var_IntAntici, 2) +
                    ifnull(sum(round(SaldoIntNoConta,2)),Entero_Cero) +

                    round(round(ifnull(sum(
                                        SaldoInteresOrd + SaldoInteresAtr +
                                        SaldoInteresVen + SaldoInteresPro +
                                        SaldoIntNoConta), Entero_Cero) +
                                        Var_IntAntici, 2) * Var_ValIVAIntOr, 2) +

                    round(ifnull(sum(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero), 2)  +
                    round(ifnull(sum(round(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen, 2) * Var_ValIVAIntMo),Entero_Cero),2) +
                    round(ifnull(sum(SaldoOtrasComis),Entero_Cero),2)  +
                    round(ifnull(sum(round(SaldoOtrasComis,2) * Var_ValIVAGen),Entero_Cero),2)
                , 2)
            into Var_MontoExigible

            from AMORTICREDITO
            where CreditoID     =  Par_CreditoID
              and Estatus       <> EstatusPagado
              and DATE_SUB(FechaExigible, INTERVAL Var_DiasPermPagAnt DAY)  <= Var_FecActual;

    Set Var_MontoExigible = ifnull(Var_MontoExigible, Decimal_Cero);

end if;

return Var_MontoExigible;

END$$