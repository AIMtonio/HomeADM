-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMAPOYOESCOLAR
DELIMITER ;
DROP TABLE IF EXISTS `PARAMAPOYOESCOLAR`;DELIMITER $$

CREATE TABLE `PARAMAPOYOESCOLAR` (
  `ParamApoyoEscID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla',
  `ApoyoEscCicloID` int(11) DEFAULT NULL COMMENT 'Corresponde con la tabla APOYOESCCICLO',
  `TipoCalculo` char(2) DEFAULT NULL COMMENT 'Tipo de calculo (MF=Monto Fijo, SM= Salario Minimo)',
  `PromedioMinimo` decimal(12,2) DEFAULT NULL COMMENT 'Promedio minimo',
  `Cantidad` decimal(12,2) DEFAULT NULL COMMENT 'Si es MF la cantidad debera representar el monto que se le dara de\n									apoyo, si es SM la cantidad sera el numero de veces que se dara al salario minimo de apoyo',
  `MesesAhorroCons` int(11) DEFAULT NULL COMMENT 'Numero de meses consecutivo de ahorro que debera tener el socio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`ParamApoyoEscID`),
  KEY `FK_ApoyoEscCicloID_1` (`ApoyoEscCicloID`),
  CONSTRAINT `FK_ApoyoEscCicloID_1` FOREIGN KEY (`ApoyoEscCicloID`) REFERENCES `APOYOESCCICLO` (`ApoyoEscCicloID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar las condiciones en las que se dara el apo'$$