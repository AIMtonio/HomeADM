-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_CODIGOAUTORIZACION
DELIMITER ;
DROP TABLE IF EXISTS `TC_CODIGOAUTORIZACION`;

DELIMITER $$
CREATE TABLE `TC_CODIGOAUTORIZACION` (
	RegistroID			INT(11) 	NOT NULL COMMENT 'ID de Tabla',
	TransaccionID		BIGINT(20) 	NOT NULL COMMENT 'Numero de Autorizacion',
	EmpresaID			INT(11)		NOT NULL COMMENT 'ID de la empresa',
	Usuario				INT(11)		NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual			DATETIME	NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP			VARCHAR(15)	NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID			VARCHAR(50)	NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal			INT(11)		NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion		BIGINT(20)	NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TB: Tabla Consecutiva para el Control de Números de Autorización.'$$