-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA2111SALDOS
DELIMITER ;
DROP TABLE IF EXISTS REGA2111SALDOS;

DELIMITER $$
CREATE TABLE REGA2111SALDOS (
	Anio			INT(11)			NOT NULL COMMENT 'Año a  Reportar',
	Mes				INT(11)			NOT NULL COMMENT 'Mes a Reportar',
	CuentaFija		VARCHAR(30)		NOT NULL COMMENT 'Cuenta Contable (Tabla CUENTASCONTABLES)',
	Saldo			DECIMAL(16,2)	NOT NULL COMMENT 'Saldo de la Cuenta',

	EmpresaID		INT(11)			NOT NULL COMMENT 'ID de la Empresa',
	Usuario			INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual		DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP		VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID		VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal		INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion	BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (Anio, Mes, CuentaFija)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos Manuales de la por cliente del Reporte Regulatorio R21 A2111'$$