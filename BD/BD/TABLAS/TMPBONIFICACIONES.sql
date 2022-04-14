-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBONIFICACIONES
DELIMITER ;
DROP TABLE IF EXISTS `TMPBONIFICACIONES`;

DELIMITER $$
CREATE TABLE `TMPBONIFICACIONES`(
	RegistroID 			INT(11)			NOT NULL COMMENT 'ID de la Tabla',
	BonificacionID		BIGINT(20) 		NOT NULL COMMENT 'ID de la Tabla TMPBONIFICACIONES',
	ClienteID			INT(11) 		NOT NULL COMMENT 'Número del Cliente',
	CuentaAhoID 		BIGINT(12) 		NOT NULL COMMENT 'Número de la Cuenta de Ahorro',
	TipoDispersion 		CHAR(1)			NOT NULL COMMENT 'Tipo de Dispersión \n"S" = SPEI \n"C"= Cheque \n"O"= Orden Pago',
	CuentaClabe 		VARCHAR(18)		NOT NULL COMMENT 'Cuenta Clave (El campo requerido si la Dispersión es SPEI)',
	Monto				DECIMAL(14,2) 	NOT NULL COMMENT 'Monto de la Bonificación',
	EmpresaID			INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual			DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP			VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID			VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal			INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion		BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`RegistroID`,`NumTransaccion`),
	KEY `IDX_TMPBONIFICACIONES_1` (`BonificacionID`),
	KEY `IDX_TMPBONIFICACIONES_2` (`ClienteID`),
	KEY `IDX_TMPBONIFICACIONES_3` (`CuentaAhoID`),
	KEY `IDX_TMPBONIFICACIONES_4` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla de Apoyo para la Dispersión de Bonificaciones por Cliente'$$