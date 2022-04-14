DELIMITER ;
DROP TABLE IF EXISTS `HIS-EDOCTAV2RESUMCAPT`;
DELIMITER $$


CREATE TABLE `HIS-EDOCTAV2RESUMCAPT` (
	AnioMes 				INT(11) 		NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	SucursalID	 			INT(11) 		NOT NULL COMMENT 'Numero de surcusal del cliente',
	InstrumentoID			BIGINT(12)		NOT NULL,
	MonedaID				INT(11)			NOT NULL COMMENT 'Identificador de la moneda',
	MonedaDescri			VARCHAR(45)		NOT NULL COMMENT 'Descripcion de la moneda',
	Etiqueta				VARCHAR	(60)	NOT NULL COMMENT '',
	SaldoPromedio			DECIMAL(14,2)	NOT NULL COMMENT 'se tomará del campo SaldoProm de la tabla HIS-CUENTASAHO del mes sobre el cual se hace la extracción.',
	SaldoAnterior			DECIMAL(14,2)	NOT NULL COMMENT 'Saldo con el que finalizo el mes anterior',
	SaldoActual				DECIMAL(14,2)	NOT NULL COMMENT 'Saldo que tiene actualmente',
	TipoInstrumento			CHAR(2)			NOT NULL COMMENT 'IN - Inversion , CH - Cuenta, CE - CEDE',
	FolioProceso			BIGINT(12)		NOT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
	EmpresaID 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP 			VARCHAR(15) 	NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID 				VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de Auditoria',
PRIMARY KEY(AnioMes, ClienteID, SucursalID, InstrumentoID, FolioProceso)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='hisorico de Datos de CAPTACION '$$
