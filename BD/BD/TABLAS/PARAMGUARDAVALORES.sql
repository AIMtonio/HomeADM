-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMGUARDAVALORES
DELIMITER ;
DROP TABLE IF EXISTS `PARAMGUARDAVALORES`;

DELIMITER $$
CREATE TABLE `PARAMGUARDAVALORES` (
	ParamGuardaValoresID		INT(11)			NOT NULL COMMENT 'ID de Tabla',
	UsuarioAdmon				INT(11)			NOT NULL COMMENT 'Usuario que puede Cambiar el Estatus de los Documentos en Custodia',
	CorreoRemitente				VARCHAR(50)		NOT NULL COMMENT 'Correo Remitente de Notificación',
	ServidorCorreo				VARCHAR(30)		NOT NULL COMMENT 'Servidor de Correo de Notificación',

	Puerto						VARCHAR(10)		NOT NULL COMMENT 'Puerto de Envio de Notificación',
	Contrasenia					VARCHAR(50)		NOT NULL COMMENT 'Contraseña del Correo de Notificación',
	UsuarioServidor 			VARCHAR(50)		NOT NULL COMMENT 'Usuario del Servidor de Correos',
	NombreEmpresa				VARCHAR(100)	NOT NULL COMMENT 'Nombre de Empresa',

	EmpresaID					INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`ParamGuardaValoresID`),
	KEY `IDX_PARAMGUARDAVALORES_1` (`UsuarioAdmon`),
	CONSTRAINT `FK_PARAMGUARDAVALORES_1` FOREIGN KEY (`UsuarioAdmon`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de parámetros para la Guarda de Valores.'$$