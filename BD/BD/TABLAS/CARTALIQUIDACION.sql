-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTALIQUIDACION
DELIMITER ;
DROP TABLE IF EXISTS `CARTALIQUIDACION`;
DELIMITER $$

CREATE TABLE CARTALIQUIDACION (
  `CartaLiquidaID`		BIGINT(12) NOT NULL COMMENT 'Identificador de carta de liquidacion interna',
  `CreditoID` 			BIGINT(12) NOT NULL COMMENT 'ID de credito',
  `ClienteID` 			INT(11) NOT NULL COMMENT 'ID del cliente',
  `FechaVencimiento` 	DATE NOT NULL COMMENT 'Fecha que captura el Usuario',
  `InstitucionID` 		INT(11) NOT NULL COMMENT 'Institucion para realizar el pago',
  `Convenio` 			BIGINT(12) NOT NULL COMMENT 'Numero de convenio para realizar el pago',
  `ArchivoIDCarta` 		INT(11) DEFAULT 0 COMMENT 'ID de los Archivos de Expediente con respecto a la Carta de Liquidacion (CREDITOARCHIVOS.DigCreaID)',
  `Estatus` 			CHAR(1) DEFAULT 'A' COMMENT 'Estatus de la carta de la liquidacion A=Activa I=Inactiva',
  `FechaRegistro` 		DATE NOT NULL COMMENT 'Fecha que se creo la carta de liquidacion',
  `FechaBaja` 			DATE DEFAULT '1900-01-01' COMMENT 'Fecha que deja de estar activa la carta de liquidación',
  `EmpresaID` 			INT(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` 			INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
  `FechaActual` 		DATETIME NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
  `DireccionIP` 		VARCHAR(15) NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
  `ProgramaID` 			VARCHAR(50) NOT NULL COMMENT 'Parámetro de auditoría Programa',
  `Sucursal`			INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
  `NumTransaccion` 		BIGINT(20) NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
  PRIMARY KEY (`CartaLiquidaID`),
  KEY `INDEX_CARTALIQUIDACION_1` (`CreditoID`,`Estatus`),
  CONSTRAINT `FK_CARTALIQUIDACION_1` FOREIGN KEY (`InstitucionID`) REFERENCES `INSTITUCIONES` (`InstitucionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el registro de las cartas de liquidacion internas'$$