-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPINTEGRACONTRATOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPINTEGRACONTRATOS`;DELIMITER $$

CREATE TABLE `TMPINTEGRACONTRATOS` (
  `NombreIntegrante` varchar(100) DEFAULT NULL,
  `DireccionIntegrante` varchar(500) DEFAULT NULL,
  `Comision` decimal(14,2) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `Consecutivo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$