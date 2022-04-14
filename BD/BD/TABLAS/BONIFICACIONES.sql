-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BONIFICACIONES
DELIMITER ;
DROP TABLE IF EXISTS `BONIFICACIONES`;

DELIMITER $$
CREATE TABLE `BONIFICACIONES`(
	BonificacionID		BIGINT(20) 		NOT NULL COMMENT 'ID de la Tabla BONIFICACIONES',
	ClienteID			INT(11) 		NOT NULL COMMENT 'Número del Cliente',
	CuentaAhoID 		BIGINT(12) 		NOT NULL COMMENT 'Número de la Cuenta de Ahorro',
	FechaInicio			DATE 			NOT NULL COMMENT 'Fecha Registro de Bonificación',
	FechaVencimiento	DATE 			NOT NULL COMMENT 'Fecha Vencimiento de Bonificación',
	Monto				DECIMAL(14,2) 	NOT NULL COMMENT 'Monto de la Bonificación',
	Meses 				INT(11) 		NOT NULL COMMENT 'Número de Meses de Bonificación',
	TipoDispersion 		CHAR(1)			NOT NULL COMMENT 'Tipo de Dispersión \n"S" = SPEI \n"C"= Cheque \n"O"= Orden Pago',
	CuentaClabe 		VARCHAR(18)		NOT NULL COMMENT 'Cuenta Clave (El campo requerido si la Dispersión es SPEI)',
	FechaDispersion 	DATE 			NOT NULL COMMENT 'Fecha de dispersion',
	FolioDispersion 	INT(11)			NOT NULL COMMENT 'Folio de Dispersión de la Bonificación',
	Estatus 			CHAR(1)			NOT NULL COMMENT 'Estatus de la Amortización \nI = Inactiva/Pendiente \nV = Vigente/Activa/Dispersada \nP = Pagada',
	UsuarioRegistro 	INT(11)			NOT NULL COMMENT 'ID del Usuario de Consumo del WS',
	EmpresaID			INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario				INT(11)			NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual			DATETIME		NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP			VARCHAR(15)		NOT NULL COMMENT 'Parametro de auditoria Dirección IP',
	ProgramaID			VARCHAR(50)		NOT NULL COMMENT 'Parametro de auditoria Programa',
	Sucursal			INT(11)			NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion		BIGINT(20)		NOT NULL COMMENT 'Parametro de auditoria Número de la transacción',
	PRIMARY KEY (`BonificacionID`),
	KEY `IDX_BONIFICACIONES_1` (`ClienteID`),
	KEY `IDX_BONIFICACIONES_2` (`CuentaAhoID`),
	KEY `IDX_BONIFICACIONES_3` (`FechaInicio`),
	KEY `IDX_BONIFICACIONES_4` (`FechaVencimiento`),
	KEY `IDX_BONIFICACIONES_5` (`UsuarioRegistro`),
	CONSTRAINT `FK_BONIFICACIONES_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
	CONSTRAINT `FK_BONIFICACIONES_2` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`),
	CONSTRAINT `FK_BONIFICACIONES_3` FOREIGN KEY (`UsuarioRegistro`) REFERENCES `USUARIOS` (`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TB: Tabla de Bonificaciones al Cliente'$$