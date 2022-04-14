-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSVBCWS
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSVBCWS`;DELIMITER $$

CREATE TABLE `PARAMETROSVBCWS` (
  `ParametroVbcID` varchar(45) NOT NULL,
  `ValorParametro` varchar(150) NOT NULL,
  `DescripcionParam` varchar(150) DEFAULT NULL,
  `SeUsaEn` varchar(150) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ParametroVbcID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla parametrizable para la alta de clientes a traves del WS \n'$$