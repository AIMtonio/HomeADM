-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MEM_TARJETADEBITO
DELIMITER ;
DROP TABLE IF EXISTS `MEM_TARJETADEBITO`;DELIMITER $$

CREATE TABLE `MEM_TARJETADEBITO` (
  `TarjetaDebID` char(16) NOT NULL COMMENT 'ID de la Tarjeta de Debito',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha de Registro de la Tarjeta',
  `FechaVencimiento` char(5) DEFAULT NULL COMMENT 'Fecha de Vencimiento o Expiracion',
  `Estatus` int(11) DEFAULT NULL COMMENT 'Estatus de la Tarjeta corresponde con tabla ESTATUSTD',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id del Cliente al que Pertenece la Tarjeta. Al incio es Cero',
  `CuentaAhoID` int(12) DEFAULT NULL COMMENT 'Id de la Cuenta Ligada a la Tarjeta. Al Inicio es Cero',
  `TipoTarjetaDebID` int(11) DEFAULT NULL COMMENT 'corresponde con la tabla TIPOTARJETADEB',
  `CompraPOSLinea` char(1) DEFAULT NULL COMMENT 'Indica si el cargo se hara en Linea\nS.- Si \nN.- No',
  `NoDispoDiario` int(11) DEFAULT NULL COMMENT 'Numero de Disposiciones de Efectivo Diarias para la Tarjeta',
  `NoDispoMes` int(11) DEFAULT NULL COMMENT 'Numero de Disposiciones de Efectivo Mensuales',
  `MontoDispoDiario` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total Disponible Diario',
  `MontoDispoMes` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total Disponible Mensual',
  `NoConsultaSaldoMes` int(11) DEFAULT NULL COMMENT 'Numero de Consultas de saldo en el Mes',
  `NoCompraDiario` int(11) DEFAULT NULL,
  `NoCompraMes` int(11) DEFAULT NULL,
  `MontoCompraDiario` decimal(12,2) DEFAULT NULL,
  `MontoCompraMes` decimal(12,2) DEFAULT NULL,
  `LimiteDispoDiario` decimal(12,4) DEFAULT NULL,
  `LimiteDispoMes` decimal(12,4) DEFAULT NULL,
  `LimiteCompraDiario` decimal(12,4) DEFAULT NULL,
  `LimiteCompraMes` decimal(12,4) DEFAULT NULL,
  `LimiteNoDispoDiario` int(11) DEFAULT NULL,
  `LimiteNoConsultaMes` int(11) DEFAULT NULL,
  `BloqueoATM` varchar(1) DEFAULT NULL,
  `BloqueoPOS` varchar(1) DEFAULT NULL,
  `BloqueoCashB` varchar(1) DEFAULT NULL,
  `OperaMOTO` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`TarjetaDebID`)
) ENGINE=MEMORY DEFAULT CHARSET=latin1$$