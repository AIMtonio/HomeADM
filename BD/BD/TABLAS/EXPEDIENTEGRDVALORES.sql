-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXPEDIENTEGRDVALORES
DELIMITER ;
DROP TABLE IF EXISTS `EXPEDIENTEGRDVALORES`;

DELIMITER $$
CREATE TABLE `EXPEDIENTEGRDVALORES` (
	NumeroExpedienteID			BIGINT(20)		NOT NULL COMMENT 'ID de Tabla',
	TipoInstrumento				INT(11)			NOT NULL COMMENT 'ID de Tabla CATINSTGRDVALORES',
	NumeroInstrumento			BIGINT(20)		NOT NULL COMMENT 'ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, SolicitudCreditoID, CreditoID, ProspectoID, AportacionID',
	SucursalID					INT(11)			NOT NULL COMMENT 'ID de Tabla SUCURSALES \nSucursal de Alta',
	FechaRegistro				DATE			NOT NULL COMMENT 'Fecha de Registro del Expediente',

	HoraRegistro				TIME			NOT NULL COMMENT 'Hora de Registro del Expediente',
	ParticipanteID				INT(11)			NOT NULL COMMENT 'Numero de Participante(ClienteID, ProspectoID)',
	TipoPersona					CHAR(1)			NOT NULL COMMENT 'Tipo Persona \nC = Cliente, \nP=Prospecto',
	UsuarioRegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que Registra el Expediente',
	Estatus						CHAR(1)			NOT NULL COMMENT 'Estatus \nA.- Activo \nI.- Inactivo',

	EmpresaID					INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Direccion IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`NumeroExpedienteID`),
	KEY `IDX_EXPEDIENTEGRDVALORES_1` (`TipoInstrumento`),
	KEY `IDX_EXPEDIENTEGRDVALORES_2` (`SucursalID`),
	KEY `IDX_EXPEDIENTEGRDVALORES_3` (`FechaRegistro`),
	KEY `IDX_EXPEDIENTEGRDVALORES_4` (`NumeroInstrumento`,`TipoInstrumento`,`ParticipanteID`),
	KEY `IDX_EXPEDIENTEGRDVALORES_5` (`NumeroInstrumento`,`TipoInstrumento`,`ParticipanteID`,`TipoPersona`),
	KEY `IDX_EXPEDIENTEGRDVALORES_6` (`SucursalID`,`ParticipanteID`),
	KEY `IDX_EXPEDIENTEGRDVALORES_7` (`NumTransaccion`),
	CONSTRAINT `FK_EXPEDIENTEGRDVALORES_1` FOREIGN KEY (`TipoInstrumento`) REFERENCES `CATINSTGRDVALORES` (`CatInsGrdValoresID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_EXPEDIENTEGRDVALORES_2` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_EXPEDIENTEGRDVALORES_3` FOREIGN KEY (`UsuarioRegistroID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Expediente de Documentos para la Guarda de Valores.'$$