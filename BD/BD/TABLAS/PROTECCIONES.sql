-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROTECCIONES
DELIMITER ;
DROP TABLE IF EXISTS `PROTECCIONES`;DELIMITER $$

CREATE TABLE `PROTECCIONES` (
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente que se esta cancelando',
  `ClienteCancelaID` int(11) DEFAULT NULL COMMENT 'Folio o Consecutivo de la tabla CLIENTESCANCELA',
  `TotalSaldoOriCap` decimal(14,2) DEFAULT NULL COMMENT 'Total saldo original de las cuentas de captacion',
  `ParteSocial` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la parte social del cliente ',
  `InteresCap` decimal(14,2) DEFAULT NULL COMMENT 'Intereses por captaciÃ³n a los dÃ­as que hayan transcurridos en el mes al momento de la cancelaciÃ³n del cliente',
  `InteresRetener` decimal(14,2) DEFAULT NULL COMMENT 'ISR  por captaciÃ³n a los dÃ­as que hayan transcurridos en el mes al momento de la cancelaciÃ³n del cliente',
  `TotalHaberes` decimal(14,2) DEFAULT NULL COMMENT 'Total de haberes del ex - cliente = [(TotalSaldoOriCap + ParteSocial + InteresesCap) - ISRCap]',
  `TotalAdeudoCre` decimal(14,2) DEFAULT NULL COMMENT 'Total de adeudo de los crÃ©ditos que fue pagado con los haberes del socio ',
  `AplicaPROFUN` char(1) DEFAULT NULL COMMENT 'Indica si aplica el beneficio de PROFUN',
  `AplicaSERVIFUN` char(1) DEFAULT NULL COMMENT 'Indica si aplica el beneficio de SERVIFUN',
  `AplicaProtecCre` char(1) DEFAULT NULL COMMENT 'Indica si aplica el beneficio de ProtecciÃ³n al CrÃ©dito',
  `AplicaProtecAho` char(1) DEFAULT NULL COMMENT 'Indica si aplica el beneficio de ProtecciÃ³n al Ahorro',
  `MontoPROFUN` decimal(14,2) DEFAULT NULL COMMENT 'Monto otorgado por PROFUN',
  `CobradoPROFUN` decimal(14,2) DEFAULT NULL,
  `MontoSERVIFUN` decimal(14,2) DEFAULT NULL COMMENT 'Monto otorgado por SERVIFUN',
  `MontoProtecCre` decimal(14,2) DEFAULT NULL COMMENT 'Monto otorgado por ProtecciÃ³n al CrÃ©dito',
  `MontoProtecAho` decimal(14,2) DEFAULT NULL COMMENT 'Monto otorgado por ProtecciÃ³n al Ahorro',
  `TotalBeneAplicado` decimal(14,2) DEFAULT NULL COMMENT 'Total de haberes del ex â socio + los beneficios aplicados, incluyendo el monto del crÃ©dito aplicado.',
  `SaldoFavorCliente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo a Favor del Cliente el cual se repartirÃ¡ entre los beneficiarios de la cuenta.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`),
  KEY `FK_ClienteCancelaID_1` (`ClienteCancelaID`),
  CONSTRAINT `FK_ClienteCancelaID_1` FOREIGN KEY (`ClienteCancelaID`) REFERENCES `CLIENTESCANCELA` (`ClienteCancelaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla en donde se registran los saldos de cada uno de concep'$$