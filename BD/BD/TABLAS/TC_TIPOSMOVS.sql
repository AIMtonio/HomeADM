-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_TIPOSMOVS
DELIMITER ;
DROP TABLE IF EXISTS TC_TIPOSMOVS;

DELIMITER $$
CREATE TABLE TC_TIPOSMOVS (
	TipoMovID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
	Descripcion			VARCHAR(100)	NOT NULL COMMENT 'Descripción del Tipo de Movimiento',
	PrealacionPago		INT(11)			NOT NULL COMMENT 'Orden o Prelación de Pago',
	EmpresaID			INT(11)			NOT NULL COMMENT 'ID de la Empresa',
	Usuario				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual			DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP			VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID			VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal			INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion		BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (TipoMovID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Movimientos de Tarjetas de Crédito.'$$