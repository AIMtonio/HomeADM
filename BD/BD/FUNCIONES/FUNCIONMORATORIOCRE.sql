-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONMORATORIOCRE
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONMORATORIOCRE`;DELIMITER $$

CREATE FUNCTION `FUNCIONMORATORIOCRE`(
    Par_CreditoID   bigint

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN


DECLARE Var_MontoExigible	decimal(14,2);
DECLARE Var_IVASucurs       decimal(12,2);
DECLARE Var_FecActual       date;
DECLARE Var_CreEstatus      char(1);
DECLARE Var_CliPagIVA       char(1);

DECLARE Var_IVAIntOrd   char(1);
DECLARE Var_IVAIntMor   char(1);
DECLARE Var_ValIVAIntOr decimal(12,2);
DECLARE Var_ValIVAIntMo decimal(12,2);
DECLARE Var_ValIVAGen   decimal(12,2);



DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(14,2);
DECLARE EstatusPagado   char(1);
DECLARE SiPagaIVA       char(1);


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.00;
Set EstatusPagado   := 'P';
Set SiPagaIVA       := 'S';

Set Var_MontoExigible   := Decimal_Cero;

select FechaSistema into Var_FecActual
	from PARAMETROSSIS;


select  Cli.PagaIVA,            Suc.IVA,            Pro.CobraIVAInteres, Cre.Estatus,
        Pro.CobraIVAMora
        into Var_CliPagIVA, Var_IVASucurs,    Var_IVAIntOrd, Var_CreEstatus,
             Var_IVAIntMor
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

 select  round(ifnull(
                    sum( round(round(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) * Var_ValIVAIntMo,2)
                         ),
                       Entero_Cero)
                , 2)
            into Var_ValIVAIntMo

            from AMORTICREDITO
            where FechaExigible <= Var_FecActual
              and Estatus       <> EstatusPagado
              and CreditoID     =  Par_CreditoID;


    Set Var_ValIVAIntMo = ifnull(Var_ValIVAIntMo, Decimal_Cero);

end if;

return Var_ValIVAIntMo;

END$$