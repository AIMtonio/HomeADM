-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_SaldosCaptacion
DELIMITER ;
DROP TABLE IF EXISTS `tmp_SaldosCaptacion`;DELIMITER $$

CREATE TABLE `tmp_SaldosCaptacion` (
  `NumCuenta` bigint(12) DEFAULT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `Importe` decimal(18,2) DEFAULT NULL,
  `SaldoGarantias` decimal(18,2) DEFAULT NULL,
  `Sucursal` varchar(100) DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL,
  `Producto` varchar(50) DEFAULT NULL,
  `TipoProducto` varchar(20) DEFAULT NULL,
  `NombreCliente` varchar(500) DEFAULT NULL,
  `Estatus` varchar(15) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$