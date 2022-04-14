-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROCUOTA
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMASEGUROCUOTA`;DELIMITER $$

CREATE TABLE `ESQUEMASEGUROCUOTA` (
  `ProducCreditoID` int(11) NOT NULL COMMENT 'Id del producto de credito',
  `Frecuencia` varchar(1) NOT NULL COMMENT 'Tipo de frecuencia',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto del seguro.',
  `Empresa` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`ProducCreditoID`,`Frecuencia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que guarda la parametrización de esquemas de seguros por cuota.'$$