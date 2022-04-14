-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOVIMIENTOSINTER
DELIMITER ;
DROP TABLE IF EXISTS `MOVIMIENTOSINTER`;DELIMITER $$

CREATE TABLE `MOVIMIENTOSINTER` (
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `FechaOpe` date DEFAULT NULL,
  `Descripcion` varchar(150) DEFAULT NULL,
  `TipoMov` char(4) DEFAULT NULL,
  `MontoMov` decimal(12,2) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tabla auxiliar para la conciliacion almacena datos de TESORE'$$