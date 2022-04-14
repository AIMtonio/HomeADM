-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPARCHRESERVFIRA
DELIMITER ;
DROP TABLE IF EXISTS `TMPARCHRESERVFIRA`;DELIMITER $$

CREATE TABLE `TMPARCHRESERVFIRA` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `NumControl` varchar(200) NOT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `IdCreditoFira` varchar(200) NOT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `IdAcreditadoFira` varchar(200) NOT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `NomAcreditado` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `IdAcredIfnb` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `CobertNominalFEGA` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `SaldoInsoluto` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `PiAcred` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `SeveridadAcred` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `SeveridadFinal` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `GarantiaFondos` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `CreditoInformado` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `MetodoCalculoCNBV` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `EstatusCredito` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `ReservaTotal` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `PorReservaTotal` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  `GradoRiesgoCred` varchar(200) DEFAULT NULL COMMENT 'Campo con la información cargado en el archivo de Reserva FIRA CSV',
  PRIMARY KEY (`NumControl`,`IdCreditoFira`,`IdAcreditadoFira`,`TransaccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP:Tabla temporal para los archivos de perdida fira'$$