-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCONDICIONES
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOCONDICIONES`;DELIMITER $$

CREATE TABLE `SEGTOCONDICIONES` (
  `CondicionID` int(11) NOT NULL,
  `Descripcion` varchar(45) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CondicionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Condiciones para Seguimiento de Campo	'$$