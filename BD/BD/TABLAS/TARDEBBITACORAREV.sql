-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBBITACORAREV
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBBITACORAREV`;DELIMITER $$

CREATE TABLE `TARDEBBITACORAREV` (
  `TarDebRevID` int(11) NOT NULL COMMENT 'PK de la tabla ',
  `TipoMensaje` char(4) DEFAULT NULL COMMENT 'Tipo Mensaje de la Transaccion:\n1200 \n1210 Transacción Normal ATMs y POS\n1220\n1230  Transacción Forzada POS (se debe aplicar el cobro)\n1400\n1410 Transacción Reverso ATMs\n1420\n1430 Transacción Reverso ATMs y POS (Prosa)',
  `Referencia` varchar(12) DEFAULT NULL COMMENT 'Código de Referencia asignado a la Transacción por la terminal o ATM origen.',
  `FechaTranOriginal` char(4) DEFAULT NULL COMMENT 'Fecha de la Transaccion Original MMDD',
  `HoraTranOriginal` char(10) DEFAULT NULL COMMENT 'Hora de la transaccion Original \nHHMMSSMS',
  `FechaCaptura` char(4) DEFAULT NULL COMMENT 'Fecha de Captura MMDD',
  `MontoTransaccion` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Transaccion ',
  `TerminalID` varchar(50) DEFAULT NULL COMMENT 'Campo 41 ISO 8583 codigo de la terminal o cajero que envio la transaccion',
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'Numero de Tarjeta de Débito',
  `MontoDispensado` decimal(12,2) DEFAULT NULL COMMENT 'Monto Dispensado al Tarjetahabiente',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Reversa\nP.- Procesado (Se aplico el reverso)\nR.- Registrado (No se aplico el Reverso)',
  `EmpresaID` int(11) DEFAULT NULL,
  `UsuarioID` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(45) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TarDebRevID`),
  KEY `Index_TarjetaDebID` (`TarjetaDebID`),
  KEY `Index_Referencia` (`Referencia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$