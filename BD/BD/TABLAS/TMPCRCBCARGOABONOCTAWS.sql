-- TMPCRCBCARGOABONOCTAWS
DELIMITER ;
DROP TABLE IF EXISTS TMPCRCBCARGOABONOCTAWS;

DELIMITER $$
CREATE TABLE `TMPCRCBCARGOABONOCTAWS` (
  `NumRegistro` bigint(20) unsigned NOT NULL COMMENT 'Numero de registro',
  `FechaCarga` datetime NOT NULL COMMENT 'Fecha en la que se realiza la carga',
  `FolioCarga` int(11) NOT NULL COMMENT 'Folio de la carga',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Identificador del numero de cuentas de ahorro',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto a abonar',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza: cargo/ abono',
  `Referencia` varchar(50) NOT NULL COMMENT 'Referencia de la Operacion',
  PRIMARY KEY (`NumRegistro`),
  KEY `fk_TMPCRBCARGOABONOCTA_1` (`FolioCarga`),
  KEY `fk_TMPCRBCARGOABONOCTA_2` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla auxiliar para almacenar las cuentas que seran procesadas para el abono.'$$
