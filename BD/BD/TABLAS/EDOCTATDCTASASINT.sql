-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCTASASINT
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTATDCTASASINT`;
DELIMITER $$

CREATE TABLE `EDOCTATDCTASASINT` (
  `Periodo` INT(11) NOT NULL COMMENT 'Periodo',
  `DiaCorte` INT(11) NOT NULL COMMENT 'DiaCorte',
  `LineaTarCredID` INT(11) NOT NULL COMMENT 'LineaTarCredID',
  `TipoTarjetaDebID` INT(11) NOT NULL COMMENT 'TipoTarjetaDebID',
  `Orden` INT(11) NOT NULL COMMENT 'Orden',
  `Concepto` VARCHAR(100) NOT NULL COMMENT 'Concepto',
  `ValorAnual` DECIMAL(16,2) NOT NULL COMMENT 'Valor Anual',
  `ValorMensual` DECIMAL(16,2) NOT NULL COMMENT 'Valor Mensual',
  `Resaltado` CHAR(1) NOT NULL COMMENT 'Resaltado',
  `ValorDefault` VARCHAR(3) NOT NULL COMMENT 'Valor default',
  `EmpresaID` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` DATE NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` VARCHAR(15) NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` VARCHAR(50) NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` INT(11) NOT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`Periodo`,`DiaCorte`,`LineaTarCredID`,`TipoTarjetaDebID`,`Orden`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los datos de EDOCTATDCTASASINT'$$
