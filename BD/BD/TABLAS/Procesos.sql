-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- Procesos
DELIMITER ;
DROP TABLE IF EXISTS `Procesos`;DELIMITER $$

CREATE TABLE `Procesos` (
  `nombre` varchar(11) DEFAULT NULL,
  `tabla` varchar(8) DEFAULT NULL,
  `descripcion` text,
  `parametros` text,
  `tabafecta` text,
  `salida` text,
  `error` text,
  `codigo` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$