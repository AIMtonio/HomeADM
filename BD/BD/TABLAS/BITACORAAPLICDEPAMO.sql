-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAAPLICDEPAMO
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAAPLICDEPAMO`;DELIMITER $$

CREATE TABLE `BITACORAAPLICDEPAMO` (
  `BitApliDepAmoID` int(11) NOT NULL COMMENT 'Consecutivo bitacora aplicacion de depreciacion y amortizacion de activos',
  `Anio` int(11) NOT NULL COMMENT 'Anio en que se realiza el proceso de depreciacion y amortizacion',
  `Mes` int(11) NOT NULL COMMENT 'Mes en que se realiza el proceso de depreciacion y amortizacion',
  `Fecha` date NOT NULL COMMENT 'Fecha de aplicacion del proceso de depreciacion y amortizacion',
  `Hora` time NOT NULL COMMENT 'Hora de aplicacion del proceso de depreciacion y amortizacion',
  `UsuarioID` int(11) NOT NULL COMMENT 'Usuario que realilza el proceso de depreciacion y amortizacion',
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal donde se realiza el proceso de depreciacion y amortizacion',
  `PolizaID` bigint(20) NOT NULL,
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`BitApliDepAmoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla almacena bitacora de la aplicacion del proceso de depreciacion y amortizacion de activos'$$