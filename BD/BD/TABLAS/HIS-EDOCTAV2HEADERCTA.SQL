DELIMITER ;
DROP TABLE IF EXISTS `HIS-EDOCTAV2HEADERCTA`;
DELIMITER $$


CREATE TABLE `HIS-EDOCTAV2HEADERCTA` (
	AnioMes 				INT(11) 		NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	SucursalID	 			INT(11) 		NOT NULL COMMENT 'Numero de surcusal del cliente',
	CuentaAhoID				BIGINT(12)		NOT NULL COMMENT 'Identificador de la cuenta',
	ProductoDesc			VARCHAR(60)		NOT NULL COMMENT 'Descripcion del producto',
	Clabe					VARCHAR(18)		NOT NULL COMMENT 'Clabe',
	SaldoMinimo				DECIMAL(14,2)	NOT NULL COMMENT 'SaldoMinimo',
	ISRRetenido				DECIMAL(14,2)	NOT NULL COMMENT 'ISR retenido',
	GatNominal				DECIMAL(5,2)	NOT NULL COMMENT 'Gat nominal',
	GatReal					DECIMAL(5,2)	NOT NULL COMMENT 'Gat real',
	TasaBruta				DECIMAL(5,2)	NOT NULL COMMENT 'Tasa Bruta',
	InteresPerido			DECIMAL(14,2)	NOT NULL COMMENT 'Intereses generados en el periodo',
	MontoComision			DECIMAL(14,2)	NOT NULL COMMENT 'Total de comisiones cargadas a la cuenta',
	IvaComision				DECIMAL(14,2)	NOT NULL COMMENT 'IVA de la comision',
	MonedaID				INT(11)			NOT NULL COMMENT 'Identificador de la moneda',
	MonedaDescri			VARCHAR(45)		NOT NULL COMMENT 'Descripcion de la moneda',
	DepositosMes			DECIMAL(14,2)	NOT NULL COMMENT 'Depositos del mes',
	RetirosMes				DECIMAL(14,2)	NOT NULL COMMENT 'Retiros del mes',
	Estatus					VARCHAR(25)		NOT NULL COMMENT 'Estatus',
	FolioProceso			BIGINT(12)		NOT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
	EmpresaID 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP 			VARCHAR(15) 	NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID 				VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de Auditoria',
PRIMARY KEY(AnioMes, ClienteID, SucursalID, CuentaAhoID, FolioProceso)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='historico cabecera de cuenta'$$
