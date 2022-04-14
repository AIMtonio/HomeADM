-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZABONICACIONES
DELIMITER ;
DROP TABLE IF EXISTS `AMORTIZABONICACIONES`;

DELIMITER $$
CREATE TABLE `AMORTIZABONICACIONES`(
	BonificacionID	BIGINT(20) 		NOT NULL COMMENT 'ID de la Tabla BONIFICACIONES',
	AmortizacionID	INT(11) 		NOT NULL COMMENT 'Número de Amortización',
	Fecha 			DATE 			NOT NULL COMMENT 'Fecha de Bonificación',
	Monto			DECIMAL(14,2) 	NOT NULL COMMENT 'Monto de la Bonificación',
	MontoPendiente 	DECIMAL(14,2) 	NOT NULL COMMENT 'Monto Pendiente de la Bonificación',
	MontoAcomulado 	DECIMAL(14,2) 	NOT NULL COMMENT 'Monto Acomulado de la Bonificación',
	Estatus 		CHAR(1)			NOT NULL COMMENT 'Estatus de la Amortización \nI = Inactiva/Pendiente \nV = Vigente/Activa/Dispersada \nP = Pagada',
	EmpresaID		INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario			INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual		DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP		VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID		VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal		INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion	BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`BonificacionID`,`AmortizacionID`),
	KEY `IDX_AMORTIZABONICACIONES_1` (`Fecha`),
	KEY `IDX_AMORTIZABONICACIONES_2` (`Estatus`),
	CONSTRAINT `FK_AMORTIZABONICACIONES_1` FOREIGN KEY (`BonificacionID`) REFERENCES `BONIFICACIONES` (`BonificacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TB: Tabla de Amortizaciones de las Bonificaciones al Cliente.'$$