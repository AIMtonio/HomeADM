-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRODUCTOSCREDITOBE
DELIMITER ;
DROP TABLE IF EXISTS `PRODUCTOSCREDITOBE`;DELIMITER $$

CREATE TABLE `PRODUCTOSCREDITOBE` (
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'Llave foranea de la tabla PRODUCTOSCREDITO',
  `DestinoCreditoID` int(11) DEFAULT NULL COMMENT 'Llave foranea de la tabla DESTINOSCREDITO',
  `ClasificacionDestino` char(1) DEFAULT NULL COMMENT 'Clasificacion del Destino Credito',
  `PerfilID` int(11) DEFAULT NULL COMMENT 'ID del d perfil de Banca en Linea',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_PRODUCTOSCREDITOBE_1_idx` (`ProductoCreditoID`),
  KEY `fk_PRODUCTOSCREDITOBE_2_idx` (`DestinoCreditoID`),
  CONSTRAINT `fk_PRODUCTOSCREDITOBE_1` FOREIGN KEY (`ProductoCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PRODUCTOSCREDITOBE_2` FOREIGN KEY (`DestinoCreditoID`) REFERENCES `DESTINOSCREDITO` (`DestinoCreID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$