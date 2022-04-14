-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOPROGRASEGTO
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOPROGRASEGTO`;DELIMITER $$

CREATE TABLE `SEGTOPROGRASEGTO` (
  `SeguimientoID` int(11) NOT NULL,
  `ProgramacionID` int(11) NOT NULL,
  `Periodicidad` char(1) DEFAULT NULL COMMENT 'Periodicidad de Criterio de Programacion  D=Diario, S=Semanal, C=Catorcenal, Q=Quincenal, M=Mensual, B=Bimestral, T=Trimestral, \nU=Cuatrimestral, I=Quincomensual, E=Semestral, A=Anual, N=No Aplica',
  `Avance` int(11) DEFAULT NULL COMMENT '% de Avance del plan de Credito',
  `DiasPostOtorga` int(11) DEFAULT NULL COMMENT 'Dias posterior del Otorgamiento',
  `DiasAnteLiquida` int(11) DEFAULT NULL COMMENT 'Dias anterior de la liquidacion',
  `DiasAntePagCuota` int(11) DEFAULT NULL COMMENT 'Dias Anterior al Pago de Cuota',
  `PlazoMinUltSegto` int(11) DEFAULT NULL COMMENT 'Plazo Minimo desde el ultimo Seguimiento',
  `PlazoMaxUltSegto` int(11) DEFAULT NULL COMMENT 'Dias Maximos desde ultimo Seguimiento    ',
  `PlazoMaxEventos` int(11) DEFAULT NULL COMMENT 'Plazo Maximo de Seguimientos Programables',
  `DiaFijoMes` int(11) DEFAULT NULL COMMENT 'Dia Fijio del Mes',
  `DiaFijoSem` char(2) DEFAULT NULL COMMENT 'Dia Fijo de la Semana L.- Lunes, M.-Martes, MI.-Miercoles, J.- Jueves, V.- Viernes, I.- Indistinto',
  `DiaHabil` char(1) DEFAULT NULL COMMENT 'Dia Habil S.- Siguiente o A.- Anterior',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguimientoID`,`ProgramacionID`),
  KEY `fk_SEGTOPROGRASEGTO_1` (`SeguimientoID`),
  CONSTRAINT `fk_SEGTOPROGRASEGTO_1` FOREIGN KEY (`SeguimientoID`) REFERENCES `SEGUIMIENTOCAMPO` (`SeguimientoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Definicion de la Programacion para la generacion de cada  Se'$$