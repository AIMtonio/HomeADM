-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CENTROCOSTOS
DELIMITER ;
DROP TABLE IF EXISTS `CENTROCOSTOS`;DELIMITER $$

CREATE TABLE `CENTROCOSTOS` (
  `CentroCostoID` int(11) NOT NULL COMMENT 'Id del Centro de \nCostos',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del\nCC',
  `Responsable` varchar(100) DEFAULT NULL COMMENT 'Reponsable del\nCC',
  `PlazaID` int(11) DEFAULT NULL COMMENT 'Plaza del CC',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CentroCostoID`),
  KEY `fk_Plaza` (`PlazaID`),
  CONSTRAINT `fk_Plaza` FOREIGN KEY (`PlazaID`) REFERENCES `PLAZAS` (`PlazaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Centros de Costos'$$