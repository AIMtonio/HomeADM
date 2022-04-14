-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPONOSOL
DELIMITER ;
DROP TABLE IF EXISTS `INTEGRAGRUPONOSOL`;DELIMITER $$

CREATE TABLE `INTEGRAGRUPONOSOL` (
  `GrupoID` bigint(12) NOT NULL COMMENT 'Numero ID del grupo',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente',
  `TipoIntegrantes` int(4) DEFAULT NULL COMMENT 'Tipo de integrante, 1.- Lider, 2.- Tesorero, 3.- Vocal, 4.- Integrante',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`GrupoID`,`ClienteID`),
  KEY `FK_GrupoID_1` (`GrupoID`),
  KEY `FK_ClienteID_12` (`ClienteID`),
  CONSTRAINT `FK_ClienteID_12` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Integrantes de Grupos No solidarios de Clientes'$$