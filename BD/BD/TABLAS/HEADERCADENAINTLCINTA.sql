DELIMITER ;
DROP TABLE IF EXISTS HEADERCADENAINTLCINTA;
DELIMITER $$
CREATE TABLE HEADERCADENAINTLCINTA(
	HeaderSegmentoID		INT(11)			NOT NULL	COMMENT 'Consecutivo General de la Tabla',
	Identificador			VARCHAR(5)		NOT NULL	COMMENT 'Campo que contiene el identifcador del Header',
	ClaveUsuarioBC			INT(11)			NOT NULL	COMMENT 'Contiene la clave Unica del Usuario para reportar el producto, la cual fue asignada por Buro de Credito.',
	ClaveUsuarioAntBC		INT(11)			NOT NULL	COMMENT 'Contiene la clave Unica del Usuario que era responsable de los creditos o cuentas antes que el Usuario actual.',
	TipoInstitucion			INT(11)			NOT NULL	COMMENT 'Se incluye el tipo de Institucion de acuerdo al ANEXO 1 “TIPO DE USUARIO”. MANUAL INTL',
	Formato					INT(11)			NOT NULL	COMMENT 'Campo para almacenar el tipo de formato que son:1.-Detallado para Formato Financiero 2.-Sumarizado para Formato Comercial',
	Fecha					VARCHAR(10)		NOT NULL	COMMENT 'Contiene la fecha de extraccion de la informacion de la base de datos del Usuario para ser reportada a Buro de Credito',
	Periodo					INT(11)			NOT NULL	COMMENT 'Contiene los datos del periodo que se esta reportando. El formato es MMAAAA',
	VersionINTL				CHAR(2)			NOT NULL	COMMENT 'Identificar de la version de la cadena INTL',
	NombreOtorgante			VARCHAR(75)		NOT NULL	COMMENT 'Incluir el Nombre de la Institucion Otorgante que reporta la informacion.',
	Filler					VARCHAR(52)		NOT NULL	COMMENT 'Campo reservado para uso futuro en la cadena INTL',
	TipoPersona				CHAR(1)			NOT NULL	COMMENT 'Tipo Persona para la cinta, F.- Fisica, M.-Moral',
	EmpresaID				INT(11)			NOT NULL	COMMENT 'Parametro de auditoria ID de la empresa',
	Usuario					INT(11)			NOT NULL	COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual				DATETIME		NOT NULL	COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL	COMMENT 'Parametro de auditoria Direccion IP',
	ProgramaID				VARCHAR(50)		NOT NULL	COMMENT 'Parametro de auditoria Programa',
	Sucursal				INT(11)			NOT NULL	COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL	COMMENT 'Parametro de auditoria Numero de la transaccion',
PRIMARY KEY (HeaderSegmentoID),
KEY INDEX_HEADERCADENAINTLCINTA_1(NumTransaccion),
KEY INDEX_HEADERCADENAINTLCINTA_2(TipoPersona)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para guardar el encabezado de la cinta de buro de credito en formato INTL'$$