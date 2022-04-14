-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPCTAACTIVAS
DELIMITER ;
DROP TABLE IF EXISTS `DISPCTAACTIVAS`;
DELIMITER $$

CREATE TABLE `DISPCTAACTIVAS` (
  `DispCuentasID`		INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ID del beneficiario',
  `ClienteID` 			INT(11) DEFAULT NULL COMMENT 'ID del beneficiario',
  `FechaAlta` 			DATE COMMENT 'Fecha de alta',
  `NumeroCta`  			VARCHAR(40) DEFAULT NULL COMMENT 'Numero de cuenta',
  `DescripcionCta` 		VARCHAR(3000) DEFAULT NULL COMMENT 'Descripcion de la cta',
  `TipoCta` 			VARCHAR(100) DEFAULT NULL COMMENT 'Tipo de cuenta',
  `Banco` 				VARCHAR(100) DEFAULT NULL COMMENT 'Banco',
  `Pais` 				VARCHAR(50) DEFAULT NULL COMMENT 'Pais',
  `Ciudad` 				VARCHAR(50) DEFAULT NULL COMMENT 'Ciudad',
  `EntidadCtaABASWIFT` 	VARCHAR(50) DEFAULT NULL COMMENT 'Entidad de la cuenta',
  `Divisa` 				VARCHAR(20) DEFAULT NULL COMMENT 'Divisa',
  `IndicadorCta` 		VARCHAR(50) DEFAULT NULL COMMENT 'Indicador de la cuenta',
  `Cesta` 				VARCHAR(50) DEFAULT NULL COMMENT 'Cesta',
  `Producto` 			VARCHAR(11) DEFAULT NULL COMMENT 'Producto',
  `SubTipo` 			VARCHAR(11) DEFAULT NULL COMMENT 'Subtipo',
  `Estado` 				VARCHAR(100) DEFAULT NULL COMMENT 'Estado',  
  `FechaProceso` 		VARCHAR(20) DEFAULT NULL COMMENT 'Fecha en que se cargo el archivo',
  `NombreArchivo` 		VARCHAR(100) DEFAULT NULL COMMENT 'Nombre del archivo',  
  `EmpresaID` 			INT(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` 			INT(11) DEFAULT NULL,
  `FechaActual` 		DATETIME DEFAULT NULL,
  `DireccionIP` 		VARCHAR(15) DEFAULT NULL,
  `ProgramaID` 			VARCHAR(50) DEFAULT NULL,
  `Sucursal` 			INT(11) DEFAULT NULL,
  `NumTransaccion` 		BIGINT(20) DEFAULT NULL,
  PRIMARY KEY(DispCuentasID),
  INDEX (`ClienteID`, `NumeroCta`, `TipoCta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla que contiene las cuentas Activas'$$

