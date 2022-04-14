-- SOLICITUDTRANSFERCAJA
DELIMITER ;
DROP TABLE IF EXISTS SOLICITUDTRANSFERCAJA;
DELIMITER $$


CREATE TABLE SOLICITUDTRANSFERCAJA (
	SolicitudTransID			BIGINT(20),
	CajaOrigen					INT(11) DEFAULT NULL COMMENT 'Caja Origen para la Transferencia',
	CajaDestino					INT(11) DEFAULT NULL COMMENT 'Caja Destino de la Transferencia',
	DenominacionID				INT(11) DEFAULT NULL COMMENT 'Corresponde a la Tabla DENOMINACIONES, para definir el tipo de denominacion\\n',
	Cantidad					DECIMAL(14,2) DEFAULT NULL,
	MontoTransferencia			DECIMAL(14,2) DEFAULT NULL COMMENT 'Monto a Transferir',
	Referencia					VARCHAR(200) DEFAULT NULL COMMENT 'Referencia de los movimientos',
	Estatus						CHAR(1) DEFAULT NULL COMMENT 'A : Alta\\nR: Recibido\\nE: Rechazado',
	FechaOperacion				DATETIME DEFAULT NULL COMMENT 'Fecha de la Operacion',
	SucursalOrigen				INT(11) DEFAULT NULL COMMENT 'Sucursal Origen para la Transferencia de Efectivo',
	SucursalDestino				INT(11) DEFAULT NULL COMMENT 'Sucursal Destino para la Transferencia de Efectivo',
	MonedaID					INT(11) DEFAULT NULL COMMENT 'Corresponde a la Tabla MONEDAS',
	EmpresaID					INT(11) DEFAULT NULL,
	Usuario						INT(11) DEFAULT NULL,
	FechaActual					DATETIME DEFAULT NULL,
	DireccionIP					VARCHAR(15) DEFAULT NULL,
	ProgramaID					VARCHAR(50) DEFAULT NULL,
	Sucursal					INT(11) DEFAULT NULL,
	NumTransaccion				BIGINT(20) DEFAULT NULL
	
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab:Tabla para guardar las solicitud de transferencia de efectivo entre cajas.'$$
