-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEPAGOSNOMINA
DELIMITER ;
DROP TABLE IF EXISTS `BEPAGOSNOMINA`;

DELIMITER $$
CREATE TABLE `BEPAGOSNOMINA` (
	`FolioNominaID`			INT(11) 		NOT NULL COMMENT 'Folio consecutivo de la Carga del Archivo de pagos de Nomina',
	`FolioCargaID`			INT(11) 		DEFAULT NULL COMMENT 'Folio de la Carga del Archivo de pagos de BECARGAPAGNOMINA\n',
	`FolioCargaIDBE`		INT(11) 		DEFAULT NULL COMMENT 'Folio de Carga Consecutivo Generado en Banca en Linea',
	`EmpresaNominaID`		INT(11) 		DEFAULT NULL COMMENT 'Numero de Cliente de la empresa de Nomina\n',
	`FechaCarga`			DATE 			DEFAULT NULL COMMENT 'Fecha en que se subio el Archivo',
	`CreditoID`				BIGINT(20) 		DEFAULT NULL COMMENT 'Numero de Credito',
	`ClienteID`				VARCHAR(20) 	DEFAULT NULL COMMENT 'Numero de empleado en la institucion de nomina',
	`MontoPagos`			DECIMAL(12,2) 	DEFAULT NULL COMMENT 'Monto del Pago del Credito\n',
	`Estatus`				CHAR(1) 		DEFAULT NULL COMMENT 'Estatus de la Solicitud de Pago\n\nP .- Por Aplicar o Cargado,\nA .- Aplicado,\nC.- Cancelado',
	`MotivoCancela`			VARCHAR(400) 	DEFAULT NULL COMMENT 'Motivo de Cancelación',
	`MontoAplicado`			DECIMAL(14,2) 	DEFAULT NULL COMMENT 'MONTO APLICADO DE PAGO DE CREDITO \n',
	`FechaAplicacion`		VARCHAR(45) 	DEFAULT NULL COMMENT 'Fecha en que se hizo la aplicacion del pago.',
	`EmpresaID`				INT(11) 		DEFAULT NULL,
	`Usuario`				INT(11) 		DEFAULT NULL,
	`FechaActual`			DATETIME 		DEFAULT NULL,
	`DireccionIP`			VARCHAR(15) 	DEFAULT NULL,
	`ProgramaID`			VARCHAR(50) 	DEFAULT NULL,
	`Sucursal`				INT(11) 		DEFAULT NULL,
	`NumTransaccion`		BIGINT(20) 		DEFAULT NULL,
	PRIMARY KEY (`FolioNominaID`),
	KEY `fk_BEPAGOSNOMINA_1_idx` (`FolioCargaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Pagos de Créditos de Nomina'$$