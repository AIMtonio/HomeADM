-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINATARIOSFTPPROSA
DELIMITER ;
DROP TABLE IF EXISTS `DESTINATARIOSFTPPROSA`;

DELIMITER $$
CREATE TABLE `DESTINATARIOSFTPPROSA` (
	Usuario						INT(11)			NOT NULL COMMENT 'Usuario id destinatario',
	EmpresaID					INT(11)			NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
	UsuarioID					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (`Usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla que almacena el usuario destinatario del correo electronico para el fallo de lectura ftp'$$
