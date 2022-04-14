-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSPUESTOS
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSPUESTOS`;DELIMITER $$

CREATE TABLE `TIPOSPUESTOS` (
  `TipoPuestoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id del Tipo de Puesto',
  `Descripcion` varchar(80) DEFAULT NULL COMMENT 'Nombre del Puesto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoPuestoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$