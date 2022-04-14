-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBALANZA
DELIMITER ;
DROP TABLE IF EXISTS `TMPBALANZA`;DELIMITER $$

CREATE TABLE `TMPBALANZA` (
  `NumeroTransaccion` bigint(20) NOT NULL COMMENT 'Numero \nTransaccion',
  `Fecha` date NOT NULL COMMENT 'Fecha',
  `CuentaContable` char(12) NOT NULL COMMENT 'Cuenta Contable',
  `ConBalanzaID` bigint(11) NOT NULL COMMENT 'Concepto de la balanza fk de la tabla CONCEPTOBALANZA',
  `Cargos` decimal(12,2) DEFAULT NULL,
  `Abonos` decimal(12,2) DEFAULT NULL,
  `Naturaleza` char(1) DEFAULT NULL COMMENT 'Naturaleza de la\nCuenta\nA .-  Acreedora\nD .-  Deudora',
  PRIMARY KEY (`NumeroTransaccion`,`Fecha`,`CuentaContable`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal para Procesos de Contabilidad'$$