
-- TMPCRWFONDEOINV
DELIMITER ;
DROP TABLE IF EXISTS `TMPCRWFONDEOINV`;
DELIMITER $$

CREATE TABLE `TMPCRWFONDEOINV` (
  `FondeoID`			BIGINT(20)		NOT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `ClienteID`			INT(11)			NOT NULL COMMENT 'Numero o ID del Cliente',
  `CreditoID`			BIGINT(12)		NOT NULL COMMENT 'Numero de Credito',
  `CuentaAhoID`			BIGINT(12)		NOT NULL COMMENT 'Cuenta de \nAhorro del \nCliente o \nInversionista',
  `SolicitudCreditoID`	BIGINT(20)		NOT NULL COMMENT 'Numero de Solicitud',
  `TasaFija`			DECIMAL(12,4)	NOT NULL COMMENT 'Si es formula uno (Tasa Fija), aqui se especifica el valor de dicha\ntasa fija',
  `MontoFondeo`			DECIMAL(14,2)	NOT NULL COMMENT 'Monto del Fondeo',
  `PorcentajeFondeo`	DECIMAL(10,6)	NOT NULL COMMENT 'Porcentaje del Fondeo',
  `MonedaID`			INT(11)			NOT NULL COMMENT 'Moneda',
  `FechaInicio`			DATE			NOT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento`	DATE			NOT NULL COMMENT 'Fecha de Vencimiento',
  `Estatus`				CHAR(1)			NOT NULL COMMENT 'Estatus del Fondeo	\nN .- Vigente o en Proceso\nP .- Pagada\nV .- Vencida',
  `SaldoCapVigente`		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo\nde Capital\nVigente',
  `SaldoCapExigible`	DECIMAL(14,2)	NOT NULL COMMENT 'Saldo\nde Capital\nExigible o\nen Atraso',
  `SaldoInteres`		DECIMAL(14,4)	NOT NULL COMMENT 'Saldo\nde Interes',
  `ProvisionAcum`		DECIMAL(14,4)	NOT NULL COMMENT 'Provision\nAcumulada ',
  `MoratorioPagado`		DECIMAL(12,2)	NOT NULL COMMENT 'Acumulado de \nMoratorios\nPagados al\nInversionista',
  `ComFalPagPagada`		DECIMAL(12,2)	NOT NULL COMMENT 'Acumulado de \nComision por Falta de Pago\nPagados al\nInversionista',
  `SaldoCapCtaOrden`	DECIMAL(12,2)	NOT NULL COMMENT 'Saldo capital cuenta ordenante',
  `EmpresaID`			INT(11)			NOT NULL COMMENT 'columna de auditoria',
  `Usuario`				INT(11)			NOT NULL COMMENT 'columna de auditoria',
  `FechaActual`			DATE			NOT NULL COMMENT 'columna de auditoria',
  `DireccionIP`			VARCHAR(15)		NOT NULL COMMENT 'columna de auditoria',
  `ProgramaID`			VARCHAR(50)		NOT NULL COMMENT 'columna de auditoria',
  `Sucursal`			INT(11)			NOT NULL COMMENT 'columna de auditoria',
  `NumTransaccion`		BIGINT(20)		NOT NULL COMMENT 'columna de auditoria',
  PRIMARY KEY (`FondeoID`),
  KEY `FK_TMPCRWFONDEOINV_1` (`ClienteID`),
  KEY `FK_TMPCRWFONDEOINV_2` (`CreditoID`),
  KEY `FK_TMPCRWFONDEOINV_3` (`CuentaAhoID`),
  KEY `INDEX_TMPCRWFONDEOINV_1` (`ClienteID`,`CuentaAhoID`,`Estatus`) USING BTREE,
  KEY `INDEX_TMPCRWFONDEOINV_2` (`ClienteID`,`CuentaAhoID`) USING BTREE,
  KEY `INDEX_TMPCRWFONDEOINV_3` (`Estatus`,`ClienteID`,`CuentaAhoID`) USING BTREE,
  CONSTRAINT `FK_TMPCRWFONDEOINV_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_TMPCRWFONDEOINV_2` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_TMPCRWFONDEOINV_3` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla clonada de Fondeos de Credito'$$