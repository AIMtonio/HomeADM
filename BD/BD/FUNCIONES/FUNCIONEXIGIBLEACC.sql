-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONEXIGIBLEACC
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONEXIGIBLEACC`;
DELIMITER $$


CREATE FUNCTION `FUNCIONEXIGIBLEACC`(
    Par_CreditoID   bigint,
    Par_Fecha       date

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

DECLARE Var_MontoExigible	decimal(14,2);
DECLARE Var_IVA             decimal(12,2);
DECLARE Var_PorcentajeIVA   decimal(12,2);
DECLARE Var_FecActual       date;
DECLARE Var_CreEstatus      char(1);
DECLARE Var_CliPagIVA       char(1);
DECLARE Var_ProCobIVA       char(1);


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

set Var_MontoExigible   := Decimal_Cero;
set Var_IVA             := Decimal_Cero;
set Var_PorcentajeIVA   := Decimal_Cero;

set Var_FecActual   := Par_Fecha;

select Cre.Estatus into Var_CreEstatus
    from CREDITOS   Cre
    where   Cre.CreditoID           = Par_CreditoID;

set Var_CreEstatus = ifnull(Var_CreEstatus, Cadena_Vacia);

if(Var_CreEstatus != Cadena_Vacia) then

    select min(FechaExigible) into Var_FecActual
    from AMORTICREDITO
    where FechaExigible >= Par_Fecha
      and Estatus       <> EstatusPagado
      and CreditoID     =  Par_CreditoID;

    set Var_FecActual = ifnull(Var_FecActual, Par_Fecha);

    select  sum(round(SaldoOtrasComis,2))
            into Var_MontoExigible

            from AMORTICREDITO
            where FechaExigible <= Var_FecActual
              and Estatus       <> EstatusPagado
              and CreditoID     =  Par_CreditoID;

    set Var_MontoExigible = ifnull(Var_MontoExigible, Decimal_Cero);

end if;

return Var_MontoExigible;

END$$