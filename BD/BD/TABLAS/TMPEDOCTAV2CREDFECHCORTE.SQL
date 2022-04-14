DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOCTAV2CREDFECHCORTE`;
DELIMITER $$

CREATE TABLE `TMPEDOCTAV2CREDFECHCORTE` (
  `CreditoID` bigint(12)         NOT NULL COMMENT 'Identificador del credito',
  `FechaCorte` date              NOT NULL COMMENT 'Fecha corte de los saldos del credito',
  PRIMARY KEY (`CreditoID`,`FechaCorte`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para obtener la proxima fecha de pago de los creditos'$$
