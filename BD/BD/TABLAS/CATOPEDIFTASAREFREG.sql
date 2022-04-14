-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATOPEDIFTASAREFREG
DELIMITER ;
DROP TABLE IF EXISTS `CATOPEDIFTASAREFREG`;DELIMITER $$

CREATE TABLE `CATOPEDIFTASAREFREG` (
  `OpeTasaRefRegID` int(11) NOT NULL COMMENT 'Consecutivo para las opciones',
  `CodigoOpcion` varchar(30) NOT NULL COMMENT 'ID de la opcion para el MenuID',
  `Descripcion` varchar(250) NOT NULL COMMENT 'Descripcion de la opcion',
  `TipoInstitucion` int(11) DEFAULT NULL COMMENT 'Tipo de Institucion de la opccion 003-Sofipos 006-scap ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usario ID',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`OpeTasaRefRegID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$