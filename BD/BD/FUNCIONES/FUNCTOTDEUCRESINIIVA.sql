-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCTOTDEUCRESINIIVA
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCTOTDEUCRESINIIVA`;
DELIMITER $$


CREATE FUNCTION `FUNCTOTDEUCRESINIIVA`(
	Par_CreditoID   bigint

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN



DECLARE Var_MontoDeuda      decimal(14,2);
DECLARE Var_FecActual       date;
DECLARE Var_CreEstatus      char(1);


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(14,2);
DECLARE EstatusPagado   char(1);


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.00;
Set EstatusPagado   := 'P';

Set Var_MontoDeuda   := Decimal_Cero;

select FechaSistema into Var_FecActual
	from PARAMETROSSIS;


select  Cre.Estatus into Var_CreEstatus
    from CREDITOS   Cre
    where   Cre.CreditoID           = Par_CreditoID;

Set Var_CreEstatus = ifnull(Var_CreEstatus, Cadena_Vacia);

if(Var_CreEstatus != Cadena_Vacia) then


    select   round( ifnull(
                    sum(round(SaldoCapVigente,2) + round(SaldoCapAtrasa,2) +
                        round(SaldoCapVencido,2) + round(SaldoCapVenNExi,2) +

                          round(SaldoInteresOrd + SaldoInteresAtr +
                                SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta,2) +

                          round(SaldoComFaltaPa,2) +
                          round(SaldoComServGar,2) +
                          round(SaldoOtrasComis,2) +
                          round(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2)
                         ),
                       Entero_Cero)
                , 2)
            into Var_MontoDeuda

            from AMORTICREDITO
            where CreditoID     =  Par_CreditoID
              and Estatus       <> EstatusPagado;


    Set Var_MontoDeuda = ifnull(Var_MontoDeuda, Decimal_Cero);

end if;

return Var_MontoDeuda;

END$$