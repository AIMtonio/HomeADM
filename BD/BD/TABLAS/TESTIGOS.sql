-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESTIGOS
DELIMITER ;
DROP TABLE IF EXISTS `TESTIGOS`;DELIMITER $$

CREATE TABLE `TESTIGOS` (
  `TestigoID` int(11) NOT NULL COMMENT 'Id del Testigo.',
  `NombreCompleto` varchar(300) NOT NULL COMMENT 'Nombre Completo del Testigo.',
  `DireccionCompleta` varchar(500) NOT NULL COMMENT 'Dirección Completa del Testigo.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`TestigoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ALMACENA LA INFORMACIÓN DE TESTIGOS USADA EN LOS CONTRATOS DE CREDITOS AGRO.'$$