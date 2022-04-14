-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPAGOPROV
DELIMITER ;
DROP TABLE IF EXISTS `TIPOPAGOPROV`;DELIMITER $$

CREATE TABLE `TIPOPAGOPROV` (
  `TipoPagoProvID` int(11) NOT NULL,
  `Descripcion` varchar(50) DEFAULT NULL,
  `CuentaContable` varchar(25) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoPagoProvID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$