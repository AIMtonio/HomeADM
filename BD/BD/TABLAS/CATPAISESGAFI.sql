-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPAISESGAFI
DELIMITER ;
DROP TABLE IF EXISTS `CATPAISESGAFI`;DELIMITER $$

CREATE TABLE `CATPAISESGAFI` (
  `PaisID` int(11) NOT NULL COMMENT 'Numero de Pais, corresponde al ID de PAISES.',
  `Nombre` varchar(150) NOT NULL COMMENT 'Nombre del Pais.',
  `TipoPais` char(1) NOT NULL COMMENT 'N.- Paises No Cooperantes\nM.- Paises en Mejora',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`PaisID`,`TipoPais`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de los Paises GAFI.'$$