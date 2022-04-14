-- TMPCRWGENINTEREINVPRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCRWGENINTEREINVPRO`;
DELIMITER $$

CREATE TABLE `TMPCRWGENINTEREINVPRO` (
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `CreditoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'Número del crédito.',
  `AmortizacionID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'Número de amortización.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha de Exigibilidad de la Amortizacion, por si la de',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Numero de empresa.',
  `SaldoCapVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nVigente',
  `CalcInteresID` int(11) DEFAULT NULL COMMENT 'Formula para el calculo de Interes',
  `TasaFija` decimal(12,4) DEFAULT NULL COMMENT 'Si es formula uno (Tasa Fija), aqui se especifica el valor de dicha\ntasa fija',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del Fondeo	\nN .- Vigente o en Proceso\nP .- Pagada\nV .- Vencida',
  `SucursalOrigen` int(5) DEFAULT NULL COMMENT 'No de Sucursal a la que pertenece el cliente, Llave Foranea Hacia Tabla SUCURSALES\n',
  `ClienteID` int(11) NOT NULL COMMENT 'LLave Primaria para Identificar los Clientes\n',
  `PagaISR` char(1) DEFAULT NULL COMMENT 'Paga ISR en Inversiones\nEspecifica si el cliente paga o no ISR por los \nIntereses de Inversión\n	''S''.- Si Paga\n	''N''.- No Paga',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Cuenta de \nAhorro del \nCliente o \nInversionista',
  `NumRetirosMes` int(11) DEFAULT NULL COMMENT 'Numero de \nRetiros en el\nMes',
  `SaldoCapCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'Capital que se encuentra en las cuentas de orden(capital que se uso para aplicar la garantia del credito)',
  `InteresGenerado` decimal(14,2) DEFAULT NULL COMMENT 'Interes Generado o Calculado',
  `SaldoInteres` decimal(14,4) DEFAULT NULL COMMENT 'Saldo\nde Interes',
  `SaldoIntCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'interes que se encuentra en cuentas de Orden(interes que se uso para aplicar la garantia al credito)',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision\nAcumulada ',
  `SaldoCapVigAmo` decimal(12,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nVigente',
  `SaldoCapExigibleL` decimal(7,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo capital exigible.',
  `NumTransaccion` bigint(12) NOT NULL DEFAULT '0' COMMENT 'Número de transacción.',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'Tasa ISR de PARAMETROSCRW.',
  `FormulaRetencion` char(1) DEFAULT NULL COMMENT 'Formula de Retencion de PARAMETROSCRW.',
  KEY `INDEX_TMPCRWGENINTEREINVPRO_1` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: SP QUE REEMPLAZA EL CURSOR GENERAINTEREINVPRO'$$
