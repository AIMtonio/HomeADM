-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOVALOR
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOVALOR`;DELIMITER $$

CREATE TABLE `CATTIPOVALOR` (
  `TipoValorID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID de la tabla',
  `ClaveValor` varchar(10) NOT NULL COMMENT 'ID del Tipo de Valor',
  `Descripcion` varchar(350) NOT NULL COMMENT 'Descripcion deL tipo de valor',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoValorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Valor para los regulatorios'$$