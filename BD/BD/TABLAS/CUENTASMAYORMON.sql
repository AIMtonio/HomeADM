-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORMON
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORMON`;DELIMITER $$

CREATE TABLE `CUENTASMAYORMON` (
  `ConceptoMonID` int(11) NOT NULL COMMENT 'Concepto\nCONCEPTOSDIVISA',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa',
  `Cuenta` varchar(25) NOT NULL COMMENT 'Cuenta de\nMayor',
  `Nomenclatura` varchar(60) NOT NULL COMMENT 'Nomenclatura de\nla Cuenta',
  `NomenclaturaCR` varchar(60) NOT NULL,
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha',
  `DireccionIP` varchar(20) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa o\nAplicacion',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de \nTransaccion',
  PRIMARY KEY (`ConceptoMonID`,`EmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas Contables para el manejo de Divisas o Monedas'$$