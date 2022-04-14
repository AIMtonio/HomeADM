-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPARCHIVODISPERSION
DELIMITER ;
DROP TABLE IF EXISTS `TMPARCHIVODISPERSION`;
DELIMITER $$

CREATE TABLE `TMPARCHIVODISPERSION` (
	`IDTmp` int(11) NOT NULL DEFAULT '0' COMMENT 'ID Consecutivo.',
	`CodigoLayout` int(11) NOT NULL DEFAULT '0' COMMENT 'Codigo Generado para el archivo.',
	`CuentaCargo` varchar(18) DEFAULT NULL COMMENT 'Cuenta Cargo',
	`CuentaAbono` varchar(20) DEFAULT NULL COMMENT 'Cuenta Abono.',
	`Monto` decimal(12,2) DEFAULT NULL COMMENT 'Monto.',
	`Concepto` varchar(40)  DEFAULT NULL COMMENT 'Concepto.',
	`CorreoBeneficiario` varchar(40) DEFAULT NULL COMMENT 'Correo del Beneficiario.',
	`Descripcion` varchar(30) DEFAULT NULL COMMENT 'Descripcion',
	`Beneficiario` varchar(30) DEFAULT NULL COMMENT 'Beneficiario.',
	`Referencia` varchar(6) DEFAULT NULL COMMENT 'Referencia',
	`RFC` varchar(13) DEFAULT NULL COMMENT 'RFC del Beneficiario.',
	`Moneda` varchar(3) NOT NULL DEFAULT '' COMMENT 'Moneda de la Dispersion.',
	`TipoMovDIspID` char(4) DEFAULT NULL COMMENT 'ID del Tipo de Movimiento\nde Tesoreria\ntabla:\n(TIPOSMOVTESO)',
	`NumTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Numero de Transaccion',
	`ClaveDispMov` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla de movimientos',
	`DispersionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de Dispersion',
	PRIMARY KEY (IDTmp, NumTransaccion) COMMENT 'ID de Aportacion.',
	KEY `INDEX_TMPARCHIVODISPERSION_1` (`IDTmp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Auxiliar en la Creacion del Archivo de Dispersion.'$$