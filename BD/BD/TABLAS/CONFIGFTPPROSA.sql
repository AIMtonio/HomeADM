-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONFIGFTPPROSA
DELIMITER ;
DROP TABLE IF EXISTS `CONFIGFTPPROSA`;

DELIMITER $$
CREATE TABLE `CONFIGFTPPROSA` (
	ConfigFTPProsaID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
	Servidor					VARCHAR(50)		NOT NULL COMMENT 'Direccion servidor ftp',
	Usuario						VARCHAR(50)		NOT NULL COMMENT 'Usuario de acceso al servidor ftp',
	Contrasenia					VARCHAR(50)		NOT NULL COMMENT 'Contrasenia de acceso al servidor ftp',
	Puerto						VARCHAR(50)		NOT NULL COMMENT 'Puerto del servidor ftp',
	Ruta						VARCHAR(50)		NOT NULL COMMENT 'Ruta del archivo ftp',
	HoraInicio					INT(11)			NOT NULL COMMENT 'Hora inicio de la lectura del archivo ftp',
	HoraFin						INT(11)			NOT NULL COMMENT 'Hora fin de la lectura del archivo ftp',
    IntervaloMin				INT(11)			NOT NULL COMMENT 'Intervalo de intentos por minuto',
	NumIntentos					INT(11)			NOT NULL COMMENT 'Numero de intentos de lectura del archivo ftp',
	Mensaje						VARCHAR(800)	NOT NULL COMMENT 'Mensaje resultado de las operaciones',
	UsuarioRemiten				INT(11)			NOT NULL COMMENT 'Usuario remitente que envia el correo en caso de fallo',
	EmpresaID					INT(11)			NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
	UsuarioID					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (`ConfigFTPProsaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla que almacena la configuración para la lectura de archivos ftp'$$
