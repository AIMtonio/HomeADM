-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREGARPRENHIPO
DELIMITER ;
DROP TABLE IF EXISTS `CREGARPRENHIPO`;
DELIMITER $$


CREATE TABLE `CREGARPRENHIPO` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero de Credito',
  `NombreSocio` varchar(250) NOT NULL COMMENT 'Nombre del Socio',
  `Monto_Original` decimal(14,2) DEFAULT NULL COMMENT 'Monto Original de la Garantia',
  `SalCapVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente',
  `SalCapVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido',
  `GarPrendaria` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la Garantia Prendaria',
  `GarHipotecaria` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la Garantia Hipotecaria',
  `NumeroAvaluo` varchar(17) DEFAULT NULL COMMENT 'Numero de avaluo registrado ante la SHF que sirvió de base para el otorgamiento del crédito.',
  `FechaAvaluo` date DEFAULT NULL COMMENT 'Fecha de Avaluo',
  `MontoAvaluo` decimal(21,2) DEFAULT NULL COMMENT 'Monto de Avaluo de la Garantia',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente',
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero de Solicitud de Credito',
  `MontoGarHipo` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Total de las Garantias que estan Libres de Gravamen',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(70) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `id_indexNomSoc` (`NombreSocio`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
