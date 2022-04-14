-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPVENCANTAPORT
DELIMITER ;
DROP TABLE IF EXISTS `TMPVENCANTAPORT`;DELIMITER $$

CREATE TABLE `TMPVENCANTAPORT` (
  `AportacionID` int(11) NOT NULL COMMENT 'Número de Aportación.',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Cuenta de ahorro.',
  `TipoAportacionID` int(11) NOT NULL COMMENT 'Tipo de Aportación.',
  `MonedaID` int(11) NOT NULL COMMENT 'Moneda id.',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente.',
  `SaldoProvision` decimal(18,2) NOT NULL COMMENT 'Saldo provision.',
  `FechaVencimiento` date NOT NULL COMMENT 'Fecha de Vencimiento.',
  `CalculoInteres` int(11) NOT NULL COMMENT 'Calculo de interes.',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus\nN =vigente\nP =Pagada\nC =Cancelada\nA =Registrada.',
  `Reinversion` char(1) NOT NULL COMMENT 'Especifica si realiza Reinversion Automatica\nS.- Si realiza Reinversion Automatica\nN.- No Realiza Reinversion.\nF.- Posterior',
  `Monto` decimal(18,2) NOT NULL COMMENT 'Monto de la Aportacion.',
  `PagoIntCapitaliza` char(1) DEFAULT 'I' COMMENT 'Indica si capitaliza interes S:Si, N:No, I:Indistinto',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria.',
  `UsuarioID` int(11) NOT NULL COMMENT 'Campo de Auditoria.',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria.',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria.',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria.',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria.',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria.',
  KEY `INDEX_TMPVENCANTAPORT_1` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Vencimientos anticipados de Aportaciones.'$$