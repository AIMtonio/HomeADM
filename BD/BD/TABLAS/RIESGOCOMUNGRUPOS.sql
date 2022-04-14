-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOCOMUNGRUPOS
DELIMITER ;
DROP TABLE IF EXISTS `RIESGOCOMUNGRUPOS`;DELIMITER $$

CREATE TABLE `RIESGOCOMUNGRUPOS` (
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Consecutivo ID',
  `ClienteID` int(11) NOT NULL COMMENT 'ID cliente pivote',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `RIESGOCOMUNGRUPOS_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que almacacena el cliente pivote para los grupos de excedentes de riesgo'$$