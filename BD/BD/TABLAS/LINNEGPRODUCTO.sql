-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINNEGPRODUCTO
DELIMITER ;
DROP TABLE IF EXISTS `LINNEGPRODUCTO`;DELIMITER $$

CREATE TABLE `LINNEGPRODUCTO` (
  `LinProID` int(11) NOT NULL COMMENT 'Llave Principal para Catalogo de Lineas de Negocio',
  `LinNegID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a tabla de Catalogo de Lineas de Negocio',
  `ProducCreditoID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a Catalogo de Productos de Credito',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`LinProID`),
  KEY `fk_LINNEGPRODUCTO_1_idx` (`LinNegID`),
  KEY `fk_LINNEGPRODUCTO_2_idx` (`ProducCreditoID`),
  CONSTRAINT `fk_LINNEGPRODUCTO_1` FOREIGN KEY (`LinNegID`) REFERENCES `CATLINEANEGOCIO` (`LinNegID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_LINNEGPRODUCTO_2` FOREIGN KEY (`ProducCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Aagrupación de productos por línea de negocio'$$