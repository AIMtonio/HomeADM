-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAFORCOBCOMLIN
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAFORCOBCOMLIN`;

DELIMITER $$
CREATE TABLE `BITACORAFORCOBCOMLIN` (
	RegistroID				INT(11) NOT NULL COMMENT 'ID de Tabla',
	CreditoID				BIGINT(12) NOT NULL COMMENT 'Numero de Credito, sigue la misma nomenclatura que usa las cuentas de ahorro\n',
	LineaCreditoID			BIGINT(20) NOT NULL COMMENT 'Linea de Credito\n',
	FechaRegistro 			DATE NOT NULL COMMENT 'Fecha de Registro',
	TipoComision			CHAR(1) NOT NULL COMMENT 'Tipo de Comisión \nA.- Administración \nG.- Ser. Com. Por Garantía',

	ComLinPrevLiq			CHAR(1) NOT NULL COMMENT 'Comisión que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI',
	ForCobCom				CHAR(1) NOT NULL COMMENT 'Forma de Cobro Comisión \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición',
	ForPagCom				CHAR(1) NOT NULL COMMENT 'Forma de Pago Comisión \n"".- No aplica \nD.- Deducción \nF.- Financiado',
	PorcentajeCom			DECIMAL(6,2) NOT NULL COMMENT 'permite un valor de 0% a 100%',
	MontoPagCom				DECIMAL(14,2) NOT NULL COMMENT 'Monto a Pagar por Comisión',
	FechaProximoCobro		DATE NOT NULL COMMENT 'Fecha de Proximo Cobro',

	EmpresaID				INT(11) NOT NULL COMMENT 'ID de la empresa',
	Usuario					INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15) NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50) NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion			BIGINT(20) NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (`RegistroID`),
	KEY `IDX_BITACORAFORCOBCOMLIN_1` (`RegistroID`),
	KEY `IDX_BITACORAFORCOBCOMLIN_2` (`CreditoID`),
	KEY `IDX_BITACORAFORCOBCOMLIN_3` (`LineaCreditoID`),
	CONSTRAINT `FK_BITACORAFORCOBCOMLIN_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`),
	CONSTRAINT `FK_BITACORAFORCOBCOMLIN_2` FOREIGN KEY (`LineaCreditoID`) REFERENCES `LINEASCREDITO` (`LineaCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Bitácora de forma cobro comisión de líneas de crédito.'$$