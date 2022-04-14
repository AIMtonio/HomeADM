-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASTRANSFER
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASTRANSFER`;
DELIMITER $$


CREATE TABLE `CUENTASTRANSFER` (
  `ClienteID` int(11) NOT NULL COMMENT 'No \ncliente',
  `CuentaTranID` int(11) NOT NULL COMMENT 'No consecutivo de cuentas transfer por cliente',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Institucion',
  `Clabe` varchar(20) DEFAULT NULL COMMENT 'Numero de Cuenta Clabe',
  `Beneficiario` varchar(100) DEFAULT NULL COMMENT 'Nombre del Beneficiario\n',
  `Alias` varchar(30) DEFAULT NULL COMMENT 'Alias',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en que se registro la cuenta',
  `UsuarioAutoriza` int(11) DEFAULT NULL COMMENT 'Numero del usuario que autoriza',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha en que autoriza',
  `UsuarioBaja` int(11) DEFAULT NULL COMMENT 'Numero del usuario que da de baja',
  `FechaBaja` date DEFAULT NULL COMMENT 'Fecha en que se da de baja',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Indica el Estatus de la cuenta Transfer\nRegistrado=R\nBaja=B\nAutorizado=A',
  `TipoCuenta` char(1) DEFAULT NULL COMMENT 'Tipo de cuenta destino:"I"=Internas; "E"=Externas',
  `CuentaDestino` bigint(12) DEFAULT NULL,
  `ClienteDestino` int(11) DEFAULT NULL COMMENT 'Corresponde con ClienteID de la tabla CLIENTES',
  `TipoCuentaSpei` int(2) DEFAULT NULL COMMENT 'Tipo de Cuenta de Envio para SPEI ',
  `RFCBeneficiario` varchar(18) DEFAULT NULL COMMENT 'RFC o CURP del Beneficiario',
  `EsPrincipal` char(1) DEFAULT 'N' COMMENT 'Indica si la Cuenta Destino es Principal.\nS.- Si\nN.- No',
  `AplicaPara` CHAR(1) DEFAULT NULL COMMENT 'C: Credito\nS: SPEI\nA: Ambas',
  `EstatusDomici` CHAR(1) DEFAULT NULL COMMENT 'A: Afiliada',
  `MontoLimite` DECIMAL(14,2) NOT NULL DEFAULT 0 COMMENT 'Monto Maximo de Transferencia',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`CuentaTranID`),
  KEY `fk_CUENTASTRANSFER_1_idx` (`ClienteID`),
  KEY `fk_CUENTASTRANSFER_2_idx` (`InstitucionID`),
  KEY `index4` (`CuentaDestino`),
  KEY `index5` (`ClienteDestino`),
  KEY `INDEX_CUENTASTRANSFER6` (`NumTransaccion`),
  CONSTRAINT `fk_CUENTASTRANSFER_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que guarda las cuentas destino del cliente.'$$
