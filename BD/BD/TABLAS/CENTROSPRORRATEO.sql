-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CENTROSPRORRATEO
DELIMITER ;
DROP TABLE IF EXISTS `CENTROSPRORRATEO`;DELIMITER $$

CREATE TABLE `CENTROSPRORRATEO` (
  `ProrrateoID` int(11) NOT NULL COMMENT 'ID del metodo de prorrateo',
  `CentroCostoID` int(11) NOT NULL COMMENT 'ID del centro de Costos',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del centro de costos',
  `Porcentaje` decimal(5,2) NOT NULL COMMENT 'Porcentaje que pagara sobre el ID del metodo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProrrateoID`,`CentroCostoID`),
  KEY `fk_CENTROSPRORRATEO_1_idx` (`ProrrateoID`),
  CONSTRAINT `fk_CENTROSPRORRATEO_1` FOREIGN KEY (`ProrrateoID`) REFERENCES `PRORRATEOCONTABLE` (`ProrrateoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$