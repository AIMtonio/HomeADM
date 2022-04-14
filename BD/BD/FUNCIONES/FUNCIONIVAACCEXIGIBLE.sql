-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONIVAACCEXIGIBLE
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONIVAACCEXIGIBLE`;
DELIMITER $$


CREATE FUNCTION `FUNCIONIVAACCEXIGIBLE`(
    Par_CreditoID   bigint,
    Par_Fecha       date

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

DECLARE Var_MontoIVA	decimal(14,2);
DECLARE Var_FecActual	date;
DECLARE Var_CreEstatus	char(1);
DECLARE Var_CliPagIVA	char(1);
DECLARE Var_ProCobIVA	char(1);
DECLARE Var_IVAIntOrd	CHAR(1);
DECLARE Var_IVAIntMor	CHAR(1);
DECLARE Var_ValIVAIntOr	DECIMAL(12,2);
DECLARE Var_ValIVAIntMo	DECIMAL(12,2);
DECLARE Var_ValIVAGen	DECIMAL(12,2);
DECLARE Var_IVASucurs	DECIMAL(12,2);

DECLARE Cadena_Vacia	char(1);
DECLARE Fecha_Vacia		date;
DECLARE Entero_Cero		int;
DECLARE Decimal_Cero	decimal(14,2);
DECLARE EstatusPagado	char(1);
DECLARE SiPagaIVA		char(1);


Set Cadena_Vacia	:= '';
Set Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero		:= 0;
Set Decimal_Cero	:= 0.00;
Set EstatusPagado	:= 'P';
Set SiPagaIVA		:= 'S';

set Var_MontoIVA	:= Decimal_Cero;

set Var_FecActual	:= Par_Fecha;

select Cre.Estatus into Var_CreEstatus
    from CREDITOS   Cre
    where   Cre.CreditoID           = Par_CreditoID;

SELECT  Cli.PagaIVA,            Suc.IVA,            Pro.CobraIVAInteres, Cre.Estatus,
        Pro.CobraIVAMora
        INTO Var_CliPagIVA, Var_IVASucurs,    Var_IVAIntOrd, Var_CreEstatus,
             Var_IVAIntMor 
    FROM CREDITOS   Cre,
         CLIENTES   Cli,
         SUCURSALES Suc,
         PRODUCTOSCREDITO Pro
    WHERE   Cre.CreditoID           = Par_CreditoID
      AND   Cre.ProductoCreditoID   = Pro.ProducCreditoID
      AND   Cre.ClienteID           = Cli.ClienteID
      AND   Cre.SucursalID          = Suc.SucursalID;

SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);
SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, SiPagaIVA);
SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, SiPagaIVA);
SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);

SET Var_CreEstatus = IFNULL(Var_CreEstatus, Cadena_Vacia);

SET Var_ValIVAIntOr := Entero_Cero;
SET Var_ValIVAIntMo := Entero_Cero;
SET Var_ValIVAGen   := Entero_Cero;

if(Var_CreEstatus != Cadena_Vacia) then

    IF (Var_CliPagIVA = SiPagaIVA) THEN

        SET Var_ValIVAGen  := Var_IVASucurs;

        IF (Var_IVAIntOrd = SiPagaIVA) THEN
            SET Var_ValIVAIntOr  := Var_IVASucurs;
        END IF;

        IF (Var_IVAIntMor = SiPagaIVA) THEN
            SET Var_ValIVAIntMo  := Var_IVASucurs;
        END IF;

    END IF;

    select min(FechaExigible) into Var_FecActual
    from AMORTICREDITO
    where FechaExigible >= Par_Fecha
      and Estatus       <> EstatusPagado
      and CreditoID     =  Par_CreditoID;

    set Var_FecActual = ifnull(Var_FecActual, Par_Fecha);

    select  SUM(IFNULL((ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2)),Decimal_Cero))
            into Var_MontoIVA

            from AMORTICREDITO
            where FechaExigible <= Var_FecActual
              and Estatus       <> EstatusPagado
              and CreditoID     =  Par_CreditoID;

    set Var_MontoIVA = ifnull(Var_MontoIVA, Decimal_Cero);

end if;

return Var_MontoIVA;

END$$