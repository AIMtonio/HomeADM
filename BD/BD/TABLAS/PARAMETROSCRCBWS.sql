-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSCRCBWS
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSCRCBWS`;DELIMITER $$

CREATE TABLE `PARAMETROSCRCBWS` (
  `LlaveParametro` varchar(50) NOT NULL COMMENT 'Llave Parametro',
  `ValorParametro` varchar(200) DEFAULT NULL COMMENT 'Valor del Parametro',
  `DescParametro` varchar(400) DEFAULT NULL COMMENT 'Descripcion de la funcionalidad del parametro y sus posibles valores',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`LlaveParametro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla parametrizable de WS para el cliente CREDICLUB'$$