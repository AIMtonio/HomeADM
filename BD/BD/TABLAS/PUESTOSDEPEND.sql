-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSDEPEND
DELIMITER ;
DROP TABLE IF EXISTS `PUESTOSDEPEND`;DELIMITER $$

CREATE TABLE `PUESTOSDEPEND` (
  `PuestoDepPadreID` bigint(20) NOT NULL COMMENT 'ID o clave del Puesto Padre',
  `PuestoDepHijoID` bigint(20) NOT NULL COMMENT 'ID o clave del Puesto Hijo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PuestoDepPadreID`,`PuestoDepHijoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Dependecias entre Puestos del Organigrama'$$