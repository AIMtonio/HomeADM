-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPRESORDPAGSAN
DELIMITER ;
DROP TABLE IF EXISTS `TMPRESORDPAGSAN`;
DELIMITER $$

CREATE TABLE `TMPRESORDPAGSAN` (
  `ConsecutivoID` INT(11) NOT NULL AUTO_INCREMENT COMMENT'Llave primaria',
  `NumeroPago` varchar(100)DEFAULT NULL COMMENT 'Numero de pago',
  `TipoServicio` varchar(100)DEFAULT NULL COMMENT'Tipo de servicio',
  `CuentaCargo` varchar(100) DEFAULT NULL COMMENT 'CuentaCargo',
  `Beneficiario` varchar(100) DEFAULT NULL COMMENT 'Beneficiario',
  `Importe` varchar(100) DEFAULT NULL COMMENT 'Importe',
  `Divisa` varchar(100) DEFAULT NULL COMMENT 'Divisa',
  `Estatus` varchar(100)  DEFAULT NULL COMMENT 'Estatus',
  `ClaveBeneficiario` varchar(100)  DEFAULT NULL COMMENT 'ClaveBeneficiario',
  `Concepto` varchar(100)  DEFAULT NULL COMMENT 'Concepto',
  `FechaLimitePag` varchar(100)  DEFAULT NULL COMMENT 'Fechalimite',
  `Referencia` varchar(100) DEFAULT NULL COMMENT 'Referencia',
  `FechaRegistro` varchar(100) DEFAULT NULL COMMENT 'Fecharegistro',
  `FormaPago` varchar(100) DEFAULT NULL COMMENT 'FormaPago',
  `SucursalID` varchar(100) DEFAULT NULL COMMENT 'Sucursal',
  `FechaLiberacion` varchar(100) DEFAULT NULL COMMENT 'Fechaliberación',
  `ReferenciaArchivo` varchar(100) DEFAULT NULL COMMENT 'ReferenciaArchivo',
  `ImporteIVA` varchar(100) DEFAULT NULL COMMENT 'ImporteIVA',
  `RFC` varchar(100) DEFAULT NULL COMMENT 'RFC',
  `FechaLiquidacion` varchar(100) DEFAULT NULL COMMENT 'FechaLiquidacion',
  `NombreArchivo`   VARCHAR(100) DEFAULT NULL COMMENT 'Nombre del archivo',  
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ConsecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para el archivo de respuesta santander'$$