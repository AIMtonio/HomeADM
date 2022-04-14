-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANZADENOM_RESP12OCT
DELIMITER ;
DROP TABLE IF EXISTS `BALANZADENOM_RESP12OCT`;DELIMITER $$

CREATE TABLE `BALANZADENOM_RESP12OCT` (
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de \nSucursal',
  `CajaID` int(11) NOT NULL COMMENT 'ID o Numero\n de Caja',
  `DenominacionID` int(11) NOT NULL COMMENT 'Consecutivo \nde denominación',
  `MonedaID` int(11) NOT NULL COMMENT 'Numero de \nMoneda',
  `Cantidad` decimal(12,2) NOT NULL COMMENT 'Cantidad de billetes o monedas\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$