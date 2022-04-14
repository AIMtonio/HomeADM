-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLPRODBROKER
DELIMITER ;
DROP TABLE IF EXISTS `PSLPRODBROKER`;DELIMITER $$

CREATE TABLE `PSLPRODBROKER` (
  `FechaCatalogo` datetime NOT NULL COMMENT 'Fecha en la que se consulto el catalogo',
  `ServicioID` int(11) NOT NULL COMMENT 'Id del servicio del Broker',
  `Servicio` varchar(100) NOT NULL COMMENT 'Nombre del Servicio',
  `TipoServicio` int(11) NOT NULL COMMENT 'Tipo de servicio del Broker',
  `ProductoID` int(11) NOT NULL COMMENT 'Id del producto del Broker',
  `Producto` varchar(200) NOT NULL COMMENT 'Nombre del producto',
  `TipoFront` int(11) NOT NULL COMMENT 'TipoFront del Broker',
  `DigVerificador` char(1) NOT NULL COMMENT 'Digito verificador',
  `Precio` decimal(14,2) NOT NULL COMMENT 'Precio del producto',
  `ShowAyuda` char(1) NOT NULL COMMENT 'Campo ShowAyuda',
  `TipoReferencia` varchar(20) NOT NULL COMMENT 'Campo para el tipo de referencia',
  `ClasificacionServ` char(2) NOT NULL COMMENT 'Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ProductoID`),
  KEY `INDEX_PSLPRODBROKER_1` (`ProductoID`),
  KEY `INDEX_PSLPRODBROKER_2` (`ServicioID`),
  KEY `INDEX_PSLPRODBROKER_3` (`ClasificacionServ`),
  KEY `INDEX_PSLPRODBROKER_4` (`ServicioID`,`ClasificacionServ`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los productos del Broker.'$$