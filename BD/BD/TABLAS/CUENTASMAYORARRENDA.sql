-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORARRENDA`;DELIMITER $$

CREATE TABLE `CUENTASMAYORARRENDA` (
  `ConceptoArrendaID` int(5) NOT NULL COMMENT 'Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento',
  `Cuenta` char(4) DEFAULT NULL COMMENT 'Capital de la cuenta de Arrendamiento',
  `Nomenclatura` varchar(30) DEFAULT NULL COMMENT 'Nomenclatura de la Arrendamiento',
  `NomenclaturaCR` varchar(30) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoArrendaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas Mayor para el Modulo de Cuentas de arrendamiento'$$