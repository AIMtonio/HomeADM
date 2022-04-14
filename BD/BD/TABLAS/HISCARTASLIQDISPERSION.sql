-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCARTASLIQDISPERSION
DELIMITER ;
DROP TABLE IF EXISTS `HISCARTASLIQDISPERSION`;
DELIMITER $$

CREATE TABLE `HISCARTASLIQDISPERSION` (
  `CartaDispersionID` INT(11) NOT NULL COMMENT 'ID Número de la Casa Comercial.',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `AsignacionCartaID` BIGINT(11) DEFAULT NULL COMMENT 'ID de Asignación de la Carta',
  `CasaComercialID` BIGINT(11) DEFAULT NULL COMMENT 'ID  de Casa Comercial',
  `FolioOperacion` INT(11) DEFAULT NULL COMMENT 'ID o referencia de la operación de la dispersion',
  `ClaveDispMov` INT(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla de movimientos',
  `Fecha` DATETIME DEFAULT NULL COMMENT 'Fecha en cual se realiza la operación de la dispersión',
  `Monto` DECIMAL(12,2) DEFAULT NULL COMMENT 'Monto a realizar ',
  `Estatus` CHAR(1) DEFAULT 'N' COMMENT 'Estatus del Registro la Carta de Liq Dispersada \nA = Autorizada,\nN = No Autorizada',
  `Destino` CHAR(1) DEFAULT 'C' COMMENT 'Tipo de Desitno \nC = Registro Cliente,\nL = Registro Carta de Liquidacion',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` INT(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CartaDispersionID`),
  KEY `INDEX_HISCARTASLIQDISPERSION_1` (`ClaveDispMov`),
  CONSTRAINT `FK_HISCARTASLIQDISPERSION_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_HISCARTASLIQDISPERSION_4` FOREIGN KEY (`FolioOperacion`) REFERENCES `DISPERSION` (`FolioOperacion`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla Historica donde contiene la relacion de las Cartas de Liquidacion que fueron Dispersadas.'$$
