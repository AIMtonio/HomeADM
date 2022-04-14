DELIMITER ;
DROP TABLE IF EXISTS `NOMCONDICIONCRED`;
DELIMITER $$
CREATE TABLE `NOMCONDICIONCRED` (
	`CondicionCredID` 	BIGINT(20) 				NOT NULL COMMENT 'Identificador de la tabla',
	`InstitNominaID` 		INT(11) 					NOT NULL COMMENT 'Empresa de nomina a la cual pertenece el convenio',
	`ConvenioNominaID` 	BIGINT UNSIGNED		NOT NULL COMMENT 'Identificador del convenio',
	`ProducCreditoID` 	INT(11) 					NOT NULL COMMENT 'Identificador del Tipo de producto al que está relacionado',
	`TipoTasa` 			 		CHAR(1)						NOT NULL COMMENT 'Tipo de tasa al que pertenece, solo puede ser F= Fija o E = por Esquema',
	`ValorTasa` 				DECIMAL(12,4) 		NOT NULL COMMENT 'Indica el valor que va a tener la tasa (este campo aparecerá si en el parámetro Tipo Tasa se indica Tasa Fija)',
	`TipoCobMora`				CHAR(1)  			NOT NULL COMMENT 'Tipo cobro comisión por apertura N.- N veces la tasa ordinaria T.- Tasa Fija anualizada',
	`ValorMora`					DECIMAL(12,4) 		NOT NULL COMMENT 'Valor de cobro de interés moratorio',
	`EmpresaID` 				INT(11) 					NOT NULL COMMENT 'Parametro de Auditoria',
	`Usuario` 					INT(11) 					NOT NULL COMMENT 'Parametro de Auditoria',
	`FechaActual` 			DATETIME 					NOT NULL COMMENT 'Parametro de Auditoria',
	`DireccionIP` 			VARCHAR(15) 			NOT NULL COMMENT 'Parametro de Auditoria',
	`ProgramaID` 				VARCHAR(50) 			NOT NULL COMMENT 'Parametro de Auditoria',
	`Sucursal` 					INT(11) 					NOT NULL COMMENT 'Parametro de Auditoria',
	`NumTransaccion`		BIGINT(20) 				NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (`CondicionCredID`),
	KEY `INDEX_NOMCONDICIONCRED_1` (`ConvenioNominaID`),
	KEY `INDEX_NOMCONDICIONCRED_2` (`InstitNominaID`),
	KEY `INDEX_NOMCONDICIONCRED_3` (`ProducCreditoID`),
	CONSTRAINT `FK_NOMCONDICIONCRED_1` FOREIGN KEY (`ConvenioNominaID`) REFERENCES `CONVENIOSNOMINA` (`ConvenioNominaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_NOMCONDICIONCRED_2` FOREIGN KEY (`ProducCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar la captacion de credito de un convenio'$$