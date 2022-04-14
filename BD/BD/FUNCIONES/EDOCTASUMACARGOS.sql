-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTASUMACARGOS
DELIMITER ;
DROP FUNCTION IF EXISTS `EDOCTASUMACARGOS`;
DELIMITER $$


CREATE FUNCTION `EDOCTASUMACARGOS`(
    Credito             BIGINT(12),
    FecIniMes           DATE,
    FecFinMes           DATE,                                    
    TipoSuma            INT(11),
    ValorIVAInt         DECIMAL(14,2),
    ValorIVAMora        DECIMAL(14,2),
    ValorIVAAccesorios  DECIMAL(14,2)

) RETURNS decimal(12,2)
    DETERMINISTIC
BEGIN
    
    DECLARE resultado DECIMAL(12,2);
    DECLARE TipoCapital INT(11);
    DECLARE TipoInteres INT(11);
    DECLARE TipoMoratorio INT(11);
    DECLARE TipoComFaltaPago INT(11);
    DECLARE TipoOtrasComisiones INT(11);
    DECLARE TipoIVAs INT(11);
    DECLARE CapitaAmo DECIMAL(18,2);

    DECLARE Var_OtrasCom DECIMAL(18,2);
    DECLARE Var_ComFaltaPago DECIMAL(18,2);
    DECLARE Var_Moratorios DECIMAL(18,2);
    DECLARE Var_Intereses DECIMAL(18,2);
    DECLARE Var_FechaDesembolso DATE;
	DECLARE MesesExcluir	VARCHAR(150);
    DECLARE ProductoCredID	INT(11);

    SET TipoCapital = 1;
    SET TipoInteres = 2;
    SET TipoMoratorio = 3;
    SET TipoComFaltaPago = 4;
    SET TipoOtrasComisiones = 5;
    SET TipoIVAs = 6;
    SET CapitaAmo := 0;
    SET MesesExcluir := '';

    SELECT FechaInicio, ProductoCreditoID INTO Var_FechaDesembolso, ProductoCredID
		FROM CREDITOS WHERE CreditoID = Credito;
	
    SET MesesExcluir := FNEDOCTAMESESEXCLUYE(ProductoCredID, YEAR(FecIniMes), MONTH(FecIniMes), MONTH(FecFinMes));

    IF TipoSuma = TipoCapital THEN
        SET resultado := (SELECT ROUND(IFNULL(SUM(Capital), 0.0), 2)
                                FROM AMORTICREDITO
                                WHERE CreditoID = Credito
                                  AND FechaVencim >= FecIniMes
                                  AND FechaVencim <= FecFinMes
                                  AND (Estatus IN ('V', 'A', 'B', 'K')
                                        OR (Estatus = 'P' AND FechaLiquida >= FecIniMes))
								  AND FIND_IN_SET(MONTH(FechaVencim), MesesExcluir) = 0);

    ELSEIF TipoSuma = TipoInteres THEN
        SELECT ROUND(IFNULL(SUM(Cantidad), 0.0) , 2)
        INTO resultado
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND TipoMovCreID IN  (10,11,12,13,14) 
          AND NatMovimiento = 'C'
          AND (Descripcion = 'CIERRE DIARO CARTERA' AND Referencia ='GENERACION INTERES')
          AND FIND_IN_SET(MONTH(FechaOperacion), MesesExcluir) = 0;          
    ELSEIF TipoSuma = TipoMoratorio THEN
        SELECT ROUND(IFNULL(SUM(Cantidad), 0.0) , 2)
        INTO resultado
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'C'
          AND TipoMovCreID IN  (15, 16, 17)
          AND (Descripcion = 'CIERRE DIARO CARTERA'  AND Referencia ='GENERACION INTERES MORATORIO')
          AND FIND_IN_SET(MONTH(FechaOperacion), MesesExcluir) = 0;
    ELSEIF TipoSuma = TipoComFaltaPago THEN
        SELECT ROUND(IFNULL(SUM(Cantidad), 0.0), 2)
        INTO resultado
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'C'
          AND TipoMovCreID IN  (40)
          AND (Descripcion = 'CIERRE DIARO CARTERA'  AND Referencia ='GENERACION INTERES MORATORIO')
          AND FIND_IN_SET(MONTH(FechaOperacion), MesesExcluir) = 0;
    ELSEIF TipoSuma = TipoOtrasComisiones THEN
        SELECT ROUND(IFNULL(SUM(Cantidad), 0.0), 2)
        INTO resultado
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'C'
          AND TipoMovCreID IN  (41,42) 
          AND FIND_IN_SET(MONTH(FechaOperacion), MesesExcluir) = 0;
    ELSEIF TipoSuma = TipoIVAs THEN

        SELECT IFNULL(SUM(Cantidad), 0.0)
        INTO Var_Intereses
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'C'
          AND TipoMovCreID IN  (10,11,12,13,14)
          AND (Descripcion = 'CIERRE DIARO CARTERA' AND Referencia ='GENERACION INTERES')
          AND FIND_IN_SET(MONTH(FechaOperacion), MesesExcluir) = 0;

        SELECT IFNULL(SUM(Cantidad), 0.0)
        INTO Var_Moratorios
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'C'
          AND TipoMovCreID IN  (15, 16, 17)
          AND (Descripcion = 'CIERRE DIARO CARTERA'  AND Referencia ='GENERACION INTERES MORATORIO')
          AND FIND_IN_SET(MONTH(FechaOperacion), MesesExcluir) = 0;

        SELECT IFNULL(SUM(Cantidad), 0.0)
        INTO Var_ComFaltaPago
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'C'
          AND TipoMovCreID IN  (40)
          AND (Descripcion = 'CIERRE DIARO CARTERA'  AND Referencia ='GENERACION INTERES MORATORIO')
          AND FIND_IN_SET(MONTH(FechaOperacion), MesesExcluir) = 0;

        SELECT IFNULL(SUM(Cantidad), 0.0)
        INTO Var_OtrasCom
        FROM CREDITOSMOVS
        WHERE CreditoID = Credito
          AND FechaOperacion >= FecIniMes AND FechaOperacion <= FecFinMes
          AND NatMovimiento = 'C'
          AND TipoMovCreID IN  (41,42) 
          AND FIND_IN_SET(MONTH(FechaOperacion), MesesExcluir) = 0;


        SET resultado   :=  (SELECT   ROUND(IFNULL(ValorIVAInt, 0.0)*Var_Intereses, 2) +
                                     ROUND(IFNULL(Var_Moratorios, 0.0) * ValorIVAMora, 2) +
                                     ROUND((IFNULL((Var_OtrasCom + Var_ComFaltaPago), 0.0) * ValorIVAAccesorios), 2)
                             FROM EDOCTARESUMCREDITOS
                             WHERE CreditoID = Credito
                               AND Orden = 2);

    END IF;

    RETURN resultado;
END$$