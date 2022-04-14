-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTASUMAABONOS
DELIMITER ;
DROP FUNCTION IF EXISTS `EDOCTASUMAABONOS`;DELIMITER $$

CREATE FUNCTION `EDOCTASUMAABONOS`(
    Credito     BIGINT(12),
    FecIniMes   DATE,
    FecFinMes   DATE,
    TipoSuma    INT(11)

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN
    DECLARE resultado DECIMAL(14,2);
    DECLARE TipoCapital INT(11);
    DECLARE TipoInteres INT(11);
    DECLARE TipoMoratorio INT(11);
    DECLARE TipoComFaltaPago INT(11);
    DECLARE TipoOtrasComisiones INT(11);
    DECLARE TipoIVAs INT(11);

    SET TipoCapital = 1;
    SET TipoInteres = 2;
    SET TipoMoratorio = 3;
    SET TipoComFaltaPago = 4;
    SET TipoOtrasComisiones = 5;
    SET TipoIVAs = 6;

    IF TipoSuma = TipoCapital THEN
        SELECT IFNULL(SUM(Cantidad), 0.0)
        INTO resultado
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'A'
          AND TipoMovCreID IN (1,2,3,4)
          AND (Descripcion = 'PAGO DE CREDITO'
                OR Descripcion = 'BONIFICACION');
    ELSEIF TipoSuma = TipoInteres THEN
        SELECT IFNULL(SUM(Cantidad), 0.0)
        INTO resultado
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'A'
          AND TipoMovCreID IN  (10,11,12,13,14)
          AND (Descripcion = 'PAGO DE CREDITO'
                OR Descripcion = 'BONIFICACION');
    ELSEIF TipoSuma = TipoMoratorio THEN
        SELECT IFNULL(SUM(Cantidad), 0.0)
        INTO resultado
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'A'
          AND TipoMovCreID IN  (15)
          AND (Descripcion = 'PAGO DE CREDITO'
                OR Descripcion = 'BONIFICACION');
    ELSEIF TipoSuma = TipoComFaltaPago THEN
        SELECT IFNULL(SUM(Cantidad), 0.0)
        INTO resultado
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'A'
          AND TipoMovCreID IN  (40)
          AND (Descripcion = 'PAGO DE CREDITO'
                OR Descripcion = 'BONIFICACION');
    ELSEIF TipoSuma = TipoOtrasComisiones THEN
        SELECT IFNULL(SUM(Cantidad), 0.0)
        INTO resultado
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'A'
          AND TipoMovCreID IN  (41,42)
          AND (Descripcion = 'PAGO DE CREDITO'
                OR Descripcion = 'BONIFICACION');
    ELSEIF TipoSuma = TipoIVAs THEN
        SELECT IFNULL(SUM(Cantidad), 0.0)
        INTO resultado
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'A'
          AND TipoMovCreID IN  (20,21,22,23)
          AND (Descripcion = 'PAGO DE CREDITO'
                OR Descripcion = 'BONIFICACION');
    END IF;

      RETURN resultado;
END$$