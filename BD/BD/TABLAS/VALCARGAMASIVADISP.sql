DELIMITER ;
DROP TABLE IF EXISTS `VALCARGAMASIVADISP`;
DELIMITER $$
CREATE TABLE `VALCARGAMASIVADISP` (
	`ValDispMasivaID` INT(11) NOT NULL COMMENT 'Columna para el consecutivo del registro',
	`DispMasivaID` INT(11) NOT NULL COMMENT 'ID de la tabla CARGAMASIVADISP',
	`Fila` INT(11) NOT NULL COMMENT 'Numero de fila que tiene detalles',
	`CatDispMasivaID` INT(11) NOT NULL COMMENT 'Identificado de la tabla CATCARGAMASIVADISP',
	`EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`FechaActual` DATETIME DEFAULT NULL  COMMENT 'Parametro de auditoria',
	`DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`ValDispMasivaID`),
	CONSTRAINT `fk_VALCARGAMASIVADISP_1` FOREIGN KEY (`DispMasivaID`) REFERENCES `CARGAMASIVADISP` (`DispMasivaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_VALCARGAMASIVADISP_2` FOREIGN KEY (`CatDispMasivaID`) REFERENCES `CATCARGAMASIVADISP` (`CatDispMasivaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
)ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='TAB.- Tabla para la detalle de los registro del archivo para dispersion masiva'$$
