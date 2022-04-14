-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAGARANTIALIQ
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMAGARANTIALIQ`;DELIMITER $$

CREATE TABLE `ESQUEMAGARANTIALIQ` (
  `EsquemaGarantiaLiqID` int(10) NOT NULL DEFAULT '0' COMMENT 'ID consecutivo de la tabla',
  `ProducCreditoID` int(11) DEFAULT NULL COMMENT 'ID del producto de credito,  PRODUCTOSCREDITO',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'Clasificacion del cliente, A=Excelente, B=Buena, C= Regular, N=No Asiganda',
  `LimiteInferior` decimal(14,2) DEFAULT NULL COMMENT 'Sucursal a la que se cambia el cliente',
  `LimiteSuperior` decimal(14,2) DEFAULT NULL COMMENT 'Promotor anterior del cliente',
  `Porcentaje` decimal(14,2) DEFAULT NULL COMMENT 'Nuevo promotor asignado en la nueva sucursal',
  `BonificacionFOGA` decimal(14,2) DEFAULT '0.00' COMMENT 'Indica el porcentaje de Bonificacion para Garantias FOGA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`EsquemaGarantiaLiqID`),
  KEY `FK_ProducCreditoID_4` (`ProducCreditoID`),
  CONSTRAINT `FK_ProducCreditoID_4` FOREIGN KEY (`ProducCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda los esquemas de garantía líquida para un producto de '$$