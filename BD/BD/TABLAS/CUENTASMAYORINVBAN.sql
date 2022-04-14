-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORINVBAN
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORINVBAN`;DELIMITER $$

CREATE TABLE `CUENTASMAYORINVBAN` (
  `ConceptoInvBanID` int(11) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVERBAN',
  `Cuenta` char(4) DEFAULT NULL COMMENT 'Numero de Cuenta Mayor',
  `Nomenclatura` varchar(60) DEFAULT NULL COMMENT 'Nomenclatura de la cuenta',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoInvBanID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$