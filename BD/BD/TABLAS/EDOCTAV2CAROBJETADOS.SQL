DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAV2CAROBJETADOS`;
DELIMITER $$

CREATE TABLE `EDOCTAV2CAROBJETADOS` (
	`AnioMes`					INT(11) 			NOT NULL	COMMENT 'Anio y mes para generar Estado de cuenta',
	`SucursalID`				INT(11) 			NOT NULL	COMMENT 'Numero de surcusal del cliente',
	`ClienteID`					INT(11) 			NOT NULL	COMMENT 'Numero de cliente',
	`Instrumento`				VARCHAR(20)			NOT NULL	COMMENT 'Descripcion del producto de credito',
	`FechaIncidencia`			VARCHAR(50)			NOT NULL	COMMENT 'Fecha limite para realizar el proximo pago',
	`Descripcion`				VARCHAR(200)		NOT NULL	COMMENT 'Descripcion del producto de credito',
	`MontoObjetado`				DECIMAL(14,2)		NOT NULL	COMMENT 'Cantidad que se debe pagar en el proximo pago',
	`FechaReporte`				VARCHAR(50)			NOT NULL	COMMENT 'Leyenda que se muestra en el campo Fecha de Ingreso de la Aclaracion',
	`CargoObjetadoID`			BIGINT(20) 			NOT NULL	COMMENT 'Identificador del registro de cargo a objetar',
	`FolioProceso`				BIGINT(12)			NOT NULL	COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
	`EmpresaID` 				INT(11) 			NOT NULL	COMMENT 'Parametro de Auditoria',
	`Usuario`					INT(11) 			NOT NULL	COMMENT 'Parametro de Auditoria',
	`FechaActual`				DATETIME 			NOT NULL	COMMENT 'Parametro de Auditoria',
	`DireccionIP`				VARCHAR(15) 		NOT NULL	COMMENT 'Parametro de Auditoria',
	`ProgramaID` 				VARCHAR(50) 		NOT NULL	COMMENT 'Parametro de Auditoria',
	`Sucursal`					INT(11) 			NOT NULL	COMMENT 'Parametro de Auditoria',
	`NumTransaccion` 			BIGINT(20)			NOT NULL	COMMENT 'Parametro de Auditoria',
	PRIMARY KEY(`AnioMes`, `SucursalID`, `ClienteID`, `CargoObjetadoID`),
	INDEX `INDEX_EDOCTAV2CAROBJETADOS_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar la informacion de las extracciones de cargos objetados.'$$
