-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-NOMINAEMPLEADOS
DELIMITER ;
DROP TABLE IF EXISTS `HIS-NOMINAEMPLEADOS`;DELIMITER $$

CREATE TABLE `HIS-NOMINAEMPLEADOS` (
  `Fecha` date NOT NULL,
  `InstitNominaID` int(11) NOT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `ProspectoID` int(11) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL,
  `FechaInicioInca` date DEFAULT NULL,
  `FechaFinInca` date DEFAULT NULL,
  `FechaBaja` date DEFAULT NULL,
  `MotivoBaja` varchar(200) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$