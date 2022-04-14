-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOPATROCINADOR
DELIMITER ;
DROP TABLE IF EXISTS `CATALOGOPATROCINADOR`;
DELIMITER $$


CREATE TABLE `CATALOGOPATROCINADOR` (
  `PatrocinadorID` INT(11) NOT NULL COMMENT 'Identificador del patrocinador',
  `NombrePatroc`   VARCHAR(50) DEFAULT NULL COMMENT 'Nombre del patrocinador.',
  `Estatus`        CHAR(1) DEFAULT NULL COMMENT 'Estatus A= Activo I= Inactivo',
  `EmpresaID`      INT(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario`        INT(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual`    DATETIME DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP`    VARCHAR(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID`     VARCHAR(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal`       INT(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`PatrocinadorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de patrocinador para sudBin de tarjetas'$$


