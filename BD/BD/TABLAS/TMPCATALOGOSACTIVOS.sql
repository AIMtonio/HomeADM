-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCATALOGOSACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCATALOGOSACTIVOS`;
DELIMITER $$

CREATE TABLE `TMPCATALOGOSACTIVOS` (
	`ConsecutivoID` INT(11) DEFAULT '0' COMMENT 'Consecutivo de la Tabla',
	`TipoActivoID` INT(11) COMMENT 'Idetinficador del tipo de activo tabla TIPOSACTIVOS' ,
	`ActivoID` INT(11)  DEFAULT '0' COMMENT 'Idetinficador Activo ID',
	`DescTipoActivo` VARCHAR(350) COMMENT 'Descripcion del Tipo de Activo',
	`DescActivo` VARCHAR(350) COMMENT 'Descripcion del Activo ID',
	`FechaAdquisicion` DATE COMMENT 'Fecha de adquisicion del Activo',
	`NumFactura` VARCHAR(50) COMMENT 'Numero de Factura',
	`PolizaFactura`	BIGINT(12) COMMENT 'Poliza Factura',
	`CentroCostoID`	VARCHAR(350) COMMENT'Identificador de Centro de Costos',
	`Clasificacion`	VARCHAR(350) COMMENT 'Clasificacion de Activos tabla CLASIFICACTIVOS',
	`Moi` DECIMAL(16,2) COMMENT 'Monto Original Inversion(MOI)',
	`Estatus` VARCHAR(50) COMMENT 'Indica el estatus del activo, VI=VIGENTE, BA=BAJA, VE=VENDIDO',
	`DepreciacionAnual` DECIMAL(16,2) COMMENT 'Indica la Despreciacion Anual del Activo',
	`TiempoAmortiMeses`	VARCHAR(50) COMMENT 'Timpo de Amortizacion en Meses',
	`DepreContaAnual` DECIMAL(16,2) COMMENT 'Indica la Depreciacion Contable Anual',
	`DepreciadoAcumulado` DECIMAL(16,2) COMMENT 'Indica el Acomulado de la Deprecicion' ,
	`TotalDepreciar` DECIMAL(16,2) COMMENT 'Indica el Total a Despreciar',
	`DepreciacionAnualFiscal` DECIMAL(16,2) COMMENT 'Indica la Despreciacion Anual del Activo',
	`TiempoAmortiMesesFiscal` VARCHAR(50) COMMENT 'Timpo de Amortizacion en Meses',
	`DepreFiscalAnual` DECIMAL(16,2) COMMENT 'Indica la Depreciacion Fiscal Anual',
	`DepreciadoAcumuladoFiscal` DECIMAL(16,2) COMMENT 'Indica el Acomulado de la Deprecicion',
	`SaldoDepreciarFiscal`	DECIMAL(16,2) COMMENT 'Indica el Saldo a Despreciar Fiscal',
	`PorcentajeFactor`	DECIMAL(16,2) COMMENT'Porcetaje de Factor Fiscal',
	`TipoReg` CHAR(1) COMMENT'Tipo de Registro A.-Activo T.-SubTotal ',
	`EmpresaID` INT(11)  DEFAULT '0' NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
	`Usuario` INT(11)  DEFAULT '0' NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
	`FechaActual` DATETIME  DEFAULT '1900-01-01'  NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
	`DireccionIP` VARCHAR(15)  DEFAULT '0' NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
	`ProgramaID` VARCHAR(50)  DEFAULT '0' NOT NULL COMMENT 'Parametro de auditoria Programa ',
	`Sucursal` INT(11)  DEFAULT '0' NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
	`NumTransaccion` BIGINT(20)  DEFAULT '0' NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
	PRIMARY KEY (`NumTransaccion`,`ConsecutivoID`,`ActivoID`),
	KEY `IDX_TMPPREVIODEPREAMORTI_1` (`NumTransaccion`),
	KEY `IDX_TMPPREVIODEPREAMORTI_2` (`ActivoID`),
	KEY `IDX_TMPPREVIODEPREAMORTI_3` (`TipoActivoID`),
	KEY `IDX_TMPPREVIODEPREAMORTI_4` (`CentroCostoID`)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla de Activos para el Reporte de Catalogo\n'$$