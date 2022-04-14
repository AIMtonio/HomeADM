-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IEDESEMBOLSOSSUCURSALES
DELIMITER ;
DROP TABLE IF EXISTS `IEDESEMBOLSOSSUCURSALES`;DELIMITER $$

CREATE TABLE `IEDESEMBOLSOSSUCURSALES` (
  `Sucursal` varchar(20) NOT NULL,
  `MontoTotal` decimal(12,2) NOT NULL,
  `NumeroCreditos` int(11) NOT NULL,
  `FechaDescuento` date NOT NULL,
  `Descripcion` varchar(200) NOT NULL,
  `numeroCuentaSic` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$