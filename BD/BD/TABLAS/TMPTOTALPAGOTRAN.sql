
DELIMITER ;
DROP TABLE IF EXISTS `TMPTOTALPAGOTRAN`;

DELIMITER $$
CREATE TABLE `TMPTOTALPAGOTRAN` (
  `RegistroID` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Crédito',
  `MontoTotal` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Pagado',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Guarda forma de pago \nE = Efectivo\nC = Cargo a cuenta',
  `NumTransaccion` bigint(20) NOT NULL,
  `AlertaXCuota2` char(1) DEFAULT 'N' COMMENT 'Indica si genera Alerta por Pago Sup. al Exigible. Nva Alerta.\nS.- Sí.\nN.- No.',
  PRIMARY KEY(RegistroID),
  KEY `IDX_TMPTOTALPAGOTRAN_1` (`Transaccion`,`CreditoID`),
  KEY `IDX_TMPTOTALPAGOTRAN_2` (`NumTransaccion`),
  KEY `IDX_TMPTOTALPAGOTRAN_3` (`NumTransaccion`,`MontoTotal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP:Tabla temporal operaciones total pagos en deteccion de  operaciones inusuales-PLDOPEINUSALERTTRANSPRO'$$

