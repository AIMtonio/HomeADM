-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMEDOVARIACIONES
DELIMITER ;
DROP TABLE IF EXISTS `PARAMEDOVARIACIONES`;

DELIMITER $$
CREATE TABLE `PARAMEDOVARIACIONES` (
	ParamEdoVariacionID		INT(11)			NOT NULL COMMENT 'ID de Tabla',
	NumeroCliente 			INT(11) 		NOT NULL COMMENT 'Número del cliente.',
	Consecutivo 			INT(11)			NOT NULL COMMENT 'Número Consecutivo',
	Nombre					VARCHAR(50)		NOT NULL COMMENT 'Nombre de la columna',
	MostrarColumna			CHAR(1)			NOT NULL COMMENT 'Mostrar Columna \nS= SI \nN= NO.',

	TipoAgrupacion			CHAR(2)			NOT NULL COMMENT 'Agrupacion Columna \nNA= No Aplica \nCC= Capital contribuido \nCG= Capital Ganado.',
	Descripcion				VARCHAR(200)	NOT NULL COMMENT 'Descripción de la columna',

	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoria Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoria Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoria Número de la transacción',
	PRIMARY KEY (`ParamEdoVariacionID`,`NumeroCliente`,`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Configuración del Reporte Excel del Estado de Variación de Capital Contable.'$$