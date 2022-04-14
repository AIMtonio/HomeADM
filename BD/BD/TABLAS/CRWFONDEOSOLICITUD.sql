-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOSOLICITUD
DELIMITER ;
DROP TABLE IF EXISTS `CRWFONDEOSOLICITUD`;
DELIMITER $$

CREATE TABLE `CRWFONDEOSOLICITUD` (
	`SolFondeoID` BIGINT(20) NOT NULL,
	`SolicitudCreditoID` BIGINT(20) NOT NULL COMMENT 'Número de la solicitud de crédito\n',
	`Consecutivo` INT(11) NOT NULL COMMENT 'Numero Consecutivo de Fondeo por Solicitud',
	`ClienteID` INT(11) NOT NULL COMMENT 'Numero de Cliente o ID, del Inversionista o  Fondeador',
	`CuentaAhoID` BIGINT(12) NOT NULL COMMENT 'Cuenta de \nAhorro del \nCliente o \nInversionista',
	`FechaRegistro` DATE NOT NULL COMMENT 'Fecha del Registro del Fondeo',
	`MontoFondeo` DECIMAL(12,2) NOT NULL COMMENT 'Monto del Fondeo',
	`PorcentajeFondeo` DECIMAL(10,6) NOT NULL COMMENT 'Porcentaje del Fondeo',
	`MonedaID` INT(11) NOT NULL COMMENT 'Moneda',
	`Estatus` CHAR(1) NOT NULL COMMENT 'Estatus del Fondeo de la Solicitud	\n	F .- En Proceso de Fondeo\n	C .- Cancelada\n	N .- Vigente o Inversion Creada',
	`TasaActiva` DECIMAL(8,4) NOT NULL COMMENT 'Tasa Activa	',
	`TasaPasiva` DECIMAL(8,4) NOT NULL COMMENT 'TasaPasiva',
	`FondeoID` BIGINT(20) NOT NULL COMMENT 'Numero o ID de\nFondeo, \nconsecutivo.\nNota: \nInicialmente esta\nvacio hasta que\nse formaliza el\ncredito\nY se asignan los\nfondeadores Ref. CRWFONDEO',
	`TipoFondeadorID` INT(11) NOT NULL COMMENT 'Tipo fondeador de la solicitud',
	`ProducCreditoID` INT(11) NOT NULL COMMENT 'Numero o ID del producto de credito',
	`Gat` DECIMAL(12,2) NOT NULL COMMENT 'Calculo GAT',
	`ValorGatReal` DECIMAL(12,2) NOT NULL COMMENT 'Valor del GAT Real.',
	`EmpresaID` INT(11) NOT NULL COMMENT 'Auditoria',
	`Usuario` INT(11) NOT NULL COMMENT 'Auditoria',
	`FechaActual` DATE NOT NULL COMMENT 'Auditoria',
	`DireccionIP` VARCHAR(15) NOT NULL COMMENT 'Auditoria',
	`ProgramaID` VARCHAR(50) NOT NULL COMMENT 'Auditoria',
	`Sucursal` INT(11) NOT NULL COMMENT 'Auditoria',
	`NumTransaccion` BIGINT(20) NOT NULL COMMENT 'Auditoria',
	 PRIMARY KEY (`SolFondeoID`),
	INDEX `FK_CUENTASAHO_CWRFONDEOSOLICITUD` (`CuentaAhoID` ASC),
	INDEX `FK_MONEDA_CWRFONDEOSOLICITUD` (`MonedaID` ASC),
	INDEX `FK_CRWFONDEO_CWRFONDEOSOLICITUD` (`FondeoID` ASC),
	INDEX `FK_TIPOSFONDEADORES_CWRFONDEOSOLICITUD` (`TipoFondeadorID` ASC),
	INDEX `FK_SOLICITUDCREDITO_CWRFONDEOSOLICITUD` (`SolicitudCreditoID` ASC),
	INDEX `FK_CLIENTE_CWRFONDEOSOLICITUD` (`ClienteID` ASC),
	INDEX `FK_PRODUCTOSCREDITO_CWRFONDEOSOLICITUD` (`ProducCreditoID`),
	INDEX `INDEX_FONDEOSOLICITUD_1` (`SolFondeoID` ASC, `ClienteID` ASC, `Estatus` ASC),
	INDEX `INDEX_FONDEOSOLICITUD_2` USING BTREE (`Estatus` ASC, `ClienteID` ASC, `CuentaAhoID` ASC),
	INDEX `INDEX_FONDEOSOLICITUD_3` (`ClienteID` ASC, `CuentaAhoID` ASC, `Estatus` ASC)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tabla de Inversionistas o Fondeo por Solicitud de Credito'$$

