-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASPRODCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASPRODCREDITO`;DELIMITER $$

CREATE TABLE `CUENTASPRODCREDITO` (
  `ProductoCreditoID` int(11) NOT NULL,
  `TipoCuentaID` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProductoCreditoID`,`TipoCuentaID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla parametrizable para las cuentas por producto \n'$$