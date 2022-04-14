DELIMITER ;
DROP TABLE IF EXISTS `PRESTAMODOCGRDVALORES`;

DELIMITER $$
CREATE TABLE `PRESTAMODOCGRDVALORES` (
	PrestamoDocGrdValoresID		BIGINT(20)		NOT NULL COMMENT 'ID de Tabla',
	CatMovimientoID				INT(11)			NOT NULL COMMENT 'ID de Tabla CATMOVDOCGRDVALORES',
	DocumentoID					BIGINT(20)		NOT NULL COMMENT 'ID de Tabla DOCUMENTOSGRDVALORES',
	HoraRegistro				TIME			NOT NULL COMMENT 'Hora de Registro del Préstamo',
	FechaRegistro				DATE			NOT NULL COMMENT 'Fecha de Registro del Préstamo',

	UsuarioRegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que Registra el Documento a Préstamo',
	UsuarioPrestamoID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que Solicita el Documento a Préstamo',
	UsuarioAutorizaID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que Autoriza el Documento a Custodia',
	UsuarioDevolucionID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que Devuelve el Documento a Custodia',
	FechaDevolucion				DATE			NOT NULL COMMENT 'Fecha de Devolución del Préstamo',
	HoraDevolucion				TIME			NOT NULL COMMENT 'Hora de Devolución',

	Observaciones				VARCHAR(500)	NOT NULL COMMENT 'Comentarios del Préstamo',
	SucursalID					INT(11)			NOT NULL COMMENT 'ID de Tabla SUCURSALES \nSucursal Origen del Préstamo',
	Estatus						CHAR(1)			NOT NULL COMMENT 'Estatus Prestamo \nV.- Vigente \nF.- Finalizado',

	EmpresaID					INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`PrestamoDocGrdValoresID`),
	KEY `IDX_PRESTAMODOCGRDVALORES_1` (`CatMovimientoID`),
	KEY `IDX_PRESTAMODOCGRDVALORES_2` (`DocumentoID`),
	KEY `IDX_PRESTAMODOCGRDVALORES_3` (`FechaRegistro`),
	KEY `IDX_PRESTAMODOCGRDVALORES_4` (`UsuarioRegistroID`),
	KEY `IDX_PRESTAMODOCGRDVALORES_5` (`UsuarioPrestamoID`),
	KEY `IDX_PRESTAMODOCGRDVALORES_6` (`UsuarioAutorizaID`),
	KEY `IDX_PRESTAMODOCGRDVALORES_7` (`UsuarioDevolucionID`),
	KEY `IDX_PRESTAMODOCGRDVALORES_8` (`FechaDevolucion`),
	KEY `IDX_PRESTAMODOCGRDVALORES_9` (`SucursalID`),
	KEY `IDX_PRESTAMODOCGRDVALORES_10` (`NumTransaccion`),
	CONSTRAINT `FK_PRESTAMODOCGRDVALORES_1` FOREIGN KEY (`CatMovimientoID`) REFERENCES `CATMOVDOCGRDVALORES` (`CatMovimientoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_PRESTAMODOCGRDVALORES_2` FOREIGN KEY (`DocumentoID`) REFERENCES `DOCUMENTOSGRDVALORES` (`DocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_PRESTAMODOCGRDVALORES_3` FOREIGN KEY (`UsuarioRegistroID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_PRESTAMODOCGRDVALORES_4` FOREIGN KEY (`UsuarioPrestamoID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_PRESTAMODOCGRDVALORES_5` FOREIGN KEY (`UsuarioAutorizaID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `FK_PRESTAMODOCGRDVALORES_6` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Préstamo de Documentos para Guarda de Valores.'$$