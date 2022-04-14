-- BITEXITODESCREDINDGRUWS
DELIMITER ;
DROP TABLE IF EXISTS BITEXITODESCREDINDGRUWS;

DELIMITER $$
CREATE TABLE `BITEXITODESCREDINDGRUWS` (
  `BitacoraID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CrcbDesCredIndGrupWSID` bigint(20) DEFAULT '0' COMMENT 'ID correspondiente al registro de la carga masiva',
  `FechaCarga` datetime DEFAULT NULL,
  `FolioCarga` int(11) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT '0' COMMENT 'ID del credito',
  `GrupoID` int(11) DEFAULT '0' COMMENT 'ID del grupo',
  `PolizaID` bigint(20) DEFAULT '0' COMMENT 'Numero de la poliza registrada en el desembolso (Nace vacia)',
  `FechaDesembolso` date DEFAULT '1900-01-01' COMMENT 'Fecha del Desembolso',
  PRIMARY KEY (`BitacoraID`),
  KEY `CrcbDesCredIndGrupWSID` (`CrcbDesCredIndGrupWSID`),
  KEY `FolioCarga` (`FolioCarga`),
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla para guardar la informacion de los desembolso de creditos exitosos del proceso masivo.'$$