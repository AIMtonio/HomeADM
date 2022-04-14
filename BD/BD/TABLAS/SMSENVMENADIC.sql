-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSENVMENADIC
DELIMITER ;
DROP TABLE IF EXISTS `SMSENVMENADIC`;DELIMITER $$

CREATE TABLE `SMSENVMENADIC` (
  `EnvioID` int(11) NOT NULL COMMENT 'ID de Envio ',
  `CuentaAsociada` varchar(20) DEFAULT NULL,
  `NumeroCliente` varchar(20) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EnvioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Informacion Adicional de envios de SMS'$$