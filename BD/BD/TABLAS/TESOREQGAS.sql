-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOREQGAS
DELIMITER ;
DROP TABLE IF EXISTS `TESOREQGAS`;DELIMITER $$

CREATE TABLE `TESOREQGAS` (
  `RequisicionID` bigint(17) NOT NULL COMMENT 'Tipo de Gasto',
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal que realizo el Registro',
  `UsuarioID` int(11) NOT NULL COMMENT 'Usuario que levanto la requisicion',
  `TipoGastoID` int(11) NOT NULL COMMENT 'Id de Tipo de Gasto',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion de la requisicion de Gasto',
  `Monto` decimal(12,2) NOT NULL COMMENT 'Monto de la Requisicion',
  `TipoPago` char(2) NOT NULL,
  `NumCtaInstit` varchar(20) DEFAULT NULL,
  `CentroCostoID` int(11) NOT NULL COMMENT 'Id del Centro de Costos',
  `FechaAlta` date NOT NULL COMMENT 'Fecha en que se levanto la requisicion',
  `FechaSolicitada` date NOT NULL COMMENT 'Fecha en que se requiere el Deposito del monto de la requisicion',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `UsuarioAutoriza` int(11) NOT NULL COMMENT 'Usuario que esta Autorizando la requisicion',
  `UsuarioProcesa` int(11) NOT NULL COMMENT 'Usuario procesa o finaliza la requisicion',
  `Status` varchar(1) NOT NULL COMMENT 'Status de la Requisicion N=Alta de requisicion, C=Cancelada, A=Autorizada,P=Procesada',
  `EmpresaID` int(11) NOT NULL COMMENT 'EmpresaID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'DireccionIP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'ProgramaID',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero Transaccion',
  PRIMARY KEY (`RequisicionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$