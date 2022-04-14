-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASCHEQUERA
DELIMITER ;
DROP TABLE IF EXISTS `CAJASCHEQUERA`;DELIMITER $$

CREATE TABLE `CAJASCHEQUERA` (
  `InstitucionID` int(11) NOT NULL COMMENT 'Se refiere al ID de la institucion Financiera',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NumCtaInstit` varchar(20) NOT NULL COMMENT 'Se refiere al numero de cuenta de la institución financiera',
  `SucursalID` int(11) NOT NULL COMMENT 'Se refiere al ID de la sucursal ',
  `CajaID` int(11) NOT NULL COMMENT 'Se refiere al ID de la caja de la sucursal',
  `DescripcionCaja` varchar(100) DEFAULT NULL COMMENT 'Descripcion de la caja ',
  `TipoCaja` char(2) NOT NULL COMMENT 'CP .- Caja\n	 Principal de\n	 Sucursal\nBG .- Boveda\n	 Central\nCA .- Caja de\n	Atencion al\n	Publico',
  `FolioCheqInicial` bigint(20) NOT NULL DEFAULT '0',
  `FolioCheqFinal` bigint(20) NOT NULL DEFAULT '0',
  `FolioUtilizar` bigint(20) NOT NULL COMMENT ' Se refiere al Último Folio del Cheque a Utilizar',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la caja respecto a la asignacion de cheques',
  `FechaActEstatus` datetime NOT NULL COMMENT 'Fecha en la que se actualizo el estatus',
  `TipoChequera` char(2) NOT NULL DEFAULT '' COMMENT 'Especifica el tipo de chequera que se estará utilizando, los posibles valores son:\nE - Estandar\nP - Proforma',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InstitucionID`,`NumCtaInstit`,`SucursalID`,`CajaID`,`TipoChequera`,`FolioCheqInicial`,`FolioCheqFinal`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$