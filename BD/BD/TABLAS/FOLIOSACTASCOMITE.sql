-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSACTASCOMITE
DELIMITER ;
DROP TABLE IF EXISTS `FOLIOSACTASCOMITE`;
DELIMITER $$


CREATE TABLE `FOLIOSACTASCOMITE` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `FolioID` int(11) NOT NULL COMMENT 'Folio Consecutivo del Acta de Comite',
  `TipoActa` char(1) NOT NULL COMMENT 'Tipo de Acta de Comite\nS .- Sucursal menores a 60mil\nC .- Creditos Mayores a 60mil\nR .- Creditos Reestructura y Renovaciones\nL .- Creditos Relacionados',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'ID de la Sucursal, algunos Folios son por Sucursal otros no',
  `Fecha` date NOT NULL COMMENT 'Fecha',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `FOLIOSACTASCOMITE_idx1` (`SucursalID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Controls de Folios de las Actas de Comite '$$
