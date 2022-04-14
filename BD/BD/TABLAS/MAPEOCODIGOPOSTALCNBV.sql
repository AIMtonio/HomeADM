-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MAPEOCODIGOPOSTALCNBV
DELIMITER ;
DROP TABLE IF EXISTS `MAPEOCODIGOPOSTALCNBV`;DELIMITER $$

CREATE TABLE `MAPEOCODIGOPOSTALCNBV` (
  `CPSAFI` char(5) NOT NULL COMMENT 'Es el campo CodigoPostal de la tabla DIRECCLIENTE',
  `CPCNBV` char(5) DEFAULT NULL COMMENT 'Codigo Postal el cual se debe mostrar para reportar ante la CNBV ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`CPSAFI`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla donde se sustituyen los Codigos Postales que tiene SAFI y que no existen en el Catalogo de la CNBV.'$$