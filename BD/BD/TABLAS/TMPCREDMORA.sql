-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDMORA
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDMORA`;DELIMITER $$

CREATE TABLE `TMPCREDMORA` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `TotalPagar` decimal(14,2) NOT NULL COMMENT 'Monto Total a Pagar',
  `SaldoVencido` decimal(14,2) NOT NULL COMMENT 'Saldo Vencido',
  `DiasAtraso` int(11) NOT NULL COMMENT 'Dias Atraso',
  `CuotasAtraso` int(11) NOT NULL COMMENT 'Cuotas Atraso',
  `FechaUltPago` datetime NOT NULL COMMENT 'Fecha Ultima Pago ',
  `MonUltPago` decimal(14,2) NOT NULL COMMENT 'Monto del Ultimo Pago ',
  `FechaSigPago` datetime NOT NULL COMMENT 'Fecha Siguiente Pago ',
  `Cuota` decimal(14,2) NOT NULL COMMENT 'Cuota',
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para los procesos BATCH hacia SGB creditos que estan e'$$