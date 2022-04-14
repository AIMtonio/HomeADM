-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOTESO
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASAHOTESO`;
DELIMITER $$

CREATE TABLE `CUENTASAHOTESO` (
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `InstitucionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id Del Banco (Institucion) de donde es la Cuenta',
  `SucursalInstit` varchar(50) DEFAULT NULL COMMENT 'Descripcion de la sucursal \n',
  `NumCtaInstit` varchar(20) NOT NULL COMMENT 'Numero de Cuenta En el Banco(Institucion)',
  `CueClave` char(18) DEFAULT NULL COMMENT 'Numero de Cuenta CLABE de la Cuenta de la Institucion',
  `Chequera` char(1) DEFAULT NULL COMMENT 'Indica si la Cuenta usa chequera\nS = Si\nN = No',
  `CuentaCompletaID` char(25) DEFAULT NULL,
  `CentroCostoID` int(11) DEFAULT NULL COMMENT 'Id del Centro de Costos',
  `Estatus` char(1) DEFAULT NULL,
  `Saldo` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de la cuenta Bancaria',
  `SobregirarSaldo` char(1) DEFAULT NULL COMMENT 'Indica si se permirte sobregirar el saldo de la cuenta bancaria\nS.- SI\nN.-NO',
  `Principal` char(1) DEFAULT 'N' COMMENT 'parametro para \nsaber si\nEs principal la \ncuenta:\nS: es  la cta Principal\nN: no es la Cta Principal',
  `TipoChequera` char(2) DEFAULT '' COMMENT 'Indica el tipo de chequera que una cuenta puede tener las cuales son: \nA - Ambas\nP - Proforma\nE - Cheque Estandar',
  `folioUtilizar` bigint(20) DEFAULT NULL COMMENT 'indica el numero de folio donde se empezara a capturar el siguiente folio',
  `rutaCheque` varchar(100) DEFAULT NULL COMMENT 'indica la ruta donde se encuentra el reporte',
  `FolioUtilizarEstan` bigint(20) DEFAULT '0' COMMENT 'Indica el numero de folio donde se empezara a capturar el siguiente folio de cheque tipo estandar.',
  `RutaChequeEstan` varchar(100) DEFAULT ' ' COMMENT 'Indica la ruta donde se encuentra el reporte para cheque tipo estandar.',
  `NumConvenio` varchar(30) DEFAULT '' COMMENT 'numero de convenio',
  `DescConvenio` varchar(100) DEFAULT '' COMMENT 'descripcion del convenio',
  `ProtecOrdenPago` char(1) DEFAULT 'N' COMMENT 'Proteccion orden de pago S:Si/N:No',
  `AlgClaveRetiro` char(1) DEFAULT 'M' COMMENT 'Campo de tipo seleccion, con las opciones Manual(M), Automatico(A), el cual por default tendra Manual(M)',
  `VigClaveRetiro` int(11) DEFAULT '7' COMMENT 'Campo de tipo numerico, con valores admisibles desde el 1 hasta el 99, este campo es opcional, el valor por default sera 7',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InstitucionID`,`NumCtaInstit`),
  KEY `fk_CUENTASAHOTESO_4` (`CentroCostoID`),
  KEY `fk_CUENTASAHOTESO_8` (`CuentaAhoID`),
  CONSTRAINT `fk_CUENTASAHOTESO_4` FOREIGN KEY (`CentroCostoID`) REFERENCES `CENTROCOSTOS` (`CentroCostoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CUENTASAHOTESO_8` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Adicional de Cuentas de Ahorro para Tesoreria'$$