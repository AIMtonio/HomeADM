-- Creacion de tabla NOMCAPACIDADPAGOSOL
DELIMITER ;

DROP TABLE IF EXISTS NOMCAPACIDADPAGOSOL;

DELIMITER $$
CREATE TABLE `NOMCAPACIDADPAGOSOL` (
  `NomCapacidadPagoSolID`	BIGINT(12)		NOT NULL	COMMENT 'Identificador de la tabla',
  `SolicitudCreditoID`		BIGINT(20)		NOT NULL	COMMENT 'Identificador de la tabla SolicitudCredito',
  `CapacidadPago`			DECIMAL(12,2)	NOT NULL	COMMENT 'Valor de la capacidad de pago',
  `MontoCasasComer`			DECIMAL(12,2)	NOT NULL	COMMENT 'Monto total de la deuda a casas comerciales',
  `MontoResguardo`			DECIMAL(12,2)	NOT NULL	COMMENT 'Monto total de resguardo',
  `PorcentajeCapacidad`		DECIMAL(12,2)	NOT NULL	COMMENT 'Valor del porcentaje de la capacidad',
  `EmpresaID`				VARCHAR(45)		NOT NULL 	COMMENT 'Parametros de Auditoria',
  `Usuario`					INT(11)			NOT NULL 	COMMENT 'Parametros de Auditoria',
  `FechaActual`				DATETIME		NOT NULL 	COMMENT 'Parametros de Auditoria',
  `DireccionIP`				VARCHAR(15)		NOT NULL 	COMMENT 'Parametros de Auditoria',
  `ProgramaID`				VARCHAR(50)		NOT NULL 	COMMENT 'Parametros de Auditoria',
  `Sucursal`				INT(11)			NOT NULL 	COMMENT 'Parametros de Auditoria',
  `NumTransaccion`			BIGINT(20)		NOT NULL 	COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`NomCapacidadPagoSolID`),
  KEY `fk_NOMCAPACIDADPAGOSOL_1` (`SolicitudCreditoID`),
  CONSTRAINT `fk_NOMCAPACIDADPAGOSOL_1` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Capacidad de Pago.'$$


