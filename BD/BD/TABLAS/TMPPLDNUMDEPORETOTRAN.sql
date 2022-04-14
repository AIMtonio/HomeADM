DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDNUMDEPORETOTRAN`;
DELIMITER $$

CREATE TABLE `TMPPLDNUMDEPORETOTRAN` (
  `RegistroID` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
  `IDPLDMov` int(11) NOT NULL DEFAULT '0',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
  `CantidadMov` decimal(12,2) DEFAULT NULL,
  `NDeposito` bigint(63) DEFAULT NULL,
  `MontoDepo` decimal(22,2) DEFAULT NULL,
  `NRetiro` bigint(63) DEFAULT NULL,
  `MontoReto` decimal(22,2) DEFAULT NULL,
  `CtaAnterior` bigint(60) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`RegistroID`),
  KEY `IDX_TMPPLDNUMDEPORETOTRAN_1` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP:Tabla temporal para numero de depositos en deteccion de  operaciones inusuales-PLDOPEINUSALERTTRANSPRO'$$
