
DELIMITER ;
DROP TABLE IF EXISTS `TMPCARGAMASIVADISP`;
DELIMITER $$
CREATE TABLE `TMPCARGAMASIVADISP` (
	`Consecutivo` INT(11) NOT NULL COMMENT 'Columna para el consecutivo del registro',
	`TipoCuenta` INT(11)  NULL DEFAULT NULL COMMENT 'Tipo de cuenta 1= Cuenta contable	2= Cuenta de Ahorro 3= Crédito',
	`CuentaCargo` VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'Cuenta de ahorro o cuenta contable',
	`Descripcion` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Descripción del movimiento',
	`Referencia` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Referencia del movimiento',
	`FormaPago` CHAR(1) NOT NULL DEFAULT '' COMMENT 'Forma de Pago S=SPEI C=Cheque O=Orden de Pago A=Transferencia Santander',
	`CtaBenefi` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Cuenta a la que se realizará el pago.',
	`Monto` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto a dispersar',
	`NombreBenefi` VARCHAR(150) NULL DEFAULT NULL COMMENT 'Nombre del Beneficiario',
	`RFC` VARCHAR(13) DEFAULT NULL COMMENT 'RFC del beneficiario',
	`EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`FechaActual` DATETIME DEFAULT NULL  COMMENT 'Parametro de auditoria',
	`DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
	`NumTransaccion` BIGINT(20) NOT NULL COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`Consecutivo`, `NumTransaccion`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Tab.- Guarda los datos leidos del archivo Excel para las dispersiones masivas'$$
