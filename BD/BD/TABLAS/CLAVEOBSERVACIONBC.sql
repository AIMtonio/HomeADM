-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLAVEOBSERVACIONBC
DELIMITER ;
DROP TABLE IF EXISTS `CLAVEOBSERVACIONBC`;DELIMITER $$

CREATE TABLE `CLAVEOBSERVACIONBC` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del credito SAFI',
  `ClaveObservaBC` char(3) DEFAULT NULL COMMENT 'Clave de observacion a reportar a BC',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene creditos y sus respectivas claves de observacion para reportar a Buro de Credito'$$