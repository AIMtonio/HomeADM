-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSPEIIE
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSSPEIIE`;DELIMITER $$

CREATE TABLE `PARAMETROSSPEIIE` (
  `EmpresaID` int(11) NOT NULL COMMENT 'Numero o ID de la Empresa',
  `CtaDDIESpei` varchar(20) NOT NULL COMMENT 'Cuenta contable deudores diversos IE para transferencias SPEI',
  `CtaDDIETrans` varchar(20) NOT NULL COMMENT 'Cuenta contable deudores diversos IE para Transferencias',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`EmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros SPEI, INCORPORATED EXPRESS'$$