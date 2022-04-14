-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESEMITIDOS
DELIMITER ;
DROP TABLE IF EXISTS `CHEQUESEMITIDOS`;DELIMITER $$

CREATE TABLE `CHEQUESEMITIDOS` (
  `InstitucionID` int(11) NOT NULL COMMENT 'Numero de Institución (Corresponde con el número de Banco Emisor del Cheque)',
  `CuentaInstitucion` varchar(20) NOT NULL COMMENT 'Número de Cuenta del Cheque',
  `NumeroCheque` int(10) NOT NULL COMMENT 'Numero de Cheque',
  `FechaEmision` date DEFAULT NULL COMMENT 'Fecha en que se emite el cheque',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Cheque',
  `SucursalID` int(12) DEFAULT NULL COMMENT 'ID de la Sucursal en  la que se emitio el cheque',
  `CajaID` int(11) DEFAULT NULL COMMENT 'ID de la Caja en la que se emitio el Cheque',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID del Usuario que emitio el Cheque',
  `Concepto` varchar(200) DEFAULT NULL COMMENT 'Indica el Concepto por el cual se Emite el Cheque(Desembolso de Credito, Devolucion de GL)',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente del Beneficiario',
  `Beneficiario` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo del Beneficiario del Cheque',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Cheque \nE=Emitido\nC=Cancelado\nP=Pagado\nR=Reemplazado\nO=Conciliado',
  `Referencia` varchar(50) DEFAULT NULL COMMENT 'Numero de Referencia de Emision',
  `EmitidoEn` char(1) DEFAULT NULL COMMENT 'Almacena donde fue emitido el cheque V Ventanilla\nT Tesoreria',
  `TipoChequera` char(2) NOT NULL DEFAULT '' COMMENT 'Especifica el tipo de chequera que se estará utilizando, los posibles valores son:\nE - Estandar\nP - Proforma',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InstitucionID`,`CuentaInstitucion`,`NumeroCheque`,`TipoChequera`),
  KEY `CHEQUESEMITIDOS_idx` (`CajaID`),
  KEY `CHEQUESEMITIDOS_idx1` (`UsuarioID`),
  KEY `CHEQUESEMITIDOS_idx2` (`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena la informacion de los Cheques Emitidos'$$