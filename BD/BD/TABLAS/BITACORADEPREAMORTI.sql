-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORADEPREAMORTI
DELIMITER ;
DROP TABLE IF EXISTS `BITACORADEPREAMORTI`;DELIMITER $$

CREATE TABLE `BITACORADEPREAMORTI` (
  `DepreAmortiID` int(11) NOT NULL COMMENT 'Consecutivo del movimiento de depreciacion y amortizacion del activo',
  `ActivoID` int(11) NOT NULL COMMENT 'Idetinficador del activo',
  `Moi` decimal(16,2) NOT NULL COMMENT 'Monto Original Inversion(MOI)',
  `DepreciacionAnual` decimal(14,2) NOT NULL COMMENT 'Indica el % que corresponde al tipo de activo, puede ser un valor a dos decimales en un rango del 1 al 100',
  `TiempoAmortiMeses` int(11) NOT NULL COMMENT 'Indica el tiempo en meses que se consideraran para amortizar el activo esto solo tratandose de "Otros Activos", en el caso de "Activo Fijo" su valor sera 12 ya que corresponde al periodo de un anio',
  `DepreciaContaAnual` decimal(16,2) NOT NULL COMMENT 'Indica el monto de Depreciacion Contable Anual',
  `Anio` int(11) NOT NULL COMMENT 'Anio en que se realiza el proceso de depreciacion y amortizacion',
  `Mes` int(11) NOT NULL COMMENT 'Mes en que se realiza el proceso de depreciacion y amortizacion',
  `DepreAcuInicio` decimal(16,2) NOT NULL COMMENT 'Depreciado Acumulado con el que inicio el activo',
  `TotalDepreciarIni` decimal(16,2) NOT NULL COMMENT 'Total por Depreciar con el que inicio el activo',
  `MontoDepreciar` decimal(16,2) NOT NULL COMMENT 'Monto por Depreciar',
  `DepreciadoAcumulado` decimal(16,2) NOT NULL COMMENT 'Monto depreciado acumulado',
  `SaldoPorDepreciar` decimal(16,2) NOT NULL COMMENT 'Saldo por depreciar',
  `Estatus` char(1) NOT NULL COMMENT 'Indica el estatus del movimiento de depreciacion y amortizacion R=Registrado o A=Aplicado',
  `FechaAplicacion` date NOT NULL COMMENT 'Fecha de aplicacion del proceso de depreciacion y amortizacion',
  `UsuarioID` int(11) NOT NULL COMMENT 'Usuario que realilza el proceso de depreciacion y amortizacion',
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal donde se realiza el proceso de depreciacion y amortizacion',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`DepreAmortiID`,`ActivoID`),
  KEY `fk_BITACORADEPREAMORTI_1` (`ActivoID`),
  CONSTRAINT `fk_BITACORADEPREAMORTI_1` FOREIGN KEY (`ActivoID`) REFERENCES `ACTIVOS` (`ActivoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla almacena los movimientos de depreciacion y amortizacion de activos'$$