-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCUMENTOSGRDVALORES
DELIMITER ;
DROP TABLE IF EXISTS `DOCUMENTOSGRDVALORES`;

DELIMITER $$
CREATE TABLE `DOCUMENTOSGRDVALORES` (
	DocumentoID					BIGINT(20)		NOT NULL COMMENT 'ID de Tabla',
	NumeroExpedienteID			BIGINT(20)		NOT NULL COMMENT 'ID de Tabla EXPEDIENTEGRDVALORES',
	TipoInstrumento				INT(11)			NOT NULL COMMENT 'ID de Tabla CATINSTGRDVALORES',
	NumeroInstrumento			BIGINT(20)		NOT NULL COMMENT 'ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, SolicitudCreditoID, CreditoID, ProspectoID, AportacionID',
	OrigenDocumento				INT(11)			NOT NULL COMMENT 'ID de Tabla CATORIGENESDOCUMENTOS',

	GrupoDocumentoID			INT(11)			NOT NULL COMMENT 'ID de Tabla GRUPODOCUMENTOS \nGrupo de Documento ',
	TipoDocumentoID				INT(11)			NOT NULL COMMENT 'ID de Tabla TIPOSDOCUMENTOS \nTipo de Documento ',
	NombreDocumento				VARCHAR(100)	NOT NULL COMMENT 'Nombre de Documento cuando el Origen de Documento sea No Aplica, de lo Contrario es Vacío',
	ParticipanteID				INT(11)			NOT NULL COMMENT 'Número de Participante(ClienteID, ProspectoID)',
	TipoPersona					CHAR(1)			NOT NULL COMMENT 'Tipo Persona \nC = Cliente, \nP=Prospecto',

	AlmacenID					INT(11)			NOT NULL COMMENT 'ID de Tabla ALMACENES \nNace Vacío',
	Ubicacion					VARCHAR(500)	NOT NULL COMMENT 'Ubicación del Documento',
	Seccion						VARCHAR(500)	NOT NULL COMMENT 'Sección/Anaquel/Cajón de Ubicación del Documento',
	Observaciones				VARCHAR(500)	NOT NULL COMMENT 'Comentarios del Documento',
	Estatus						CHAR(1)			NOT NULL COMMENT 'Estatus \nR = Registrado \nC= Custodia \nP=  Préstamo \nB= Baja.',

	UsuarioRegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que Registra el Documento',
	UsuarioProcesaID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que Procesa el Documento en Custodia',
	SucursalID					INT(11)			NOT NULL COMMENT 'ID de Tabla SUCURSALES \nSucursal Origen del Documento',
	FechaRegistro				DATE			NOT NULL COMMENT 'Fecha de Registro del Documento',
	HoraRegistro				TIME			NOT NULL COMMENT 'Hora de Registro del Documento',

	FechaCustodia				DATE			NOT NULL COMMENT 'Fecha de Pase a Custodia',
	UsuarioBajaID				INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que realiza la Baja del Documento',
	SucursalBajaID				INT(11)			NOT NULL COMMENT 'ID de Tabla SUCURSALES \nSucursal donde se realiza la Baja del Documento',
	FechaBaja					DATE			NOT NULL COMMENT 'Fecha de Baja del Documento',
	PrestamoDocGrdValoresID 	BIGINT(20)		NOT NULL COMMENT 'ID de Tabla PRESTAMODOCGRDVALORES, Nace Vacío',

	DocSustitucionID			INT(11)			NOT NULL COMMENT 'ID de Tabla TIPOSDOCUMENTOS \nTipo de Documento de sustitución ',
	NombreDocSustitucion		VARCHAR(100)	NOT NULL COMMENT 'Nombre de Documento de sustitución, Nace Vacío',
	ArchivoID					 BIGINT(20) 	NOT NULL COMMENT 'Número de Archivo Digital en SAFI (Disponible solo para archivos de digitalización',

	EmpresaID					INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`DocumentoID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_1` (`NumeroExpedienteID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_2` (`TipoInstrumento`,`NumeroInstrumento`),
	KEY `IDX_DOCUMENTOSGRDVALORES_3` (`GrupoDocumentoID`,`TipoDocumentoID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_4` (`OrigenDocumento`),
	KEY `IDX_DOCUMENTOSGRDVALORES_5` (`TipoInstrumento`,`NumeroInstrumento`,`ParticipanteID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_6` (`AlmacenID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_7` (`Estatus`),
	KEY `IDX_DOCUMENTOSGRDVALORES_8` (`UsuarioRegistroID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_9` (`UsuarioProcesaID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_10` (`SucursalID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_11` (`UsuarioBajaID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_12` (`SucursalBajaID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_13` (`SucursalID`,`NumeroInstrumento`,`ParticipanteID`),
	KEY `IDX_DOCUMENTOSGRDVALORES_14` (`NumTransaccion`),
	CONSTRAINT `FK_DOCUMENTOSGRDVALORES_1` FOREIGN KEY (`NumeroExpedienteID`) REFERENCES `EXPEDIENTEGRDVALORES` (`NumeroExpedienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_DOCUMENTOSGRDVALORES_2` FOREIGN KEY (`TipoInstrumento`) REFERENCES `CATINSTGRDVALORES` (`CatInsGrdValoresID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_DOCUMENTOSGRDVALORES_3` FOREIGN KEY (`UsuarioRegistroID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_DOCUMENTOSGRDVALORES_4` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_DOCUMENTOSGRDVALORES_5` FOREIGN KEY (`OrigenDocumento`) REFERENCES `CATORIGENESDOCUMENTOS` (`CatOrigenDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Documentos para la Guarda de Valores.'$$