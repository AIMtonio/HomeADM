-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTRANSFERCUEFOGAFI
DELIMITER ;
DROP TABLE IF EXISTS TMPTRANSFERCUEFOGAFI;

DELIMITER $$
CREATE TABLE TMPTRANSFERCUEFOGAFI (
	RegistroID				INT(11)			NOT NULL COMMENT 'ID del Tabla',
	CreditoID				BIGINT(12)		NOT NULL COMMENT 'ID del Tabla CREDITOS',
	CuentaAhoID				BIGINT(12)		NOT NULL COMMENT 'ID del Tabla CUENTASAHO',
	SaldoExigible			DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Exigible del Credito',
	SaldoExigibleFogafi		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Exigible Fogafi del Credito',
	SaldoDisponible			DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Disponible de la Cuenta de Ahorro',
	PorcentajePago			DECIMAL(14,8)	NOT NULL COMMENT 'Porcentaje de Prorreteo',
	MontoPago				DECIMAL(14,2)	NOT NULL COMMENT 'Monto de Pago de Credito',
	MontoTransferencia		DECIMAL(14,2)	NOT NULL COMMENT 'Monto de Transferencia',
	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la Empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del Usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha Actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (RegistroID,NumTransaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Guarda el Monto de Transferencia para el pago de FOGAFI.'$$