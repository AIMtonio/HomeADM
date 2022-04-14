-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULADIASATRASO
DELIMITER ;
DROP FUNCTION IF EXISTS `CALCULADIASATRASO`;DELIMITER $$

CREATE FUNCTION `CALCULADIASATRASO`(
    Par_CreditoID  BIGINT(12)

) RETURNS int(11)
    DETERMINISTIC
BEGIN


    DECLARE Var_FechaSistema        DATE;
    DECLARE Var_FechaExigible       DATE;
    DECLARE Var_FechaVencimiento    DATE;
    DECLARE Var_DiasDeatraso        INT;



    DECLARE VIGENTE                 CHAR(1);
    DECLARE AUTORIZADO              CHAR(1);
    DECLARE VENCIDO                 CHAR(1);
    DECLARE CASTIGADO               CHAR(1);



    SET VIGENTE                     :='V';
    SET AUTORIZADO                  :='A';
    SET VENCIDO                     :='B';
    SET CASTIGADO                   :='K';

    SET Var_FechaSistema    := (SELECT FechaSistema FROM PARAMETROSSIS);

    SET Var_FechaExigible   := (SELECT MIN(FechaExigible) FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID  AND Estatus IN (VIGENTE, AUTORIZADO, VENCIDO,CASTIGADO));
    SET Var_FechaExigible   := IFNULL(Var_FechaExigible, DATE_ADD(Var_FechaSistema, INTERVAL 2 DAY));

    SET Var_DiasDeatraso    := 0;

    IF Var_FechaExigible < Var_FechaSistema THEN

        SET Var_FechaVencimiento    := (SELECT MIN(FechaVencim) FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID  AND  Estatus IN (VIGENTE, AUTORIZADO, VENCIDO,CASTIGADO));
        SET Var_DiasDeatraso        := DATEDIFF(Var_FechaSistema, Var_FechaVencimiento) ;

    END IF;

    RETURN Var_DiasDeatraso;

END$$