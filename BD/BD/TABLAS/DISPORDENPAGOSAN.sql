-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPORDENPAGOSAN
DELIMITER ;
DROP TABLE IF EXISTS `DISPORDENPAGOSAN`;
DELIMITER $$

CREATE TABLE `DISPORDENPAGOSAN` (
	`ConsecutivoID` 		INT(11) NOT NULL AUTO_INCREMENT COMMENT'Llave primaria',
	`NumeroPago` 			VARCHAR(100) DEFAULT 0 COMMENT 'Numero de pago',
	`TipoServicio` 			VARCHAR(100) DEFAULT '' COMMENT'Tipo de servicio',
	`CuentaCargo` 			VARCHAR(100) DEFAULT '' COMMENT 'CuentaCargo',
	`Beneficiario` 			VARCHAR(100) DEFAULT '' COMMENT 'Beneficiario',
	`Importe` 				VARCHAR(20)  DEFAULT 0 COMMENT 'Importe',
	`Divisa` 				VARCHAR(50)  DEFAULT '' COMMENT 'Divisa',
	`Estatus` 				VARCHAR(50)  DEFAULT '' COMMENT 'Estatus',
	`ClaveBeneficiario` 	VARCHAR(100) DEFAULT '' COMMENT 'ClaveBeneficiario',
	`Concepto` 				VARCHAR(100) DEFAULT '' COMMENT 'Concepto',
	`FechaLimitePag` 		VARCHAR(20)  DEFAULT '1900-01-01' COMMENT 'Fechalimite',
	`Referencia` 			VARCHAR(100) DEFAULT '' COMMENT 'Referencia',
	`FechaRegistro` 		VARCHAR(20)  DEFAULT '1900-01-01' COMMENT 'Fecharegistro',
	`FormaPago` 			VARCHAR(100) DEFAULT '' COMMENT 'FormaPago',
	`SucursalID` 			VARCHAR(100) DEFAULT '' COMMENT 'Sucursal',
	`FechaLiberacion` 		VARCHAR(20)  DEFAULT '1900-01-01' COMMENT 'Fechaliberación',
	`ReferenciaArchivo` 	VARCHAR(100) DEFAULT '' COMMENT 'ReferenciaArchivo',
	`ImporteIVA` 			VARCHAR(20)  DEFAULT '' COMMENT 'ImporteIVA',
	`RFC` 					VARCHAR(100) DEFAULT '' COMMENT 'RFC',
	`FechaLiquidacion` 		VARCHAR(20)  DEFAULT '1900-01-01' COMMENT 'FechaLiquidacion',
	`NombreArchivo` 		VARCHAR(100) DEFAULT '' COMMENT 'Nombre del archivo',  
	`EmpresaID` 			INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`UsuarioID` 			INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`FechaActual` 			DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria',
	`DireccionIP` 			VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`ProgramaID` 			VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`Sucursal` 				INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`NumTransaccion` 		BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (ConsecutivoID),
  INDEX(NumTransaccion, NombreArchivo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla para el proceso de dispersion de Ordenes de Pago'$$