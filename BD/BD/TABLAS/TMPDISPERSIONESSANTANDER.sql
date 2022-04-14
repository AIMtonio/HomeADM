-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDISPERSIONESSANTANDER
DELIMITER ;
DROP TABLE IF EXISTS `TMPDISPERSIONESSANTANDER`;
DELIMITER $$

CREATE TABLE `TMPDISPERSIONESSANTANDER` (
	`Consecutivo` 			INT(11) NOT NULL COMMENT 'Consecutivo',
    `NumTransaccion` 		INT(11) NOT NULL COMMENT'Numero de transaccion',
	`NombreArchivo` 		VARCHAR(100) DEFAULT '' COMMENT 'Nombre del archivo',
    `Concepto`  			VARCHAR(100) DEFAULT '' COMMENT 'Concepto',
	`Importe`   			DECIMAL(12,2) DEFAULT '0.0' COMMENT 'Importe',	
	`IVA`   				DECIMAL(12,2) DEFAULT '0.0' COMMENT 'IVA',
	`Estatus`   			VARCHAR(100) DEFAULT '' COMMENT 'Fecha Aplicacion',	
	`NumeroPago`   			VARCHAR(100) DEFAULT '' COMMENT 'Numero de orden o de Pago',	
	`Beneficiario` 			VARCHAR(100) DEFAULT '' COMMENT 'Beneficiario',	
	`Referencia` 			VARCHAR(100) DEFAULT '' COMMENT 'Beneficiario',	
	`FechaLiquidacion` 		DATETIME DEFAULT '1900-01-01' COMMENT 'Fecha de Liquidacion',	
	`FechaRechazo` 			DATETIME DEFAULT '1900-01-01' COMMENT 'Fecha de rechazo',
	`FolioDispersion` 		INT(11) DEFAULT '0' COMMENT 'ID o referencia de la operación de la dispersion',
	`ClaveDispMov` 			INT(11) DEFAULT '0' COMMENT 'Consecutivo de la tabla de movimientos',

  PRIMARY KEY (NumTransaccion, Consecutivo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP:Para procesar las dispersiones SANTANDER'$$
