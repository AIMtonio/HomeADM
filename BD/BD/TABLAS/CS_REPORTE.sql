--
-- Table structure for table `CS_REPORTE`
--
DELIMITER ;
DROP TABLE IF EXISTS `CS_REPORTE`;
DELIMITER $$


CREATE TABLE `CS_REPORTE` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fechadelaoperacion` date NOT NULL COMMENT 'fecha del movimiento',
  `Foliodelaoperacion` bigint(20) NOT NULL,
  `NombredelUsuario` varchar(150) NOT NULL COMMENT 'Nombre del\nUsuario',
  `NoDecontrato` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `Montodelaoperacion` decimal(12,2) DEFAULT NULL,
  `Monto de la operacion` varchar(5) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Instrumentomonetario` varchar(13) CHARACTER SET utf8 NOT NULL DEFAULT '',
  KEY `CS_REPORTEIDX` (`NoDecontrato`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
