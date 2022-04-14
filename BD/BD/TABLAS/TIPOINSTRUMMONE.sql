-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOINSTRUMMONE
DELIMITER ;
DROP TABLE IF EXISTS `TIPOINSTRUMMONE`;DELIMITER $$

CREATE TABLE `TIPOINSTRUMMONE` (
  `TipoInstruMonID` int(11) NOT NULL COMMENT 'ID del tipo de instrumento monetario',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Efectivo,docto SBF, docto mercantil,etc',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente\nB=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoInstruMonID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='catalogo de tipos de instrumentos monetarios'$$