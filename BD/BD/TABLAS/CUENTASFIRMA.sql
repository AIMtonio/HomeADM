-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASFIRMA
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASFIRMA`;DELIMITER $$

CREATE TABLE `CUENTASFIRMA` (
  `CuentaFirmaID` int(11) NOT NULL COMMENT 'Numero de Firma',
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0',
  `PersonaID` int(12) NOT NULL COMMENT 'Numero de persona relacionada',
  `NombreCompleto` varchar(200) NOT NULL COMMENT 'Nombre de persona autorizada para firma',
  `Tipo` char(1) NOT NULL COMMENT 'Tipo de Firma: A .- Individual, B .-Mancumunada, C.-Especial',
  `InstrucEspecial` varchar(150) DEFAULT NULL COMMENT 'Deberá ser llenado al seleccionar el Tipo C',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CuentaFirmaID`,`CuentaAhoID`),
  KEY `fk_CUENTASFIRMA_1` (`CuentaAhoID`),
  CONSTRAINT `fk_CUENTASFIRMA_1` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Firmas Autorizadas de la Cuenta de Ahorro'$$