-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMISCRE
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMACOMISCRE`;DELIMITER $$

CREATE TABLE `ESQUEMACOMISCRE` (
  `EsquemaComID` int(11) NOT NULL COMMENT 'ID consecutivo de la tabla',
  `MontoInicial` decimal(12,2) NOT NULL COMMENT 'Monto Inicial',
  `MontoFinal` decimal(12,2) NOT NULL COMMENT 'Monto Final ',
  `TipoComision` char(1) NOT NULL COMMENT 'Tipo de Comision:\nM .- Monto\nP .- Porcentaje',
  `Comision` decimal(12,4) NOT NULL COMMENT 'Valor del monto la\ncomision o Porcentaje.',
  `ProducCreditoID` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`EsquemaComID`),
  KEY `fk_ESQUEMACOMISCRE_1` (`ProducCreditoID`),
  CONSTRAINT `fk_ESQUEMACOMISCRE_1` FOREIGN KEY (`ProducCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Manejo de Comisiones'$$