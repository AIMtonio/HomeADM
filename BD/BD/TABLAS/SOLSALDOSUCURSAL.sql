-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLSALDOSUCURSAL
DELIMITER ;
DROP TABLE IF EXISTS `SOLSALDOSUCURSAL`;DELIMITER $$

CREATE TABLE `SOLSALDOSUCURSAL` (
  `SolSaldoSucursalID` int(11) NOT NULL COMMENT 'ID Solicitud de Saldo de Sucursal',
  `UsuarioID` int(11) NOT NULL COMMENT 'ID Usuario, FK Tabla Usuarios',
  `SucursalID` int(11) NOT NULL COMMENT 'ID Sucursal, FK Tabla Sucursal',
  `FechaSolicitud` date NOT NULL COMMENT 'Almacena la Fecha en que se reliza la Solicitud',
  `HoraSolicitud` time NOT NULL COMMENT 'Almacena la Hora en que se realiza la Solicitud, Formato 24 hrs HH:MM',
  `CanCreDesem` int(11) NOT NULL COMMENT 'Almacena la Cantidad de Creditos por Desembolsar',
  `MonCreDesem` decimal(14,2) NOT NULL COMMENT 'Almacena el Monto de Creditos por Desembolsar',
  `CanInverVenci` int(11) NOT NULL COMMENT 'Almacena la Cantidad de Inversiones por Vencer Hoy',
  `MonInverVenci` decimal(14,2) NOT NULL COMMENT 'Almacena el Monto de Inversiones por Vencer Hoy',
  `CanChequeEmi` int(11) NOT NULL COMMENT 'Almacena la Cantidad de Cheques Emitidos en Transito',
  `MonChequeEmi` decimal(14,2) NOT NULL COMMENT 'Almacena el Monto de Cheques Emitidos en Transito',
  `CanChequeIntReA` int(11) NOT NULL COMMENT 'Almacena la Cantidad de Cheques Internos Recibidos Dia Anterior',
  `MonChequeIntReA` decimal(14,2) NOT NULL COMMENT 'Almacena el Monto de Cheques Internos Recibidos Dia Anterior ',
  `CanChequeIntRe` int(11) NOT NULL COMMENT 'Almacena la Cantidad Cheques Internos Recibidos Hoy',
  `MonChequeIntRe` decimal(14,2) NOT NULL COMMENT 'Almacena el Monto Cheques Internos Recibidos Hoy ',
  `SaldosCP` decimal(14,2) NOT NULL COMMENT 'Almacena los Saldos en Caja Principal',
  `SaldosCA` decimal(14,2) NOT NULL COMMENT 'Almacena los Saldos en Cajas de Atención ',
  `MontoSolicitado` decimal(14,2) NOT NULL COMMENT 'Almacena el monto Solicitado para pasar a las Cajas de Atención',
  `Comentarios` varchar(300) NOT NULL COMMENT 'Almacena los comentarios de la solicitud',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Nombre de Usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual del Sistema',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa',
  `Sucursal` int(11) NOT NULL COMMENT 'Nombre de la Sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`SolSaldoSucursalID`),
  KEY `UsuarioID` (`UsuarioID`),
  KEY `SucursalID` (`SucursalID`),
  CONSTRAINT `SOLSALDOSUCURSAL_ibfk_1` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`),
  CONSTRAINT `SOLSALDOSUCURSAL_ibfk_2` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que se usa para el registro de Solicitud de Saldos por Sucursal en el modulo de Ventanilla'$$