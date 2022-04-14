-- FN_MONTIPOCAMBIOANT
DELIMITER ;
DROP FUNCTION IF EXISTS `FN_MONTIPOCAMBIOANT`;
DELIMITER $$

CREATE FUNCTION `FN_MONTIPOCAMBIOANT`(
/*Función para obtener el ultimo registro de la tabla HIS-MONEDAS*/
Par_MonedaID    INT(11),
Par_Fecha       DATE


) RETURNS DECIMAL(14,6)
    DETERMINISTIC
BEGIN
      DECLARE Var_TipoCamDof        DECIMAL(14,6);
      DECLARE Var_NumTransaccion    BIGINT(20);
      DECLARE Var_FechaRegistro     DATE;
      DECLARE Decimal_Cero          DECIMAL(14,6);

      SET Decimal_Cero := 0.000000;

      SELECT MAX(NumTransaccion),FechaRegistro INTO Var_NumTransaccion, Var_FechaRegistro 
        FROM `HIS-MONEDAS` 
        WHERE MonedaId = Par_MonedaID 
          AND FechaRegistro < Par_Fecha 
        GROUP BY FechaRegistro 
        ORDER BY FechaRegistro DESC 
        LIMIT 1;

      SELECT TipCamDof INTO Var_TipoCamDof  
        FROM `HIS-MONEDAS` 
        WHERE MonedaId = 2 
          AND FechaRegistro = Var_FechaRegistro 
          AND NumTransaccion = Var_NumTransaccion 
        ORDER BY FechaRegistro DESC;

	
      RETURN IFNULL(Var_TipoCamDof,Decimal_Cero);
END$$