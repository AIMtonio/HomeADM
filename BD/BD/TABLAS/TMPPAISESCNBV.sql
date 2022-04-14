-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPAISESCNBV
DELIMITER ;
DROP TABLE IF EXISTS `TMPPAISESCNBV`;DELIMITER $$

CREATE TABLE `TMPPAISESCNBV` (
  `PaisCNBV` int(11) NOT NULL COMMENT 'Clave del pais en numero.',
  `ClaveCNBV` varchar(45) DEFAULT NULL COMMENT 'Clave del pais tipo nomenclatura',
  `Nombre` varchar(200) DEFAULT NULL COMMENT 'Nombre completo del pais.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`PaisCNBV`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal que servirá como referencia con las nuevas claves del catálogo.'$$