-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MAPEOLOCALIDADESCNBV
DELIMITER ;
DROP TABLE IF EXISTS `MAPEOLOCALIDADESCNBV`;DELIMITER $$

CREATE TABLE `MAPEOLOCALIDADESCNBV` (
  `LocalidadSAFI` varchar(13) NOT NULL COMMENT 'Es el campo LocalidadCNBV de la tabla LOCALIDADREPUB',
  `LocalidadCNBV` varchar(13) DEFAULT NULL COMMENT 'Campo el cual se debe mostrar para reportar ante la CNBV ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`LocalidadSAFI`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla donde se sustituyen las localidades tiene SAFI y que no existen en el Catalogo de la CNBV.'$$