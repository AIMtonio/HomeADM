-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCDETMOVMXGRAL
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTATDCDETMOVMXGRAL`;
DELIMITER $$

CREATE TABLE `EDOCTATDCDETMOVMXGRAL` (
  `Periodo` INT(11) NOT NULL COMMENT 'anio y mes de la fecha que se realizara el corte',
  `DiaCorte` INT(11) NOT NULL COMMENT 'Dia de la fecha que se realizara el corte',
  `LineaTarCredID` BIGINT(20) NOT NULL COMMENT 'ID de la linea de credito',
  `NumTarjeta` VARCHAR(20) NOT NULL COMMENT 'Numero de tarjeta',
  `Fecha` DATE NOT NULL COMMENT 'Fecha de la operacion',
  `Referencia` VARCHAR(150) NOT NULL COMMENT 'Referencia',
  `Descripcion` VARCHAR(150) NOT NULL COMMENT 'Descripción de la operación',
  `Cargos` DECIMAL(16,2) NOT NULL COMMENT 'Cargos',
  `Abonos` DECIMAL(16,2) NOT NULL COMMENT 'Abonos',
  `EmpresaID` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` DATE NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` VARCHAR(15) NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` VARCHAR(50) NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  KEY `IDX_EDOCTATDCDETMOVGRAL_01_Periodo` (`Periodo`,`DiaCorte`),
  KEY `IDX_EDOCTATDCDETMOVGRAL_02_Fecha` (`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
