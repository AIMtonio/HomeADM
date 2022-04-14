DELIMITER ;
DROP FUNCTION IF EXISTS `FNFINIQCUOTASCOMPLETAS`;

DELIMITER $$
CREATE FUNCTION `FNFINIQCUOTASCOMPLETAS`(
-- --------------------------------------------------------------------
-- FUNCION PARA PROYECCION DE SALDO DE FINIQUITO CON PROYECCION DE
-- INTERES Y DE ACCESORIOS
-- --------------------------------------------------------------------
    Par_CreditoID       BIGINT(12),         -- Numero de Credito,
    Par_IncluyeLiaAnt   CHAR(1)             -- Indica si se incluye la comision por liquidacion anticipada
)RETURNS DECIMAL(16,2)
    DETERMINISTIC
TerminaStore: BEGIN
    -- Declaracion de variables
    DECLARE Var_Control         VARCHAR(100);       -- Variable Control
    DECLARE Var_CreditoID       BIGINT(11);            -- Variable de Credito ID
    DECLARE Var_AmortInicial    INT(11);            -- ID Amortizacion Inicial
    DECLARE Var_AmortFinal      int(11);            -- ID Amortizacion Final
    DECLARE Var_IVAIntOrd       CHAR(1);            -- Variable Cobra IVA Interes Ordinario
    DECLARE Var_CliPagIVA       CHAR(1);            -- Variable Cliente Paga IVA
    DECLARE Var_IVAIntMor       CHAR(1);            -- Variable Cobra Interes Moratorio
    DECLARE Var_IVASucurs       DECIMAL(12,2);      -- Variable IVA de la Sucursal
    DECLARE Var_SucCredito      INT(11);            -- Variable Sucursal del Cliente
    DECLARE Var_ValIVAIntOr     DECIMAL(12,2);      -- Variable Valor IVA de Interes Ord
    DECLARE Var_ValIVAGen       DECIMAL(12,2);      -- Variable Valor de IVA
    DECLARE Var_ValIVAIntMo     DECIMAL(12,2);      -- Variable Valor de IVA Interes Moratorios
    DECLARE Var_DiasAntici      INT;
    DECLARE Var_DiasGraciaLiq   INT;
    DECLARE SI_PermiteLiqAnt    CHAR(1);
    DECLARE Var_CobraComLiqAnt  CHAR(1);
    DECLARE SI_CobraLiqAnt      CHAR(1);
    DECLARE Var_TipComLiqAnt    CHAR(1);
    DECLARE Proyeccion_Int      CHAR(1);
    DECLARE Var_ComAntici       DECIMAL(14,2);
    DECLARE Var_IntActual       DECIMAL(14,2);
    DECLARE Por_Porcentaje      CHAR(1);
    DECLARE Var_PrductoCreID    INT;
    DECLARE Var_FecProxPago     DATE;
    DECLARE Var_DiasCredito     INT;
    DECLARE Var_FecActual       DATE;
    DECLARE Var_PermiteLiqAnt   CHAR(1);
    DECLARE Var_ComLiqAnt       DECIMAL(14,2);
    DECLARE Var_Adeudo          DECIMAL(16,2);
    DECLARE Var_SaldoCapita     DECIMAL(14,2);
    DECLARE Var_SaldoAccesorio      DECIMAL(14,2);
    DECLARE Var_SaldoIVAAccesorio  DECIMAL(14,2);




    -- Declaracion de constantes
    DECLARE Cadena_Vacia        CHAR(1);            -- Constante Cadena Vacia ''
    DECLARE Fecha_Vacia         DATE;               -- Constante Fecha Vacia  '1900-01-01'
    DECLARE Entero_Cero         INT(11);            -- Constante Entero Cero 0
    DECLARE Decimal_Cero        DECIMAL(12,4);      -- Constante Deciaml Cero 0.0
    DECLARE Decimal_Cien        DECIMAL(12,4);      -- Deciaml Cien 100.00
    DECLARE Con_Principal       INT(11);
    DECLARE EstatusVigente      CHAR(1);            -- Estatus Vigente
    DECLARE EstatusPagado       CHAR(1);            -- Estatus Pagado
    DECLARE SiPagaIVA           CHAR(1);            -- Cobra IVA 'S'
    DECLARE SalidaSI            CHAR(1);            -- Salida SI
    DECLARE Cons_Si             CHAR(1);            -- Constante SI
    DECLARE Proces_Monto        CHAR(1);            -- Constante 'M' Proceso para sacar el Monto de los Accesorios
    DECLARE Proces_IVA          CHAR(1);            -- Constante 'I' Proceso para sacar el IVA de los Accesorios

    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET Decimal_Cien        := 100.0;
    SET Con_Principal       := 1;
    SET EstatusVigente      := 'V';
    SET EstatusPagado       := 'P';
    SET SiPagaIVA           := 'S';
    SET SalidaSI            := 'S';
    SET Cons_Si             := 'S';
    SET Proces_Monto        := 'M';
    SET Proces_IVA          := 'I';
    SET SI_PermiteLiqAnt    := 'S';       -- El Producto Si Permite Liquidacion Anticipada
    SET SI_CobraLiqAnt      := 'S';       -- El Producto Si Cobra Comision por Liquidacion Anticipada
    SET Proyeccion_Int      := 'P';       -- Tipo de Comision por Finiquito: Proyeccion de Interes
    SET Por_Porcentaje      := 'S';       -- Tipo de Comision Porcentaje del Sald Insoluto
    SET Var_ComAntici       := Entero_Cero;
    SET Var_DiasAntici      := Entero_Cero;

    SELECT FechaSistema, DiasCredito INTO Var_FecActual, Var_DiasCredito
    FROM PARAMETROSSIS;

        SELECT  Cli.PagaIVA,    Cre.SucursalID,     Pro.CobraIVAInteres,        Pro.CobraIVAMora,   Pro.ProducCreditoID,
                Cre.FechaVencimien,
                (Cre.SaldoCapVigent + Cre.SaldCapVenNoExi + Cre.SaldoCapAtrasad + Cre.SaldoCapVencido)
                INTO
                Var_CliPagIVA,  Var_SucCredito,     Var_IVAIntOrd,              Var_IVAIntMor,      Var_PrductoCreID,
                Var_FecProxPago,
                Var_SaldoCapita
                FROM CREDITOS Cre,
                    PRODUCTOSCREDITO Pro,
                    CLIENTES Cli
                WHERE Cre.CreditoID     = Par_CreditoID
                AND Cre.ProductoCreditoID = Pro.ProducCreditoID
                AND Cre.ClienteID     = Cli.ClienteID;

        SET Var_CliPagIVA       := IFNULL(Var_CliPagIVA, SiPagaIVA);
        SET Var_IVAIntOrd       := IFNULL(Var_IVAIntOrd, SiPagaIVA);
        SET Var_IVAIntMor       := IFNULL(Var_IVAIntMor, SiPagaIVA);

        SET Var_ValIVAIntOr := Entero_Cero;
        SET Var_ValIVAIntMo := Entero_Cero;
        SET Var_ValIVAGen   := Entero_Cero;

        IF (Var_CliPagIVA = SiPagaIVA) THEN
            SET Var_IVASucurs   := (SELECT IVA
                                        FROM SUCURSALES
                                            WHERE  SucursalID = Var_SucCredito);
            SET Var_IVASucurs := IFNULL(Var_IVASucurs, Entero_Cero);

                -- IVA General (Comisiones y Otro Cargos)
                SET Var_ValIVAGen  := Var_IVASucurs;
                -- Verificamos si Paga IVA de Interes Ordinario
                IF (Var_IVAIntOrd = SiPagaIVA) THEN
                    SET Var_ValIVAIntOr  := Var_IVASucurs;
                END IF;

                IF (Var_IVAIntMor = SiPagaIVA) THEN
                    SET Var_ValIVAIntMo  := Var_IVASucurs;
                END IF;
        END IF;

        -- Obtenemos las Condiciones de la Comision por Finiquito.
        SELECT  PermiteLiqAntici, CobraComLiqAntici, TipComLiqAntici,
            ComisionLiqAntici, DiasGraciaLiqAntici INTO

            Var_PermiteLiqAnt, Var_CobraComLiqAnt, Var_TipComLiqAnt,
            Var_ComLiqAnt, Var_DiasGraciaLiq

        FROM ESQUEMACOMPRECRE
        WHERE ProductoCreditoID = Var_PrductoCreID;

        SELECT MIN(AmortizacionID), MAX(AmortizacionID)
        INTO Var_AmortInicial, Var_AmortFinal
        FROM AMORTICREDITO
        WHERE CreditoID = Par_CreditoID
        AND Estatus IN ('V','A','B');

        SET Var_AmortInicial := IFNULL(Var_AmortInicial,Entero_Cero);
        SET Var_AmortFinal := IFNULL(Var_AmortFinal,Entero_Cero);

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

        SET Var_SaldoAccesorio := ROUND(IFNULL(FNMONTOCUOPROYACCES(Par_CreditoID, Var_AmortInicial, Var_AmortFinal, Proces_Monto),0),2);
        SET Var_SaldoIVAAccesorio := ROUND(IFNULL(FNMONTOCUOPROYACCES(Par_CreditoID, Var_AmortInicial, Var_AmortFinal, Proces_IVA),0),2);
        SET Var_Adeudo := (SELECT
                    IFNULL(
                                SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                                    ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +
                                    ROUND(CASE WHEN IFNULL(NumProyInteres,Entero_Cero) = Entero_Cero AND Estatus = EstatusVigente  AND FechaVencim >= Var_FecActual THEN Interes
                                            ELSE SaldoInteresOrd + SaldoInteresAtr +
                                                    SaldoInteresVen + SaldoInteresPro +
                                                    SaldoIntNoConta + SaldoSeguroCuota +
                                                    SaldoComisionAnual END ,2) +
                                    CASE WHEN IFNULL(NumProyInteres,Entero_Cero) = Entero_Cero AND Estatus = EstatusVigente  AND FechaVencim >= Var_FecActual THEN ROUND(Interes * Var_ValIVAIntOr,2)
                                        ELSE
                                        ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
                                                ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
                                                ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
                                                ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
                                                ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2), 2) END +
                                    ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
                                    ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
                                    ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +
                                    ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
                                    ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
                                            ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2)+
                                            ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2)+
                                            ROUND(SaldoComisionAnual * Var_ValIVAGen,2), 2)
                                    ),
                                Entero_Cero) AS adeudoTotal

                FROM AMORTICREDITO Amo
                WHERE Amo.CreditoID = Par_CreditoID
                AND Amo.Estatus IN ('V','A','B'));

        SET Var_Adeudo := IFNULL(Var_Adeudo,Entero_Cero);

        SET Var_Adeudo := Var_Adeudo + Var_SaldoAccesorio + Var_SaldoIVAAccesorio + CASE WHEN Par_IncluyeLiaAnt = 'S' THEN Var_ComAntici ELSE 0 END;

        RETURN Var_Adeudo;

END TerminaStore$$
