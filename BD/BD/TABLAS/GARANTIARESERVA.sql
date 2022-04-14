-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTIARESERVA
DELIMITER ;
DROP TABLE IF EXISTS `GARANTIARESERVA`;DELIMITER $$

CREATE TABLE `GARANTIARESERVA` (
  `Fecha` date NOT NULL COMMENT 'Fecha del Captura o Registro',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `Instrumento` bigint(20) NOT NULL COMMENT 'Instrumento: No.Cuenta, Inversion, ID de la Garantia',
  `TipoGarantiasID` int(11) NOT NULL COMMENT 'Tipo de Garantia',
  `ClasifGarantiaID` int(11) NOT NULL COMMENT 'Clasificacion de la Garantia',
  `MontoGarantia` decimal(14,2) NOT NULL COMMENT 'Monto de la Garantia',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Fecha`,`CreditoID`,`Instrumento`),
  KEY `fk_GARANTIARESERVA_1` (`TipoGarantiasID`),
  KEY `index4` (`Fecha`),
  KEY `fk_GARANTIARESERVA_2_idx` (`CreditoID`),
  CONSTRAINT `fk_GARANTIARESERVA_1` FOREIGN KEY (`TipoGarantiasID`) REFERENCES `TIPOGARANTIAS` (`TipoGarantiasID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_GARANTIARESERVA_2` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Garantias por Credito para Reservas'$$