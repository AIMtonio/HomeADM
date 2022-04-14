-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPVENCIMANTCEDE
DELIMITER ;
DROP TABLE IF EXISTS `TMPVENCIMANTCEDE`;DELIMITER $$

CREATE TABLE `TMPVENCIMANTCEDE` (
  `CedeID` int(11) NOT NULL COMMENT 'Cede id',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Cuenta de ahorro',
  `TipoCedeID` int(11) NOT NULL COMMENT 'Tipo de Cede',
  `MonedaID` int(11) NOT NULL COMMENT 'Moneda id',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `SaldoProvision` decimal(18,2) NOT NULL COMMENT 'Saldo provision',
  `FechaVencimiento` date NOT NULL COMMENT 'Fecha de Vencimiento',
  `CalculoInteres` int(11) NOT NULL COMMENT 'Calculo de interes',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus\nN =vigente\nP =Pagada\nC =Cancelada\nA =Registrada',
  `Reinversion` char(1) NOT NULL COMMENT 'Especifica si realiza Reinversion Automatica\nS.- Si realiza Reinversion Automatica\nN.- No Realiza Reinversion',
  `Monto` decimal(18,2) NOT NULL COMMENT 'Monto de la cede',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `UsuarioID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$