-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPROXPAGCONTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPROXPAGCONTCON`;DELIMITER $$

CREATE PROCEDURE `CREPROXPAGCONTCON`(
    -- devuelve: Total Adeudo, MontoPagar y  ProxFecPago del Credito Contingente
    Par_CreditoID           BIGINT(12),
    Par_NumCon              TINYINT UNSIGNED,
    OUT OutTotalAde         VARCHAR(30),
    OUT OutMontoPag         VARCHAR(30),
    OUT OutProxFecPag       VARCHAR(20),

    OUT OutSaldoCapita      VARCHAR(30),
    /* Parametros de Auditoria */
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),

    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_FecActual       DATE;
DECLARE Var_TotAdeudo       DECIMAL(14,2);
DECLARE Var_TotAtrasado     DECIMAL(14,2);
DECLARE Var_MontoExigible   DECIMAL(14,2);
DECLARE Var_SaldoCapital    DECIMAL(16,2);
DECLARE Var_FechaExigible   DATE;
DECLARE Var_AmortizacionID  INT;


DECLARE Var_SucCredito      INT;
DECLARE Var_CliPagIVA       CHAR(1);
DECLARE Var_IVAIntOrd       CHAR(1);
DECLARE Var_IVAIntMor       CHAR(1);
DECLARE Var_ValIVAIntOr     DECIMAL(12,2);
DECLARE Var_ValIVAIntMo     DECIMAL(12,2);
DECLARE Var_ValIVAGen       DECIMAL(12,2);
DECLARE Var_IVASucurs       DECIMAL(12,2);

-- Declaracion de constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE EstatusPagado   CHAR(1);
DECLARE Con_ProFecPag   INT;
DECLARE SiPagaIVA       CHAR(1);

-- Asignacion de constantes
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Con_ProFecPag   := 9;   -- Consulta de Exigible y Proximas Fechas de Pago
SET SiPagaIVA       := 'S';
SET EstatusPagado   := 'P';

SET Aud_FechaActual := NOW();

SELECT Cli.PagaIVA, Cre.SucursalID, Pro.CobraIVAInteres, Pro.CobraIVAMora INTO
            Var_CliPagIVA, Var_SucCredito, Var_IVAIntOrd, Var_IVAIntMor
        FROM CREDITOSCONT Cre,
             PRODUCTOSCREDITO Pro,
             CLIENTES Cli
        WHERE Cre.CreditoID     = Par_CreditoID
          AND ProductoCreditoID = ProducCreditoID
          AND Cre.ClienteID     = Cli.ClienteID;


SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);
SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, SiPagaIVA);
SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, SiPagaIVA);

SET Var_ValIVAIntOr := Entero_Cero;
SET Var_ValIVAIntMo := Entero_Cero;
SET Var_ValIVAGen   := Entero_Cero;

-- Verificacion de Pago de IVA
IF (Var_CliPagIVA = SiPagaIVA) THEN     -- El Cliente si paga IVA
    SET Var_IVASucurs   := IFNULL((SELECT IVA
                                    FROM SUCURSALES
                                     WHERE  SucursalID = Var_SucCredito),  Entero_Cero);

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


SELECT FechaSistema INTO Var_FecActual
    FROM PARAMETROSSIS;

/* Consulta de Exigible y Proximas Fechas de Pago */
IF(Par_NumCon = Con_ProFecPag) THEN

    SELECT ROUND(IFNULL(SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                            ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2)
                            ), Entero_Cero),2),

           ROUND(IFNULL(SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                              ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

                              ROUND(SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen +
                                    SaldoInteresPro + SaldoIntNoConta, 2) +

                             ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
                                   ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
                                   ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
                                   ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
                                   ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2), 2) +

                              ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
                              ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
                              ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +
                              ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen, 2) +

                              ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
                                    ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
                                    ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2)

                             ),
                           Entero_Cero), 2)


             INTO  Var_SaldoCapital, Var_TotAdeudo

            FROM AMORTICREDITOCONT
            WHERE CreditoID     =  Par_CreditoID
              AND Estatus       <> EstatusPagado;


        SET Var_SaldoCapital    := IFNULL(Var_SaldoCapital, Entero_Cero);
        SET OutSaldoCapita      := FORMAT(Var_SaldoCapital,2);

        SELECT  ROUND(SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                    ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

                    ROUND(SaldoInteresOrd,2) + ROUND(ROUND(SaldoInteresOrd,2) * Var_ValIVAIntOr,2) +
                    ROUND(SaldoInteresAtr,2) + ROUND(ROUND(SaldoInteresAtr,2) * Var_ValIVAIntOr,2) +
                    ROUND(SaldoInteresVen,2) + ROUND(ROUND(SaldoInteresVen,2) * Var_ValIVAIntOr,2) +
                    ROUND(SaldoInteresPro,2) + ROUND(ROUND(SaldoInteresPro,2) * Var_ValIVAIntOr,2) +
                    ROUND(SaldoIntNoConta,2) + ROUND(ROUND(SaldoIntNoConta,2) * Var_ValIVAIntOr,2) +

                    ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
                    ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
                    ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +
                    ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen, 2) +
                    ROUND(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) * Var_ValIVAIntMo,2) ), 2) INTO Var_TotAtrasado


        FROM AMORTICREDITOCONT
        WHERE FechaExigible <= Var_FecActual
          AND Estatus <> EstatusPagado
          AND CreditoID = Par_CreditoID;

        SET Var_TotAtrasado := IFNULL(Var_TotAtrasado, Entero_Cero);
        SET Var_TotAdeudo   := IFNULL(Var_TotAdeudo, Entero_Cero);

        IF (Var_TotAtrasado > Entero_Cero) THEN
            SET OutTotalAde := FORMAT(Var_TotAdeudo, 2);
            SET OutMontoPag := FORMAT(Var_TotAtrasado,2);
            SET OutProxFecPag   := 'Inmediato';
        ELSE

            SELECT MIN(AmortizacionID) INTO Var_AmortizacionID
                FROM AMORTICREDITOCONT
                WHERE CreditoID   = Par_CreditoID
                  AND FechaExigible >= Var_FecActual
                  AND Estatus          != EstatusPagado;

            SET Var_AmortizacionID := IFNULL(Var_AmortizacionID, Entero_Cero);

            IF Var_AmortizacionID != Entero_Cero THEN
                SELECT  FechaExigible,
                        (ROUND(SaldoCapVigente, 2) + ROUND(Interes, 2) + ROUND(IVAInteres, 2)+
                         ROUND(SaldoCapVencido,2)  + ROUND(SaldoCapVenNExi,2)+
                         ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2))
                    INTO
                        Var_FechaExigible,
                        Var_MontoExigible
                    FROM AMORTICREDITOCONT
                    WHERE CreditoID      = Par_CreditoID
                      AND AmortizacionID = Var_AmortizacionID
                      AND Estatus          != EstatusPagado;

                SET Var_MontoExigible   := IFNULL(Var_MontoExigible, Entero_Cero);
                SET Var_FechaExigible   := IFNULL(Var_FechaExigible, Fecha_Vacia);


               SET OutTotalAde  := FORMAT(Var_TotAdeudo, 2);
               SET OutMontoPag  := FORMAT(Var_MontoExigible,2);
               SET OutProxFecPag:= Var_FechaExigible;

            ELSE
               SET OutTotalAde  := FORMAT(Var_TotAdeudo, 2);
               SET OutMontoPag  := FORMAT(Entero_Cero,2);
               SET OutProxFecPag:= Cadena_Vacia;
            END IF;
        END IF;
END IF;


END TerminaStore$$