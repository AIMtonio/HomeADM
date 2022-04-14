-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMWSAPI
DELIMITER ;
DROP TABLE IF EXISTS `PARAMWSAPI`;
DELIMITER $$

CREATE TABLE `PARAMWSAPI` (
	`ParamID` INT(11) NOT NULL COMMENT 'LLave Primaria para Identificar los Parmetros\n',
	`NombreWS` VARCHAR(50) NOT NULL COMMENT  'Nombre del webservice Madulo seguido del endpoint',
	`NombreCampo` VARCHAR(50) NOT NULL COMMENT 'Nombre del campo que desea manejar',
	`Valor`	VARCHAR(50) NOT NULL COMMENT 'Valor del campo',
	`Descripcion` VARCHAR(50) NOT NULL COMMENT 'Descripcion del campo del parametro',
	`EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
	`DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`ParamID`)
	
)  ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tabla de parametros adicionales de webservices'$$
