
DELIMITER ;

DROP TABLE IF EXISTS CREDRECCARTCASTMAS;
delimiter $$
CREATE TABLE `CREDRECCARTCASTMAS` (
  `TransaccionID` int(11) NOT NULL COMMENT 'Numero de Transaccion de la Carga del Archivo Excel',
  `FechaCarga` date NOT NULL COMMENT 'Fecha del sistema en la que se hace la carga',
  `Hora` time NOT NULL COMMENT 'Hora de la carga',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `CuentaAhoID` bigint(12) NOT NULL,
  `MontoRecuperar` decimal(14,2) NOT NULL COMMENT 'Monto a Recuperar',
  `TotalRecuperado` decimal(14,2) DEFAULT NULL COMMENT 'Total Recuperado',
  `Estatus` char(1) DEFAULT 'I' COMMENT 'I:Pendiente\nP:Procesado\nF:Fallo el Proceso\n',
  `NumErr` int(11) DEFAULT '0' COMMENT 'Numero de Error',
  `ErrMen` varchar(400) DEFAULT NULL COMMENT 'Mensaje de Error en caso de exista.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TransaccionID`,`FechaCarga`,`CreditoID`,`Hora`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que guarda los creditos cargados en el proceso masivo de recuperación de cartera'$$
