-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCLAVESOBS
DELIMITER ;
DROP TABLE IF EXISTS `CATCLAVESOBS`;DELIMITER $$

CREATE TABLE `CATCLAVESOBS` (
  `Clave` varchar(5) DEFAULT NULL COMMENT 'CLAVE ',
  `Descripcion` varchar(10000) DEFAULT NULL COMMENT 'Descripcion corta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Claves de la OBS, se utiliza esta tabla en buro de credito'$$