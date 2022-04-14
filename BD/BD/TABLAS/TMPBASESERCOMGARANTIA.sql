-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBASESERCOMGARANTIA
DELIMITER ;
DROP TABLE IF EXISTS TMPBASESERCOMGARANTIA;

DELIMITER $$
CREATE TABLE TMPBASESERCOMGARANTIA (
	RegistroID			INT(11) NOT NULL COMMENT 'ID de Tabla',
	TransaccionID		BIGINT(20) NOT NULL COMMENT 'Número de la Transacción',
	FechaInicio			DATE NOT NULL COMMENT 'Fecha de Inicio',
	FechaFin			DATE NOT NULL COMMENT 'Fecha de Fin',
	Dias				INT(11) NOT NULL COMMENT 'Numero de Días',

	Capital				DECIMAL(14,2) NOT NULL COMMENT 'Monto de Capitla',
	BaseCalculo			DECIMAL(14,2) NOT NULL COMMENT 'Base de Calculo',
	PorcentajeComision	DECIMAL(12,2) NOT NULL COMMENT 'Procentaje de la Comision',
	ComisionPago		DECIMAL(14,2) NOT NULL COMMENT 'Pago de Comision',
	AmortizacionID		INT(11) NOT NULL COMMENT 'Numero de Amortizacion',

	EmpresaID			INT(11) NOT NULL COMMENT 'ID de la empresa',
	Usuario				INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual			DATETIME NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP			VARCHAR(15) NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID			VARCHAR(50) NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal			INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion		BIGINT(20) NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (RegistroID,TransaccionID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla de Temporal para calcular el cobro comisión por servicio de Garantías en líneas de crédito.'$$