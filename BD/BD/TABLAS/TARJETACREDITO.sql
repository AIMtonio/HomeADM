-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETACREDITO
DELIMITER ;
DROP TABLE IF EXISTS `TARJETACREDITO`;
DELIMITER $$

CREATE TABLE `TARJETACREDITO` (
  `TarjetaCredID` char(16) NOT NULL DEFAULT '' COMMENT 'ID de la Tarjeta de Debito',
  `LoteCreditoID` int(11) DEFAULT NULL COMMENT 'ID Lote con que se Creo la Tarjeta (LOTETARJETACRED)',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha de Registro de la Tarjeta',
  `FechaVencimiento` char(5) DEFAULT NULL COMMENT 'Fecha de Vencimiento o Expiracion',
  `FechaActivacion` date DEFAULT NULL COMMENT 'Fecha de Activacion',
  `Estatus` int(11) DEFAULT NULL COMMENT 'Estatus de la Tarjeta corresponde con tabla ESTATUSTD',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id del Cliente al que Pertenece la Tarjeta. Al incio es Cero',
  `LineaTarCredID` int(11) DEFAULT NULL COMMENT 'Id de la Linea de Credito de la Tarjeta',
  `FechaBloqueo` date DEFAULT NULL COMMENT 'Fecha de Bloqueo',
  `MotivoBloqueo` int(11) DEFAULT NULL COMMENT 'Motivo de Bloqueo de la Tarjeta. Nace Vacio',
  `FechaCancelacion` date DEFAULT NULL COMMENT 'Fecha de Cancelacion',
  `MotivoCancelacion` int(11) DEFAULT NULL COMMENT 'Motivo de Cancelacion de la Tarjeta FK CATALCANBLOQTAR',
  `FechaDesbloqueo` date DEFAULT NULL COMMENT 'Feha de desbloqueo',
  `MotivoDesbloqueo` int(11) DEFAULT NULL COMMENT 'Motivo del bloqueo',
  `NIP` varchar(256) DEFAULT NULL COMMENT 'NIP de la Tarjeta.Encriptado con SHA',
  `NombreTarjeta` varchar(250) DEFAULT NULL COMMENT 'Nombre del TarjetaHabiente',
  `Relacion` char(1) DEFAULT NULL COMMENT 'Relacion del TarjetaHabiente T.-Titular, A.-Adicional',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal a la que Pertenece la Tarjeta',
  `TipoTarjetaCredID` int(11) DEFAULT NULL COMMENT 'corresponde con la tabla TIPOTARJETADEB',
  `NoDispoDiario` int(11) DEFAULT NULL COMMENT 'Numero de Disposiciones de Efectivo Diarias para la Tarjeta',
  `NoDispoMes` int(11) DEFAULT NULL COMMENT 'Numero de Disposiciones de Efectivo Mensuales',
  `MontoDispoDiario` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total Disponible Diario',
  `MontoDispoMes` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total Disponible Mensual',
  `NoConsultaSaldoMes` int(11) DEFAULT NULL COMMENT 'Numero de Consultas de saldo en el Mes',
  `NoCompraDiario` int(11) DEFAULT NULL COMMENT 'Numero de compras diario',
  `NoCompraMes` int(11) DEFAULT NULL COMMENT 'Numero de compras por mes',
  `MontoCompraDiario` decimal(12,2) DEFAULT NULL COMMENT 'Monto de compras diario',
  `MontoCompraMes` decimal(12,2) DEFAULT NULL COMMENT 'Monto de Compras por mes',
  `PagoComAnual` char(1) DEFAULT NULL COMMENT 'Pago de comision anual. S = SI, N = NO',
  `FPagoComAnual` date DEFAULT NULL COMMENT 'Fecha en que le corresponde el pago de la comision anual',
  `TipoCobro` char(3) DEFAULT NULL COMMENT 'Tipo de Cobro: NSC = Nueva Sin Costo, RE = Renov. Por Expedicion, RC = Reposicion Costo',
  `CuentaClabe` char(18) DEFAULT NULL COMMENT 'Cuenta CLABE para pago de credito',
  `EsVirtual` char(1) NOT NULL DEFAULT 'N' COMMENT 'Especifica si la tarjeta es virtual S-Si N-No',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`TarjetaCredID`),
  KEY `fk_TARJETADEBITO_1_idx` (`Estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Control de tarjetas de credito'$$