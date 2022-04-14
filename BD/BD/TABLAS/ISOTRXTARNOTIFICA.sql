-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXTARNOTIFICA
DELIMITER ;
DROP TABLE IF EXISTS `ISOTRXTARNOTIFICA`;

DELIMITER $$
CREATE TABLE `ISOTRXTARNOTIFICA` (
	FechaOperacion			DATE			NOT NULL COMMENT 'Fecha en que se realizo la Operacion.',
	RegistroID				BIGINT(20)		NOT NULL COMMENT 'ID de Registro',
	HoraOperacion			TIME			NOT NULL COMMENT 'Hora en que se realizo la Operacion.',
	TipoTarjeta				INT(11)			NOT NULL COMMENT 'Tipo de Tarjeta \n1.- Tarjeta Debito \n2.- Tarjeta Crédito',
	TarjetaID				CHAR(16)		NOT NULL COMMENT 'Numero de Tarjeta',

	CuentaAhoID				BIGINT(12)		NOT NULL COMMENT 'Numero de Cuenta de Ahorro asociada a la Tarjeta',
	OperacionPeticionID		INT(11)			NOT NULL COMMENT 'ID de la Tabla RELOPERAPETICIONISOTRX',
	Transaccion 			BIGINT(20)		NOT NULL COMMENT 'Numero de la transaccion',
	MontoOperacion			DECIMAL(14,2)	NOT NULL COMMENT 'Monto de la Operacion',
	Estatus 				CHAR(1)			NOT NULL COMMENT 'Estatus del Registro\nP=Pendiente(Estatus Inicial) \nE= Enviado \nF.- Error o Fallo en el proceso',

	PIDTarea				VARCHAR(50)		NOT NULL COMMENT 'Identificador del hilo de ejecucion de la tarea',
	NumeroIntentos 			INT(11) 		NOT NULL COMMENT 'Número Máximo de Intentos (Parametrizable Llave: NumIntentosConWSAutoriza PARAMTARJETAS)',

	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parametro de auditoria Direccion IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parametro de auditoria Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
	PRIMARY KEY ( `FechaOperacion` ,`RegistroID`),
	KEY `IDX_ISOTRXTARNOTIFICA_2` (`TarjetaID`),
	KEY `IDX_ISOTRXTARNOTIFICA_3` (`CuentaAhoID`),
	KEY `IDX_ISOTRXTARNOTIFICA_4` (`OperacionPeticionID`),
	KEY `IDX_ISOTRXTARNOTIFICA_5` (`PIDTarea`),
	CONSTRAINT `FK_ISOTRXTARNOTIFICA_1` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`),
	CONSTRAINT `FK_ISOTRXTARNOTIFICA_2` FOREIGN KEY (`OperacionPeticionID`) REFERENCES `RELOPERAPETICIONISOTRX` (`OperacionPeticionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Notificación para la Tarea: TAREA_ISOTRX_NOTIFICASALDO.'$$