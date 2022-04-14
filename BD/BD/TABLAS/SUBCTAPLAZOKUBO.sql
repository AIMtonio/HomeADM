-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOKUBO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAPLAZOKUBO`;DELIMITER $$

CREATE TABLE `SUBCTAPLAZOKUBO` (
  `ConceptoKuboID` int(11) NOT NULL DEFAULT '0' COMMENT 'Concepto\nContable\n',
  `NumRetiros` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de \nRetiros en el\nMes',
  `Subcuenta` char(2) DEFAULT NULL COMMENT 'SubCuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual\n',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP\n',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ProgramaID\n',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal\n',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de \nTransaccion',
  PRIMARY KEY (`ConceptoKuboID`,`NumRetiros`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por plazo'$$