-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCONSTRETENCION
DELIMITER ;
DROP TABLE IF EXISTS `HISCONSTRETENCION`;
DELIMITER $$


CREATE TABLE `HISCONSTRETENCION` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de Cliente',
  `Anio` int(11) NOT NULL DEFAULT '0' COMMENT 'Anio proceso',
  `Mes` int(11) NOT NULL DEFAULT '0' COMMENT 'Mes de proceso',
  `TipoInstrumentoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Tipo de Instrumento:\n2 = Cuenta\n13 = Inversion\n28 = Cede',
  `InstrumentoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'Numero de Instrumento',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto',
  `InteresGravado` decimal(18,2) DEFAULT NULL COMMENT 'Interes Gravado',
  `InteresExento` decimal(18,2) DEFAULT NULL COMMENT 'Interes Exento',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes Retenido',
  `Ajuste` decimal(18,2) DEFAULT NULL COMMENT 'Ajuste',
  `InteresReal` decimal(18,2) DEFAULT NULL COMMENT 'Interes Real',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`Anio`,`ClienteID`,`Mes`,`TipoInstrumentoID`,`InstrumentoID`),
  KEY `INDEX_HISCONSTRETENCION_1` (`ClienteID`),
  KEY `INDEX_HISCONSTRETENCION_2` (`Anio`),
  KEY `INDEX_HISCONSTRETENCION_3` (`Mes`),
  KEY `INDEX_HISCONSTRETENCION_4` (`TipoInstrumentoID`),
  KEY `INDEX_HISCONSTRETENCION_5` (`InstrumentoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar informacion historica de cuentas, inversiones y cedes para la constancia de retencion'$$