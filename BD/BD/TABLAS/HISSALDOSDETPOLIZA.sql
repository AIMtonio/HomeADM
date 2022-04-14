-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSALDOSDETPOLIZA
DELIMITER ;
DROP TABLE IF EXISTS `HISSALDOSDETPOLIZA`;

DELIMITER $$
CREATE TABLE `HISSALDOSDETPOLIZA` (
	`HisSaldosDetPolizaID`	BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID de la tabla',
	`Fecha`					DATE			NOT NULL COMMENT 'Fecha de la Poliza',
	`CentroCostoID`			INT(11)			NOT NULL COMMENT 'Centro de Costos',
	`CuentaCompleta`		VARCHAR(50)		NOT NULL COMMENT 'Cuenta Contable Completa',
	`Cargos`				DECIMAL(18,4)	NOT NULL COMMENT 'Cargos de la Cuenta',
	`Abonos`				DECIMAL(18,4)	NOT NULL COMMENT 'Abonos de la Cuenta',
	`EmpresaID`				INT(11)			NOT NULL COMMENT 'ID de la Empresa',
	`Usuario`				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	`FechaActual`			DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	`DireccionIP`			VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	`ProgramaID`			VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	`Sucursal`				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	`NumTransaccion`		BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (`HisSaldosDetPolizaID`),
	KEY `INDEX_HISSALDOSDETPOLIZA_1` (`Fecha`,`CentroCostoID`,`CuentaCompleta`),
	KEY `INDEX_HISSALDOSDETPOLIZA_2` (`Fecha`),
	KEY `INDEX_HISSALDOSDETPOLIZA_3` (`CentroCostoID`),
	KEY `INDEX_HISSALDOSDETPOLIZA_4` (`CuentaCompleta`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla historica de los Saldos de los detalles de Póliza.'$$