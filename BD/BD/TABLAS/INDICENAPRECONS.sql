-- INDICENAPRECONS
DELIMITER ;
DROP TABLE IF EXISTS `INDICENAPRECONS`;
DELIMITER $$

CREATE TABLE `INDICENAPRECONS` (
  `Anio` int(11) NOT NULL COMMENT 'Anio del INPC',
  `Mes` int(11) NOT NULL COMMENT 'Mes del INPC',
  `ValorINPC` decimal(12,3) NOT NULL COMMENT 'Indice Nacional de Precios al Consumidor del Mes y Anio',
  `FechaFinMes` date NOT NULL COMMENT 'Fecha Fin Mes',
  `FechaRegistro` date NOT NULL COMMENT 'Fecha en que se registra en INPC',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`Anio`,`Mes`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el registro de Indice Nacional de Precios al Consumidor'$$