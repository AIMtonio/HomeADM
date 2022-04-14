-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACFDIDATOS
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTACFDIDATOS`;
DELIMITER $$


CREATE TABLE `EDOCTACFDIDATOS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `AnioMes` int(11) NOT NULL COMMENT 'Periodo en el que se procesan los datos',
  `SucursalID` int(11) NOT NULL COMMENT 'Identificador de la sucursal',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del cliente',
  `InstrumentoID` bigint(20) NOT NULL COMMENT 'Identificador del instrumento',
  `TipoInstrumento` char(1) NOT NULL COMMENT 'C: Credito, A: Cuenta de Ahorro',
  `Concepto` varchar(150) NOT NULL COMMENT 'Descripcion del concepto a timbrar',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Cantidad de dinero que se cargo',
  `ValorIVA` decimal(14,2) NOT NULL COMMENT 'Cantidad del IVA',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  KEY `INDEX_EDOCTACFDIDATOS_1` (`ClienteID`),
  KEY `INDEX_EDOCTACFDIDATOS_2` (`InstrumentoID`),
  KEY `INDEX_EDOCTACFDIDATOS_3` (`Concepto`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab:Tabla para almacenar informacion utilizada para timbrar la informacion del cliente'$$
