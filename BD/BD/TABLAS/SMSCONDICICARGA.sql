-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCONDICICARGA
DELIMITER ;
DROP TABLE IF EXISTS `SMSCONDICICARGA`;DELIMITER $$

CREATE TABLE `SMSCONDICICARGA` (
  `ArchivoCargaID` int(11) NOT NULL COMMENT 'Numero consecutivo de carga',
  `CampaniaID` int(11) NOT NULL COMMENT 'Numero de Campania',
  `TipoEnvio` char(1) DEFAULT NULL COMMENT 'Tipo de Envio\\\\nU: Una vez\\\\nR: Repetido',
  `OpcionEnvio` char(1) DEFAULT NULL COMMENT 'Indica la opcion de envio\\nA: Ahora\\nH: Horario (En un horario en especifico)\\nC: Calendario (Programado para un calendario de fechas)',
  `NumVeces` int(11) DEFAULT NULL COMMENT 'Numero de Veces cuando el tipo de envio es repetido',
  `Distancia` varchar(5) DEFAULT NULL COMMENT 'Distancia en horas y minutos cuando el tipo de envio es repetido\\n',
  `FechaInicio` datetime DEFAULT NULL COMMENT 'Fecha de Inicio cuando la opcion de envio es Calendario',
  `FechaFin` datetime DEFAULT NULL COMMENT 'Fecha de Fin cuando la opcion de envio es Calendario',
  `Periodicidad` char(1) DEFAULT NULL COMMENT 'Periodicidad en caso de que la opcion de envio es Calendario\\\\n\\nD: Diario\\nS: Semanal\\\\nQ: Quincenal\\\\nM: Mensual\\\\nB: Bimestral\\\\nA: Anual',
  `HoraPeriodicidad` char(5) DEFAULT NULL,
  `FechaProgEnvio` datetime DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ArchivoCargaID`),
  KEY `fk_SMSCONDICICARGA_cAMPANIA_idx` (`CampaniaID`),
  CONSTRAINT `fk_SMSCONDICICARGA_CAMPANIA` FOREIGN KEY (`CampaniaID`) REFERENCES `SMSCAMPANIAS` (`CampaniaID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de condiciones por carga de archivos sms por campaña'$$