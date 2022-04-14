-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREVERSAPAGOCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `TMPREVERSAPAGOCREDITO`;

DELIMITER ;
CREATE TABLE `TMPREVERSAPAGOCREDITO`(
	`RegistroID`			INT(11)			NOT NULL COMMENT 'ID de la tabla',
	`CreditoID`				BIGINT(12)		NOT NULL COMMENT 'ID de Crédito',
	`TransaccionID`			BIGINT(20)		NOT NULL COMMENT 'Número de Transaccion de la Operación',
	`CuentaAhoID`			BIGINT(12)		NOT NULL COMMENT 'ID de Cuenta de Ahorro',
	`MontoPagado`			DECIMAL(12,2)	NOT NULL COMMENT 'Monto  total pagado Respaldo Reversa',
	`BloqueoID`				INT(11)			NOT NULL COMMENT 'ID del Bloqueo',
	`MontoBloq`				DECIMAL(12,2)	NOT NULL COMMENT 'Monto Bloqueado',
	`CueGarLiqID`			BIGINT(12)		NOT NULL COMMENT 'ID de Cuenta de Ahorro en Garantia Liquida',
	`EmpresaID`				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la empresa',
	`Usuario`				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	`FechaActual`			DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	`DireccionIP`			VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	`ProgramaID`			VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	`Sucursal`				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	`NumTransaccion`		BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY(`RegistroID`,`CreditoID`,`TransaccionID`),
	KEY `IDX_TMPREVERSAPAGOCREDITO_1` (`TransaccionID`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal Física utilizada para el proceso de reversa de pago de crédito';