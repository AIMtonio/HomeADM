-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMFALTASOBRA
DELIMITER ;
DROP TABLE IF EXISTS `PARAMFALTASOBRA`;DELIMITER $$

CREATE TABLE `PARAMFALTASOBRA` (
  `ParamFaltaSobraID` int(11) NOT NULL COMMENT 'id  de la tabla',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Numero de Sucursal',
  `MontoMaximoSobra` decimal(14,2) DEFAULT NULL COMMENT 'Monto Maximo permitido como Sobrante en la Caja',
  `MontoMaximoFalta` decimal(14,2) DEFAULT NULL COMMENT 'Monto Maximo Faltante en la Caja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ParamFaltaSobraID`),
  KEY `fk_PARAMFALTASOBRA_1_idx` (`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena informacion de los Parametros  Faltantes y Sobrante'$$