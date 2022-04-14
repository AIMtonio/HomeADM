DELIMITER ;
DROP TABLE IF EXISTS BITACORATARJETA;

DELIMITER $$
CREATE TABLE `BITACORATARJETA`(
  `BitacoraID` 			INT(11)       NOT NULL COMMENT 'ID de la Bitacora ',
  `Transaccion` 		BIGINT(20)    NOT NULL COMMENT 'Numero de Transaccion',
  `Fecha` 				  DATETIME      NOT NULL COMMENT 'Fecha en que se crea la TARJETA',
  `NumTarjeta`      VARCHAR(16)  	NOT NULL COMMENT 'Numero Tarjeta Generada',
  `EmpresaID` 			INT(11)       NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario`         INT(11) 		  NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` 		DATETIME 		  NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` 		VARCHAR(15) 	NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` 			VARCHAR(50) 	NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` 			  INT(11) 		  NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion`  BIGINT(20) 		NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`BitacoraID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar los registros de la generacion de TARJETAS. '$$