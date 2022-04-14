-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMTARJETAS
DELIMITER ;
DROP TABLE IF EXISTS `PARAMTARJETAS`;

DELIMITER $$
CREATE TABLE `PARAMTARJETAS` (
	LlaveParametro			VARCHAR(50)		NOT NULL COMMENT 'Llave de Tabla',
	ValorParametro			VARCHAR(200)	NOT NULL COMMENT 'Valor del Parámentro',
	DescripcionParametro	VARCHAR(200)	NOT NULL COMMENT 'Descripción del parámetro y sus posibles valores',

	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la Empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`LlaveParametro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de parámetros para las Tarjetas de Crédito o Debito.'$$