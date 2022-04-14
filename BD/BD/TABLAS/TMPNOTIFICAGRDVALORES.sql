-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPNOTIFICAGRDVALORES
DELIMITER ;
DROP TABLE IF EXISTS `TMPNOTIFICAGRDVALORES`;

DELIMITER $$
CREATE TABLE `TMPNOTIFICAGRDVALORES` (
	NotificacionID		INT(11)			NOT NULL COMMENT 'ID de Tabla',
	CorreoDestino		VARCHAR(50)		NOT NULL COMMENT 'Correo Destino de Notificación',
	EmpresaID			INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual			DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP			VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID			VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal			INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion		BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`NotificacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla de Notificacion para los Puestos y los Usuarios Facultados para el Menu Guarda Valores.'$$