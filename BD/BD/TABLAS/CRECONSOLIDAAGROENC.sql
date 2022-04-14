-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROENC
DELIMITER ;
DROP TABLE IF EXISTS `CRECONSOLIDAAGROENC`;
DELIMITER $$


CREATE TABLE `CRECONSOLIDAAGROENC` (
  `FolioConsolida` bigint(12) NOT NULL COMMENT 'ID o Referencia de Consolidacion',
  `FechaConsolida` date NOT NULL COMMENT 'Fecha en cual se realiza la operación de la Consolidacion',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Número de Solicitud',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Número de Crédito',
  `FechaDesembolso` date NOT NULL COMMENT 'Fecha de Desembolso del crédito consolidado',
  `CantRegistros` int(11) NOT NULL COMMENT 'Cantidad Creditos Consolidados ',
  `MontoConsolidado` decimal(14,2) DEFAULT NULL COMMENT 'Suma total de las Creditos Consolidados',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la Consolidacion.\nN = No Autorizada,\nA = Autorizada \nC = Cancelada',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`FolioConsolida`),
  KEY `IDX_CRECONSOLIDAAGROENC_1` (`SolicitudCreditoID`),
  KEY `IDX_CRECONSOLIDAAGROENC_2` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Encabezado para el proceso de Consolidacion de Creditos'$$