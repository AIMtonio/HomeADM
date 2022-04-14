-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESCAJA
DELIMITER ;
DROP TABLE IF EXISTS `OPCIONESCAJA`;
DELIMITER $$

CREATE TABLE `OPCIONESCAJA` (
	`OpcionCajaID` int(11) NOT NULL COMMENT 'ID de la Opción en Ventanilla',
	`Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripción de la Operación',
	`EsReversa` char(1) DEFAULT NULL COMMENT 'Indica si la operacion es una reversa de Ventanilla',
	`ReqAutentificacion` char(1) DEFAULT NULL COMMENT 'Indica si se haran las validaciones por huella digital S=SI N=NO',
	`SujetoPLDEscala` char(1) DEFAULT NULL COMMENT 'Indica si la operacion de ventanilla es sujeto de escalamiento interno en PLD.\nS.- Si\nN.- No',
	`SujetoPLDIdenti` char(1) DEFAULT NULL COMMENT 'Indica si la operacion de ventanilla es sujeto de identificacion simplificada del cliente en PLD.\nS.- Si\nN.- No',
	`TipoInstruMonID` int(11) DEFAULT NULL COMMENT 'Tipo de Instrumento Monetario usado en Escalamiento de Operaciones en Ventanilla (PLD).',
	`EvaluaPLD` char(1) DEFAULT 'N' COMMENT 'Indica si la operación puede estar Sujeta a las evaluaciones PLD.\nSi puede aplicar escalamiento interno (SujetoPLDEscala) o Identificación del Cliente (SujetoPLDIdenti).\nN: No (default)\nS: Sí',
	`ImpTicketResumen` CHAR(1) NOT NULL COMMENT 'Habilita el botón Imprimir Ticket del Resumen \nS.- SI \nI.- NO',
	`CampoPantalla` VARCHAR(30) NOT NULL COMMENT 'Campo de donde se obtiene el Número de Cliente o Socio',
	`EmpresaID` int(11) DEFAULT NULL,
	`Usuario` int(11) DEFAULT NULL,
	`FechaActual` datetime DEFAULT NULL,
	`DireccionIP` varchar(15) DEFAULT NULL,
	`ProgramaID` varchar(50) DEFAULT NULL,
	`Sucursal` int(11) DEFAULT NULL,
	`NumTransaccion` bigint(20) DEFAULT NULL,
	PRIMARY KEY (`OpcionCajaID`),
	KEY `FK_OPCIONESCAJA_1` (`TipoInstruMonID`),
	CONSTRAINT `FK_OPCIONESCAJA_1` FOREIGN KEY (`TipoInstruMonID`) REFERENCES `TIPOINSTRUMMONE` (`TipoInstruMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Catalogo de Operaciones en Ventanilla'$$