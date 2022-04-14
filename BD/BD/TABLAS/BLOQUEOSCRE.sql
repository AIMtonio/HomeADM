-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BLOQUEOSCRE
DELIMITER ;
DROP TABLE IF EXISTS `BLOQUEOSCRE`;DELIMITER $$

CREATE TABLE `BLOQUEOSCRE` (
  `Consecutivo` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de registro',
  `BloqueoID` int(11) DEFAULT NULL COMMENT 'Numero de Bloqueo',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Cuenta de Ahorro del Cliente',
  `MontoBloqueado` decimal(12,2) DEFAULT NULL COMMENT 'Monto Bloqueado',
  `Referencia` bigint(20) DEFAULT NULL COMMENT 'Numero del Credito al que se le realizo el bloqueo',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo Auditoria',
  PRIMARY KEY (`Consecutivo`),
  KEY `INDEX_BLOQUEOSCRE_1` (`BloqueoID`),
  KEY `INDEX_BLOQUEOSCRE_2` (`CuentaAhoID`),
  KEY `INDEX_BLOQUEOSCRE_3` (`Referencia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena los bloqueos por garantia liquida que se le han realizado a un credito'$$