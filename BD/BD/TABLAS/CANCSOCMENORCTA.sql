-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCSOCMENORCTA
DELIMITER ;
DROP TABLE IF EXISTS `CANCSOCMENORCTA`;DELIMITER $$

CREATE TABLE `CANCSOCMENORCTA` (
  `ConsecutivoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Indica el Consecutivo de la Tabla',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'El ID del Socio Menor Cancelado ',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `SaldoAhorro` decimal(14,2) DEFAULT NULL COMMENT 'El saldo Total de Ahorro',
  `EstatusCta` char(1) DEFAULT NULL COMMENT 'Estatus de la Cuenta de Ahorro antes de la Cancelación ',
  `FechaCancela` date DEFAULT NULL COMMENT 'Fecha Cancelacion',
  `Aplicado` char(1) DEFAULT NULL COMMENT 'Retiro de Efectivo R = Ya fue Retirado  N = No ha sido Retirado',
  `FechaRetiro` datetime DEFAULT NULL COMMENT 'Fecha de retiro del total',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Indica la sucursal en la que se hizo el retiro',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Indica la caja en la que se hizo el retiro',
  `Identidad` int(11) DEFAULT NULL COMMENT 'Indica el Tipo de Identificación del socio',
  `NumIdentific` varchar(50) DEFAULT NULL COMMENT 'Indica el numero de identificacion del socio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(45) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`ConsecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar Registros de los Socios Menores cancelado'$$