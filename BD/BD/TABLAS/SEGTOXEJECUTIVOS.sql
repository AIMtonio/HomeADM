-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOXEJECUTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOXEJECUTIVOS`;DELIMITER $$

CREATE TABLE `SEGTOXEJECUTIVOS` (
  `SeguimientoID` int(11) NOT NULL COMMENT 'Identificador del Seguimiento',
  `EjecutivoID` varchar(10) NOT NULL COMMENT 'Clave del Puesto al que se le aplica el Seguimiento FK con tabla de PUESTOS',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguimientoID`,`EjecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Ejecutivos a los que se aplica el Seguimiento'$$