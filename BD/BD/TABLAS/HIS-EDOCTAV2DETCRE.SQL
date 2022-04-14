DELIMITER ;
DROP TABLE IF EXISTS `HIS-EDOCTAV2DETCRE`;
DELIMITER $$


CREATE TABLE `HIS-EDOCTAV2DETCRE` (
	AnioMes 				INT(11) 		NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	SucursalID	 			INT(11) 		NOT NULL COMMENT 'Numero de surcusal del cliente',
	CreditoID				BIGINT(12)		NOT NULL COMMENT 'Identificacion de credito',
	FechaOperacion			DATE			NOT NULL COMMENT 'Fecha en la que se realizo la operacion',
	Referencia				VARCHAR(50)		NOT NULL COMMENT 'Referencia de la operacion',
	Concepto				VARCHAR(150)	NOT NULL COMMENT 'Concepto de la opercacion realizada',
	Cargos					DECIMAL(14,2)	NOT NULL COMMENT 'Cargo de la cuenta',
	Abonos					DECIMAL(14,2)	NOT NULL COMMENT 'Abono de la cuenta',
	Orden					INT(11)			NOT NULL COMMENT 'Orden el el que se mostrara el detalle de creditos',
	FolioProceso			BIGINT(12)		NOT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
	EmpresaID 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP 			VARCHAR(15) 	NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID 				VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de Auditoria',
PRIMARY KEY(AnioMes,ClienteID,SucursalID,CreditoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='historico detalle de creditos'$$
