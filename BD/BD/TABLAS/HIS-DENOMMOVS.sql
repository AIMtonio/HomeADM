-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-DENOMMOVS
DELIMITER ;
DROP TABLE IF EXISTS `HIS-DENOMMOVS`;
DELIMITER $$


CREATE TABLE `HIS-DENOMMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `FechaCorte` date NOT NULL COMMENT 'Campo que nos indica la fecha en la que se paso al historico',
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal donde se encuentra Asignada la Caja',
  `CajaID` int(11) NOT NULL COMMENT 'ID o Numero de Caja',
  `Fecha` date NOT NULL COMMENT 'Fecha del Movimiento',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de \nTransaccion',
  `Naturaleza` int(11) NOT NULL COMMENT 'Naturaleza de la\n Operacion\n1 .- Entrada\n2 .- Salida',
  `DenominacionID` int(11) NOT NULL COMMENT 'Consecutivo de denominación',
  `Cantidad` decimal(14,2) NOT NULL COMMENT 'Cantidad de la Denominacion',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto del Movimiento = Cantidad * Valor Denominacion',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Numero o ID de la Moneda',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `Idx_HisDenomMov_FechaCajaSuc` (`SucursalID`,`FechaCorte`,`CajaID`),
  KEY `Idx_HisDenomMov_FechaCajaSucDen` (`FechaCorte`,`SucursalID`,`CajaID`,`DenominacionID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico Movs de las Denominaciones'$$
