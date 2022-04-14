-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFECHAPROXPAG
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHAPROXPAG`;DELIMITER $$

CREATE FUNCTION `FNFECHAPROXPAG`(
    Par_CreditoID   BIGINT(12)


) RETURNS varchar(20) CHARSET latin1
    DETERMINISTIC
BEGIN

    DECLARE FechaVacia          DATE;
    DECLARE Est_Pagado          CHAR(1);

    DECLARE Var_FecProxPago     VARCHAR(20);
    DECLARE Var_FecActual       DATE;


    SET FechaVacia              := '1900-01-01';
    SET Est_Pagado              := 'P';


    SET Var_FecActual           := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_FecActual           := IFNULL(Var_FecActual, FechaVacia);

    SELECT CASE WHEN DATEDIFF(Var_FecActual, IFNULL(MIN(FechaExigible), Var_FecActual)) > 0 THEN 'INMEDIATO'
            ELSE IFNULL(MIN(FechaExigible), '') END
        INTO Var_FecProxPago
    FROM AMORTICREDITO
    WHERE CreditoID     =  Par_CreditoID
      AND Estatus       <> Est_Pagado;

    RETURN Var_FecProxPago;

END$$