-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSUCURSALESCERRADAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPSUCURSALESCERRADAS`;

DELIMITER $$
CREATE TABLE `TMPSUCURSALESCERRADAS` (
	RegistroID			INT(11)		NOT NULL COMMENT 'Número de Registro',
	SucursalID			INT(11) 	NOT NULL COMMENT 'Número de Sucursal',
	FechaCierre			DATE		NOT NULL COMMENT 'Fecha de Cierre por Contigencia',
	FechaApertura		DATE		NOT NULL COMMENT 'Fecha de Apertura por Contigencia',
	EmpresaID			INT(11)		NOT NULL COMMENT 'ID de la Empresa',
	Usuario				INT(11)		NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual			DATETIME	NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP			VARCHAR(15)	NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID			VARCHAR(50)	NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal			INT(11)		NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion		BIGINT(20)	NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (`RegistroID`),
	KEY `IDX_TMPSUCURSALESCERRADAS_1` (`RegistroID`),
	KEY `IDX_TMPSUCURSALESCERRADAS_2` (`SucursalID`),
	CONSTRAINT `FK_TMPSUCURSALESCERRADAS_1` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla Temporal Física Para almacenar las sucursales cerradas por contigencia.'$$
