-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETADEBITO
DELIMITER ;
DROP TABLE IF EXISTS `TARJETADEBITO`;
DELIMITER $$

CREATE TABLE `TARJETADEBITO` (
  `TarjetaDebID` char(16) NOT NULL COMMENT 'ID de la Tarjeta de Debito',
  `LoteDebitoID` int(11) DEFAULT NULL COMMENT 'ID Lote con que se Creo la Tarjeta',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha de Registro de la Tarjeta',
  `FechaVencimiento` char(5) DEFAULT NULL COMMENT 'Fecha de Vencimiento o Expiracion',
  `FechaActivacion` date DEFAULT NULL COMMENT 'Fecha de Activacion',
  `Estatus` int(11) DEFAULT NULL COMMENT 'Estatus de la Tarjeta corresponde con tabla ESTATUSTD',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id del Cliente al que Pertenece la Tarjeta. Al incio es Cero',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `FechaBloqueo` date DEFAULT NULL COMMENT 'Fecha de Bloqueo',
  `MotivoBloqueo` int(11) DEFAULT NULL COMMENT 'Motivo de Bloqueo de la Tarjeta. Nace Vacio',
  `FechaCancelacion` date DEFAULT NULL COMMENT 'Fecha de Cancelacion',
  `MotivoCancelacion` int(11) DEFAULT NULL COMMENT 'Motivo de Cancelacion de la Tarjeta, FK CATALCANBLOQTAR',
  `FechaDesbloqueo` date DEFAULT NULL,
  `MotivoDesbloqueo` int(11) DEFAULT NULL,
  `NIP` varchar(256) DEFAULT NULL COMMENT 'NIP de la Tarjeta.Encriptado con SHA',
  `NombreTarjeta` varchar(250) DEFAULT NULL COMMENT 'Nombre del TarjetaHabiente',
  `Relacion` char(1) DEFAULT NULL COMMENT 'Relacion del TarjetaHabiente  T.-Titular, A.-Adicional',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal a la que Pertenece la Tarjeta',
  `TipoTarjetaDebID` int(11) DEFAULT NULL COMMENT 'corresponde con la tabla TIPOTARJETADEB',
  `NoDispoDiario` int(11) DEFAULT NULL COMMENT 'Numero de Disposiciones de Efectivo Diarias para la Tarjeta',
  `NoDispoMes` int(11) DEFAULT NULL COMMENT 'Numero de Disposiciones de Efectivo Mensuales',
  `MontoDispoDiario` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total Disponible Diario',
  `MontoDispoMes` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total Disponible Mensual',
  `NoConsultaSaldoMes` int(11) DEFAULT NULL COMMENT 'Numero de Consultas de saldo en el Mes',
  `NoCompraDiario` int(11) DEFAULT NULL,
  `NoCompraMes` int(11) DEFAULT NULL,
  `MontoCompraDiario` decimal(12,2) DEFAULT NULL,
  `MontoCompraMes` decimal(12,2) DEFAULT NULL,
  `TipoCobro` char(3) DEFAULT NULL COMMENT 'Tipo de Cobro: NSC = Nueva Sin Costo, RC = Reposicion Costo, RE = Renov. Por Expedicion',
  `PagoComAnual` char(1) DEFAULT NULL COMMENT 'Pago de comisión anual. S = SI, N = NO',
  `FPagoComAnual` date DEFAULT NULL COMMENT 'Fecha en que le corresponde el pago de la comision anual',
  `EsVirtual` char(1) NOT NULL DEFAULT 'N' COMMENT 'Especifica si la tarjeta es virtual S-Si N-No',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TarjetaDebID`),
  KEY `INDEX_Estatus` (`Estatus`),
  KEY `INDEX_ClienteID` (`ClienteID`),
  KEY `INDEX_CuentaAhoID` (`CuentaAhoID`),
  CONSTRAINT `fk_TARJETADEBITO_1` FOREIGN KEY (`Estatus`) REFERENCES `ESTATUSTD` (`EstatusID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tarjeta de Debito'$$