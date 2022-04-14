-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAFRECTIMXPROD
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAFRECTIMXPROD`;
DELIMITER $$


CREATE TABLE `EDOCTAFRECTIMXPROD` (
  `FrecuenciaID` char(1) NOT NULL COMMENT 'Frecuencia',
  `ProducCreditoID` int(11) NOT NULL COMMENT 'Producto de credito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`FrecuenciaID`,`ProducCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Frecuencias de Timbrado por Producto'$$
