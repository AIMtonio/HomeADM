-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPTRANSFERENCIASAN
DELIMITER ;
DROP TABLE IF EXISTS `DISPTRANSFERENCIASAN`;
DELIMITER $$

CREATE TABLE `DISPTRANSFERENCIASAN` (
	`ConsecutivoID` 		INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave primaria',
	`CuentaClabe`   		VARCHAR(100) DEFAULT NULL COMMENT 'Cuenta Clabe',
	`CuentaCargo`   		VARCHAR(100) DEFAULT NULL COMMENT 'Cuenta Cargo',
	`DesCtaCargo`			VARCHAR(300) DEFAULT NULL COMMENT 'Descripcion Cuenta Cargo',
	`CuentaAbono`   		VARCHAR(100) DEFAULT NULL COMMENT 'Cuenta de Abono',
	`DesCtaAbono`			VARCHAR(300) DEFAULT NULL COMMENT 'Descripción Cuenta abono',
	`Importe`   			DECIMAL(12,2) DEFAULT '0.0' COMMENT 'Importe',
	`Concepto`  			VARCHAR(100) DEFAULT NULL COMMENT 'Concepto',
	`FechaAplicacion`   	DATE DEFAULT '1900-01-01' COMMENT 'Fecha Aplicacion',
	`IVA`   				DECIMAL(12,2) DEFAULT '0.0' COMMENT 'IVA',
	`BancoOrigen`			VARCHAR(50)	DEFAULT NULL COMMENT 'Banco Origen',
	`BancoDestino`  		VARCHAR(50) DEFAULT NULL COMMENT 'Banco Destino',
	`RefOperacion`  		VARCHAR(100) DEFAULT NULL COMMENT 'Referencia Bancaria',
	`ClaveABASWIFT` 		VARCHAR(100) DEFAULT NULL COMMENT 'Clave ABA/SWIFT',
	`TipoCambio`			DECIMAL(14,2) DEFAULT '0.0' COMMENT 'Tipo de Cambio',
	`ImporteDivisa`			DECIMAL(14,2) DEFAULT '0.0' COMMENT 'Importe Divisa',
	`ImporteUSD`			DECIMAL(14,2) DEFAULT '0.0' COMMENT 'Importe USD',
	`Ciudad`    			VARCHAR(50) DEFAULT NULL COMMENT 'Ciudad',
	`Pais`  				VARCHAR(50) DEFAULT NULL COMMENT 'Pais',
	`Estatus`   			VARCHAR(50) DEFAULT NULL COMMENT 'Estatus',
	`TipoOperacion` 		VARCHAR(100) DEFAULT NULL COMMENT 'Tipo Operacion',
	`RefArchivo`    		VARCHAR(100) DEFAULT NULL COMMENT 'Referencia del archivo',
	`RefNumEmisor`			BIGINT(20) DEFAULT '0' COMMENT 'Referencia numerica del emisor',
	`IdenFiscalBenefi`		VARCHAR(50) DEFAULT NULL COMMENT 'Identificador Fiscal del Beneficiario',
	`Correo`    			VARCHAR(100) DEFAULT NULL COMMENT 'Correo',
	`ClaveABASWIFTInterme`  VARCHAR(100) DEFAULT NULL COMMENT 'Clave ABA/SWIFT Intermediaria',
	`BancoIntermediario`    VARCHAR(100) DEFAULT NULL COMMENT 'Banco intermediario',
	`CuentaIntermediaria`   VARCHAR(100) DEFAULT NULL COMMENT 'Cuenta Intermediaria',
	`TipoPago`  			VARCHAR(100) DEFAULT NULL COMMENT 'Tipo de Pago',
	`ClaveRastreo`  		VARCHAR(100) DEFAULT NULL COMMENT 'Clave de Rastreo',
	`FechaAlta` 			DATETIME DEFAULT '1900-01-01' COMMENT 'Fecha de Alta',
	`FechaLiquidacion`  	DATETIME DEFAULT '1900-01-01' COMMENT 'Fecha de Liquidacion',
	`RFCOrdenante`  		VARCHAR(100) DEFAULT NULL COMMENT 'RFC del Ordenante',
	`Observaciones`			VARCHAR(150) DEFAULT NULL COMMENT 'Observaciones',
	`TipoAplicacion`		VARCHAR(150) DEFAULT NULL COMMENT 'Tipo de aplicacion',
	`SaldoActualizado`		VARCHAR(50) DEFAULT NULL COMMENT 'Saldo Actualizado',
	`NombreArchivo` 		VARCHAR(100) DEFAULT NULL COMMENT 'Nombre del archivo',
	`EmpresaID` 			INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`UsuarioID` 			INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`FechaActual` 			DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria',
	`DireccionIP` 			VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`ProgramaID` 			VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`Sucursal` 				INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`NumTransaccion` 		BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ConsecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB:Tabla para el proceso de dispersiones de Transferencias Santander'$$