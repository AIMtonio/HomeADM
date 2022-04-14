-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASBCAMOVIL
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASBCAMOVIL`;
DELIMITER $$

CREATE TABLE `CUENTASBCAMOVIL` (
  `CuentasBcaMovID` bigint(20) NOT NULL COMMENT 'Numero del registro para Banca Movil',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `Telefono` varchar(20) NOT NULL COMMENT 'Numero de telefono que se registró.',
  `UsuarioPDMID` int(11) NOT NULL COMMENT 'ID del Usuario que le asigno el proveedor externo',
  `RegistroPDM` char(1) NOT NULL COMMENT 'Campo para indicar si requiere uso del registro en pademovil o no',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del Registro: \nA) Activo \nI) Inactivo \nB) Bloqueado \n',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha en la Cual fue dado de Alta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CuentasBcaMovID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena los Registros en Banca Movil'$$