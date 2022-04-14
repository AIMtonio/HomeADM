-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADOSREPUB
DELIMITER ;
DROP TABLE IF EXISTS `ESTADOSREPUB`;DELIMITER $$

CREATE TABLE `ESTADOSREPUB` (
  `EstadoID` int(11) NOT NULL COMMENT 'Numero de Estado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Numero de la Empresa',
  `Nombre` varchar(100) DEFAULT NULL COMMENT 'Nombre de la Empresa',
  `EqBuroCred` varchar(5) DEFAULT NULL COMMENT 'Equivalente a la clave del Estado de acuerdo a los catalogos de Buro de Credito',
  `EqCirCre` varchar(4) DEFAULT NULL COMMENT 'Equivalente a la clave del Estado de acuerdo a los catalogos de Circulo de Credito',
  `Clave` char(2) DEFAULT NULL COMMENT 'Indica la normativa para la generacion de la CURP',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EstadoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Estados de la Republica'$$