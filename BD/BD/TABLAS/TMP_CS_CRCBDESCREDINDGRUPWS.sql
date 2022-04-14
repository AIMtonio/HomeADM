-- TMP_CS_CRCBDESCREDINDGRUPWS
DELIMITER ;
DROP TABLE IF EXISTS TMP_CS_CRCBDESCREDINDGRUPWS;

DELIMITER $$
CREATE TABLE `TMP_CS_CRCBDESCREDINDGRUPWS` (
  `NumRegistro` bigint(20) NOT NULL,
  `CrcbDesCredIndGrupWSID` bigint(20) NOT NULL AUTO_INCREMENT,
  `FechaCarga` datetime DEFAULT NULL,
  `FolioCarga` int(11) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT '0' COMMENT 'ID del credito',
  `GrupoID` int(11) DEFAULT '0' COMMENT 'ID del grupo',
  PRIMARY KEY (`NumRegistro`),
  KEY `CrcbDesCredIndGrupWSID` (`CrcbDesCredIndGrupWSID`),
  KEY `FolioCarga` (`FolioCarga`),
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el proceso masivo de desembolso de creditos.'$$