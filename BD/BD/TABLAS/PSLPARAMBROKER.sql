-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLPARAMBROKER
DELIMITER ;
DROP TABLE IF EXISTS `PSLPARAMBROKER`;DELIMITER $$

CREATE TABLE `PSLPARAMBROKER` (
  `LlaveParametro` varchar(50) NOT NULL COMMENT 'Llave del parametro',
  `ValorParametro` varchar(200) NOT NULL COMMENT 'Valor del parametro',
  `DescParametro` varchar(200) NOT NULL COMMENT 'Descripcion del parametro',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`LlaveParametro`),
  KEY `INDEX_PSLPARAMBROKER_1` (`LlaveParametro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Par: Tabla para almacenar los parametros del broker.'$$