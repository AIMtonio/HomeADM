-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMANUAL
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMACOMANUAL`;DELIMITER $$

CREATE TABLE `ESQUEMACOMANUAL` (
  `ProducCreditoID` int(11) NOT NULL COMMENT 'Id del producto de credito',
  `CobraComision` varchar(1) NOT NULL COMMENT 'Cobra Comision S:Si N:No',
  `TipoComision` varchar(1) NOT NULL COMMENT 'Tipo de Comision P:Porcentaje M:Monto',
  `BaseCalculo` varchar(1) NOT NULL COMMENT 'Base del Cálculo M:Monto del crédito Original S:Saldo Insoluto',
  `MontoComision` decimal(14,2) NOT NULL COMMENT 'Monto de la Comision en caso de que el tipo de comision sea M',
  `PorcentajeComision` decimal(14,4) NOT NULL COMMENT 'Porcentaje de la comision en caso de que el tipo de comision sea P',
  `DiasGracia` int(11) NOT NULL COMMENT 'Dias de gracia que se dan antes de cobrar la comisión',
  `Empresa` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`ProducCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que guarda la parametrización de esquemas de comision de cobro de anualidad del crédito.'$$