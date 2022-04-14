-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONCONFINIQCRE
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONCONFINIQCRE`;
DELIMITER $$

CREATE FUNCTION `FUNCIONCONFINIQCRE`(
    Par_CreditoID   BIGINT(12)


) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

-- Declaracion de Variables.
DECLARE Var_MontoExigible DECIMAL(14,2);
DECLARE Var_IVASucurs       DECIMAL(12,2);
DECLARE Var_FecActual       DATE;
DECLARE Var_CreEstatus      CHAR(1);
DECLARE Var_CliPagIVA       CHAR(1);
DECLARE Var_IVAIntOrd       CHAR(1);
DECLARE Var_IVAIntMor       CHAR(1);
DECLARE Var_ValIVAIntOr     DECIMAL(12,2);
DECLARE Var_ValIVAIntMo     DECIMAL(12,2);
DECLARE Var_ValIVAGen       DECIMAL(12,2);

DECLARE Var_ProyInPagAde    CHAR(1);
DECLARE Var_PrductoCreID    INT;
DECLARE Var_SaldoCapita     DECIMAL(14,2);
DECLARE Var_DiasPermPagAnt  INT;
DECLARE Var_Frecuencia      CHAR(1);
DECLARE Var_DiasAntici      INT;
DECLARE Var_CreTasa         DECIMAL(12,4);
DECLARE Var_DiasCredito     INT;
DECLARE Var_FechaVencim     DATE;
DECLARE Var_FecProxPago     DATE;

DECLARE Var_ComAntici       DECIMAL(14,2);
DECLARE Var_PermiteLiqAnt   CHAR(1);
DECLARE Var_CobraComLiqAnt  CHAR(1);
DECLARE Var_TipComLiqAnt    CHAR(1);
DECLARE Var_ComLiqAnt       DECIMAL(14,2);
DECLARE Var_DiasGraciaLiq   INT;
DECLARE Var_IntActual       DECIMAL(14,2);
DECLARE Var_SaldoIVAInteres DECIMAL(12,2);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(14,2);
DECLARE Decimal_Cien    DECIMAL(14,2);
DECLARE EstatusPagado   CHAR(1);
DECLARE SiPagaIVA       CHAR(1);
DECLARE SI_ProyectInt   CHAR(1);
DECLARE SI_PermiteLiqAnt    CHAR(1);
DECLARE SI_CobraLiqAnt      CHAR(1);
DECLARE Proyeccion_Int    CHAR(1);
DECLARE Monto_Fijo        CHAR(1);
DECLARE Por_Porcentaje    CHAR(1);
DECLARE Con_Finiquito2      INT(11);
DECLARE Par_EmpresaID   INT(11);
DECLARE Aud_Usuario     INT(11);
DECLARE Aud_FechaActual   DATETIME;
DECLARE Aud_DireccionIP   VARCHAR(15);
DECLARE Aud_ProgramaID    VARCHAR(50);
DECLARE Aud_Sucursal    INT(11);
DECLARE Aud_NumTransaccion  INT(11);
DECLARE Var_cliEsp        INT(11);
DECLARE Var_CliSFG        INT(11);
DECLARE Var_CliConfiadora INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia      := '';              -- Cadena Vacia
SET Fecha_Vacia       := '1900-01-01';    -- Fecha Vacia
SET Entero_Cero       := 0;               -- Entero en Cero
SET Decimal_Cero      := 0.00;            -- Moneda en Cero
SET Decimal_Cien      := 100.0;           -- Decimal Cien
SET EstatusPagado     := 'P';             -- Estatus Pagado.
SET SiPagaIVA         := 'S';             -- El Cliente Si Paga IVA
SET SI_ProyectInt     := 'S';             -- El Producto de Credito si Proyecta Interes
SET SI_PermiteLiqAnt    := 'S';       -- El Producto Si Permite Liquidacion Anticipada
SET SI_CobraLiqAnt      := 'S';       -- El Producto Si Cobra Comision por Liquidacion Anticipada
SET Proyeccion_Int      := 'P';       -- Tipo de Comision por Finiquito: Proyeccion de Interes
SET Monto_Fijo          := 'M';       -- Tipo de Comision por Finiquito: Monto Fijo
SET Por_Porcentaje      := 'S';       -- Tipo de Comision Porcentaje del Sald Insoluto
SET Con_Finiquito2      := 1;

SET Par_EmpresaID   := 1;
SET Aud_Usuario     := 1;
SET Aud_FechaActual   := NOW();
SET Aud_DireccionIP   := '127.0.0.1';
SET Aud_ProgramaID    := 'FUNCIONCONFINIQCRE';
SET Aud_Sucursal    := 1;
SET Aud_NumTransaccion  := 1;

SET Var_MontoExigible   := Decimal_Cero;
SET Var_CliSFG          := 29;
SET Var_CliConfiadora   := 46;
SET Var_CliEsp :=(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='CliProcEspecifico');

SELECT FechaSistema, DiasCredito INTO Var_FecActual, Var_DiasCredito
  FROM PARAMETROSSIS;

SELECT  Cli.PagaIVA,            Suc.IVA,                Pro.CobraIVAInteres,    Cre.Estatus,
        Pro.CobraIVAMora,       Pro.ProyInteresPagAde,  Pro.ProducCreditoID,    Cre.FrecuenciaCap,
        Cre.TasaFija,           Cre.FechaVencimien,
        (Cre.SaldoCapVigent + Cre.SaldCapVenNoExi + Cre.SaldoCapAtrasad + Cre.SaldoCapVencido)
       INTO
        Var_CliPagIVA,          Var_IVASucurs,          Var_IVAIntOrd,          Var_CreEstatus,
        Var_IVAIntMor,          Var_ProyInPagAde,       Var_PrductoCreID,       Var_Frecuencia,
        Var_CreTasa,            Var_FecProxPago,     Var_SaldoCapita

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

SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

SET Var_ValIVAIntOr := Entero_Cero;
SET Var_ValIVAIntMo := Entero_Cero;
SET Var_ValIVAGen   := Entero_Cero;

IF(Var_CreEstatus != Cadena_Vacia) THEN


    IF (Var_CliPagIVA = SiPagaIVA) THEN

        SET Var_ValIVAGen  := Var_IVASucurs;

        IF (Var_IVAIntOrd = SiPagaIVA) THEN
            SET Var_ValIVAIntOr  := Var_IVASucurs;
        END IF;

        IF (Var_IVAIntMor = SiPagaIVA) THEN
            SET Var_ValIVAIntMo  := Var_IVASucurs;
        END IF;

    END IF;

    -- Inicializacion.
    SET Var_ComAntici   := Entero_Cero;
    SET Var_DiasAntici  := Entero_Cero;
    SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);

  SET Var_SaldoIVAInteres := IFNULL(Var_SaldoIVAInteres,Decimal_Cero);
    IF(Var_CliPagIVA = 'S' ) THEN -- se agrego la validación Aeuan T_11173
    CALL CALCIVAINTERESPROVCON(
      Par_CreditoID,    Con_Finiquito2,   Var_SaldoIVAInteres,  Par_EmpresaID,  Aud_Usuario,
      Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal, Aud_NumTransaccion);
  END IF; -- fin validacion
    -- Obtenemos las Condiciones de la Comision por Finiquito.
    SELECT  PermiteLiqAntici, CobraComLiqAntici, TipComLiqAntici,
            ComisionLiqAntici, DiasGraciaLiqAntici INTO

            Var_PermiteLiqAnt, Var_CobraComLiqAnt, Var_TipComLiqAnt,
            Var_ComLiqAnt, Var_DiasGraciaLiq

        FROM ESQUEMACOMPRECRE
        WHERE ProductoCreditoID = Var_PrductoCreID;

    SET Var_PermiteLiqAnt   := IFNULL(Var_PermiteLiqAnt, Cadena_Vacia);
    SET Var_CobraComLiqAnt  := IFNULL(Var_CobraComLiqAnt, Cadena_Vacia);
    SET Var_TipComLiqAnt    := IFNULL(Var_TipComLiqAnt, Cadena_Vacia);
    SET Var_ComLiqAnt       := IFNULL(Var_ComLiqAnt, Entero_Cero);
    SET Var_DiasGraciaLiq   := IFNULL(Var_DiasGraciaLiq, Entero_Cero);

    IF(Var_FecProxPago != Fecha_Vacia AND Var_FecProxPago >= Var_FecActual) THEN
        SET Var_DiasAntici := DATEDIFF(Var_FecProxPago, Var_FecActual);
    ELSE
        SET Var_DiasAntici := Entero_Cero;
    END IF;

    IF(Var_DiasAntici > Var_DiasGraciaLiq AND Var_PermiteLiqAnt = SI_PermiteLiqAnt AND
       Var_CobraComLiqAnt = SI_CobraLiqAnt) THEN

        -- * VALIDAR EL TIPO DE COMISION
        IF(Var_TipComLiqAnt = Proyeccion_Int) THEN
            -- * SI ES PROYECCION
            -- Obtenemos el Monto del Interes Pendiente de Devengar
            SELECT SUM(Interes) INTO Var_ComAntici
                FROM AMORTICREDITO
                WHERE CreditoID   = Par_CreditoID
                  AND FechaVencim > Var_FecActual
                  AND Estatus     != EstatusPagado;

            SET Var_ComAntici   := IFNULL(Var_ComAntici, Entero_Cero);

            -- Obtenemos el Saldo De Interes de la Amortizacion Actual o Vigente
            SELECT ROUND(Amo.SaldoInteresPro + Amo.SaldoIntNoConta,2) INTO Var_IntActual
                FROM AMORTICREDITO Amo
                WHERE Amo.CreditoID   = Par_CreditoID
                  AND Amo.FechaVencim > Var_FecActual
                  AND Amo.FechaInicio <= Var_FecActual
                  AND Amo.Estatus     != EstatusPagado;

            SET Var_IntActual   := IFNULL(Var_IntActual, Entero_Cero);
            SET Var_ComAntici   := ROUND(Var_ComAntici - Var_IntActual,2);

        ELSEIF (Var_TipComLiqAnt = Por_Porcentaje) THEN        -- En Base a Porcentaje de Saldo Insoluto
            SET Var_ComAntici   := ROUND(Var_SaldoCapita * Var_ComLiqAnt / Decimal_Cien,2);
        ELSE
            SET Var_ComAntici   := Var_ComLiqAnt;
        END IF;
    ELSE
        SET Var_ComAntici   := Entero_Cero;
    END IF;

    IF(Var_ComAntici < Entero_Cero) THEN
        SET Var_ComAntici   := Entero_Cero;
    END IF;

    SELECT ROUND(IFNULL(SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                              ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

                              ROUND(SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen +
                                    SaldoInteresPro + SaldoIntNoConta, 2) +

                              ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
                              ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
                              ROUND(SaldoOtrasComis,2) +

                              CASE WHEN Var_CliEsp = Var_CliSFG THEN
                                    IFNULL(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2),Entero_Cero)
                                  WHEN Var_CliEsp = Var_CliConfiadora THEN
                                    IFNULL(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2),Entero_Cero)
                              ELSE
                                  ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2)
                              END

                              + ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen, 2) +

                ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
                  ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
                  ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2) +
                                    ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +
                                    ROUND(SaldoComisionAnual,2) +
                                    ROUND(ROUND(SaldoComisionAnual,2) * Var_ValIVAGen,2)) + ROUND(Var_ComAntici,2) + ROUND(ROUND(Var_ComAntici,2) * Var_ValIVAIntOr,2),
                           Entero_Cero) + (ROUND(Var_SaldoIVAInteres,2)), 2)
            INTO Var_MontoExigible
            FROM AMORTICREDITO
            WHERE CreditoID     =  Par_CreditoID
              AND Estatus       <> EstatusPagado;

    SET Var_MontoExigible := IFNULL(Var_MontoExigible, Decimal_Cero);

END IF;

RETURN Var_MontoExigible;

END$$