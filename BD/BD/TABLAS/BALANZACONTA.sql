-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANZACONTA
DELIMITER ;
DROP TABLE IF EXISTS `BALANZACONTA`;DELIMITER $$

CREATE TABLE `BALANZACONTA` (
  `EjercicioID` int(11) NOT NULL COMMENT 'Numero de \nEjercicio\nContable',
  `ConBalanzaID` bigint(11) NOT NULL COMMENT 'Concepto de la balanza fk de la tabla CONCEPTOBALANZA',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del concepto de la balanza tabla CONCEPTOBALANZA',
  `FechaCorte` varchar(45) DEFAULT NULL COMMENT 'Fecha de Corte\no de Ultimo\nCierre Contable',
  `SaldoInicial` decimal(12,2) DEFAULT NULL,
  `Cargos` decimal(12,2) DEFAULT NULL,
  `Abonos` decimal(12,2) DEFAULT NULL,
  `SaldoFinal` decimal(12,2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConBalanzaID`),
  KEY `fk_BALANZACONTA_1` (`EjercicioID`),
  KEY `fk_BALANZACONTA_2` (`ConBalanzaID`),
  CONSTRAINT `fk_BALANZACONTA_2` FOREIGN KEY (`ConBalanzaID`) REFERENCES `CONCEPTOBALANZA` (`ConBalanzaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos de las Cuentas Conatables\nPor Corte de Periodo'$$