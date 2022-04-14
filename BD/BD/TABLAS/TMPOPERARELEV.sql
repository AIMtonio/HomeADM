-- Creacion de tabla TMPOPERARELEV

DELIMITER ;

DROP TABLE IF EXISTS `TMPOPERARELEV`;

DELIMITER $$

CREATE TABLE `TMPOPERARELEV` (
	`TipoReporte` 		INT(11) 		NOT NULL COMMENT 'Tipo de Reporte',
	`PeriodoReporte` 	VARCHAR(10) 	NOT NULL COMMENT 'Periodo el cual cubre el Reporte',
	`Folio` 			VARCHAR(6) 		NOT NULL COMMENT 'Folio consecutivo.',
	`OperaRelevante` 	TEXT			NOT NULL COMMENT 'Informacion de la Operacion Relevante',
	`EmpresaID` 		INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`Usuario` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`FechaActual` 		DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	`DireccionIP` 		VARCHAR(20) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`ProgramaID` 		VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`Sucursal` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`NumTransaccion` 	BIGINT(20) 		NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (`TipoReporte`,`PeriodoReporte`,`Folio`),
    INDEX `INDEX_TMPOPERARELEV_1` (`NumTransaccion`),
    INDEX `INDEX_TMPOPERARELEV_2` (`PeriodoReporte`,`TipoReporte`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla para registrar informacion de las Operaciones Relevantes.'$$
