DELIMITER ;
DROP TABLE IF EXISTS `CATCARGAMASIVADISP`;
DELIMITER $$
CREATE TABLE `CATCARGAMASIVADISP` (
	`CatDispMasivaID` INT(11) NOT NULL COMMENT 'Columna para el consecutivo del registro',
	`Validacion` VARCHAR(150)  DEFAULT NULL COMMENT 'Descripcion corta de la validacion',
	`DescDetalada` VARCHAR(250) DEFAULT NULL COMMENT 'Descripcion detallada de la validacion',
	`Estatus` CHAR(1) DEFAULT NULL COMMENT 'Estatus de la validacion A = Activo I = Inactivo',
	`EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`FechaActual` DATETIME DEFAULT NULL  COMMENT 'Parametro de auditoria',
	`DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`CatDispMasivaID`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='CAT.- Catalogos para las validaciones del archivo de carga masiva de dispersiones'$$
