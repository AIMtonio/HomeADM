-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAAMORTI
DELIMITER ;
DROP TABLE IF EXISTS `ARRENDAAMORTI`;DELIMITER $$

CREATE TABLE `ARRENDAAMORTI` (
  `ArrendaAmortiID` int(4) NOT NULL COMMENT 'Numero consudecutivo de la amortizacion o la cuota',
  `ArrendaID` bigint(12) NOT NULL COMMENT 'Llave principal del Arrendamiento ',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de cliente a quien pertenece el arrendamiento',
  `FechaInicio` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de inicio de la cuota o amortizacion',
  `FechaVencim` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de vencimiento de la cuota o amortizacion',
  `FechaExigible` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha en la que es exigible el pago Cuando la fecha de vencimiento es dia habil esta fecha es igual,  cuando la fecha de vencimiento es inhabil, esta fecha se recorre a la siguiente fecha habil',
  `FechaLiquida` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha en la que la cuota fue liquidada Requerida solo si la cuota tiene estatus de P = Pagada',
  `Estatus` varchar(1) NOT NULL DEFAULT 'G' COMMENT 'Estatus de la amortización valores:  I .- Inactivo V.- Vigente  P .- Pagado  C .- Cancelado  B.- Vencido  A.- Atrasado  K.- Castigado',
  `CapitalRenta` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Monto de Capital de la renta correspondiente a cada cuota',
  `InteresRenta` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Monto de Interes de la renta correspondiente a cada cuota',
  `Renta` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Es el valor de la renta (debe ser igual a la suma de Capita e Interes)',
  `IVARenta` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Es el IVA que debera pagar correspondiente a la Renta ',
  `SaldoInsoluto` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'indica el saldo insoluto del capital de Arrendamiento a lo largo de las cutoas, iniciando con el monto Financiado hasta finalizar el Arrendamiento llegando a cero o al valor residual en caso que aplique',
  `Seguro` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Es el valor del seguro que se suma a la renta en cada cuota Solo aplica si el seguro es financiado',
  `SeguroVida` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Es el valor del seguro de vida que se suma a la renta en cada cuota Solo aplica si el seguro es financiado',
  `SaldoCapVigent` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo de Capital de la renta  cuando la cuota y el arrendamiento se encuentran vigentes ',
  `SaldoCapAtrasad` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo de Capital Atrasado de la Renta en cuotas que estan atrasadas',
  `SaldoCapVencido` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo de Capital Vendio exigible, cuando la cuota esta vencida (90 dias de atraso del arrendamiento)',
  `MontoIVACapital` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Es el IVA de capita que se ha pagado (no es saldo, es lo realmente pagado) en cada cuota',
  `SaldoInteresVigente` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo vigente de Interes de la Renta, cuando la cuota esta vigente y el arrendamiento tambien esta vigente',
  `SaldoInteresAtras` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo Atrasado del interes de la renta, esto es cuando la cuota esta atrasada y el arrendamiento esta vigente',
  `SaldoInteresVen` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo de Interes Vencido exigible, esto es cuando el arrendamiento esta vencido (90 dias de atraso) y la cuota ya llego o paso su exigibilidad',
  `MontoIVAInteres` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Es el IVA de Interes que se ha pagado (no es saldo, es lo realmente pagado) en cada cuota',
  `SaldoSeguro` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo del Seguro inmobiliario Solo aplica si el seguro fue financiado',
  `MontoIVASeguro` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Monto de IVA del seguro inmobiliario pagado (no es saldo, es lo realmente pagado) en cada cuota',
  `SaldoSeguroVida` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo del Seguro de vida Solo aplica si el seguro fue Financiado',
  `MontoIVASeguroVida` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Monto de IVA del seguro de vida pagado (no es saldo, es lo realmente pagado) en cada cuota',
  `SaldoMoratorios` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo de los intereses moratorios en caso de tener atraso y que el arrendamiento no se encuentre como vencido',
  `MontoIVAMora` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Monto de IVA de moratorios pagado (no es saldo, es lo realmente pagado) en cada cuota',
  `SaldComFaltPago` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo de la comision generada por falta de pago',
  `MontoIVAComFalPag` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Monto de IVA de comision Falta de pago que se ha pagado (no es saldo, es lo realmente pagado) en cada cuota',
  `SaldoOtrasComis` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Saldo de comision por concepto de otras comisiones ',
  `MontoIVAComisi` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Monto de IVA de otras comisiones pagado (no es saldo, es lo realmente pagado) en cada cuota',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transacción',
  PRIMARY KEY (`ArrendaAmortiID`,`ArrendaID`),
  KEY `FK_ ARRENDAAMORTI_1_idx` (`ArrendaID`),
  KEY `FK_ ARRENDAAMORTI_2_idx` (`ClienteID`),
  CONSTRAINT `FK_ ARRENDAAMORTI_1` FOREIGN KEY (`ArrendaID`) REFERENCES `ARRENDAMIENTOS` (`ArrendaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ ARRENDAAMORTI_2` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para amortizaciones de arrendamientos'$$