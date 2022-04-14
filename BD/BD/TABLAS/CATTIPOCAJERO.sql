-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOCAJERO
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOCAJERO`;DELIMITER $$

CREATE TABLE `CATTIPOCAJERO` (
  `TipoCajeroID` int(11) NOT NULL COMMENT 'Id del Tipo de Cajero',
  `ClaveCNBV` int(11) DEFAULT NULL COMMENT 'Clave de Cajero para regulatorio D2443',
  `ClaveD2442` int(11) DEFAULT NULL COMMENT 'Clave de Cajero para regulatorio D2442 y D2441',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion de la CLave',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoCajeroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipo de Cajero para regulatorio serie R24'$$