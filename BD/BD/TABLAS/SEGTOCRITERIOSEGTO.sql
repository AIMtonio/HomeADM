-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCRITERIOSEGTO
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOCRITERIOSEGTO`;DELIMITER $$

CREATE TABLE `SEGTOCRITERIOSEGTO` (
  `SeguimientoID` int(11) NOT NULL COMMENT 'PK Compuesta de Criterios de Seguimiento',
  `CriterioID` int(11) NOT NULL COMMENT 'PK Compuesta de Criterios de Seguimiento',
  `Compuerta` char(3) DEFAULT NULL COMMENT 'Condicion OR o AND de Criterios ',
  `Condicion1` int(11) DEFAULT NULL COMMENT 'Condicion de Seleccion 1.- Saldo Total Credito, 2.-Monto Original Credito, 3.-Saldo de Capital, 4.- Capital Atrasado\n5.-Dias de Atraso, 6.-Dias de Liquidacion, 7.-Dias desde el otorgamiento, 8.-Dias para el proximo vencimiento',
  `Operador` char(5) DEFAULT NULL COMMENT 'Operador 1.- Mayor que, 2.- Menor que, 3.- Igual que, 4.- Diferente que',
  `Condicion2` int(11) DEFAULT NULL COMMENT 'Condicion 1.-Numero Fijo, 2.-Monto Fijo, 3.-Saldo Credito, 4.- Monto Credito, 5.- Dias de Atraso\n6.-Dias a la liquidacion, 7.-Dias desde el otorgamiento, 8.-Dias para el proximo vencimiento,\n9.-Saldo de Capital',
  `ValorCondicion` varchar(20) DEFAULT NULL COMMENT 'Valor de la condicion de la Seleccion, solo cuando la condicion seleccionada sea Numero Fijo o Monto Fijo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguimientoID`,`CriterioID`),
  KEY `fk_SEGTOCRITERIOSEGTO_1` (`SeguimientoID`),
  CONSTRAINT `fk_SEGTOCRITERIOSEGTO_1` FOREIGN KEY (`SeguimientoID`) REFERENCES `SEGUIMIENTOCAMPO` (`SeguimientoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Definicion de Criterios para la generacion de cada Seguimiento'$$