-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATSISTEMAFINMEX
DELIMITER ;
DROP TABLE IF EXISTS `CATSISTEMAFINMEX`;DELIMITER $$

CREATE TABLE `CATSISTEMAFINMEX` (
  `ClaveEntidad` varchar(10) NOT NULL COMMENT 'Clave de la Entidad Financiera',
  `NombreEntidad` varchar(200) NOT NULL COMMENT 'Nombre de la Entidad Financiera',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`ClaveEntidad`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo del Sistema Financiero Mexicano (CSFM).'$$