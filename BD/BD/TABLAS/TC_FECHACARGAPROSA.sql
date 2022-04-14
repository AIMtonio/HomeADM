-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_FECHACARGAPROSA
DELIMITER ;
DROP TABLE IF EXISTS `TC_FECHACARGAPROSA`;

DELIMITER $$
CREATE TABLE `TC_FECHACARGAPROSA` (
	`FechaCargaProsaID`			BIGINT(20)		NOT NULL COMMENT 'Identificador de la tabla',
	`Fecha`						DATE			NOT NULL COMMENT 'Fecha de la ejecucion del registro',
	`TipoArchivo`				CHAR(1)			NOT NULL COMMENT 'Tipo archivo a cargar E = Emi, S = Stats',
	`HoraEjecucion`				TIME			NOT NULL COMMENT 'Hora en la que se realizo el intento de carga de archivo ya sea exitoso o no',
	`IntentosFallidos`			INT(11)			NOT NULL COMMENT 'Numero de intentos sobre la fecha',
	`Estatus`					CHAR(1)			NOT NULL COMMENT 'Estatus de los intentos de lectura E = Exitoso, F= Fallido',
	`EmpresaID`					INT(11)			NOT NULL COMMENT 'Campo de auditoria ID de la empresa',
	`Usuario`					INT(11)			NOT NULL COMMENT 'Campo de auditoría ID del usuario',
	`FechaActual`				DATETIME		NOT NULL COMMENT 'Campo de auditoría Fecha actual',
	`DireccionIP`				VARCHAR(15)		NOT NULL COMMENT 'Campo de auditoría Dirección IP',
	`ProgramaID`				VARCHAR(50)		NOT NULL COMMENT 'Campo de auditoría Programa',
	`Sucursal`					INT(11)			NOT NULL COMMENT 'Campo de auditoría ID de la Sucursal',
	`NumTransaccion`			BIGINT(20)		NOT NULL COMMENT 'Campo de auditoría Número de la Transacción',
	PRIMARY KEY (`FechaCargaProsaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla para los intentos de lectura de prosa'$$
