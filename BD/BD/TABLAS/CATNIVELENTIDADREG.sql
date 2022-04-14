-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATNIVELENTIDADREG
DELIMITER ;
DROP TABLE IF EXISTS `CATNIVELENTIDADREG`;DELIMITER $$

CREATE TABLE `CATNIVELENTIDADREG` (
  `NivelEntidadRegID` int(11) NOT NULL COMMENT 'Consecutivo para las opciones',
  `CodigoOpcion` varchar(6) NOT NULL COMMENT 'ID de la opcion para el MenuID',
  `DesNivelOpera` varchar(250) NOT NULL COMMENT 'Descripcion Nivel Operacion',
  `DesRegPruden` varchar(250) NOT NULL COMMENT 'Descripcion Regulacion Prudencial',
  `Desplegado` varchar(250) NOT NULL COMMENT 'Desplegado pantalla parametros generales',
  `TipoInstitucion` int(11) DEFAULT NULL COMMENT 'Tipo de Institucion de la opccion 003-Sofipos 006-scap ',
  `NivelOperacionID` int(11) DEFAULT NULL COMMENT 'Clave de Nivel de Operaciones - CATPRUDENCIALOPERA',
  `NivelPrudencialID` int(11) DEFAULT NULL COMMENT 'Clave de Nivel de Regulación Prudencial - CATPRUDENCIALOPERA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usario ID',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`NivelEntidadRegID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo Nivel Institucion'$$