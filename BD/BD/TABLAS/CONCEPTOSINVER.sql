-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSINVER
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSINVER`;DELIMITER $$

CREATE TABLE `CONCEPTOSINVER` (
  `ConceptoInvID` int(11) NOT NULL COMMENT 'ID o Llave del \nConcepto',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion\nDel Concepto\nContable',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoInvID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Conceptos Contables del Modulo de inversiones'$$