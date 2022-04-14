-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPCTAPENDIENTES
DELIMITER ;
DROP TABLE IF EXISTS `DISPCTAPENDIENTES`;
DELIMITER $$

CREATE TABLE `DISPCTAPENDIENTES` (
  `DispCuentasPenID`	INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Consecutivo de la tabla',
  `TipoOperacion`		VARCHAR(50)  COMMENT 'Tip de Operacion',
  `TipoCuenta`			VARCHAR(100) COMMENT 'Tip de Cuenta',
  `NumeroCta`  			VARCHAR(40)  DEFAULT NULL COMMENT 'Numero de cuenta',
  `DescripcionCta` 		VARCHAR(200) DEFAULT NULL COMMENT 'Descripcion de la cta',
  `Estatus`		 		VARCHAR(100) DEFAULT NULL COMMENT 'Estatus de la cuenta',
  `Banco` 				VARCHAR(100) DEFAULT NULL COMMENT 'Banco',
  `FechaRegistro` 		DATE DEFAULT '1900-01-01' COMMENT 'Fecha de registro',
  `RefRegistro`		 	VARCHAR(300) DEFAULT NULL COMMENT 'Referencia de autorizacion',
  `FechaAutoriza` 		DATE  DEFAULT '1900-01-01' COMMENT 'Fecha de autorizacion',
  `RefAutorizacion` 	VARCHAR(300) DEFAULT NULL COMMENT 'Referencia de autorizacion',
  `UsuarioRegistro` 	VARCHAR(100) DEFAULT NULL COMMENT 'usuario que registro',
  `UsuarioAutorizo` 	VARCHAR(100) DEFAULT NULL COMMENT 'Usuario que autorizo',
  `ClaveABASWIFT` 		VARCHAR(50) DEFAULT NULL COMMENT 'Usuario que autorizo',
  `Pais` 				VARCHAR(50) DEFAULT NULL COMMENT 'Pais',
  `Divisa` 				VARCHAR(20) DEFAULT NULL COMMENT 'Divisa',
  `Ciudad` 				VARCHAR(50) DEFAULT NULL COMMENT 'Ciudad',
  `FechaProceso` 		VARCHAR(20) DEFAULT NULL COMMENT 'Fecha en que se cargo el archivo',
  `NombreArchivo` 		VARCHAR(100) DEFAULT NULL COMMENT 'Nombre del archivo',
  `EmpresaID` 			INT(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` 			INT(11) DEFAULT NULL,
  `FechaActual` 		DATETIME DEFAULT NULL,
  `DireccionIP` 		VARCHAR(15) DEFAULT NULL,
  `ProgramaID` 			VARCHAR(50) DEFAULT NULL,
  `Sucursal` 			INT(11) DEFAULT NULL,
  `NumTransaccion` 		BIGINT(20) DEFAULT NULL,
  primary key (DispCuentasPenID),
  INDEX (`TipoOperacion`, `TipoCuenta`, `NumeroCta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla que contiene las cuentas Pendientes'$$

