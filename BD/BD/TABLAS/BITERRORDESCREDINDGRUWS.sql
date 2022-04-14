-- BITERRORDESCREDINDGRUWS
DELIMITER ;
DROP TABLE IF EXISTS BITERRORDESCREDINDGRUWS;

DELIMITER $$
CREATE TABLE `BITERRORDESCREDINDGRUWS` (
  `BitacoraID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CrcbDesCredIndGrupWSID` bigint(20) DEFAULT '0' COMMENT 'ID correspondiente al registro de la carga masiva',
  `FechaCarga` datetime DEFAULT NULL,
  `FolioCarga` int(11) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT '0' COMMENT 'ID del credito',
  `GrupoID` int(11) DEFAULT '0' COMMENT 'ID del grupo',
  `Mensaje` varchar(500) NOT NULL COMMENT 'Mensaje del Error',
  `Codigo` int(11) NOT NULL COMMENT 'Codigo de Error',
  `SP` varchar(30) NOT NULL COMMENT 'Nombre del SP del Error',
  PRIMARY KEY (`BitacoraID`),
  KEY `CrcbDesCredIndGrupWSID` (`CrcbDesCredIndGrupWSID`),
  KEY `FolioCarga` (`FolioCarga`),
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el proceso masivo de desembolso de creditos.'$$