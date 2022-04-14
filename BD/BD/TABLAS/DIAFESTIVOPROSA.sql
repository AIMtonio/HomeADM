-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIAFESTIVOPROSA
DELIMITER ;
DROP TABLE IF EXISTS `DIAFESTIVOPROSA`;
DELIMITER $$


CREATE TABLE `DIAFESTIVOPROSA` (
  `Fecha` DATE NOT NULL COMMENT 'Fecha Dia Festivo o Feriado para PROSA',
  
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catalogo de Dias Festivos o Feriados para PROSA.'$$ 
