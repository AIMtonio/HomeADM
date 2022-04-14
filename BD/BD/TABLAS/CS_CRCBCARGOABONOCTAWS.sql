-- CS_CRCBCARGOABONOCTAWS
DELIMITER ;
DROP TABLE IF EXISTS CS_CRCBCARGOABONOCTAWS;

DELIMITER $$
CREATE TABLE `CS_CRCBCARGOABONOCTAWS` (
  `FechaCarga` datetime DEFAULT NULL,
  `FolioCarga` int(11) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT '0' COMMENT 'numero de la cuenta, ID de la talba CUENTASAHO',
  `Monto` decimal(14,2) DEFAULT '0.00' COMMENT 'monto a abonar',
  `NatMovimiento` char(1) DEFAULT '' COMMENT 'Naturaleza: cargo/ abono',
  `Referencia` varchar(50) DEFAULT '' COMMENT ' Referencia de la Operacion'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$