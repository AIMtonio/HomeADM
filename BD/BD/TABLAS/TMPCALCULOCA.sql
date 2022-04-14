-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCALCULOCA
DELIMITER ;
DROP TABLE IF EXISTS `TMPCALCULOCA`;
DELIMITER $$

CREATE TABLE `TMPCALCULOCA` (
  `CuentaAhoID` decimal(12,0) NOT NULL COMMENT 'Identificador de la cuenta',
  `NombreCliente` varchar(100) DEFAULT NULL COMMENT 'Nombre Cliente',
  `Etiqueta` varchar(150) DEFAULT NULL COMMENT 'Etiqueta',
  `Cargos` decimal(12,2) DEFAULT NULL COMMENT 'Cargos a la cuenta',
  `Abonos` decimal(12,2) DEFAULT NULL COMMENT 'Abonos a la cuenta',
  `FechaUltReti` date DEFAULT NULL COMMENT 'Fecha Ultimo Retiro',
  `FechaUltDepo` date DEFAULT NULL COMMENT 'Fecha Ultimo Deposito',
  `Saldo` decimal(12,2) DEFAULT NULL COMMENT 'Saldo',
  `NumTrans` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `INDEX_TMPCALCULOCA_1` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Calculo para cuenta'$$