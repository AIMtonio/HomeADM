-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCARTERA
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSCARTERA`;DELIMITER $$

CREATE TABLE `CONCEPTOSCARTERA` (
  `ConceptoCarID` int(11) NOT NULL,
  `Descripcion` varchar(100) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoCarID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$