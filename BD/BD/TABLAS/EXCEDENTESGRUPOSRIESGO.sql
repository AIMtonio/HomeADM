-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXCEDENTESGRUPOSRIESGO
DELIMITER ;
DROP TABLE IF EXISTS `EXCEDENTESGRUPOSRIESGO`;DELIMITER $$

CREATE TABLE `EXCEDENTESGRUPOSRIESGO` (
  `GrupoID` int(11) NOT NULL COMMENT 'Identificador de Grupo',
  `RiesgoID` varchar(200) NOT NULL COMMENT 'Identificador de riesgo Comun del SIIOF ',
  `Fecha` datetime DEFAULT NULL COMMENT 'Fecha en la que se dio de Alta el Excedente de Riesgo',
  `ClienteID` int(11) NOT NULL COMMENT 'ID cliente realiza la solicitud de credito',
  `NombreIntegrante` varchar(200) NOT NULL COMMENT 'Nombre Completo Cliente que representa un riesgo en comun',
  `TipoPersona` varchar(20) NOT NULL COMMENT 'Tipo de Personalidad del Cliente M= MORAL .- F = FISICA .- A = FISICA',
  `RFC` char(13) NOT NULL COMMENT 'Registro Federal de Contribuyentes del Cliente',
  `CURP` char(18) NOT NULL COMMENT 'Clave Unica de Registro Poblacional',
  `SaldoIntegrante` decimal(14,2) NOT NULL COMMENT 'Saldo Insoluto del Integrante',
  `SaldoGrupal` decimal(14,2) NOT NULL COMMENT 'Saldo Insoluto del Grupo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  KEY `idx_EXCEDENTESGRUPOSRIESGO_1` (`GrupoID`),
  KEY `idx_EXCEDENTESGRUPOSRIESGO_2` (`ClienteID`),
  KEY `idx_EXCEDENTESGRUPOSRIESGO_3` (`Fecha`),
  CONSTRAINT `fk_EXCEDENTESGRUPOSRIESGO_1` FOREIGN KEY (`GrupoID`) REFERENCES `RIESGOCOMUNGRUPOS` (`ConsecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que almacacena los registros de los integrantes agrupados por grupos que representen un excedente de riesgo comun'$$