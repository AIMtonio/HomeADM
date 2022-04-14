-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMSCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `PARAMSCREDITO`;DELIMITER $$

CREATE TABLE `PARAMSCREDITO` (
  `FechaActualCar` date DEFAULT NULL COMMENT 'Fecha del Sistema de Cartera',
  `ManejaCuentaAho` char(1) DEFAULT NULL COMMENT 'Maneja cuenta de ahorro  S .- Si Maneja  N .- No Maneja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros Generales del Modulo de Credito'$$