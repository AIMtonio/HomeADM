-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONFIGPRODUCTO
DELIMITER ;
DROP TABLE IF EXISTS `PSLCONFIGPRODUCTO`;DELIMITER $$

CREATE TABLE `PSLCONFIGPRODUCTO` (
  `ProductoID` int(11) NOT NULL COMMENT 'Id del producto',
  `ServicioID` int(11) NOT NULL COMMENT 'Id de servicio del Broker',
  `ClasificacionServ` char(2) NOT NULL COMMENT 'Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)',
  `Producto` varchar(200) NOT NULL COMMENT 'Nombre del producto',
  `Habilitado` char(1) NOT NULL COMMENT 'Bandera para habilitar el producto en los canales (S = SI, N = NO)',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del producto (A = Activo, B = Baja)',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ProductoID`),
  KEY `INDEX_PSLCONFIGPRODUCTO_1` (`ProductoID`),
  KEY `INDEX_PSLCONFIGPRODUCTO_2` (`ServicioID`),
  KEY `INDEX_PSLCONFIGPRODUCTO_3` (`ClasificacionServ`),
  KEY `INDEX_PSLCONFIGPRODUCTO_4` (`ServicioID`,`ClasificacionServ`),
  CONSTRAINT `FK_PSLCONFIGPRODUCTO_1` FOREIGN KEY (`ServicioID`, `ClasificacionServ`) REFERENCES `PSLCONFIGSERVICIO` (`ServicioID`, `ClasificacionServ`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar la configuracion de productos de los servicios en linea.'$$