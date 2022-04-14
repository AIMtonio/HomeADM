-- Creacion de tabla ESQUEMAQUINQUENIOS

DELIMITER ;

DROP TABLE IF EXISTS ESQUEMAQUINQUENIOS;

DELIMITER $$

CREATE TABLE `ESQUEMAQUINQUENIOS` (
  `EsqQuinquenioID` 	BIGINT(12) 		NOT NULL COMMENT 'Identificador Esquema de Convenio',
  `InstitNominaID` 		INT(11) 		NOT NULL COMMENT 'Numero de Institucion de Nomina',
  `ConvenioNominaID` 	BIGINT UNSIGNED	NOT NULL COMMENT 'Numero de Convenio de Nomina',
  `SucursalID` 			VARCHAR(500) 	NOT NULL COMMENT 'Numero de Sucursales',
  `QuinquenioID` 		VARCHAR(500)  	NOT NULL COMMENT 'Numero Quinquenios',
  `PlazoID` 			VARCHAR(5000) 	NOT NULL COMMENT 'Numero de Plazos',  
  `EmpresaID` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` 		DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` 		VARCHAR(15) 	NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` 			VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` 		BIGINT(20) 		NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`EsqQuinquenioID`),
  KEY `INDEX_ESQUEMAQUINQUENIOS_1` (`InstitNominaID`),
  KEY `INDEX_ESQUEMAQUINQUENIOS_2` (`ConvenioNominaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el registro de Esquema de Quinquenios.'$$


