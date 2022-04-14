-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLICANCELAENTREGA
DELIMITER ;
DROP TABLE IF EXISTS `CLICANCELAENTREGA`;DELIMITER $$

CREATE TABLE `CLICANCELAENTREGA` (
  `CliCancelaEntregaID` int(11) DEFAULT '0' COMMENT 'Consecutivo tabla CLICANCELAENTREGA',
  `ClienteCancelaID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo Tabla CLIENTESCANCELA',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente de la solicitud de cancelacion',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `PersonaID` int(11) NOT NULL COMMENT 'ID de la persona relacionada a la cuenta como beneficiario, debe de existir en tabla CUENTASPERSONA\nSi se trata de cancelaciÃ³n por atenciÃ³n al socio, este valor es Cero ',
  `ClienteBenID` int(11) DEFAULT NULL COMMENT 'ID del cliente de la persona relacionada, este campo se obtiene de CUENTASPERSONA y su valor puede ser cero.',
  `Parentesco` int(11) DEFAULT NULL COMMENT 'ID del parentesco del beneficiario que se registro en CUENTASPERSONA\nSi se trata de cancelaciÃ³n por atenciÃ³n al socio, este valor es Cero ',
  `NombreBeneficiario` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo del Beneficiario',
  `Porcentaje` decimal(12,2) DEFAULT NULL COMMENT 'Porcentaje que tiene el beneficiario\nSi se trata de cancelaciÃ³n por atenciÃ³n al socio, este valor sera 100%',
  `CantidadRecibir` decimal(14,2) DEFAULT NULL COMMENT 'Cantidad que recibirÃ¡ el beneficiario',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus en que se encuentra el registro de la recepciÃ³n del beneficiario\nAutorizado = "A" (la solicitud de cancelaciÃ³n se acaba de autorizar)\nPagado = "P" (el dinero se entrega en ventanilla)',
  `NombreRecibePago` varchar(200) DEFAULT NULL COMMENT 'Nombre de la persona que recibe el pago en ventanilla, puede que el beneficiario no reciba el dinero y alguien acuda con una carta poder',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`PersonaID`,`ClienteCancelaID`),
  KEY `FK_TipoRelacionID_1` (`Parentesco`),
  KEY `FK_ClienteCancelaID_2` (`ClienteCancelaID`),
  KEY `FK_PersonaID_1` (`CuentaAhoID`,`PersonaID`),
  CONSTRAINT `FK_ClienteCancelaID_2` FOREIGN KEY (`ClienteCancelaID`) REFERENCES `CLIENTESCANCELA` (`ClienteCancelaID`),
  CONSTRAINT `FK_ClienteID_8` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla en donde se registran las entregas que se harÃ¡n en ve'$$