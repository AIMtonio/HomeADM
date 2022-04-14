-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOBALANZA
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOBALANZA`;DELIMITER $$

CREATE TABLE `CONCEPTOBALANZA` (
  `ConBalanzaID` bigint(11) NOT NULL,
  `Descripcion` varchar(100) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConBalanzaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Conceptos de la Balanza'$$