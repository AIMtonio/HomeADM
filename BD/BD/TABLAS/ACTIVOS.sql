-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `ACTIVOS`;

DELIMITER $$
CREATE TABLE `ACTIVOS` (
  `ActivoID` int(11) NOT NULL COMMENT 'Idetinficador del activo',
  `TipoActivoID` int(11) NOT NULL COMMENT 'Idetinficador del tipo de activo tabla TIPOSACTIVOS',
  `Descripcion` varchar(300) NOT NULL COMMENT 'Descripcion del activo',
  `FechaAdquisicion` date NOT NULL COMMENT 'Fecha de adquisicion',
  `ProveedorID` int(11) NOT NULL COMMENT 'Idetinficador del proveedor',
  `NumFactura` varchar(50) NOT NULL COMMENT 'Numero de factura',
  `NumSerie` varchar(100) NOT NULL COMMENT 'Numero de serie',
  `Moi` decimal(16,2) NOT NULL COMMENT 'Monto Original Inversion(MOI)',
  `DepreciadoAcumulado` decimal(16,2) NOT NULL COMMENT 'Depreciado Acumulado',
  `TotalDepreciar` decimal(16,2) NOT NULL COMMENT 'Total por Depreciar',
  `MesesUso` int(11) NOT NULL COMMENT 'Meses de Uso',
  `PolizaFactura` bigint(12) NOT NULL COMMENT 'Poliza Factura',
  `CentroCostoID` int(11) NOT NULL COMMENT 'Centro de Costo',
  `CtaContable` varchar(50) NOT NULL COMMENT 'Numero de Cuenta Contable Depreciación',
  `CtaContableRegistro` varchar(50) NOT NULL COMMENT 'Numero de Cuenta Contable de Registro',
  `Estatus` char(2) NOT NULL COMMENT 'Indica el estatus del activo, VI=VIGENTE, BA=BAJA, VE=VENDIDO',
  `TipoRegistro` char(1) NOT NULL COMMENT 'Indica cual fue el tipo de registro del activo. \nA.- Atomatico \nM.-manual \nP.- Proceso Masivo',
  `FechaRegistro` date NOT NULL COMMENT 'Fecha de registro del activo',
  `EsDepreciado` char(1) NOT NULL COMMENT 'Indica S= si el activo ya se esta depreciado y no se puede modificar, N= no se ha depreciado y es editable',
  `SucursalID` int(11) NOT NULL COMMENT 'ID de la sucursal donde se da de alta el activo',
  `NumeroConsecutivo`     CHAR(11) NOT NULL COMMENT 'Número asignado al activo de acuerdo al tipo de activo.',
  `PorDepFiscal`          DECIMAL(16,2) NOT NULL COMMENT 'Porcentaje de depreciación fiscal para el activo.',
  `DepFiscalSaldoInicio`  DECIMAL(16,2) NOT NULL COMMENT 'Saldo inicial de acuerdo a la depreciación fiscal.',
  `DepFiscalSaldoFin`     DECIMAL(16,2) NOT NULL COMMENT 'Saldo final de acuerdo a la depreciación fiscal.',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`ActivoID`),
  KEY `idx_ACTIVOS_1` (`TipoActivoID`),
  KEY `idx_ACTIVOS_2` (`ProveedorID`),
  KEY `idx_ACTIVOS_3` (`PolizaFactura`),
  KEY `idx_ACTIVOS_4` (`CtaContable`),
  KEY `idx_ACTIVOS_5` (`Estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena datos de los activos'$$
