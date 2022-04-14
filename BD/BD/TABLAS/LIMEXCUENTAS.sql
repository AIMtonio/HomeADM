-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMEXCUENTAS
DELIMITER ;
DROP TABLE IF EXISTS `LIMEXCUENTAS`;DELIMITER $$

CREATE TABLE `LIMEXCUENTAS` (
  `CuentaAhoID` bigint(20) NOT NULL COMMENT 'ID de la cuenta de ahorro.',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente.',
  `SucursalID` int(11) NOT NULL COMMENT 'ID de la sucursal',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha',
  `Motivo` int(2) DEFAULT NULL COMMENT 'Motivo por el cual la cuenta ya no puede recibir depósitos puede 3 o 4.',
  `Descripcion` varchar(300) DEFAULT NULL COMMENT 'Descripcion de la validación.',
  `Canal` char(1) DEFAULT NULL COMMENT 'Canal de acceso puede ser E o R',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID Empresa.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual.',
  `DireccionIP` varchar(50) DEFAULT NULL COMMENT 'Direccion IP.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ID de Programa.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena cuentas con saldo o limite excedido'$$