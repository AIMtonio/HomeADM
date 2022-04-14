DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAV2FOLIOS`;
DELIMITER $$

CREATE TABLE `EDOCTAV2FOLIOS` (
  `IDFolios` INT(11)          NOT NULL COMMENT 'Identificador',
  `FolioEDOCTA` BIGINT(20)    NOT NULL COMMENT 'folios de procesos de estado de cuenta',
  `EmpresaID` INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11)           NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME      NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15)   NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50)    NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11)          NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`IDFolios`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el control de folios de estado de cuenta'$$
