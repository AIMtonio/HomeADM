-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOVIMIENTOSEXTER
DELIMITER ;
DROP TABLE IF EXISTS `MOVIMIENTOSEXTER`;DELIMITER $$

CREATE TABLE `MOVIMIENTOSEXTER` (
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `FechaOperacion` date DEFAULT NULL,
  `DescripcionMov` varchar(150) DEFAULT NULL,
  `TipoMovs` char(4) DEFAULT NULL,
  `MontoMovs` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tabla auxiliar para la conciliacion almacena datos de TESOMO'$$