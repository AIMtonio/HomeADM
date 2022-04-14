DELIMITER ;
DROP TABLE IF EXISTS `DETCARGAMASIVADISP`;
DELIMITER $$
CREATE TABLE `DETCARGAMASIVADISP` (
	`DetDispMasivaID` INT(11) NOT NULL COMMENT 'Columna para el consecutivo del registro',
	`DispMasivaID` INT(11) NOT NULL COMMENT 'ID de la tabla CARGAMASIVADISP',
	`TipoCuenta` INT(11)  NULL DEFAULT NULL COMMENT 'Tipo de cuenta 1= Cuenta contable	2= Cuenta de Ahorro 3= Crédito',
	`CuentaCargo` VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'Cuenta de ahorro o cuenta contable',
	`Descripcion` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Descripción del movimiento',
	`Referencia` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Referencia del movimiento',
	`FormaPago` CHAR(1) NOT NULL DEFAULT '' COMMENT 'Forma de Pago S=SPEI C=Cheque O=Orden de Pago A=Transferencia Santander',
	`CuentaBeneficirario` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Cuenta a la que se realizará el pago.',
	`Monto` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto a dispersar',
	`NombreBeneficiario` VARCHAR(150) NULL DEFAULT NULL COMMENT 'Nombre del Beneficiario',
	`RFC` VARCHAR(13) DEFAULT NULL COMMENT 'RFC del beneficiario',
	`EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`FechaActual` DATETIME DEFAULT NULL  COMMENT 'Parametro de auditoria',
	`DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`DetDispMasivaID`),
	CONSTRAINT `fk_DETCARGAMASIVADISP_1` FOREIGN KEY (`DispMasivaID`) REFERENCES `CARGAMASIVADISP` (`DispMasivaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
)ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='TAB.- Tabla para la detalle de los registro del archivo para dispersion masiva'$$
