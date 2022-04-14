-- TMPCRWFONTRASEXIPRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCRWFONTRASEXIPRO`;

DELIMITER $$
CREATE TABLE `TMPCRWFONTRASEXIPRO` (
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID.',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `NumRetirosMes` int(11) DEFAULT NULL COMMENT 'Numero de \nRetiros en el\nMes',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Cuenta de \nAhorro del \nCliente o \nInversionista',
  `SaldoCapVigente` decimal(12,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nVigente',
  `SaldoInteres` decimal(14,4) DEFAULT NULL COMMENT 'Saldo\nde Interes',
  `SucursalOrigen` int(5) DEFAULT NULL COMMENT 'No de Sucursal a la que pertenece el cliente, Llave Foranea Hacia Tabla SUCURSALES\n',
  `ClienteID` int(11) NOT NULL COMMENT 'LLave Primaria para Identificar los Clientes\n',
  `NumTransaccion` int(7) NOT NULL DEFAULT '0' COMMENT 'Número de transacción.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: SP QUE REEMPLAZA EL CURSOR CURSOREXIGIBLE'$$
