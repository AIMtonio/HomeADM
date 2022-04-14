-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATESTRATIFICACION
DELIMITER ;
DROP TABLE IF EXISTS `CATESTRATIFICACION`;DELIMITER $$

CREATE TABLE `CATESTRATIFICACION` (
  `ClaveID` int(11) NOT NULL COMMENT 'Clave del Estratificacion',
  `Tamanio` varchar(15) DEFAULT NULL COMMENT 'Tamano de la empresa',
  `TopeMinimo` decimal(6,2) DEFAULT NULL COMMENT 'Tope Minimo combinado',
  `TopeMaximo` decimal(16,2) DEFAULT NULL COMMENT 'Tope maximo combinado',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClaveID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CATALOGO DE NIVEL DE ESTATIFICACION SITI'$$