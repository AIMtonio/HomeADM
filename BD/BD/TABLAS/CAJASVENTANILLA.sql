-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASVENTANILLA
DELIMITER ;
DROP TABLE IF EXISTS `CAJASVENTANILLA`;DELIMITER $$

CREATE TABLE `CAJASVENTANILLA` (
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal donde\nse encuentra\nAsignada la Caja',
  `CajaID` int(11) NOT NULL COMMENT 'ID o Numero de Caja',
  `TipoCaja` char(2) NOT NULL COMMENT 'CP .- Caja\n	 Principal de\n	 Sucursal\nBG .- Boveda\n	 Central\nCA .- Caja de\n	Atencion al\n	Publico',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario Asignado\na la Caja',
  `DescripcionCaja` varchar(50) DEFAULT NULL COMMENT 'Descripcion de la Caja',
  `Estatus` char(1) DEFAULT NULL COMMENT 'A .- Activa \\nI .- Inactiva\\nC .- Cancelado\\nLas cajas nacen con\\nEstatus A\\n .- Activa',
  `EstatusOpera` char(1) DEFAULT NULL,
  `SaldoEfecMN` decimal(14,2) NOT NULL COMMENT 'Saldo del\nEfectivo en\nMoneda Nacional',
  `SaldoEfecME` decimal(14,2) unsigned zerofill NOT NULL COMMENT 'Saldo del Efectivo\\nen Moneda\\nExtranjera',
  `LimiteEfectivoMN` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Limite del la caja, si este valor se supera se bloquea la caja',
  `LimiteDesemMN` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Limite del Desembolso de moneda nacional, si este valor se supera se bloquea la operacion',
  `MaximoRetiroMN` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Limite del Desembolso de moneda naciona, si este valor se supera se bloquea la operacion',
  `FechaCan` date DEFAULT NULL COMMENT 'Fecha de cancelacion',
  `MotivoCan` varchar(100) DEFAULT NULL COMMENT 'Motivo Cancelacion\n',
  `FechaInac` date DEFAULT NULL COMMENT 'Fecha Inactivacion\n',
  `MotivoInac` varchar(100) DEFAULT NULL COMMENT 'Motivo Inactivacion\n',
  `FechaAct` date DEFAULT NULL COMMENT 'Fecha de Activacion',
  `MotivoAct` varchar(100) DEFAULT NULL COMMENT 'Motivo de Activacion',
  `NomImpresora` varchar(30) DEFAULT NULL,
  `NomImpresoraCheq` varchar(30) DEFAULT NULL COMMENT 'Refiere al nombre de la impresora de los cheque',
  `HuellaDigital` char(1) DEFAULT NULL COMMENT 'Indica si la caja valida la huella digital ',
  `EjecutaProceso` char(1) DEFAULT 'N' COMMENT 'Bandera para saber si la caja esta procesando alguna operacion o no.\nN = NO, S=SI',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SucursalID`,`CajaID`),
  KEY `fk_CAJASVENTANILLA_1` (`SucursalID`),
  KEY `fk_CAJASVENTANILLA_2` (`UsuarioID`),
  CONSTRAINT `fk_CAJASVENTANILLA_1` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo para Manejo de Cajas en Ventanilla'$$