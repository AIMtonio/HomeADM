-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FORMTIPOCALINT
DELIMITER ;
DROP TABLE IF EXISTS `FORMTIPOCALINT`;DELIMITER $$

CREATE TABLE `FORMTIPOCALINT` (
  `FormInteresID` int(11) NOT NULL COMMENT 'ID de la Formula de calculo deinteres\n',
  `Formula` varchar(100) DEFAULT NULL COMMENT 'Formula\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FormInteresID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Formulas del Tipo de Calculo de Interes'$$