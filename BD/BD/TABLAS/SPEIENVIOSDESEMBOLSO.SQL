DELIMITER ;

DROP TABLE IF EXISTS `SPEIENVIOSDESEMBOLSO`;

DELIMITER $$

CREATE TABLE `SPEIENVIOSDESEMBOLSO` (
	`SpeiEnviosDesembID`		INT(11)			NOT NULL COMMENT		'ID desembolso de un envio SPEI',
	`FolioSPEI`					BIGINT(20)		NOT NULL COMMENT		'Folio de envio por SPEI, referencia a la tabla SPEIENVIOS',
	`CreditoID`					BIGINT(12)		NOT NULL COMMENT		'ID numero de credito, que hace referencia a la tabla CREDITOS',
	`BloqueoID`					INT(11)			NOT NULL COMMENT		'ID de Bloqueo que hace referencia a la tabla BLOQUEOS',

	`EmpresaID`					INT(11)			DEFAULT NULL COMMENT	'ID Empresa',
	`Usuario`					INT(11)			DEFAULT NULL COMMENT	'Usuario',
	`FechaActual`				DATETIME		DEFAULT NULL COMMENT	'Fecha Actual',
	`DireccionIP`				VARCHAR(15)		DEFAULT NULL COMMENT	'DireccionIP',
	`ProgramaID`				VARCHAR(50)		DEFAULT NULL COMMENT	'ProgramaID',
	`Sucursal`					INT(11)			DEFAULT NULL COMMENT	'Sucursal',
	`NumTransaccion`			BIGINT(20)		DEFAULT NULL COMMENT	'Numero de Transaccion',
	PRIMARY KEY (`SpeiEnviosDesembID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab:Tabla para almacenar los envios SPEI que son desembolsos'$$