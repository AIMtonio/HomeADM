-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOTIVACTIVACION
DELIMITER ;
DROP TABLE IF EXISTS `MOTIVACTIVACION`;DELIMITER $$

CREATE TABLE `MOTIVACTIVACION` (
  `MotivoActivaID` int(11) NOT NULL COMMENT 'ID de la tabla de Activacion/Inactivacion',
  `TipoMovimiento` int(11) DEFAULT NULL COMMENT 'Tipo de movimiento 1.-Activacion.2.-Inactivacion',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion del motivo de  Activación/Inactivacion',
  `PermiteReactivacion` char(1) DEFAULT NULL COMMENT 'Campo que guardará valos S o N, para saber si se puede reactivar un cliente',
  `RequiereCobro` char(1) DEFAULT NULL COMMENT 'Campo que almacenará S o N, para saber si la reactivación requiere cobro',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoría\n',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoría\n',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoría\n',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoría\n',
  `ProgramaID` varchar(10) DEFAULT NULL COMMENT 'Campo de auditoría\n',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoría\n',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoría\n',
  PRIMARY KEY (`MotivoActivaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo para almacenar los motivos de  Activación e Iniacti'$$