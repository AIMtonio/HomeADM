-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONDONACIONMASIVA
DELIMITER ;
DROP TABLE IF EXISTS `CONDONACIONMASIVA`;DELIMITER $$

CREATE TABLE `CONDONACIONMASIVA` (
  `TransaccionID` int(11) NOT NULL COMMENT 'Numero de Transaccion de la Carga del Archivo Excel',
  `FechaCarga` date NOT NULL COMMENT 'Fecha del sistema en la que se hace la carga',
  `Hora` time NOT NULL COMMENT 'Hora de la carga',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Crédito',
  `MontoCapital` decimal(12,2) DEFAULT NULL COMMENT 'Monto de capital a condonar',
  `MontoInteres` decimal(12,2) DEFAULT NULL COMMENT 'Monto de Interes a condonar',
  `MontoMoratorios` decimal(12,2) DEFAULT NULL COMMENT 'Monto de intereses moratorios a condonar',
  `MontoComisiones` decimal(12,2) DEFAULT NULL COMMENT 'monto de comisiones a condonar',
  `MotivoCondonacion` varchar(500) DEFAULT NULL COMMENT 'Motivo de Cancelacion',
  `Estatus` char(1) DEFAULT 'N' COMMENT 'N: No Aplicado\nA.Aplicado',
  `NumErr` int(11) DEFAULT '0' COMMENT 'Numero de Error',
  `ErrMen` varchar(400) DEFAULT NULL COMMENT 'Mensaje de Error en caso de exista.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CreditoID`,`TransaccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el proceso de Condonacion masiva'$$