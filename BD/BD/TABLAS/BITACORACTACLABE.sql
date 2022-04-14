DELIMITER ;
DROP TABLE IF EXISTS BITACORACTACLABE;

DELIMITER $$
CREATE TABLE `BITACORACTACLABE`(
  `BitacoraID` 			int(11)   		NOT NULL COMMENT 'ID de la Bitacora ',
  `Transaccion` 		bigint(20) 		NOT NULL COMMENT 'Numero de Transaccion',
  `Fecha` 				datetime	 	NOT NULL COMMENT 'Fecha en que se crea la cuenta CLABE',
  `CuentaCLABE` 		varchar(18)  	NOT NULL COMMENT 'Cuenta CLABE generada',
  `EmpresaID` 			int(11) 		NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` 			int(11) 		NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` 		datetime 		NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` 		varchar(15) 	NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` 			varchar(50) 	NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` 			int(11) 		NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` 		bigint(20) 		NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`BitacoraID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar los registros de la generacion de cuentas CLABE. '$$