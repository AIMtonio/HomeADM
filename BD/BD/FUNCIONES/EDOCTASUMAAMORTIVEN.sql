-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTASUMAAMORTIVEN
DELIMITER ;
DROP FUNCTION IF EXISTS `EDOCTASUMAAMORTIVEN`;
DELIMITER $$


CREATE FUNCTION `EDOCTASUMAAMORTIVEN`(
    Credito             BIGINT(12),
    FecFinMes           DATE,
    ValorIVAInt         DECIMAL(14,2),
    ValorIVAMora        DECIMAL(14,2),
    ValorIVAAccesorios  DECIMAL(14,2)

) RETURNS decimal(18,2)
    DETERMINISTIC
BEGIN


    DECLARE resultado DECIMAL(18,2);

    SET ValorIVAInt         := IFNULL(ValorIVAInt, 0.0) + 1;
    SET ValorIVAMora        := IFNULL(ValorIVAMora, 0.0) + 1;
    SET ValorIVAAccesorios  := IFNULL(ValorIVAAccesorios, 0.0) + 1;

    SELECT IFNULL(SUM(   (SaldoCapVigente
                          +SaldoCapAtrasa
                          +SaldoCapVencido
                          +SaldoCapVenNExi)
                        +((SaldoInteresOrd
                           +SaldoInteresAtr
                           +SaldoInteresVen
                           +SaldoInteresPro
                           +SaldoIntNoConta) * ValorIVAInt
                         )+(SaldoMoratorios*ValorIVAMora) + (SaldoMoraVencido*ValorIVAMora) + (SaldoMoraCarVen*ValorIVAMora)
                        +((SaldoComFaltaPa
                           +SaldoComServGar
                           +SaldoOtrasComis)*ValorIVAAccesorios
                         )
                      ), 0.0)
    INTO resultado
    FROM AMORTICREDITO
    WHERE CreditoID = Credito
      AND FechaExigible <= FecFinMes
      AND Estatus IN('V', 'B', 'A');



      RETURN resultado;
END$$