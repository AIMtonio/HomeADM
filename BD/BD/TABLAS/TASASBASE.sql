-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASBASE
DELIMITER ;
DROP TABLE IF EXISTS `TASASBASE`;DELIMITER $$

CREATE TABLE `TASASBASE` (
  `TasaBaseID` int(11) NOT NULL COMMENT 'ID de la tabla base',
  `Nombre` varchar(45) DEFAULT NULL,
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion de la tasa base\n',
  `Valor` decimal(12,4) DEFAULT NULL COMMENT 'Valor de la Tasa',
  `ClaveCNBV` int(11) DEFAULT NULL COMMENT 'Clave Del Catalogo Tasa de Interes de Referencia SITI',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TasaBaseID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Tasas Base\n'$$