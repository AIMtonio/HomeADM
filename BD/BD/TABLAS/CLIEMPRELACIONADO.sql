-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIEMPRELACIONADO
DELIMITER ;
DROP TABLE IF EXISTS `CLIEMPRELACIONADO`;DELIMITER $$

CREATE TABLE `CLIEMPRELACIONADO` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de CLiente ',
  `EmpleadoID` bigint(20) NOT NULL COMMENT 'Numero de empleado',
  `TienePoder` char(1) DEFAULT NULL COMMENT 'ESte cambio indica si el cliente o empleado tiene poder notarial',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`EmpleadoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla relacion de clientes - empleados para saber quienes tienen firma que comprometa a la institucion'$$