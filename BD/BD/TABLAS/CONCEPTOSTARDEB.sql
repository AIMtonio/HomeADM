-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSTARDEB
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSTARDEB`;DELIMITER $$

CREATE TABLE `CONCEPTOSTARDEB` (
  `ConceptoTarDebID` int(11) NOT NULL COMMENT 'ID o Numero del Concepto Contable de Tarjeta de Debito',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoTarDebID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Conceptos Contables de Tarjeta de Debito'$$