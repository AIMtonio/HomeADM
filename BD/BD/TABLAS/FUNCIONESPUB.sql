-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONESPUB
DELIMITER ;
DROP TABLE IF EXISTS `FUNCIONESPUB`;DELIMITER $$

CREATE TABLE `FUNCIONESPUB` (
  `FuncionID` int(11) NOT NULL COMMENT 'ID de la funcion',
  `Empresa` int(11) DEFAULT NULL,
  `Descripcion` varchar(150) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FuncionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Funciones Publicas\n'$$