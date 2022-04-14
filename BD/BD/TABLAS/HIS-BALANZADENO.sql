-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-BALANZADENO
DELIMITER ;
DROP TABLE IF EXISTS `HIS-BALANZADENO`;
DELIMITER $$


CREATE TABLE `HIS-BALANZADENO` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fecha` date NOT NULL COMMENT 'Campo que nos indica la fecha en la que se paso al historico',
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de \nSucursal',
  `CajaID` int(11) NOT NULL COMMENT 'ID o Numero\n de Caja',
  `DenominacionID` int(11) NOT NULL COMMENT 'Consecutivo \nde denominación',
  `MonedaID` int(11) NOT NULL COMMENT 'Numero de \nMoneda',
  `Cantidad` decimal(14,2) NOT NULL COMMENT 'Tipo de \ndenominación \nM=Moneda, \nB= Billete',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_HIS-BALANZADENO_1` (`SucursalID`,`Fecha`,`CajaID`,`MonedaID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Histórico de Balanza Actual de Denominaciones, Efectivo'$$
