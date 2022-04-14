-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCONCEPTOSINVERAGRO
DELIMITER ;
DROP TABLE IF EXISTS `CATCONCEPTOSINVERAGRO`;DELIMITER $$

CREATE TABLE `CATCONCEPTOSINVERAGRO` (
  `ConceptoFiraID` int(11) NOT NULL COMMENT 'Identificador del concepto de inversion',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion del concepto.',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del concepto V=vigente I=Inactivo.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion',
  PRIMARY KEY (`ConceptoFiraID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Conceptos de InversionFira'$$