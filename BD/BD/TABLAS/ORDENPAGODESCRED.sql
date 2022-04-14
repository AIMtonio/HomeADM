-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORDENPAGODESCRED
DELIMITER ;
DROP TABLE IF EXISTS `ORDENPAGODESCRED`;DELIMITER $$

CREATE TABLE `ORDENPAGODESCRED` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numero del cliente',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'ID de la institucion',
  `NumCtaInstit` varchar(20) NOT NULL COMMENT 'Cuenta bancaria',
  `NumOrdenPago` varchar(50) NOT NULL COMMENT 'Numero de la orden de pago',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto de desembolso del credito',
  `Fecha` date NOT NULL COMMENT 'Fecha en la que se realizo la dispersion',
  `Beneficiario` varchar(200) NOT NULL COMMENT 'Nombre del Beneficiario',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la orden de pago E-Emitido, R-Renovado, O-Conciliado',
  `Referencia` varchar(50) NOT NULL COMMENT 'Referencia Orden de pago',
  `Concepto` varchar(200) NOT NULL COMMENT 'Concepto de la orden de pago',
  `MotivoRenov` varchar(150) DEFAULT '' COMMENT 'Motivo de renovacion de orden de pago',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Campo de auditoria',
  PRIMARY KEY (`ClienteID`,`NumOrdenPago`,`NumTransaccion`),
  KEY `FK_ORDENPAGODESCRED_1` (`NumOrdenPago`),
  CONSTRAINT `FK_NumOrdenPago_2` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena ordenes de pago para desembolso de credito.'$$