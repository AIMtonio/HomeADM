-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROSARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `SEGUROSARRENDA`;DELIMITER $$

CREATE TABLE `SEGUROSARRENDA` (
  `SeguroArrendaID` int(11) NOT NULL COMMENT 'Numero de ID de la aseguradora',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion o nombre de la aseguradora',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguroArrendaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para seguro de arrendamiento'$$