-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXCEDENTERIESGOCOMUN
DELIMITER ;
DROP TABLE IF EXISTS `EXCEDENTERIESGOCOMUN`;DELIMITER $$

CREATE TABLE `EXCEDENTERIESGOCOMUN` (
  `GrupoID` int(11) NOT NULL COMMENT 'Identificador de Grupo',
  `RiesgoID` varchar(200) NOT NULL COMMENT 'Identificador de riesgo Comun del SIIOF ',
  `ClienteID` int(11) NOT NULL COMMENT 'ID cliente realiza la solicitud de credito',
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID Credito que representa un riesgo en comun',
  `Fecha` datetime DEFAULT NULL COMMENT 'Fecha en la que se dio de Alta el Excedente de Riesgo',
  `NombreIntegrante` varchar(200) NOT NULL COMMENT 'Nombre Completo Cliente que representa un riesgo en comun',
  `TipoPersona` varchar(20) NOT NULL COMMENT 'Tipo de Personalidad del Cliente M= MORAL .- F = FISICA .- A = FISICA',
  `RFC` char(13) NOT NULL COMMENT 'Registro Federal de Contribuyentes del Cliente',
  `CURP` char(18) NOT NULL COMMENT 'Clave Unica de Registro Poblacional',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  KEY `idx_EXCEDENTERIESGOCOMUN_1` (`GrupoID`),
  KEY `idx_EXCEDENTERIESGOCOMUN_2` (`ClienteID`),
  KEY `idx_EXCEDENTERIESGOCOMUN_3` (`CreditoID`),
  KEY `idx_EXCEDENTERIESGOCOMUN_4` (`Fecha`),
  CONSTRAINT `fk_EXCEDENTERIESGOCOMUN_1` FOREIGN KEY (`GrupoID`) REFERENCES `RIESGOCOMUNGRUPOS` (`ConsecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que almacacena los registros que son procesados en el monitor de riesgo'$$