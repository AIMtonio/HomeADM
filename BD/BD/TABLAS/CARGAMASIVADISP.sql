DELIMITER ;
DROP TABLE IF EXISTS `CARGAMASIVADISP`;
DELIMITER $$
CREATE TABLE `CARGAMASIVADISP` (
	`DispMasivaID` INT(11) NOT NULL COMMENT 'Columna para el consecutivo del registro',
	`FolioOperacion` INT(11) DEFAULT NULL COMMENT 'Folio de la tabla DISPERSION',
	`FechaOperacion` DATETIME DEFAULT NULL COMMENT 'Fecha en cual se realiza la operacion',
  	`InstitucionID` INT(11) DEFAULT NULL COMMENT 'Numero de la institución financiera en la cual se le hara el cargo',
  	`CuentaAhoID` INT(11) DEFAULT NULL COMMENT 'Numero de la cuenta a la cual se le afecta.',
  	`NumCtaInstit` VARCHAR(20) DEFAULT NULL COMMENT 'Corresponde con el num de cuenta de la institucion en CUENTASAHOTESO',
  	`TotalRegistros` DECIMAL(12,2) DEFAULT NULL COMMENT 'Suma total de las dispersiones',
  	`MontoEnviado` DECIMAL(12,4) DEFAULT NULL COMMENT 'Monto total de las dispersiones enviadas',
  	`RutaArchivo` VARCHAR(300) DEFAULT NULL COMMENT 'ruta del archivo que se cargo',
  	`Estatus` CHAR(1) DEFAULT NULL COMMENT 'V = Validacion P = Procesado',
	`EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`FechaActual` DATETIME DEFAULT NULL  COMMENT 'Parametro de auditoria',
	`DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`DispMasivaID`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='TAB.- Tabla para la cabecera de los registro del archivo para dispersion masiva'$$
