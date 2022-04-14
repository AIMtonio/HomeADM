-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPROTECCIONES
DELIMITER ;
DROP TABLE IF EXISTS `HISPROTECCIONES`;DELIMITER $$

CREATE TABLE `HISPROTECCIONES` (
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente que se esta cancelando',
  `ClienteCancelaID` int(11) DEFAULT NULL COMMENT 'Folio o Consecutivo de la tabla CLIENTESCANCELA',
  `TotalSaldoOriCap` decimal(14,2) DEFAULT NULL COMMENT 'Total saldo original de las cuentas de captacion',
  `ParteSocial` varchar(45) DEFAULT NULL COMMENT 'Monto de la parte social del cliente ',
  `InteresCap` decimal(14,2) DEFAULT NULL COMMENT 'Intereses por captación a los días que hayan transcurridos en el mes al momento de la cancelación del cliente',
  `InteresRetener` decimal(14,2) DEFAULT NULL COMMENT 'ISR  por captación a los días que hayan transcurridos en el mes al momento de la cancelación del cliente',
  `TotalHaberes` decimal(14,2) DEFAULT NULL COMMENT 'Total de haberes del ex - cliente = [(TotalSaldoOriCap + ParteSocial + InteresesCap) - ISRCap]',
  `TotalAdeudoCre` decimal(14,2) DEFAULT NULL COMMENT 'Total de adeudo de los créditos que fue pagado con los haberes del socio ',
  `AplicaPROFUN` char(1) DEFAULT NULL COMMENT 'Indica si aplica el beneficio de PROFUN',
  `AplicaSERVIFUN` char(1) DEFAULT NULL COMMENT 'Indica si aplica el beneficio de SERVIFUN',
  `AplicaProtecCre` char(1) DEFAULT NULL COMMENT 'Indica si aplica el beneficio de Protección al Crédito',
  `AplicaProtecAho` char(1) DEFAULT NULL COMMENT 'Indica si aplica el beneficio de Protección al Ahorro',
  `MontoPROFUN` decimal(14,2) DEFAULT NULL COMMENT 'Monto otorgado por PROFUN',
  `CobradoPROFUN` decimal(14,2) DEFAULT NULL COMMENT 'Monto cobrado PROFUN',
  `MontoProtecCre` decimal(14,2) DEFAULT NULL COMMENT 'Monto otorgado por Protección al Crédito',
  `MontoSERVIFUN` decimal(14,2) DEFAULT NULL COMMENT 'Monto otorgado por SERVIFUN',
  `MontoProtecAho` decimal(14,2) DEFAULT NULL COMMENT 'Monto otorgado por Protección al Ahorro',
  `TotalBeneAplicado` decimal(14,2) DEFAULT NULL COMMENT 'Total de haberes del ex – socio + los beneficios aplicados, incluyendo el monto del crédito aplicado.',
  `SaldoFavorCliente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo a Favor del Cliente el cual se repartirá entre los beneficiarios de la cuenta.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` int(15) DEFAULT NULL COMMENT 'Campo de auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$