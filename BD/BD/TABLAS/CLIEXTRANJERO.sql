-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIEXTRANJERO
DELIMITER ;
DROP TABLE IF EXISTS `CLIEXTRANJERO`;DELIMITER $$

CREATE TABLE `CLIEXTRANJERO` (
  `ClienteID` int(11) NOT NULL COMMENT 'ID o Numero de Clientes',
  `Inmigrado` char(1) DEFAULT NULL COMMENT 'Calidad de \nImigrado \n(S .- SI, N .- NO)',
  `DocumentoLegal` char(3) DEFAULT NULL COMMENT 'Documento que Establece su Estancia Legal\nEn el Pais',
  `MotivoEstancia` varchar(30) DEFAULT NULL,
  `FechaVencimien` date DEFAULT NULL COMMENT 'Fecha de Vencimiento del Documento    ',
  `Entidad` varchar(100) DEFAULT NULL COMMENT 'Entidad del Domicilio en el Extranjero  ',
  `Localidad` varchar(100) DEFAULT NULL COMMENT 'Localidad del Domicilio en el Extranjero',
  `Colonia` varchar(150) DEFAULT NULL COMMENT 'Colonia',
  `Calle` varchar(50) DEFAULT NULL COMMENT 'Calle\n',
  `NumeroCasa` varchar(10) DEFAULT NULL COMMENT 'Número de la Casa',
  `NumeroIntCasa` varchar(10) DEFAULT NULL COMMENT 'Número Interior de la Casa',
  `Adi_CoPoEx` char(6) DEFAULT NULL COMMENT 'Codigo Postal del Domicilio    ',
  `PaisRFC` int(11) DEFAULT NULL COMMENT 'Pais de Registro Fiscal',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Direccion del cliente Extanjero\n'$$