DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAV2PRODUCTOS`;
DELIMITER $$

CREATE TABLE `EDOCTAV2PRODUCTOS` (
	`EdoCtaV2ProductoID`		INT(11) 			NOT NULL	COMMENT 'Identificador de la tabla',
	`ProductoID`				INT(11) 			NOT NULL	COMMENT 'Identificador del producto',
	`TipoProducto`				INT(11)				NOT NULL	COMMENT 'Indica el tipo de instrumento al que pertenece el producto. 1: Ahorro. 2: Cede. 3: Inversion. 4: Credito',
	`Descripcion`				VARCHAR(100)		NOT NULL	COMMENT 'Descripcion del parametro registrado en esta tabla',
	`EmpresaID` 				INT(11) 			NOT NULL	COMMENT 'Parametro de Auditoria',
	`Usuario`					INT(11) 			NOT NULL	COMMENT 'Parametro de Auditoria',
	`FechaActual`				DATETIME 			NOT NULL	COMMENT 'Parametro de Auditoria',
	`DireccionIP`				VARCHAR(15) 		NOT NULL	COMMENT 'Parametro de Auditoria',
	`ProgramaID` 				VARCHAR(50) 		NOT NULL	COMMENT 'Parametro de Auditoria',
	`Sucursal`					INT(11) 			NOT NULL	COMMENT 'Parametro de Auditoria',
	`NumTransaccion` 			BIGINT(20)			NOT NULL	COMMENT 'Parametro de Auditoria',
	PRIMARY KEY(`EdoCtaV2ProductoID`),
	INDEX `INDEX_EDOCTAV2PRODUCTOS_1` (`ProductoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los productos que seran incluidos en los procesos de extraccion.'$$
