-- Creacion de tabla ARCHIVOSCARGAFACT

DELIMITER ;
DROP TABLE IF EXISTS `ARCHIVOSCARGAFACT`;

DELIMITER $$
CREATE TABLE `ARCHIVOSCARGAFACT` (
	`FolioCargaID` INT(11) NOT NULL	COMMENT 'Folio consecutivo de la Carga del Archivo de Facturas',
	`Mes` INT(11) NOT NULL COMMENT 'Mes del cual se proceso la Carga del Archivo de Facturas',
	`UsuarioCarga` INT(11) DEFAULT NULL	COMMENT 'Usuario que subio el archivo',
	`FechaCarga` DATE DEFAULT NULL COMMENT 'Fecha en que se subio el Archivo',
	`NumTotalFacturas` INT(11) DEFAULT NULL COMMENT 'Numero total de Facturas del Archivo',
	`NumFacturasExito` INT(11) DEFAULT NULL	COMMENT 'Numero total de Facturas subidas correctamente',
	`NumFacturasError` INT(11) DEFAULT NULL	COMMENT 'Numero total de Facturas subidas con error',
	`RutaArchivoFacturas` VARCHAR(250) DEFAULT NULL COMMENT 'Ruta del Archivo de Facturas',
	`Estatus` CHAR(1) DEFAULT NULL COMMENT 'P=Procesado \nN=No Procesado',
	`EmpresaID` INT(11) DEFAULT NULL,
	`Usuario` INT(11) DEFAULT NULL,
	`FechaActual` DATETIME DEFAULT NULL,
	`DireccionIP` VARCHAR(15) DEFAULT NULL,
	`ProgramaID` VARCHAR(50) DEFAULT NULL,
	`Sucursal` INT(11) DEFAULT NULL,
	`NumTransaccion` BIGINT(20) DEFAULT NULL,
	PRIMARY KEY (`FolioCargaID`,`Mes`),
    KEY `IDX_ARCHIVOSCARGAFACT_1_idx` (`UsuarioCarga`),
    KEY `IDX_ARCHIVOSCARGAFACT_2_idx` (`FechaCarga`),
    KEY `IDX_ARCHIVOSCARGAFACT_3_idx` (`Estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB:Encabezado de la Carga del Archivo de Facturas'$$