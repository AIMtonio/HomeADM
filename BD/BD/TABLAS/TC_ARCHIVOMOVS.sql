-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_ARCHIVOMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TC_ARCHIVOMOVS`;

DELIMITER $$
CREATE TABLE `TC_ARCHIVOMOVS` (
	`Tc_ArchivoMovsID` 			BIGINT(20)		AUTO_INCREMENT NOT NULL COMMENT 'id del archivo',
	`TipoArchivo`				CHAR(1)			NOT NULL COMMENT 'Campo indica el tipo de archivo. (E = EMI, S = STATS)',
	`FechaArchivo`				DATE			NOT NULL COMMENT 'Campo indica la fecha del archivo cargado',
	`NombreArchivo`				VARCHAR(50)		NOT NULL COMMENT 'Nombre del archivo cargado',
	`Registro`					VARCHAR(520)	NOT NULL COMMENT 'Contenido por linea del archivo',
	`NumTranCarga`				BIGINT(20)		NOT NULL COMMENT 'Transaccion con la que se registra el archivo',
	`Estatus`					CHAR(1)			NOT NULL COMMENT 'Estatus de la linea del archivo R = Registrado, P = Procesado C = Cancelado',
	`NumLinea` 					INT(11) 		NOT NULL COMMENT 'Numero de Linea',
	`MotivoCancel`				VARCHAR(400)		NOT NULL COMMENT 'Indica el motivo por lo que no genera movimiento',
	`EmpresaID`					INT(11)			NOT NULL COMMENT 'Campo de auditoria ID de la empresa',
	`Usuario`					INT(11)			NOT NULL COMMENT 'Campo de auditoría ID del usuario',
	`FechaActual`				DATETIME		NOT NULL COMMENT 'Campo de auditoría Fecha actual',
	`DireccionIP`				VARCHAR(15)		NOT NULL COMMENT 'Campo de auditoría Dirección IP',
	`ProgramaID`				VARCHAR(50)		NOT NULL COMMENT 'Campo de auditoría Programa',
	`Sucursal`					INT(11)			NOT NULL COMMENT 'Campo de auditoría ID de la Sucursal',
	`NumTransaccion`			BIGINT(20)		NOT NULL COMMENT 'Campo de auditoría Número de la Transacción',
	PRIMARY KEY (`Tc_ArchivoMovsID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla que almacena el contenido de archivos por linea'$$
