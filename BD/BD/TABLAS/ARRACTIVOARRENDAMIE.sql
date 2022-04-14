-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRACTIVOARRENDAMIE
DELIMITER ;
DROP TABLE IF EXISTS `ARRACTIVOARRENDAMIE`;DELIMITER $$

CREATE TABLE `ARRACTIVOARRENDAMIE` (
  `ArrendaID` bigint(12) NOT NULL COMMENT 'ID del Arrendamiento',
  `ActivoID` int(11) NOT NULL COMMENT 'ID del Activo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`ArrendaID`,`ActivoID`),
  KEY `FK_ARRACTIVOARRENDAMIE_1` (`ArrendaID`),
  KEY `FK_ARRACTIVOARRENDAMIE_2` (`ActivoID`),
  CONSTRAINT `FK_ARRACTIVOARRENDAMIE_1` FOREIGN KEY (`ArrendaID`) REFERENCES `ARRENDAMIENTOS` (`ArrendaID`),
  CONSTRAINT `FK_ARRACTIVOARRENDAMIE_2` FOREIGN KEY (`ActivoID`) REFERENCES `ARRACTIVOS` (`ActivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que lleva la reacion de activos ligados a un Arrendamiento.'$$