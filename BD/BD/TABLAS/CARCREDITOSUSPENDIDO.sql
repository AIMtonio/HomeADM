-- Creacion de tabla CARCREDITOSUSPENDIDO

DELIMITER ;

DROP TABLE IF EXISTS CARCREDITOSUSPENDIDO;

DELIMITER $$

CREATE TABLE CARCREDITOSUSPENDIDO(
	CarCreditoSuspendidoID	BIGINT(12)		NOT NULL COMMENT 'ID o Consecutivo de la Tabla',
	CreditoID				BIGINT(12)		NOT NULL COMMENT 'ID Del Numero de Credito del cliente',
	EstatusCredito			CHAR(1)			NOT NULL COMMENT 'Estatus Anterior del Credito Ante de Realizar el pase a Defuncion',
	FechaDefuncion			DATE			NOT NULL COMMENT 'Indicar la fecha en que el cliente fallecio.',
	FechaSuspencion			DATE			NOT NULL COMMENT 'Indicar la fecha en que se realiza la suspension.',
	FolioActa				VARCHAR(30)		NOT NULL COMMENT 'Indicar el folio del acta de defuncion.',
	ObservDefuncion			VARCHAR(250)	NOT NULL COMMENT 'Campo para que el usuario que realice la suspensión pueda agregar cualquier tipo de comentarios.',
	Estatus					CHAR(1)			NOT NULL COMMENT 'Estatus Defuncion R= Registrado/Aplicado, C= Cancelado/Reversado',
	TotalAdeudo				DECIMAL(12,2)	NOT NULL COMMENT 'Indicar el Total Adeudo del credito al momento de Realizar el pase a defuncion.',
	TotalSalCapital			DECIMAL(12,2)	NOT NULL COMMENT 'Indicar el Total de Saldo Capital del credito al momento de Realizar el pase a defuncion.',
	TotalSalInteres			DECIMAL(12,2)	NOT NULL COMMENT 'Indicar el Total de Saldo Interes del credito al momento de Realizar el pase a defuncion.',
	TotalSalMoratorio		DECIMAL(12,2)	NOT NULL COMMENT 'Indicar el Total de Saldo Moratorio del credito al momento de Realizar el pase a defuncion.',
	TotalSalComisiones		DECIMAL(12,2)	NOT NULL COMMENT 'Indicar el Total de Saldo Comisiones del credito al momento de Realizar el pase a defuncion.',
	EmpresaID				INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	Usuario					INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parametros de Auditoria',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parametros de Auditoria',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parametros de Auditoria',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parametros de Auditoria',

	PRIMARY KEY (CarCreditoSuspendidoID),
	KEY `fk_CARCREDITOSUSPENDIDO_1` (CreditoID),
	CONSTRAINT `fk_CARCREDITOSUSPENDIDO_1` FOREIGN KEY (CreditoID) REFERENCES CREDITOS (CreditoID) ON DELETE NO ACTION ON UPDATE NO ACTION
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla para el Registro de suspension de un credito por defuncion del cliente'$$
