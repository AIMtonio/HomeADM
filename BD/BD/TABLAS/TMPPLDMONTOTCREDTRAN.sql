DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDMONTOTCREDTRAN`;
DELIMITER $$

CREATE TABLE `TMPPLDMONTOTCREDTRAN` (
  `RegistroID` bigint(12) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `MontoTotal` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Pagado',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Guarda forma de pago \nE = Efectivo\nC = Cargo a cuenta',
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY(RegistroID),
  KEY `IDX_TMPPLDMONTOTCREDTRAN_1` (`Transaccion`),
  KEY `IDX_TMPPLDMONTOTCREDTRAN_2` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP:Tabla temporal para montos totales creditos en deteccion de  operaciones inusuales-PLDOPEINUSALERTTRANSPRO'$$
