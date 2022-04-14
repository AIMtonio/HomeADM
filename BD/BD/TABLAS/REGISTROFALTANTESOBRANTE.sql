-- REGISTROFALTANTESOBRANTE

DELIMITER ;
DROP TABLE IF EXISTS REGISTROFALTANTESOBRANTE;
DELIMITER $$

CREATE TABLE REGISTROFALTANTESOBRANTE (
	RegFaltanteSobranteID	INT(11)			NOT NULL COMMENT 'ID de  que hace referencia ala llave primaria de la tabla',
	Monto					DECIMAL(14,2)	NOT NULL COMMENT 'Monto total de ajuste',
	NumCaja					INT(11)			NOT NULL COMMENT 'Número de la caja que realiza la transacción',
	DescripcionCaja			VARCHAR(100)	NOT NULL COMMENT 'Indica la descripción de la caja.',
	UsuarioID				INT(11)			NOT NULL COMMENT 'Usuario asignado a la caja',
	SucursalID				INT(11)			NOT NULL COMMENT 'Sucursal donde se encuentra la caja',
	UsuarioAutoriza			VARCHAR(45)		NOT NULL COMMENT 'Usuario que va autorizar el ajuste',
	TipoOperacion			CHAR(1)			NOT NULL COMMENT 'Indica si es ajuste por faltante o por sobrante.F=Ajuste por Faltante, S=Ajuste por Sobrante.',
	Estatus					CHAR(1)			NOT NULL COMMENT 'Indica si la solicitud está A=Autorizada P=Pendiente.',
	EmpresaID				INT(11)			NOT NULL COMMENT 'Parametro de auditorias',
	Usuario					INT(11)			NOT NULL COMMENT 'Parametro de auditorias',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parametro de auditorias',
	DireccionIP				VARCHAR(20)		NOT NULL COMMENT 'Parametro de auditorias',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parametro de auditorias',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parametro de auditorias',
	NumTransaccion			BIGINT(11)		NOT NULL COMMENT 'Parametro de auditorias',
	PRIMARY KEY (RegFaltanteSobranteID),
	KEY `idx_FALTANTESOBRANTE_1` (`NumCaja`),
	KEY `idx_FALTANTESOBRANTE_2` (`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl. Almacena los datos de ajuste de sobrante y faltante de una ventanilla Para una Posible Autorizacion.'$$





