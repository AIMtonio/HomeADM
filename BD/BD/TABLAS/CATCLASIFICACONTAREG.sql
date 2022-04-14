-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCLASIFICACONTAREG
DELIMITER ;
DROP TABLE IF EXISTS `CATCLASIFICACONTAREG`;DELIMITER $$

CREATE TABLE `CATCLASIFICACONTAREG` (
  `ClasificaContaRegID` int(11) NOT NULL COMMENT 'Consecutivo para las opciones',
  `CodigoOpcion` varchar(30) NOT NULL COMMENT 'ID de la opcion para el MenuID',
  `Descripcion` varchar(250) NOT NULL COMMENT 'Descripcion de la opcion',
  `Plazo` int(11) DEFAULT NULL COMMENT 'Plazo de la opcion 1: corto plazo, 2	: largo Plazo.',
  `TipoInstitucion` int(11) DEFAULT NULL COMMENT 'Tipo de Institucion de la opccion 003-Sofipos 006-scap ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usario ID',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`ClasificaContaRegID`),
  KEY `index2` (`CodigoOpcion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$