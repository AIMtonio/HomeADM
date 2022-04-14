-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTCTADISPERSIONES
DELIMITER ;
DROP TABLE IF EXISTS `APORTCTADISPERSIONES`;
DELIMITER $$

CREATE TABLE `APORTCTADISPERSIONES` (
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente ID.',
  `CuentaAhoID` bigint(12)  NOT NULL COMMENT 'Número de la Cuenta.',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total Capital + Interes - ISR .',
  `MontoPendiente` decimal(18,2) DEFAULT '0.00',
  `Beneficiarios` char(1) DEFAULT 'N' COMMENT 'Indica si la Dsipersión cuenta con Beneficiarios Capturados.\nS.- Sí\nN.- No.',
  `Estatus` char(1) DEFAULT 'P' COMMENT 'Estatus de la Dispersión.\nP.- Pendiente por Dispersar\nS.- Seleccionada\nD.- Dispersada',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Aportacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`CuentaAhoID`),
  KEY `INDEX_APORTDISPERSIONES_1` (`ClienteID`),
  KEY `INDEX_APORTDISPERSIONES_2` (`CuentaAhoID`),
  KEY `INDEX_APORTDISPERSIONES_3` (`ClienteID`,`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Dispersiones de Aportaciones.'$$