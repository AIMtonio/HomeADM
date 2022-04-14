-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEASCREDITOMOVS
DELIMITER ;
DROP TABLE IF EXISTS `LINEASCREDITOMOVS`;DELIMITER $$

CREATE TABLE `LINEASCREDITOMOVS` (
  `LineaCreditoID` int(11) NOT NULL,
  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `Fecha` date NOT NULL,
  `NatMovimiento` char(1) NOT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `Referencia` varchar(50) DEFAULT NULL,
  `MonedaID` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$