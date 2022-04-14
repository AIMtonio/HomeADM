-- TMPCRWFONVENCIMPRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCRWFONVENCIMPRO`;
DELIMITER $$

CREATE TABLE `TMPCRWFONVENCIMPRO` (
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `NumRetirosMes` int(11) DEFAULT NULL COMMENT 'Numero de \nRetiros en el\nMes',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Cuenta de \nAhorro del \nCliente o \nInversionista',
  `SaldoCapVigente` decimal(12,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nVigente',
  `SaldoCapExigible` decimal(12,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nExigible o\nen Atraso',
  `SaldoInteres` decimal(14,4) DEFAULT NULL COMMENT 'Saldo\nde Interes',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision\nAcumulada ',
  `RetencionIntAcum` decimal(14,4) DEFAULT NULL COMMENT 'Monto\nde la Retencion\nde Interes\nAcumulada\nDiaria',
  `SucursalOrigen` int(5) DEFAULT NULL COMMENT 'No de Sucursal a la que pertenece el cliente, Llave Foranea Hacia Tabla SUCURSALES\n',
  `ClienteID` int(11) NOT NULL COMMENT 'LLave Primaria para Identificar los Clientes\n',
  `PagaISR` char(1) DEFAULT NULL COMMENT 'Paga ISR en Inversiones\nEspecifica si el cliente paga o no ISR por los \nIntereses de Inversión S.- Si Paga\nN.- No Paga',
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Numero de transacción.',
  KEY `INDEX_TMPCRWFONVENCIMPRO_1` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: SP QUE REEMPLAZA EL CURSOR CURSORFONDEO'$$
