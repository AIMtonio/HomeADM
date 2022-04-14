DELIMITER ;
DROP TABLE IF EXISTS `HIS-EDOCTAV2DETACTA`;
DELIMITER $$


CREATE TABLE `HIS-EDOCTAV2DETACTA` (
	AnioMes 				INT(11) 		NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	SucursalID	 			INT(11) 		NOT NULL COMMENT 'Numero de surcusal del cliente',
	CuentaAhoID				BIGINT(12)		NOT NULL COMMENT 'Identificador de la cuenta',
	FechaMovimiento			DATE			NOT NULL COMMENT 'Fecha en la que se realizo el movimiento',
	Referencia				VARCHAR(50)		NOT NULL COMMENT 'Origen del movimiento',
	Concepto				VARCHAR(150)	NOT NULL COMMENT 'Concepto del movimiento',
	Cargo					DECIMAL(14,2)	NOT NULL COMMENT 'Cargo de la cuenta',
	Abono					DECIMAL(14,2)	NOT NULL COMMENT 'Abono de la cuenta',
	Orden					INT(11)			NOT NULL COMMENT 'Orden en el que se mostrara el detalle, el saldo inicial es 0',
	FolioProceso			BIGINT(12)		NOT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
	EmpresaID 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP 			VARCHAR(15) 	NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID 				VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de Auditoria',
PRIMARY KEY(AnioMes,ClienteID,SucursalID,CuentaAhoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='historico detalle de cuenta'$$
