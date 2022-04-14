-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROVIDA
DELIMITER ;
DROP TABLE IF EXISTS `SEGUROVIDA`;DELIMITER $$

CREATE TABLE `SEGUROVIDA` (
  `SeguroVidaID` int(11) NOT NULL,
  `ClienteID` int(11) NOT NULL,
  `CuentaID` bigint(12) DEFAULT NULL,
  `CreditoID` bigint(12) NOT NULL,
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Solicitud de Credito',
  `FechaInicio` date NOT NULL,
  `FechaVencimiento` date NOT NULL,
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del Seguro: I.- Inactivo, V .- Vigente, C . Cobrado',
  `Beneficiario` varchar(200) NOT NULL COMMENT 'Nombre del Beneficiario',
  `DireccionBen` varchar(300) NOT NULL COMMENT 'Direccion del Beneficiario',
  `TipoRelacionID` int(11) NOT NULL COMMENT 'Tipo de Relacion del Beneficiario',
  `MontoPoliza` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Poliza en Caso de Siniestro',
  `ForCobroSegVida` char(1) NOT NULL COMMENT 'A: Anticipado, D: Deduccion, F: Financiamiento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguroVidaID`),
  KEY `fk_SEGUROVIDA_1` (`ClienteID`),
  KEY `fk_SEGUROVIDA_2` (`CuentaID`),
  KEY `fk_SEGUROVIDA_3` (`CreditoID`),
  KEY `fk_SEGUROVIDA_4` (`TipoRelacionID`),
  KEY `fk_SEGUROVIDA_5` (`SolicitudCreditoID`),
  CONSTRAINT `fk_SEGUROVIDA_4` FOREIGN KEY (`TipoRelacionID`) REFERENCES `TIPORELACIONES` (`TipoRelacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Seguros de Vida'$$