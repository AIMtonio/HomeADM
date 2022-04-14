-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPORESULESCPLD
DELIMITER ;
DROP TABLE IF EXISTS `TIPORESULESCPLD`;DELIMITER $$

CREATE TABLE `TIPORESULESCPLD` (
  `TipoResultEscID` char(1) NOT NULL COMMENT 'clave del resultado del escalamiento',
  `Descripcion` varchar(30) DEFAULT NULL COMMENT 'descripcion del resultado de escalamiento',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoResultEscID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo  de resultados de revision de escalamiento interno	'$$