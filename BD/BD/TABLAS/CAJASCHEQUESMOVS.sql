-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASCHEQUESMOVS
DELIMITER ;
DROP TABLE IF EXISTS `CAJASCHEQUESMOVS`;DELIMITER $$

CREATE TABLE `CAJASCHEQUESMOVS` (
  `consecutivo` bigint(20) NOT NULL COMMENT 'Numero consecutivo de movimiento por transaccion',
  `SucursalID` int(11) NOT NULL COMMENT 'Se refiere al ID de la sucursal de donde es la caja',
  `CajaID` int(11) NOT NULL COMMENT 'Se refiere al ID de la caja de cheques',
  `InstitucionID` int(11) NOT NULL COMMENT 'Numero de la Institucion Bancaria',
  `NumCtaInstit` bigint(12) NOT NULL DEFAULT '0',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de \nTransaccion',
  `EstatusCambiado` char(1) NOT NULL COMMENT 'Se refiere al Estatus que tendra Actualizado',
  `EstatusOriginal` char(1) NOT NULL COMMENT 'Se refiere al ID de la caja de cheques',
  `FechaActualizacion` datetime NOT NULL COMMENT 'Se refiere a la Fecha cuando se hizo la modificación del estatus',
  `FolioUtilizar` bigint(20) NOT NULL COMMENT ' Se refiere al Último Folio del Cheque a Utilizar',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`consecutivo`,`SucursalID`,`CajaID`,`InstitucionID`,`NumCtaInstit`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$