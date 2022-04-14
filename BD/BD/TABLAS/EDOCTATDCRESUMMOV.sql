-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCRESUMMOV
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTATDCRESUMMOV`;
DELIMITER $$

CREATE TABLE `EDOCTATDCRESUMMOV` (
  `Periodo` INT(11) NOT NULL COMMENT 'anio y mes de la fecha que se realizara el corte',
  `DiaCorte` INT(11) NOT NULL COMMENT 'Dia de la fecha que se realizara el corte',
  `LineaTarCredID` BIGINT(20) NOT NULL COMMENT 'ID de la linea de credito',
  `Orden` INT(11) NOT NULL COMMENT 'Orden del movimiento',
  `Concepto` VARCHAR(30) NOT NULL COMMENT 'Concepto del movimiento',
  `Monto` DECIMAL(16,2) NOT NULL COMMENT 'Monto',
  `Sombreado` CHAR(1) NOT NULL COMMENT 'Si se sombreara en el reporte',
  `EmpresaID` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` DATE NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` VARCHAR(15) NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` VARCHAR(50) NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`Periodo`,`DiaCorte`,`LineaTarCredID`,`Orden`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
