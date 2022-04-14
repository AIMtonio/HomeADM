-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMREGSERIER24
DELIMITER ;
DROP TABLE IF EXISTS `PARAMREGSERIER24`;DELIMITER $$

CREATE TABLE `PARAMREGSERIER24` (
  `LlaveParametro` varchar(50) NOT NULL COMMENT 'Identificador del parametro',
  `ValorParametro` varchar(200) NOT NULL COMMENT 'Valor del parametro',
  `DescParametro` varchar(200) DEFAULT NULL COMMENT 'Brebe descripcion de la funcionalidad del parametro y sus posibles valores',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`LlaveParametro`,`ValorParametro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros para los reportes regulatorios de la serie R24'$$