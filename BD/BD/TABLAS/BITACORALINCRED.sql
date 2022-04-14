-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORALINCRED
DELIMITER ;
DROP TABLE IF EXISTS `BITACORALINCRED`;DELIMITER $$

CREATE TABLE `BITACORALINCRED` (
  `LineaCreditoID` char(12) DEFAULT NULL COMMENT 'Numero de Linea de Credito. Es un consecutivo',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente',
  `CuentaID` bigint(12) DEFAULT NULL,
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Numero de Moneda',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Numero de Sucursal',
  `FolioContrato` varchar(15) DEFAULT NULL COMMENT 'Folio del Contrato. Es dato que ingresa el ejecutivo',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio de la Linea de Credito',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Linea de Credito',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'Tipo de Linea',
  `Solicitado` decimal(12,2) DEFAULT NULL COMMENT 'Monto solicitado\npor el usuario',
  `Autorizado` decimal(12,2) DEFAULT NULL COMMENT 'Monto Autorizado de la Linea',
  `FechaDesbloqueo` date DEFAULT NULL,
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha en que se\nautoriza',
  `UsuarioAutoriza` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `NumError` int(3) DEFAULT NULL,
  `MensajeError` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Para errores de insercion masiva\n'$$